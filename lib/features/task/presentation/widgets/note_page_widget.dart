import 'package:flutter/material.dart';

import '../../../../assets/assets_manager.dart';

class NotePageWidget extends StatelessWidget {
  const NotePageWidget({
    super.key,
    this.children,
    this.containerColor = Colors.black,
  }) : assert(children != null);

  factory NotePageWidget.withEndTaskContainer() {
    return NotePageWidget(
      containerColor: Colors.white,
      children: [
        Image.asset(AssetsManager.astronautManPng),
        Text('End of Tasks, Have a nice day'),
      ],
    );
  }
  final List<Widget>? children;
  final Color? containerColor;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return 
        Container(
         
          height: height * .6,
          width: double.infinity,
          decoration: _containerDecoration(containerColor),
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(left: 20, right: 20),
          child: SingleChildScrollView(child: Column(children: children!)),
        );
       
  }

  BoxDecoration _containerDecoration([Color? color = Colors.black]) {
    return BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.white.withValues(alpha: 0.5),
          blurRadius: 10,
          spreadRadius: -2,
          blurStyle: BlurStyle.solid,
          offset: Offset(0, 20),
        ),
        BoxShadow(
          color: Colors.white.withValues(alpha: 0.1),
          blurRadius: 10,
          spreadRadius: -2,
          blurStyle: BlurStyle.normal,
          offset: Offset(0, 18),
        ),
      ],
      color: color,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
    );
  }
}
