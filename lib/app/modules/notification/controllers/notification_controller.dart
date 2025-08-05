import 'package:get/get.dart';
import 'package:zest_mobile/app/core/models/model/notification_model.dart'; // Ganti dengan path model Anda

class NotificationController extends GetxController {
  // Gunakan List<NotificationModel> untuk menampung data dari API
  var notifications = <NotificationModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    isLoading.value = true;
    try {
      // Simulasi pengambilan data dari API
      await Future.delayed(const Duration(seconds: 1));
      
      // CONTOH DATA - Ganti ini dengan panggilan API Anda
      notifications.assignAll([
        NotificationModel(id: '1', type: 'SYSTEM', title: 'Welcome Athletes', message: 'Thank you for joining us! Be sure to check out the latest updates and important information right here.', isRead: false, createdAt: DateTime.now()),
        NotificationModel(id: '2', type: 'NEW_FOLLOWER', title: 'Afif', message: 'Just followed you', isRead: false, createdAt: DateTime.now(), imageUrl: 'https://avatar.iran.liara.run/public/1'),
        NotificationModel(id: '3', type: 'ACTIVITY_LIKE', title: 'Chopper', message: 'Liked your activity, Keep it up!', isRead: false, createdAt: DateTime.now(), imageUrl: 'https://avatar.iran.liara.run/public/2'),
        NotificationModel(id: '4', type: 'CHALLENGE_INVITE', title: 'Get Ready for a New Challenge!', message: 'Challenge Time! Eric wants you join on challenge: ZEST People Run', isRead: false, createdAt: DateTime.now(), imageUrl: 'https://avatar.iran.liara.run/public/3'),
        NotificationModel(id: '5', type: 'EVENT_INVITE', title: 'You\'re Invited! Let\'s Run Together!', message: 'You\'re invited! Join Ronney at event: Colour Run 2025', isRead: false, createdAt: DateTime.now(), imageUrl: 'https://avatar.iran.liara.run/public/4'),
        NotificationModel(id: '6', type: 'NEW_COMMENT', title: 'You\'ve got a new comment on your post', message: 'See what they said and reply now', isRead: false, createdAt: DateTime.now(), imageUrl: 'https://avatar.iran.liara.run/public/5'),
        NotificationModel(id: '7', type: 'GROUP_JOIN', title: 'Wooohoo! A new member just joined!', message: 'Your group is growing! Stanley is now part of "Zest Running Club"', isRead: true, createdAt: DateTime.now(), imageUrl: 'https://avatar.iran.liara.run/public/6'),
      ]);
    } finally {
      isLoading.value = false;
    }
  }

  void followBack(String userId) {
    // TODO: Implementasi logika follow back
    Get.snackbar("Followed Back", "You are now following this user.");
  }
}