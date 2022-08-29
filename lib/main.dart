import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_app/utils/database/database.dart';
import 'package:news_app/utils/utils.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await DatabaseHepler().intiDatabase();
  await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp])
      .then((value) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: ProviderBind.providers,
        builder: (context, child) {
          return const MaterialApp(
            initialRoute: RouteUtilities.root,
            debugShowCheckedModeBanner: false,
            onGenerateRoute: RouteUtilities.onGenerateRoute,
          );
        });
  }
}
