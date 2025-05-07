import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class MediaPreview extends StatelessWidget {
  final List<XFile> medias;

  const MediaPreview({super.key, required this.medias});

  bool isVideo(String path) {
    final ext = path.toLowerCase();
    return ext.endsWith('.mp4') || ext.endsWith('.mov') || ext.endsWith('.avi');
  }

  @override
  Widget build(BuildContext context) {
    if (medias.isEmpty) return const SizedBox();

    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: medias.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, index) {
          final media = medias[index];
          if (isVideo(media.path)) {
            return _VideoThumbnail(path: media.path);
          } else {
            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(media.path),
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            );
          }
        },
      ),
    );
  }
}

class _VideoThumbnail extends StatefulWidget {
  final String path;

  const _VideoThumbnail({required this.path});

  @override
  State<_VideoThumbnail> createState() => _VideoThumbnailState();
}

class _VideoThumbnailState extends State<_VideoThumbnail> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.path))
      ..initialize().then((_) {
        setState(() {});
        _controller.setVolume(0);
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: _controller.value.isInitialized
          ? SizedBox(
              width: 100,
              height: 100,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  VideoPlayer(_controller),
                  const Align(
                    alignment: Alignment.center,
                    child: Icon(Icons.play_circle_fill, size: 30, color: Colors.white),
                  )
                ],
              ),
            )
          : const SizedBox(width: 100, height: 100, child: Center(child: CircularProgressIndicator())),
    );
  }
}
