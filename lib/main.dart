import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:timezone/browser.dart' as tz;

import 'package:web_duplicate_app/constants.dart';
import 'package:web_duplicate_app/firebase_options.dart';
import 'package:web_duplicate_app/screens/project/project.dart';
import 'package:web_duplicate_app/screens/project_board/components/project_board.dart';
import 'package:web_duplicate_app/screens/project_board/project_board_screen.dart';
import 'package:web_duplicate_app/services/user.dart';

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await tz.initializeTimeZone();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  UserService userService = UserService();
  await userService.exampleUsage();

  // FrameService frameService = FrameService();
  // frameService.exampleUsage();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      title: 'Film Planner',
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.space):
            const SelectIntent()
      },
      localizationsDelegates: const [
        AppFlowyEditorLocalizations.delegate,
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: colorSkyBlue),
        useMaterial3: false,
        scrollbarTheme: const ScrollbarThemeData(
          thumbColor: MaterialStatePropertyAll(colorLightBlue),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const ProjectBoardScreen(),
    );
  }
}
