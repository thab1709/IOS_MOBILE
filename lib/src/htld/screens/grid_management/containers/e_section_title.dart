// @dart=2.9
import 'package:flutter/material.dart';

class ESectionTitle extends StatelessWidget {
  const ESectionTitle(this.title, {this.padding});

  final String title;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: Container(
            color: Colors.grey.shade300,
            height: 1,
          )),
          const SizedBox(
            width: 16,
          ),
          Container(
              constraints: const BoxConstraints(minWidth: 70, maxWidth: 240),
              child: Text(
                title,
                style: const TextStyle(
                    fontWeight: FontWeight.w800, fontSize: 16),
                textAlign: TextAlign.center,
              )),
          const SizedBox(
            width: 16,
          ),
          Expanded(
              child: Container(
            color: Colors.grey.shade300,
            height: 1,
          )),
        ],
      ),
    );
  }
}

