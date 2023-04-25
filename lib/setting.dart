import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String _inputMileage = '0';

  @override
  void initState() {
    _get();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting Page'),
      ),
      body: Container (
        padding: EdgeInsets.all(64),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 8),
            TextField(
              keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
              controller: TextEditingController(text: _inputMileage),
              decoration: InputDecoration(
                  labelText: "Set Mileage",
                  border: OutlineInputBorder()
              ),
              onChanged: (String value) {
                _inputMileage = value;
              },
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _save();
                },
                child: Text('Submit', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _get() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _inputMileage = prefs.getInt('setMileage').toString();
      if (_inputMileage == 'null') {
        _inputMileage = '0';
      }
    });
  }

  _save() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int setMileage = int.parse(_inputMileage);

    if (setMileage <= 0) {
      showDialog(
          context: context,
          builder: (_) {
            return ErrorDialog();
          }
      );
    } else {
      setState(() {
        prefs.setInt('setMileage', setMileage);
      });
      Navigator.of(context).pop();
    }
  }
}

class ErrorDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Error'),
      actions: <Widget>[
        GestureDetector(
          child: Text('OK'),
          onTap: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}