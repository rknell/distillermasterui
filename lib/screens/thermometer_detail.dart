import 'package:distillermaster_control/classes/thermometer.dart';
import 'package:flutter/material.dart';

class ThermometerDetail extends StatefulWidget {
  Thermometer thermometer;
  ThermometerDetail({Key? key, required this.thermometer}) : super(key: key);

  @override
  State<ThermometerDetail> createState() => _ThermometerDetailState();
}

class _ThermometerDetailState extends State<ThermometerDetail> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  ThermometerType _type = ThermometerType.Column;

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
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
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
              SizedBox(height: 20),
              DropdownButtonFormField<ThermometerType>(
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    widget.thermometer.save();
                    Navigator.pop(context);
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
