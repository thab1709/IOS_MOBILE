// @dart=2.9
import 'package:flutter/material.dart';

class TextSpecialCharView extends StatelessWidget {
  const TextSpecialCharView({this.firstChar, this.lastChar});

  final String firstChar;
  final String lastChar;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Wrap(
        children: [
          Text(
            firstChar,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(lastChar,
                  style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Colors.black)))
        ],
      ),
    );
  }
}

