import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Text(
            'Home Page',
            style: TextStyle(fontSize: 30),
          ),
          // RaisedButton(
          //   child: Text('Go to About'),
          //   onPressed: () {
          //     Navigator.pushNamed(context, '/about');
          //   },
          // ),
        ],
      ),
    );
  }
}