import 'package:cr/notifications/notification_helper.dart';
import 'package:cr/pages/splash_page.dart';
import 'package:cr/pages/tasks_page.dart';
import 'package:cr/pages/updates_page.dart';
import 'package:cr/providers/major_provider.dart';
import 'package:cr/widgets/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationHelper.init();
  //
  var sharedPrefs = await SharedPreferences.getInstance();
  var isAppNotJustInstalled = sharedPrefs.getBool("isAppNotJustInstalled");
  // print("IsAppFirstTimeOpened:$isAppFirstTimeOpened");
  Widget home =
      isAppNotJustInstalled == true ? const MyHome() : const SplashScreen();
  //
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MajorProvider(),
        )
      ],
      child: MyApp(
        homeWidget: home,
      )));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.homeWidget});

  final Widget homeWidget;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CR',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
          colorSchemeSeed: const Color(0xff9c000f),
          useMaterial3: true,
          brightness: Brightness.light),
      darkTheme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color(0xff9c000f),
          brightness: Brightness.dark),
      initialRoute: '/',
      routes: {
        'home': (context) => const MyHome(),
        'tasks': (context) => const TaskScreen(),
        'updates': (context) => const MessageScreen(),
      },
      home: homeWidget,
    );
  }
}

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MajorProvider>(context);
    var theme = Theme.of(context);

    return Scaffold(
      body: provider.loadScreen(),
      bottomNavigationBar: BottomNavigation(theme: theme, provider: provider),
    );
  }
}
