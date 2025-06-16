import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PostMediaScroll extends StatelessWidget {
  final List<String> mediaUrls;

  const PostMediaScroll({super.key, required this.mediaUrls});

  bool _isVideo(String url) {
    return url.endsWith('.mp4') ||
        url.endsWith('.mov') ||
        url.endsWith('.webm');
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSingleMedia = mediaUrls.length == 1;
    final mediaWidth = isSingleMedia ? screenWidth * 0.80 : screenWidth * 0.7;
    buildSingleMedia(String url) {
      return SizedBox(
        height: 300,
        width: double.infinity,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: _isVideo(url)
              ? PostVideoPlayer(videoUrl: url)
              : Image.network(
                  url,
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
                ),
        ),
      );
    }

    return mediaUrls.length == 1
        ? buildSingleMedia(mediaUrls.first)
        : SizedBox(
            height: 300,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(right: 12),
              itemCount: mediaUrls.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final url = mediaUrls[index];
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: mediaWidth,
                    child: _isVideo(url)
                        ? PostVideoPlayer(videoUrl: url)
                        : Image.network(
                            url,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, _) => Container(
                              color: Colors.grey.shade300,
                              child:
                                  const Center(child: Icon(Icons.broken_image)),
                            ),
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return Container(
                                color: Colors.grey.shade300,
                                child: const Center(
                                    child: CircularProgressIndicator()),
                              );
                            },
                          ),
                  ),
                );
              },
            ),
          );
  }
}

class PostVideoPlayer extends StatefulWidget {
  final String videoUrl;
  const PostVideoPlayer({super.key, required this.videoUrl});

  @override
  State<PostVideoPlayer> createState() => _PostVideoPlayerState();
}

class _PostVideoPlayerState extends State<PostVideoPlayer> {
  late VideoPlayerController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() => _initialized = true);
        _controller.setLooping(true);
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
