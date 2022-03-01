import 'package:flutter/material.dart';

class AlertBox extends StatelessWidget {
  final Color? iconColor;
  final Widget child;
  const AlertBox({Key? key, this.iconColor, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Card(
          color: Colors.grey[850],
          elevation: 0.0,
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.error_outline,
                    color: iconColor ?? Colors.redAccent,
                  ),
                ),
                Expanded(child: child),
              ],
            ),
          ),
          margin: const EdgeInsets.all(10.0),
        ),
      ],
    );
  }
}
