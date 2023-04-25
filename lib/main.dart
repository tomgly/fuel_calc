import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'add.dart';
import 'edit.dart';
import 'setting.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fuel Calculation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ListPage(),
    );
  }
}

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<String> _resultList = [];
  List<String> _dateList = [];

  @override
  Widget build(BuildContext context) {
    _set();
    return Scaffold(
      appBar: AppBar(
        title: Text('Fuel Calculation'),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return SettingPage();
                }),
              );
            },
            icon: Icon(Icons.settings),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: _resultList.length,
        itemBuilder: (BuildContext context, int index) {
          return Slidable(
            key: const ValueKey(0),
            endActionPane: ActionPane(
              extentRatio: 0.4,
              motion: const StretchMotion(),
              children: [
                SlidableAction(
                  onPressed: (_) {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => EditPage(value: index,)),
                    );
                  },
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                  icon: Icons.more,
                  label: 'Edit',
                ),
                SlidableAction(
                  onPressed: (_) {
                    _delete(index);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Deleted'))
                    );
                  },
                  backgroundColor: Colors.red.shade500,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            ),
            child: Card(
              child: ListTile(
                title: Text(_resultList[index]),
                subtitle: Text(_dateList[index]),
              )
            )
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return AddPage();
            }),
          );
          _set();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  _set() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _resultList = prefs.getStringList('result') as List<String>;
      _dateList = prefs.getStringList('date') as List<String>;
    });
  }

  _delete(int index) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> mileageList = prefs.getStringList('mileage') as List<String>;
    List<String> gallonList = prefs.getStringList('gallon') as List<String>;
    setState(() {
      mileageList.removeAt(index);
      prefs.setStringList('mileage', mileageList);
      gallonList.removeAt(index);
      prefs.setStringList('gallon', gallonList);
      _resultList.removeAt(index);
      prefs.setStringList('result', _resultList);
      _dateList.removeAt(index);
      prefs.setStringList('date', _dateList);
    });
  }
}