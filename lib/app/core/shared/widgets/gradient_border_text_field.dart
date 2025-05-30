import 'package:flutter/material.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart'; // Sesuaikan path
import 'package:zest_mobile/app/core/shared/theme/text_theme.dart';    // Sesuaikan path

const List<Color> kDefaultGradientBorderColors = [
  Color(0xFFA2FF00),
  Color(0xFF00FF7F),
];
const List<Color> kFocusedGradientBorderColors = [
  Color(0xFFA2FF00),
  Color(0xFF00FF7F),
];
final Color kErrorBorderColor = darkColorScheme.error;

class GradientBorderTextField extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hintText;
  final String? labelText;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted; // ✨ BARU: onSubmitted
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final Color? cursorColor;
  final int? maxLines;
  final int? minLines;

  const GradientBorderTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.hintText,
    this.labelText,
    this.errorText,
    this.onChanged,
    this.onSubmitted, // ✨ BARU
    this.validator,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.prefixIcon,
    this.suffixIcon,
    this.cursorColor,
    this.maxLines = 1,
    this.minLines = 1,
  });

  @override
  State<GradientBorderTextField> createState() => _GradientBorderTextFieldState();
}

class _GradientBorderTextFieldState extends State<GradientBorderTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  String? _internalErrorText;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
    if (widget.validator != null && widget.controller != null && widget.controller!.text.isNotEmpty) {
      _internalErrorText = widget.validator!(widget.controller!.text);
    }
  }

  void _onFocusChange() {
    if (mounted) {
      setState(() {
        _isFocused = _focusNode.hasFocus;
        if (!_isFocused && widget.validator != null) {
          _internalErrorText = widget.validator!(widget.controller?.text ?? "");
        }
      });
    }
  }

  void _handleInternalValidation(String? value) {
    if (widget.validator != null) {
      if (mounted) {
        setState(() {
          _internalErrorText = widget.validator!(value ?? "");
        });
      }
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inputTheme = theme.inputDecorationTheme;
    final String? displayErrorText = widget.errorText ?? _internalErrorText;

    List<Color>? currentGradientColors;
    Color? currentSolidBorderColor;
    double borderWidth = 1.5;

    if (displayErrorText != null && displayErrorText.isNotEmpty) {
      currentSolidBorderColor = kErrorBorderColor;
      borderWidth = 2.0;
    } else if (_isFocused) {
      currentGradientColors = kFocusedGradientBorderColors;
      borderWidth = 2.0;
    } else {
      currentGradientColors = kDefaultGradientBorderColors;
    }

    Widget textFieldCore = Container(
      padding: EdgeInsets.all(borderWidth),
      decoration: BoxDecoration(
        gradient: currentGradientColors != null
            ? LinearGradient(
                colors: currentGradientColors,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : null,
        color: currentSolidBorderColor,
        borderRadius: BorderRadius.circular(8 + borderWidth),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: inputTheme.fillColor ?? darkColorScheme.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          onChanged: (value) {
            widget.onChanged?.call(value);
            if (widget.validator != null) {
              _handleInternalValidation(value);
            }
          },
          onSubmitted: widget.onSubmitted, // ✨ BARU: Meneruskan onSubmitted
          cursorColor: widget.cursorColor ?? darkColorScheme.primary,
          decoration: InputDecoration(
            hintText: widget.hintText,
            labelText: widget.labelText,
            filled: true,
            fillColor: Colors.transparent,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            contentPadding: inputTheme.contentPadding,
            hintStyle: inputTheme.hintStyle,
            labelStyle: inputTheme.labelStyle,
            floatingLabelStyle: inputTheme.floatingLabelStyle,
            errorText: null,
            errorStyle: const TextStyle(height: 0, fontSize: 0),
            prefixIcon: widget.prefixIcon != null
                ? Icon(
                    widget.prefixIcon,
                    color: _isFocused
                        ? darkColorScheme.primary
                        : (displayErrorText != null && displayErrorText.isNotEmpty
                            ? darkColorScheme.error
                            : darkColorScheme.onSurfaceVariant),
                  )
                : null,
            suffixIcon: widget.suffixIcon,
          ),
          style: TTextTheme.darkTextTheme.bodyMedium?.copyWith(color: darkColorScheme.onSurface),
          obscureText: widget.obscureText,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
        ),
      ),
    );

    if (widget.validator != null) {
      return FormField<String>(
        validator: widget.validator,
        initialValue: widget.controller?.text ?? "",
        autovalidateMode: AutovalidateMode.onUserInteraction,
        builder: (FormFieldState<String> field) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && field.hasError && (widget.errorText == null && _internalErrorText != field.errorText)) {
              setState(() {
                _internalErrorText = field.errorText;
              });
            } else if (mounted && !field.hasError && (widget.errorText == null && _internalErrorText != null)) {
              setState(() {
                _internalErrorText = null;
              });
            }
          });

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textFieldCore,
              if (displayErrorText != null && displayErrorText.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 6.0, left: 12.0),
                  child: Text(
                    displayErrorText,
                    style: inputTheme.errorStyle ?? TextStyle(color: darkColorScheme.error, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                    maxLines: inputTheme.errorMaxLines ?? 2,
                  ),
                ),
            ],
          );
        },
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textFieldCore,
          if (widget.errorText != null && widget.errorText!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6.0, left: 12.0),
              child: Text(
                widget.errorText!,
                style: inputTheme.errorStyle ?? TextStyle(color: darkColorScheme.error, fontSize: 12),
                overflow: TextOverflow.ellipsis,
                maxLines: inputTheme.errorMaxLines ?? 2,
              ),
            ),
        ],
      );
    }
  }
}