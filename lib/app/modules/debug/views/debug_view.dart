    // file: app/modules/debug/views/debug_view.dart

    import 'package:flutter/material.dart';
    import 'package:get/get.dart';
    import 'package:zest_mobile/app/core/di/service_locator.dart';
    import 'package:zest_mobile/app/core/services/log_service.dart';
import 'package:zest_mobile/app/modules/debug/controllers/debug_controller.dart';

    class DebugView extends StatelessWidget {
      const DebugView({super.key});

      @override
      Widget build(BuildContext context) {
        // Dapatkan instance LogService dari service locator Anda
        final logService = sl<LogService>();
        final controller = Get.put(DebugController());
        controller.onDebugViewReady();

        return Scaffold(
      appBar: AppBar(
        title: const Text('Debug & Logs'),
        backgroundColor: Colors.grey[850],
        actions: [
          // Tombol Refresh
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshLogs,
            tooltip: 'Refresh Logs',
          ),
        ],
      ),
      body: Column(
        children: [
          // ✨ Area untuk menampilkan log
          Expanded(
            child: Container(
              color: Colors.black,
              padding: const EdgeInsets.all(8.0),
              child: Obx(
                () => SingleChildScrollView(
                  reverse: true, // Scroll otomatis ke bawah
                  child: SelectableText(
                    controller.logContent.value,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Area untuk tombol aksi
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey[850],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.share, size: 20),
                    label: const Text('Export'),
                    onPressed: () => logService.exportLogs(),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextButton.icon(
                    icon: const Icon(Icons.delete_forever, size: 20),
                    label: const Text('Clear'),
                    onPressed: () {
                      Get.dialog(
                        AlertDialog(
                          title: const Text("Confirm"),
                          content: const Text("Are you sure you want to clear the log file?"),
                          actions: [
                            TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
                            TextButton(
                              onPressed: () {
                                controller.clearAndRefreshLogs();
                                Get.back();
                              },
                              child: const Text("Clear", style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        )
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(vertical: 12)
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
      }
    }
    