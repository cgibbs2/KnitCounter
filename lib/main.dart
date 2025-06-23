import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: RowCounterWidget(),
    debugShowCheckedModeBanner: false,
  ));
}

class RowCounterWidget extends StatefulWidget {
  @override
  _RowCounterWidgetState createState() => _RowCounterWidgetState();
}

class _RowCounterWidgetState extends State<RowCounterWidget> {
  int _rowCount = 0;
  int _repeatInterval = 8;
  int _lastRowCount = 0;

  void _incrementRow() {
    setState(() {
      _lastRowCount = _rowCount;
      _rowCount++;
    });
  }

  void _resetCounter() {
    setState(() {
      _lastRowCount = _rowCount;
      _rowCount = 0;
    });
  }

  void _undo() {
    setState(() {
      _rowCount = _lastRowCount;
    });
  }

  void _setRepeatInterval(int value) {
    setState(() {
      _repeatInterval = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    int currentRepeatRow = (_rowCount % _repeatInterval) + 1;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color.fromARGB(255, 3, 255, 159), const Color.fromARGB(255, 4, 189, 245)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Knitting Row Counter'),
          backgroundColor: Colors.teal,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 24), 
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _incrementRow,
          child: Center(
            child: Column(
              children: [
                Expanded(
                  flex: 12,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Total Rows',
                        style: TextStyle(fontSize: 32),
                      ),
                      SizedBox(height: 16),
                      Text(
                        '$_rowCount',
                        style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Pattern Row $currentRepeatRow of $_repeatInterval',
                        style: TextStyle(fontSize: 28),
                      ),
                      SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Repeat Interval:', style: TextStyle(fontSize: 24)),
                          SizedBox(width: 40, height: 60),
                          DropdownButton<int>(
                            value: _repeatInterval,
                            style: TextStyle(fontSize: 24, color: Colors.black),
                            items: [2, 3, 4, 6, 8, 10, 12, 16, 20, 24, 30]
                                .map((val) => DropdownMenuItem(
                                      value: val,
                                      child: Text('$val'),
                                    ))
                                .toList(),
                            onChanged: (val) {
                              if (val != null) _setRepeatInterval(val);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Spacer(flex: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _resetCounter,
                      child: Text('Reset'),
                    ),
                    SizedBox(width: 20, height: 40),
                    ElevatedButton(
                      onPressed: _undo,
                      child: Text('Undo'),
                    ),
                  ],
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}