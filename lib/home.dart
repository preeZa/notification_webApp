import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:notification_web/auth.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseAccessToken firebaseAccessToken = FirebaseAccessToken();
  String accessToken = '';
  @override
  void initState() {
    super.initState();

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings darwinInitializationSettings =DarwinInitializationSettings();

    const InitializationSettings initializationSettings = InitializationSettings(android: androidInitializationSettings,iOS: darwinInitializationSettings);

    const AndroidNotificationChannel channel = AndroidNotificationChannel('messages', 'messages',description: 'This is for flutter firebase',importance: Importance.max);
    
    createChanel(channel);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen(
      (event) {
        if (event.notification == null) return;
        // showDialog(
        //     context: context,
        //     builder: (context) {
        //       return Column(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         crossAxisAlignment: CrossAxisAlignment.center,
        //         children: [
        //           Container(
        //             width: 200,
        //             height: 200,
        //             color: Colors.white,
        //             child: Column(
        //               children: [
        //                 Text(event.notification?.title ?? ''),
        //                 const SizedBox(
        //                   height: 8,
        //                 ),
        //                 Text(event.notification?.body ?? '')
        //               ],
        //             ),
        //           )
        //         ],
        //       );
        //     });
        final notification = event.notification;
        final android = event.notification?.android;
        if(notification != null && android != null){
          flutterLocalNotificationsPlugin.show(notification.hashCode, notification.title, notification.body, NotificationDetails(
            android: AndroidNotificationDetails(channel.id,channel.name,channelDescription: channel.description,icon: android.smallIcon)
          ));
        }
      },
    );
    getAccessToken();
  }
  void createChanel(AndroidNotificationChannel channel) async {
    final FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();
    await plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
  }

  Future<void> getAccessToken() async {
    accessToken = await firebaseAccessToken.getToken();
    setState(() {
      accessToken = accessToken;
      print(accessToken);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Text(accessToken),
        const SizedBox(
          height: 10,
        ),
        TextButton(
            onPressed: () {
              sendMessage();
            },
            child: const Text('send'))
      ],
    ));
  }

  void sendMessage() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    final token = await messaging.getToken(
        vapidKey:"BB_DEso4vCLc-B1VWU4iNr01JdUyYIurcwMngYfgv2De6tU74N-BzaHo2AsVnm9BykTx_SQekkZvh1VCHNsvZ_w");
     print('-------------------------------------------------');
    print(token);
    final data = {
      "message": {
        "token": token,
        "notification": {"body": "Test notification", "title": "Hello Preecha"}
      }
    };

    final response = await http.post(
      Uri.parse(
          'https://fcm.googleapis.com/v1/projects/notificationwebpreecha/messages:send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      print("Notification sent successfully");
    } else {
      print("Failed to send notification");
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
    }
  }
}
