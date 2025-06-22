// post_media.dart

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

// --- Widget PostMediaScroll yang Sudah Dimodifikasi ---
class PostMediaScroll extends StatelessWidget {
  // ✅ Diubah: Sekarang menerima List<Widget>
  final List<Widget> mediaItems;

  const PostMediaScroll({super.key, required this.mediaItems});

  @override
  Widget build(BuildContext context) {
    // Jika tidak ada item, jangan tampilkan apa-apa
    if (mediaItems.isEmpty) {
      return const SizedBox.shrink();
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final isSingleMedia = mediaItems.length == 1;
    // Atur lebar item berdasarkan jumlah media
    final mediaWidth = isSingleMedia ? screenWidth : screenWidth * 0.7;

    if (isSingleMedia) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 300,
          width: mediaWidth,
          child: mediaItems.first,
        ),
      );
    }

    return SizedBox(
      height: 300, // Anda bisa sesuaikan tinggi ini jika perlu
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(right: 16), // Padding di awal dan akhir
        itemCount: mediaItems.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          // ✅ Logika itemBuilder menjadi sangat sederhana
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: mediaWidth,
              // Langsung tampilkan widget dari list
              child: mediaItems[index],
            ),
          );
        },
      ),
    );
  }
}


// --- Widget PostVideoPlayer tidak perlu diubah ---
// Widget ini akan kita panggil dari luar PostMediaScroll sekarang
class PostVideoPlayer extends StatefulWidget {
  final String videoUrl;
  const PostVideoPlayer({super.key, required this.videoUrl});

  @override
  State<PostVideoPlayer> createState() => _PostVideoPlayerState();
}

class _PostVideoPlayerState extends State<PostVideoPlayer> {
  // ... (implementasi _PostVideoPlayerState tetap sama)
  late VideoPlayerController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
      videoPlayerOptions: VideoPlayerOptions(
        mixWithOthers: false,
        allowBackgroundPlayback: false,
      ),
    )
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
    if (!_initialized) {
      return Container(
        color: Colors.grey.shade300,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    // Gunakan Stack untuk menumpuk video dan progress indicator
    return Stack(
      fit: StackFit.expand, // Pastikan Stack mengisi seluruh area yang diberikan
      children: [
        // Widget untuk menampilkan video dengan behavior 'cover'
        FittedBox(
          fit: BoxFit.cover, // ✅ Ini adalah kuncinya
          clipBehavior: Clip.hardEdge, // Memotong bagian video yang keluar dari bounds
          child: SizedBox(
            // Beri tahu FittedBox ukuran asli video
            width: _controller.value.size.width,
            height: _controller.value.size.height,
            child: VideoPlayer(_controller),
          ),
        ),
        
        // Letakkan progress indicator di atas video
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: VideoProgressIndicator(
            _controller,
            allowScrubbing: true,
            colors: VideoProgressColors(
              backgroundColor: Colors.black.withOpacity(0.3), // Beri sedikit background agar terlihat
              playedColor: Colors.white, // Ganti warna played agar kontras
              bufferedColor: Colors.white38,
            ),
          ),
        ),
      ],
    );
  }
}