import 'package:flutter/material.dart';

import '../features/auth/presentation/auth_screen.dart';
import '../features/home/presentation/home_shell.dart';
import 'app_scope.dart';
import 'app_services.dart';
import 'theme/app_theme.dart';

class DTableApp extends StatefulWidget {
  const DTableApp({
    super.key,
    this.services,
  });

  final AppServices? services;

  @override
  State<DTableApp> createState() => _DTableAppState();
}

class _DTableAppState extends State<DTableApp> {
  late final AppServices _services;
  late final bool _ownsServices;

  @override
  void initState() {
    super.initState();
    _ownsServices = widget.services == null;
    _services = widget.services ?? AppServices.bootstrap();
  }

  @override
  void dispose() {
    if (_ownsServices) {
      _services.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      services: _services,
      child: MaterialApp(
        title: 'D Table',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: AnimatedBuilder(
          animation: _services.authController,
          builder: (context, _) {
            if (!_services.authController.isAuthenticated) {
              return const AuthScreen();
            }
            return const HomeShell();
          },
        ),
      ),
    );
  }
}
