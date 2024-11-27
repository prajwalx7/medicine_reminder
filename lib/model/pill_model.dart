class PillModel {
  final int id;
  final String type;
  final String name;
  final String dosage;
  final List<bool> selectedDays; // Days selected for taking the pill
  bool isTaken; // Whether the pill is taken or not
  final List<int> intTime; // [hour, minute]

  PillModel({
    required this.id,
    required this.type,
    required this.name,
    required this.dosage,
    required this.selectedDays,
    required this.intTime,
    this.isTaken = false,
  });

  // Factory constructor to create a PillModel from JSON
  factory PillModel.fromJson(Map<String, dynamic> json) {
    return PillModel(
      id: json['id'],
      type: json['type'],
      name: json['name'],
      dosage: json['dosage'],
      selectedDays: List<bool>.from(json['selectedDays']),
      intTime: List<int>.from(json['intTime']),
      isTaken: json['isTaken'] ?? false,
    );
  }

  // Convert the PillModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'name': name,
      'dosage': dosage,
      'selectedDays': selectedDays,
      'intTime': intTime,
      'isTaken': isTaken,
    };
  }

  // Helper method to parse `time` into a List<int> [hour, minute]
  static List<int> parseTime(String time) {
    final timeParts = RegExp(r"(\d+):(\d+)\s*(AM|PM)").firstMatch(time);
    if (timeParts == null) {
      throw FormatException("Invalid time format");
    }

    int hour = int.parse(timeParts.group(1)!);
    int minute = int.parse(timeParts.group(2)!);
    String period = timeParts.group(3)!;

    if (period.toUpperCase() == "PM" && hour != 12) {
      hour += 12;
    } else if (period.toUpperCase() == "AM" && hour == 12) {
      hour = 0;
    }

    return [hour, minute];
  }
}
