import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:zest_mobile/app/core/models/model/post_model.dart';

class MediaPreviewEdit extends StatelessWidget {
  final List<Gallery> currentGalleries;
  final List<File> newGalleries;
  final void Function(int index, bool isFromServer, Gallery? gallery, File? file) onRemove;

  const MediaPreviewEdit({
    super.key, 
    required this.currentGalleries,
    this.newGalleries = const [],
    required this.onRemove,
  });

  bool _isVideo(String url) {
    return url.endsWith('.mp4') || url.endsWith('.mov') || url.endsWith('.webm');
  }

  @override
  Widget build(BuildContext context) {
    final totalMedia = currentGalleries.length + newGalleries.length;

    return SizedBox(
      height: 240,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(right: 12),
        itemCount: totalMedia,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final isFromServer = index < currentGalleries.length; // 0, 1, 2, 3, 4
          String pathOrUrl = isFromServer ? (currentGalleries[index].url ?? '') : newGalleries[index - currentGalleries.length].path;

          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 130,
                  height: 230,
                  child: _isVideo(pathOrUrl)
                      ? PostVideoPlayer(isFromServer: isFromServer, videoUrlOrPath: pathOrUrl)
                      : 
                      (
                        isFromServer
                        ? Image.network(
                          pathOrUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, _) => Container(
                            color: Colors.grey.shade300,
                            child: const Center(child: Icon(Icons.broken_image)),
                          ),
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Container(
                              color: Colors.grey.shade300,
                              child: const Center(child: CircularProgressIndicator()),
                            );
                          },
                        )
                        : Image.file(
                          File(pathOrUrl),
                          fit: BoxFit.cover,
                        )
                      ),
                ),
              ),
              // remove button in top right
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.pink.shade100.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.delete_outline, size: 25, color: Colors.red),
                    onPressed: () {
                      if (isFromServer) {
                        onRemove(index, true, currentGalleries[index], null);
                      } else {
                        onRemove(index, false, null, newGalleries[index - currentGalleries.length]);
                      }
                    },
                    splashRadius: 20,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class PostVideoPlayer extends StatefulWidget {
  final bool isFromServer;
  final String videoUrlOrPath;
  const PostVideoPlayer({super.key, required this.isFromServer, required this.videoUrlOrPath});

  @override
  State<PostVideoPlayer> createState() => _PostVideoPlayerState();
}

class _PostVideoPlayerState extends State<PostVideoPlayer> {
  late VideoPlayerController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.isFromServer) {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrlOrPath))
        ..initialize().then((_) {
          setState(() => _initialized = true);
          _controller.setLooping(true);
          _controller.setVolume(0);
          _controller.play();
        });
    } else {
      _controller = VideoPlayerController.file(File(widget.videoUrlOrPath))
        ..initialize().then((_) {
          setState(() => _initialized = true);
          _controller.setLooping(true);
          _controller.setVolume(0);
          _controller.play();
        });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _initialized
        ? Stack(
            alignment: Alignment.bottomCenter,
            children: [
              VideoPlayer(_controller),
              VideoProgressIndicator(
                _controller, 
                allowScrubbing: true,
                colors: VideoProgressColors(
                  backgroundColor: Colors.transparent,
                  playedColor: Colors.grey.shade600,
                ),
              ),
            ],
          )
        : Container(
            color: Colors.grey.shade300,
            child: const Center(child: CircularProgressIndicator()),
          );
  }
}
