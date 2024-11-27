import 'package:hive/hive.dart';

part 'pill_model.g.dart';

@HiveType(typeId: 0)
class PillModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String type;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String dosage;

  @HiveField(4)
  final String time;

  @HiveField(5)
  final List<bool> selectedDays;

  @HiveField(6)
  bool isTaken;

  PillModel({
    required this.id,
    required this.type,
    required this.name,
    required this.dosage,
    required this.time,
    required this.selectedDays,
    this.isTaken = false,
  });
}
