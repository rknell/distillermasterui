import 'package:distillermaster_control/components/change_notifier_builder.dart';

import '../classes/thermometer.dart';
import 'package:flutter/material.dart';
import '../classes/alarm.dart';

class ThermometerDetail extends StatefulWidget {
  Thermometer thermometer;
  ThermometerDetail({Key? key, required this.thermometer}) : super(key: key);

  @override
  State<ThermometerDetail> createState() => _ThermometerDetailState();
}

class _ThermometerDetailState extends State<ThermometerDetail> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  ThermometerType _type = ThermometerType.Other;

  @override
  void initState() {
    super.initState();
    _name = widget.thermometer.name ?? widget.thermometer.uuid;
    _type = widget.thermometer.type;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thermometer Detail'),
      ),
      body: ChangeNotifierBuilder(
          notifier: widget.thermometer,
          builder: (context) {
            return Center(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        initialValue: _name,
                        decoration: InputDecoration(
                          labelText: 'Name',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          if (value != null) {
                            setState(() {
                              _name = value;
                            });
                            widget.thermometer.setName(value);
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: DropdownButtonFormField<ThermometerType>(
                        value: _type,
                        decoration: InputDecoration(
                          labelText: 'Type',
                        ),
                        items: ThermometerType.values
                            .map<DropdownMenuItem<ThermometerType>>(
                                (ThermometerType value) {
                          return DropdownMenuItem<ThermometerType>(
                            value: value,
                            child: Text(value.toString().split('.').last),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _type = value!;
                          });
                          widget.thermometer.setType(value!);
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            widget.thermometer.save();
                            Navigator.pop(context);
                          }
                        },
                        child: Text('Save'),
                      ),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: widget.thermometer.alarms.length,
                        itemBuilder: (context, index) {
                          final alarm =
                              widget.thermometer.alarms.elementAt(index);
                          return ChangeNotifierBuilder(
                              notifier: alarm,
                              builder: (context) {
                                return Card(
                                  child: ListTile(
                                    title: Text(
                                      'Min: ${alarm.minTemp}, Max: ${alarm.maxTemp}',
                                      style: TextStyle(
                                        color: alarm.isTriggered
                                            ? Colors.red
                                            : null,
                                      ),
                                    ),
                                    subtitle: alarm.isTriggered
                                        ? Text(
                                            'Alarm Triggered',
                                            style: TextStyle(
                                              color: Colors.red,
                                            ),
                                          )
                                        : null,
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.edit),
                                          onPressed: () {
                                            editAlarm(alarm);
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () {
                                            setState(() {
                                              widget.thermometer
                                                  .removeAlarm(alarm);
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            editAlarm(null);
                          },
                          child: Text('Add Alarm'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            widget.thermometer.clearTriggered();
                          },
                          child: Text('Clear Triggered'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  void editAlarm(Alarm? alarm) async {
    final value = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AlarmDetail(
          alarm: alarm ?? Alarm(),
        ),
      ),
    );
    widget.thermometer.addAlarm(value);
  }
}

class AlarmDetail extends StatefulWidget {
  final Alarm alarm;

  const AlarmDetail({Key? key, required this.alarm}) : super(key: key);

  @override
  State<AlarmDetail> createState() => _AlarmDetailState();
}

class _AlarmDetailState extends State<AlarmDetail> {
  // Function to reset the trigger and set Alarm.isTriggered to false
  void resetTrigger() {
    setState(() {
      widget.alarm.isTriggered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alarm Detail'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Set Temperature Range',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Minimum Temperature',
              ),
              onChanged: (value) {
                setState(() {
                  widget.alarm.minTemp = double.tryParse(value);
                });
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Maximum Temperature',
              ),
              onChanged: (value) {
                setState(() {
                  widget.alarm.maxTemp = double.tryParse(value);
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, widget.alarm);
              },
              child: Text('Save'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: resetTrigger, // Call the resetTrigger function
              child: Text('Reset Trigger'),
            ),
          ],
        ),
      ),
    );
  }
}
