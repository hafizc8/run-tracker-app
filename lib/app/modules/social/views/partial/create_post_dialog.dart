import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class CreatePostDialog extends StatelessWidget {
  const CreatePostDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shadowColor: Theme.of(context).colorScheme.onPrimary,
      surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      insetPadding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(radius: 20, backgroundColor: Colors.grey.shade300),
                const SizedBox(width: 8),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'What\'s up Yola?',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Share a photo, post, or activity with your followers!',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
        
            // Input Field
            TextFormField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Jot down your activity here',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
        
            const SizedBox(height: 12),
        
            // Optional: Media Upload / Tags / Location
            Row(
              children: [
                TextButton.icon(
                  onPressed: () {}, 
                  icon: const Icon(
                    Icons.photo,
                    size: 18,
                  ), 
                  label: Text(
                    'Add Photo or Video',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 12,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.primary.withOpacity(0.2)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 15)),
                  ),
                ),
              ],
            ),
        
            const SizedBox(height: 20),
        
            // Action Button
            Row(
              children: [
                // Tombol Back (30%)
                Expanded(
                  flex: 3,
                  child: OutlinedButtonTheme(
                    data: OutlinedButtonThemeData(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.onPrimary,
                        minimumSize: const Size.fromHeight(40),
                        side: BorderSide(color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                    child: OutlinedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text('Back'),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
        
                // Tombol Post (70%)
                Expanded(
                  flex: 7,
                  child: ElevatedButtonTheme(
                    data: ElevatedButtonThemeData(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        minimumSize: const Size.fromHeight(40),
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text('Post'),
                    ),
                  ),
                ),
        
              ],
            ),
        
          ],
        ),
      ),
    );
  }
}