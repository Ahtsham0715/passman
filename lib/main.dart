import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:passman/constants.dart';
import 'package:passman/firebase_options.dart';
import 'package:passman/records/models/password_model.g.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'Auth/splash_screen.dart';
import 'package:logging/logging.dart';
import 'package:logging_appenders/logging_appenders.dart';

final _logger = Logger('main');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // await ScreenProtector.protectDataLeakageOn();
  var directory = await getApplicationDocumentsDirectory();
  // Directory privateDir = Directory('${directory.path}/private');

  // if (!await privateDir.exists()) {
  //   await privateDir.create();
  // }

  // // Create a .nomedia file in the private directory
  // File nomediaFile = File('${privateDir.path}/.nomedia');
  // if (!await nomediaFile.exists()) {
  //   await nomediaFile.create();
  // }

  await Hive.initFlutter(directory.path);
  Hive.registerAdapter(PasswordModelAdapter());
  // await Hive.openBox<PasswordModel>('my_data');
  await Hive.openBox('logininfo');

  Logger.root.level = Level.ALL;
  PrintAppender().attachToLogger(Logger.root);
  _logger.info('Initialized logger.');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Passman',
        theme: ThemeData(
            primarySwatch: Colors.green,
            primaryColor: Color(0XFFd66d75),
            fontFamily: 'majalla',
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            appBarTheme:
                AppBarTheme(iconTheme: IconThemeData(color: Colors.white))),
        home: const SplashScreen(),
      );
    });
  }
}
