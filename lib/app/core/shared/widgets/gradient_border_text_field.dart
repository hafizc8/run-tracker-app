// gradient_border_text_field.dart
import 'package:flutter/material.dart';
// Pastikan import ini sesuai dengan struktur proyek Anda
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart'; // Ganti dengan path yang benar
import 'package:zest_mobile/app/core/shared/theme/text_theme.dart'; // Ganti dengan path yang benar

// Definisikan ulang atau impor konstanta warna gradient jika belum
const List<Color> kDefaultGradientBorderColors = [
  Color(0xFFA2FF00),
  Color(0xFF00FF7F),
];
const List<Color> kFocusedGradientBorderColors = [
  Color(0xFFA2FF00),
  Color(0xFF00FF7F),
];
final Color kErrorBorderColor = darkColorScheme.error; // Ambil dari color scheme

class GradientBorderTextField extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hintText;
  final String? labelText;
  final String? errorText;
  final ValueChanged<String>? onChanged;
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

    // Tentukan error text yang akan ditampilkan, prioritaskan dari widget.errorText
    final String? displayErrorText = widget.errorText ?? _internalErrorText;

    List<Color>? currentGradientColors;
    Color? currentSolidBorderColor;
    double borderWidth = 1.5;

    // Logika penentuan warna border berdasarkan state (error, fokus, normal)
    if (displayErrorText != null && displayErrorText.isNotEmpty) { // Periksa juga isNotEmpty
      currentSolidBorderColor = kErrorBorderColor;
      borderWidth = 2.0;
    } else if (_isFocused) {
      currentGradientColors = kFocusedGradientBorderColors;
      borderWidth = 2.0;
    } else {
      currentGradientColors = kDefaultGradientBorderColors;
    }

    // Widget untuk field input dengan border gradient
    Widget textFieldWithBorder = Container(
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
        borderRadius: BorderRadius.circular(8 + borderWidth), // Sesuaikan radius luar
      ),
      child: Container(
        decoration: BoxDecoration(
          color: inputTheme.fillColor ?? darkColorScheme.surface, // Warna isian field
          borderRadius: BorderRadius.circular(8), // Radius dalam agar sesuai
        ),
        child: TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          onChanged: (value) {
            widget.onChanged?.call(value);
            if (widget.validator != null) {
              _handleInternalValidation(value);
            }
            // Jika menggunakan FormField di luar, Anda mungkin perlu memanggil field.didChange(value)
          },
          cursorColor: widget.cursorColor ?? darkColorScheme.primary,
          decoration: InputDecoration(
            hintText: widget.hintText,
            labelText: widget.labelText,
            filled: true,
            fillColor: Colors.transparent, // fillColor dihandle oleh Container luar
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            contentPadding: inputTheme.contentPadding,
            hintStyle: inputTheme.hintStyle,
            labelStyle: inputTheme.labelStyle,
            floatingLabelStyle: inputTheme.floatingLabelStyle,
            errorText: null, // ❗ errorText dihilangkan dari InputDecoration internal
            errorStyle: TextStyle(height: 0, fontSize: 0), // Cegah alokasi ruang error internal
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

    // Bungkus dengan FormField jika ada validator, untuk integrasi dengan Form
    if (widget.validator != null) {
      textFieldWithBorder = FormField<String>(
        validator: widget.validator,
        initialValue: widget.controller?.text ?? "",
        autovalidateMode: AutovalidateMode.onUserInteraction,
        builder: (FormFieldState<String> field) {
          // Sinkronkan error dari FormField ke _internalErrorText jika perlu,
          // atau biarkan displayErrorText menangkapnya jika errorText widget null.
          // Untuk saat ini, displayErrorText sudah mencakup _internalErrorText.
          // Jika field.errorText ada dan berbeda, Anda bisa memperbarui state.
          // Namun, ini bisa menyebabkan loop build jika tidak hati-hati.

          // Cek apakah errorText dari FormField (setelah validasi) berbeda
          // Ini penting agar perubahan border terjadi saat Form melakukan validasi
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


          return Column( // Column untuk menampung field dan error text di bawahnya
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textFieldWithBorder, // Field input yang sudah kita buat di atas
              if (displayErrorText != null && displayErrorText.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 6.0, left: 12.0), // Sesuaikan padding error text
                  child: Text(
                    displayErrorText,
                    style: inputTheme.errorStyle ?? TextStyle(color: darkColorScheme.error, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                    maxLines: inputTheme.errorMaxLines ?? 2, // Ambil dari tema atau default
                  ),
                ),
            ],
          );
        },
      );
      // Jika tidak ada validator, kita tidak perlu FormField, langsung Column saja.
      // Namun, penggunaan FormField lebih disarankan untuk integrasi form.
      // Maka, kita akan selalu bungkus dengan Column di luar FormField jika FormField tidak ada.
      // Tapi karena FormField sudah return Column, maka sudah cukup.
       return textFieldWithBorder; // textFieldWithBorder di sini sudah merupakan FormField yang return Column
    } else {
      // Jika tidak ada validator, FormField tidak diperlukan.
      // Langsung return Column dengan field dan error text (jika ada widget.errorText).
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textFieldWithBorder, // Field input
          if (widget.errorText != null && widget.errorText!.isNotEmpty) // Hanya tampilkan jika widget.errorText ada
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