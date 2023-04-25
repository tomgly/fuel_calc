import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  String _mileage = '0';
  String _gallon = '0';
  String _result = '0';
  String _date = '01/01/2023';
  int _setMileage = 0;
  final _txtCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Page'),
      ),
      body: Container(
        padding: EdgeInsets.all(64),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 8),
            TextField(
              keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
              decoration: InputDecoration(
                  labelText: "Mileage",
                  border: OutlineInputBorder()
              ),
              onChanged: (String value) {
                _mileage = value;
              },
            ),
            const SizedBox(height: 8),
            TextField(
              keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
              decoration: InputDecoration(
                  labelText: "Gallon",
                  border: OutlineInputBorder()
              ),
              onChanged: (String value) {
                _gallon = value;
              },
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _txtCont,
              keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Date',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () async {
                    DateTime initDate = DateTime.now();
                    try {
                      initDate = DateFormat('MM/dd/yyyy').parse(_txtCont.text);
                    } catch (_) {}
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: initDate,
                      firstDate: DateTime(2023),
                      lastDate: DateTime(2100),
                    );
                    _date = DateFormat('MM/dd/yyyy').format(picked!);
                    _txtCont.text = _date;
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _calc();
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

  _calc() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _setMileage = prefs.getInt('setMileage') ?? 0;
    double inputmileage = double.parse(_mileage);
    double gallon = double.parse(_gallon);

    // Calculation
    double mileage = inputmileage - _setMileage;
    double result = mileage / gallon;
    _result = result.toStringAsFixed(2) + ' mpg';

    //Check
    if (result <= 0 || _result == 'Infinity mpg' || _result == 'NaN mpg') {
      showDialog(
          context: context,
          builder: (_) {
            return ErrorDialog();
          }
      );
    } else {
      _save();
      Navigator.of(context).pop();
    }
  }

  _save() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> mileageList = prefs.getStringList('mileage') ?? [];
    List<String> gallonList = prefs.getStringList('gallon') ?? [];
    List<String> resultList = prefs.getStringList('result') ?? [];
    List<String> dateList = prefs.getStringList('date') ?? [];

    setState(() {
      mileageList.add(_mileage);
      prefs.setStringList('mileage', mileageList);
      gallonList.add(_gallon);
      prefs.setStringList('gallon', gallonList);
      resultList.add(_result);
      prefs.setStringList('result', resultList);
      dateList.add(_date);
      prefs.setStringList('date', dateList);
      prefs.setInt('setMileage', int.parse(_mileage));
    });
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