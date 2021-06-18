import 'package:flutter/material.dart';

class AuthenScreen extends StatefulWidget {
  const AuthenScreen({Key? key}) : super(key: key);

  @override
  _AuthenScreenState createState() => _AuthenScreenState();
}

class _AuthenScreenState extends State<AuthenScreen> {
  TextEditingController _textPass = new TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              child: TextField(
                obscureText: true,
                autofocus: true,
                decoration: InputDecoration(hintText: "Password ..."),
                textAlign: TextAlign.center,
                controller: _textPass,
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                if (_textPass.text == "123") {
                  Navigator.of(context).pushReplacementNamed("/home", arguments: true);
                }
              },
              child: Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
