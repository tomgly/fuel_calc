import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditPage extends StatefulWidget {
  final int value;
  const EditPage({Key? key, required this.value}) : super(key: key);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  String _mileage = '0';
  String _gallon = '0';
  String _result = '0';
  String _date = '01/01/2023';
  final _txtCont = TextEditingController();
  late int index;

  @override
  void initState() {
    super.initState();
    index = widget.value;
    _get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Page'),
      ),
      body: Container (
        padding: EdgeInsets.all(64),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 8),
            TextField(
              keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
              controller: TextEditingController(text: _mileage),
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
              controller: TextEditingController(text: _gallon),
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
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Date',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () async {
                    List<String> dateList = _date.split('/');
                    String newDate = dateList[2] + dateList[0] + dateList[1];
                    DateTime initDate = DateTime.parse(newDate);
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

  _calc() {
    double mileage = double.parse(_mileage);
    double gallon = double.parse(_gallon);

    // Calculation
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
      mileageList.removeAt(index);
      mileageList.insert(index, _mileage);
      prefs.setStringList('mileage', mileageList);
      gallonList.removeAt(index);
      gallonList.insert(index, _gallon);
      prefs.setStringList('gallon', gallonList);
      resultList.removeAt(index);
      resultList.insert(index, _result);
      prefs.setStringList('result', resultList);
      dateList.removeAt(index);
      dateList.insert(index, _date);
      prefs.setStringList('date', dateList);
    });
  }

  _get() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var mileageList = prefs.getStringList('mileage') as List<String>;
    var gallonList = prefs.getStringList('gallon') as List<String>;
    var resultList = prefs.getStringList('result') as List<String>;
    var dateList = prefs.getStringList('date') as List<String>;

    setState(() {
      _mileage = mileageList[index];
      _gallon = gallonList[index];
      _result = resultList[index];
      _date = dateList[index];
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