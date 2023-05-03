import 'dart:math';
import 'package:habit_tracker/main.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/pages/home_page.dart';

class NotificationService {
  static Future<void> notificationAllowed() async {
    await AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) async {
        if (!isAllowed) {
          await AwesomeNotifications().requestPermissionToSendNotifications();
        }
      },
    );
  }

  //method to detect when a new notification or schedule is created
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('onNotificationCreatedMethod');
  }

//method to detect every time a new notification  is displayed
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('onNotificationDisplayedMethod');
  }

//Method to detect if user dismissed notification
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('onDismissActionsReceivedMethod');
  }

//method to detect when user taps on a notification or action button
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('onActionReceiveMethod');
    final payload = receivedAction.payload ?? {};
    if (payload["navigate"] == true) {
      MainApp.navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => const HomePage(),
        ),
      );
    }
  }

  //this method shows a notification on the page
  //we need to have conditions on when it is clicked - what happens to a notification?
  static Future<void> showNotification({
    required final String title,
    required final String body,
    final String? summary,
    final Map<String, String>? payload,
    final ActionType actionType = ActionType.Default,
    final NotificationLayout notificationLayout = NotificationLayout.Default,
    final NotificationCategory? category,
    final String? bigPicture,
    final List<NotificationActionButton>? actionButtons,
    final bool scheduled = false,
    final int? interval,
  }) async {
    assert(!scheduled || (scheduled && interval != null));

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: -1,
        channelKey: 'high_importance_channel',
        title: title,
        body: body,
        actionType: actionType,
        notificationLayout: notificationLayout,
        summary: summary,
        category: category,
        payload: payload,
        bigPicture: bigPicture,
        backgroundColor: Colors.amber,
      ),
      actionButtons: actionButtons,
      schedule: scheduled
          ? NotificationInterval(
              interval: interval,
              timeZone:
                  await AwesomeNotifications().getLocalTimeZoneIdentifier(),
              preciseAlarm: true,
            )
          : null,
    );
  }

  //this allows us to create scheduled notifications & input in the date and time
  static Future<bool> scheduleNotification({
    required final String title,
    required final String body,
    required final int Day,
    required final int Month,
    required final int Year,
    required final int Hour,
    required final int Minute,
  }) async {
    final AwesomeNotifications awesomeNotifications = AwesomeNotifications();
    return await awesomeNotifications.createNotification(
        schedule: NotificationCalendar(
          day: Day,
          month: Month,
          year: Year,
          hour: Hour,
          minute: Minute,
          repeats: true,
        ),
        content: NotificationContent(
          id: Random().nextInt(100),
          title: title,
          body: body,
          channelKey: 'scheduled_notification',
          wakeUpScreen: true,
          autoDismissible: false,
          notificationLayout: NotificationLayout.Default,
          category: NotificationCategory.Reminder,
          backgroundColor: Colors.amber,
        ));
  }

  //this method will repeat notifications everyday at a specific time in the day
  static Future<bool> dailyNotification({
    required final String title,
    required final String body,
    required final int Hour,
    required final int Minute,
  }) async {
    final AwesomeNotifications awesomeNotifications = AwesomeNotifications();
    return await awesomeNotifications.createNotification(
        schedule: NotificationCalendar(
          hour: Hour,
          minute: Minute,
          repeats: true,
        ),
        content: NotificationContent(
          id: Random().nextInt(100),
          title: "Scheduled Notification",
          body: "This notification goes off at 4 pm on Apr 26, 2023",
          channelKey: 'scheduled_notification',
          wakeUpScreen: true,
          autoDismissible: false,
          notificationLayout: NotificationLayout.Default,
          category: NotificationCategory.Reminder,
        ));
  }

  static Future<void> retrieveScheduledNotifications() async {
    final AwesomeNotifications awesomeNotifications = AwesomeNotifications();
    List<NotificationModel> scheduledNotifications =
        await awesomeNotifications.listScheduledNotifications();
    print(scheduledNotifications);
  }
}
