import 'dart:convert';
import 'dart:io';

import 'package:category/utils/constant.dart';
import 'package:category/utils/routeGenerator.dart';
import 'package:category/utils/routeGeneratorPartner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/locale.dart';
import 'package:flutter/material.dart' as mLocale;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'l10n/l10n.dart';
import 'modals/user.dart';
import 'utils/sharedPrefs.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

ValueNotifier<bool> valueNotifier = ValueNotifier<bool>(true);

ValueNotifier<String> locale = ValueNotifier<String>("en");

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await SharedPrefs().init();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  String lang = locale.value??"en";

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<Map<String, dynamic>> onNotificationSelected(String payload) async {
    Map<String, dynamic> data = json.decode(payload);

    if(SharedPrefs().isUserRoleAvailable() && SharedPrefs().userRole == "customer" && data["type"] == "promo" ){
      await Future.delayed(Duration.zero);
      Navigator.of(context).pushNamed("/PromoCode");
    }
    return Future.value(data);
  }

  _downloadAndSaveFile(String url, String fileName) async {
    var directory = await getApplicationDocumentsDirectory();
    var filePath = '${directory.path}/$fileName';
    var response = await http.get(Uri.parse(url));
    var file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  showNotification(RemoteMessage data) async {
    var attachmentPicturePath = await _downloadAndSaveFile(
        data.data["images"], data.data["filename"]);
    print("image" + data.data['images']);
    print("filename" + data.data['filename']);
    var andriod = AndroidNotificationDetails(
      "CL",
      "Catalog",
      "Catalog",
      priority: Priority.high,
      importance: Importance.max,
      largeIcon: (FilePathAndroidBitmap(attachmentPicturePath)),
    );
    var ios = IOSNotificationDetails();
    var platform = new NotificationDetails(android: andriod, iOS: ios);
    await _flutterLocalNotificationsPlugin.show(
        0, data.notification.title, data.notification.body, platform,
        payload: json.encode(data.data));
  }

  showPromoNotification(RemoteMessage data) async {
    var andriod = AndroidNotificationDetails(
      "CL",
      "Catalog",
      "Catalog",
      priority: Priority.high,
      importance: Importance.max,
    );
    var ios = IOSNotificationDetails();
    var platform = new NotificationDetails(android: andriod, iOS: ios);
    await _flutterLocalNotificationsPlugin.show(
        0, data.notification.title, data.notification.body, platform,
        payload: json.encode(data.data));
  }

  @override
  void initState() {
    if(SharedPrefs().isUserRoleAvailable()){
     valueNotifier.value =  SharedPrefs().isUserRoleAvailable() && SharedPrefs().userRole == "partner";
     valueNotifier.notifyListeners();
    }
    if(SharedPrefs().isLocaleAvailable()){
      locale.value = SharedPrefs().locale;
      locale.notifyListeners();
    }
    locale.addListener(() {
      lang = locale.value;
      setState(() {});
    });

    var initializationSettingAndroid =
    AndroidInitializationSettings('ic_launcher');
    var initializationSettingIos = IOSInitializationSettings();

    var initSettings = InitializationSettings(
      android: initializationSettingAndroid,
      iOS: initializationSettingIos,
    );

    _flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: onNotificationSelected);

    _firebaseMessaging.requestPermission(sound: true, badge: true, alert: true);
    _firebaseMessaging.subscribeToTopic('notification');
    _firebaseMessaging.subscribeToTopic('promo');

    FirebaseMessaging.onMessage.listen((event) {
      print("pref user role ${event.data['type']}");
      print("pref user role ${SharedPrefs().userRole}");
      if(SharedPrefs().isUserRoleAvailable() && SharedPrefs().userRole == event.data['type'] ){
        showNotification(event);
      }

      if(SharedPrefs().isUserRoleAvailable() && SharedPrefs().userRole == "customer" && event.data["type"] == "promo" ){
        showPromoNotification(event);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print("pref user role ${event.data['type']}");
      print("pref user role ${SharedPrefs().userRole}");
      if(SharedPrefs().isUserRoleAvailable() && SharedPrefs().userRole == event.data['type'] ){
        showNotification(event);
      }

      if(SharedPrefs().isUserRoleAvailable() && SharedPrefs().userRole == "customer" && event.data["type"] == "promo" ){
        showPromoNotification(event);
      }

    });

    _firebaseMessaging.getToken().then((value) {
     var _userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));
      FirebaseFirestore.instance
          .collection('token')
          .doc(_userInfo.userData.id)
          .set({
        'token': value,
      }, SetOptions(merge: true));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("User Role ${SharedPrefs().userRole}");
    return ValueListenableBuilder<bool>(valueListenable: valueNotifier, builder: (BuildContext ctx, bool value, Widget child) {
     print("value ${valueNotifier.value}");

      return value? MaterialApp(
          key: GlobalKey<NavigatorState>(),
          debugShowCheckedModeBanner: false,
          title: 'Catalog',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: white,
            accentColor: white,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: mLocale.Locale(lang),
          supportedLocales: L10n.all,
          initialRoute: '/splash',
          onGenerateRoute: RouteGeneratorPartner.generateRoute,
        ):
      MaterialApp(
          key: GlobalKey<NavigatorState>(),
          debugShowCheckedModeBanner: false,
          title: 'Catalog',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: white,
            accentColor: white,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: mLocale.Locale(lang),
          supportedLocales: L10n.all,
          initialRoute: '/splash',
          onGenerateRoute: RouteGeneratorCust.generateRoute,
        );



    });
  }
}
