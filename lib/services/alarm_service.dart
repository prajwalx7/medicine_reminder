import 'dart:math';
import 'package:alarm/alarm.dart';
import 'package:permission_handler/permission_handler.dart';

class AlarmService {
  static final Random _random = Random();

  static final Map<int, int> _pillAlarms = {};

  static Future<void> scheduleAlarm({
    required int pillId,
    required DateTime alarmTime,
    required String medicineName,
    required int dayOfWeek,
  }) async {
    if (!(await Permission.notification.isGranted)) {
      final status = await Permission.notification.request();
      if (!status.isGranted) {
        print("Notification permission denied");
        return;
      }
    }

    DateTime nextAlarmTime = alarmTime;
    while (nextAlarmTime.weekday != dayOfWeek) {
      nextAlarmTime = nextAlarmTime.add(const Duration(days: 1));
    }

    final int alarmId = _random.nextInt(2147483647);

    _pillAlarms[pillId] = alarmId;
    final alarmSettings = AlarmSettings(
      id: alarmId,
      dateTime: nextAlarmTime,
      assetAudioPath: 'assets/audio/ring.mp3',
      loopAudio: true,
      vibrate: true,
      fadeDuration: 3.0,
      notificationSettings: NotificationSettings(
        title: 'Medicine Reminder',
        body: 'It\'s time to take your $medicineName!',
        stopButton: 'Taken',
      ),
    );

    await Alarm.set(alarmSettings: alarmSettings);
  }

  static Future<void> cancelAlarm(int pillId) async {
    final alarmId = _pillAlarms[pillId];

    if (alarmId != null) {
      await Alarm.stop(alarmId);
      _pillAlarms.remove(pillId);
      print("Alarm for pill ID $pillId canceled.");
    } else {
      print("No alarm found for pill ID $pillId.");
    }
  }
}
