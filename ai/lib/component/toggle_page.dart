import 'package:flutter/material.dart';
import 'package:ai/screens/home_screen.dart';
import 'package:ai/screens/ana_screens.dart';
class TooglePage extends StatefulWidget {
  const TooglePage({super.key});
 @override
  State<TooglePage> createState() => _TooglePageState();}
class _TooglePageState extends State<TooglePage> {
  bool _showHomeScreen = true;
  void _toogleScreen() {
    setState(() {
      _showHomeScreen = !_showHomeScreen;
    });
  }
  @override
  Widget build(BuildContext context) {
    if (_showHomeScreen) {
      return HomeScreen(
        showPromptScreen: _toogleScreen,
      );
    } else {
      return PromptScreen(
        showHomeScreen: _toogleScreen,
      );
    }
  }
}
