// @dart=2.9
import 'package:flutter/material.dart';

class ChooseLinePopup extends StatelessWidget {
  final String title;
  final String description1;
  final String description2;
  final String buttonTitle;
  final List<Widget> actions;

  const ChooseLinePopup(
      {this.title,
      this.description1,
      this.description2,
      this.buttonTitle,
      this.actions = const []});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AlertDialog(
          title: Text(
            title,
            style: Theme.of(context).textTheme.headline6,
          ),
          actions: actions,
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                description1,
                style: Theme.of(context).textTheme.bodyText2,
              ),
              const SizedBox(height: 15),
              Text(
                description2,
                style: Theme.of(context).textTheme.bodyText2,
              )
            ],
          ),
        ),
      ],
    );
  }
}

