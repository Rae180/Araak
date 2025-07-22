import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:start/firebase_options.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  // 1. Make background handler a top-level function
  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await _showFlutterNotification(message);
  }

  // 2. Static function for background notification response
  @pragma('vm:entry-point')
  static void onBackgroundNotificationResponse(NotificationResponse response) {
    print('User tapped notification : ${response.payload}');
  }

  static Future<void> initilaizeNotification() async {
    // Initialize notifications FIRST
    await _initializeLocalNotification();
    
    await _firebaseMessaging.requestPermission();
    
    // Set background handler
    FirebaseMessaging.onBackgroundMessage(
        firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await _showFlutterNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print('An app opened : ${message.data}');
    });

    await _getFcmToken();
    await _getInitialNotification();
  }

  static Future<void> _getFcmToken() async {
    String? token = await _firebaseMessaging.getToken();
    print('FCM Token : $token');
  }

  static Future<void> _showFlutterNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    Map<String, dynamic>? data = message.data;

    String title = notification?.title ?? data['title'] ?? 'No Title';
    String body = notification?.body ?? data['body'] ?? 'No Body';

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'CHANNEL_ID', 
      'CHANNEL_NAME',
      channelDescription: 'Notification channel',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0, 
      title, 
      body, 
      notificationDetails,
      payload: message.data.toString(),
    );
  }

  static Future<void> _initializeLocalNotification() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
        
    const InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
    );
    
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      // 3. Use the static handler here
      onDidReceiveBackgroundNotificationResponse: onBackgroundNotificationResponse,
    );
  }

  static Future<void> _getInitialNotification() async {
    RemoteMessage? message = await _firebaseMessaging.getInitialMessage();
    if (message != null) {
      print('APP Launched from : ${message.data}');
    }
  }
}