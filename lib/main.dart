import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_journal_app/core/common/app/providers/user_provider.dart';
import 'package:mental_health_journal_app/core/resources/colours.dart';
import 'package:mental_health_journal_app/core/services/router/router.dart';
import 'package:mental_health_journal_app/core/services/service_locator.dart';
import 'package:mental_health_journal_app/features/dashboard/providers/dashboard_controller.dart';
import 'package:mental_health_journal_app/features/notifications/utils/notification_utils.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

// void callbackDispatcher()
// {
//   Workmanager().executeTask((task, inputData) async{
//
//     return Future.value(true);
//   });
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUpServices();
  await Firebase.initializeApp();

  debugPrint('✅ Initializing WorkManager...');
  await Workmanager().initialize(
    callbackDispatcher,
  );
  debugPrint('✅ WorkManager Initialized Successfully!');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => DashBoardController(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          colorScheme: ColorScheme.fromSeed(seedColor: Colours.primaryColor),
        ),
        onGenerateRoute: onGenerateRoute,
      ),
    );
  }
}
