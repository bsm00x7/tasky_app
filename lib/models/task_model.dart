



class TaskModel {
  final String id;
  final String taskName;
  final String taskDescription;
  final bool taskPriority;
  bool isDone;

  TaskModel({
    required this.id,
    required this.taskName,
    required this.taskDescription,
    required this.taskPriority,
    this.isDone = false,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json["id"],
      taskName: json["TaskName"],
      taskDescription: json["TaskDescription"] ?? "",
      taskPriority: json["TaskPriority"],
      isDone: json["isDone"] ?? false,
    );
  }

// Convert Task Model to Map
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "TaskName": taskName,
      "TaskDescription": taskDescription,
      "TaskPriority": taskPriority,
      "isDone": isDone, // ✅ include this
    };
  }
}