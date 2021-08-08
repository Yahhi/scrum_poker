import 'package:flutter/material.dart';

class NoItems extends StatelessWidget {
  const NoItems({Key? key, required this.title, this.subtitle}) : super(key: key);

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Image.asset('assets/images/lazy_cat.png'),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headline3,
                ),
                if (subtitle != null) Text(subtitle!)
              ],
            ),
          )
        ],
      );
}
