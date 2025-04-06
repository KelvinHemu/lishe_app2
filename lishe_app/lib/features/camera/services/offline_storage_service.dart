import 'dart:convert';
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';

/// Model for pending image tasks
class PendingImageTask {
  final String id;
  final String imagePath;
  final DateTime timestamp;

  PendingImageTask({
    required this.id,
    required this.imagePath,
    required this.timestamp,
  });

  // Convert to JSON for storage
  Map<String, dynamic> toJson() => {
        'id': id,
        'imagePath': imagePath,
        'timestamp': timestamp.toIso8601String(),
      };

  // Create from JSON for retrieval
  factory PendingImageTask.fromJson(Map<String, dynamic> json) {
    return PendingImageTask(
      id: json['id'],
      imagePath: json['imagePath'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

/// Service to handle offline storage and retrieval of images
class OfflineStorageService {
  static OfflineStorageService? _instance;
  static const String _indexFileName = 'pending_images_index.json';
  final _uuid = Uuid();

  // Private constructor
  OfflineStorageService._();

  // Factory constructor for singleton
  factory OfflineStorageService() {
    _instance ??= OfflineStorageService._();
    return _instance!;
  }

  /// Save an image for later processing
  Future<PendingImageTask> saveImageForLaterProcessing(File imageFile) async {
    try {
      // Create a directory for storing our pending images
      final appDir = await getApplicationDocumentsDirectory();
      final pendingDir = Directory('${appDir.path}/pending_images');

      // Create directory if it doesn't exist
      if (!await pendingDir.exists()) {
        await pendingDir.create(recursive: true);
      }

      // Create unique ID for the task
      final taskId = _uuid.v4();

      // Create a copy of the image in our pending directory
      final savedImagePath = '${pendingDir.path}/$taskId.jpg';
      await imageFile.copy(savedImagePath);

      // Create a task record
      final task = PendingImageTask(
        id: taskId,
        imagePath: savedImagePath,
        timestamp: DateTime.now(),
      );

      // Add to the index
      await _addTaskToIndex(task);

      print('Image saved for later processing: $savedImagePath');
      return task;
    } catch (e) {
      print('Error saving image for later: $e');
      rethrow;
    }
  }

  /// Add a task to the index file
  Future<void> _addTaskToIndex(PendingImageTask task) async {
    try {
      // Get all pending tasks
      final tasks = await getPendingTasks();

      // Add the new task
      tasks.add(task);

      // Save the updated index
      await _saveIndex(tasks);
    } catch (e) {
      print('Error adding task to index: $e');
      rethrow;
    }
  }

  /// Remove a task from the index
  Future<void> removeTask(String taskId) async {
    try {
      // Get all pending tasks
      final tasks = await getPendingTasks();

      // Find the task
      final taskIndex = tasks.indexWhere((task) => task.id == taskId);
      if (taskIndex == -1) {
        print('Task not found: $taskId');
        return;
      }

      // Get the task for file deletion
      final task = tasks[taskIndex];

      // Remove from the list
      tasks.removeAt(taskIndex);

      // Save the updated index
      await _saveIndex(tasks);

      // Delete the image file
      final imageFile = File(task.imagePath);
      if (await imageFile.exists()) {
        await imageFile.delete();
      }

      print('Task removed: $taskId');
    } catch (e) {
      print('Error removing task: $e');
      rethrow;
    }
  }

  /// Get all pending tasks
  Future<List<PendingImageTask>> getPendingTasks() async {
    try {
      final indexFile = await _getIndexFile();

      // If the file doesn't exist, return an empty list
      if (!await indexFile.exists()) {
        return [];
      }

      // Read and parse the file
      final jsonString = await indexFile.readAsString();
      if (jsonString.isEmpty) {
        return [];
      }

      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList
          .map((jsonItem) => PendingImageTask.fromJson(jsonItem))
          .toList();
    } catch (e) {
      print('Error getting pending tasks: $e');
      return []; // Return empty list on error
    }
  }

  /// Save the index of pending tasks
  Future<void> _saveIndex(List<PendingImageTask> tasks) async {
    try {
      final indexFile = await _getIndexFile();
      final jsonList = tasks.map((task) => task.toJson()).toList();
      await indexFile.writeAsString(json.encode(jsonList));
    } catch (e) {
      print('Error saving index: $e');
      rethrow;
    }
  }

  /// Get the index file
  Future<File> _getIndexFile() async {
    final appDir = await getApplicationDocumentsDirectory();
    return File('${appDir.path}/$_indexFileName');
  }

  /// Get a pending image file
  Future<File?> getImageFile(String taskId) async {
    try {
      // Get all pending tasks
      final tasks = await getPendingTasks();

      // Find the task
      final task = tasks.firstWhere(
        (task) => task.id == taskId,
        orElse: () => throw Exception('Task not found: $taskId'),
      );

      // Check if the file exists
      final imageFile = File(task.imagePath);
      if (!await imageFile.exists()) {
        throw Exception('Image file not found: ${task.imagePath}');
      }

      return imageFile;
    } catch (e) {
      print('Error getting image file: $e');
      return null;
    }
  }
}
