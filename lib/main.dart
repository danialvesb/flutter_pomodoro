import 'package:flutter/material.dart';
import 'package:pomodoro/pages/pomodoro.dart';
import 'package:pomodoro/store/pomodoro.store.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_mobx/flutter_mobx.dart';
// import './store/count.store.dart';

void main() {
  runApp(const App());
}

// final store = CountStore();

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<PomodoroStore>(
          create: (_) => PomodoroStore(),
        ),
      ],
      child: const MaterialApp(
        home: Pomodoro(),
      ),
    );
  }
}
