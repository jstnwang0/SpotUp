import 'package:flutter/material.dart';

class TabWidget extends StatelessWidget {
  const TabWidget({
    Key key,
    @required this.scrollController,
  }) : super(key: key);
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) => ListView(
        padding: EdgeInsets.all(16),
        controller: scrollController,
        children: [
          Text(
            'some bullshit honestly',
            textAlign: TextAlign.center,
          ),
          Container(
            height: 300,
            width: 200,
            child: Image.asset('assets/snorlax.png'),
          ),
        ],
      );
}
