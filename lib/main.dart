import 'package:flutter/material.dart';
import 'package:knitting_counter/pages/HomeRoute.dart';
import 'package:knitting_counter/pages/SecondRoute.dart';
import 'package:knitting_counter/pages/RowCounterWidget.dart';
import 'package:knitting_counter/pages/SessionsPage.dart';
import 'package:knitting_counter/models/user_session_repository_impl.dart';

void main() {
  final userSessionRepository = UserSessionRepository();
  runApp(
    MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeRoute(),
        '/second': (context) =>
            SecondRoute(sessionRepository: userSessionRepository),
        '/third': (context) {
          final sessionId =
              ModalRoute.of(context)?.settings.arguments as String?;
          return RowCounterWidget(
            sessionRepository: userSessionRepository,
            sessionId: sessionId,
          );
        },
        '/sessions': (context) =>
            SessionsPage(sessionRepository: userSessionRepository),
      },
      debugShowCheckedModeBanner: false,
    ),
  );
}
