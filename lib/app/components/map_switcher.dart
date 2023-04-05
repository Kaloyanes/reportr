import 'package:flutter/material.dart';

class MapSwitcher extends StatefulWidget {
  const MapSwitcher({super.key, required this.child});

  final Widget child;

  @override
  State<MapSwitcher> createState() => _MapSwitcherState();
}

class _MapSwitcherState extends State<MapSwitcher> {
  bool isMap = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        setState(() {
          isMap = false;
        });
        return Future.value(true);
      },
      child: isMap ? widget.child : const SizedBox.expand(),
    );
  }
}
