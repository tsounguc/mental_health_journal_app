import 'package:flutter/material.dart';
import 'package:mental_health_journal_app/core/common/app/providers/user_provider.dart';
import 'package:mental_health_journal_app/core/resources/colours.dart';
import 'package:mental_health_journal_app/core/services/router/router.dart';
import 'package:mental_health_journal_app/core/services/service_locator.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUpServices();
  // await Firebase.initializeApp();
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
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
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
