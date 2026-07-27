import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme.dart';
import 'data/job_repository.dart';
import 'viewmodels/jobs_view_model.dart';
import 'viewmodels/saved_jobs_view_model.dart';
import 'views/home_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();
  runApp(RemoteFlowApp(preferences: preferences));
}

class RemoteFlowApp extends StatefulWidget {
  const RemoteFlowApp({super.key, required this.preferences});
  final SharedPreferences preferences;

  @override
  State<RemoteFlowApp> createState() => _RemoteFlowAppState();
}

class _RemoteFlowAppState extends State<RemoteFlowApp> {
  late bool _dark = widget.preferences.getBool('dark_mode') ?? false;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) =>
              JobsViewModel(RemotiveJobsRepository(Dio(), widget.preferences))
                ..load(),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              SavedJobsViewModel(SavedJobsRepository(widget.preferences)),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'RemoteFlow',
        theme: AppTheme.build(Brightness.light),
        darkTheme: AppTheme.build(Brightness.dark),
        themeMode: _dark ? ThemeMode.dark : ThemeMode.light,
        home: HomeShell(
          darkMode: _dark,
          onThemeChanged: (value) async {
            setState(() => _dark = value);
            await widget.preferences.setBool('dark_mode', value);
          },
        ),
      ),
    );
  }
}
