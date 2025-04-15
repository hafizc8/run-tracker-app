import 'package:get_storage/get_storage.dart';

class StorageService {
  final GetStorage _box = GetStorage();

  // Save generic
  Future<void> write<T>(String key, T value) async {
    await _box.write(key, value);
  }

  // Read generic
  T? read<T>(String key) {
    return _box.read<T>(key);
  }

  // Remove
  Future<void> remove(String key) async {
    await _box.remove(key);
  }

  // Clear all
  Future<void> clear() async {
    await _box.erase();
  }
}
