import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerTextField extends StatefulWidget {
  @override
  _DatePickerTextFieldState createState() => _DatePickerTextFieldState();
}

class _DatePickerTextFieldState extends State<DatePickerTextField> {
  String dateTo = '';
  DateTime selectedDateTo = DateTime.now();
  var dateTextController = new TextEditingController();

  Future<Null> _selectDateTo(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDateTo,
        firstDate: DateTime(1964, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDateTo) {
      setState(() {
        selectedDateTo = picked;
        dateTo = "${DateFormat("yyyy-MM-dd").format(selectedDateTo)}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 12, bottom: 12),
      // height: 45.0,
      // padding: EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                ),
                color: Colors.white,
              ),
              child: Text(
                '11/10/2019',
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
          ),
          Container(
            //  padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
            child: FlatButton(
              color: Theme.of(context).primaryColor,
              onPressed: () {
                _selectDateTo(context);
                print(dateTo);
              },
              child: Container(
                 padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                child: Icon(
                  Icons.date_range,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
