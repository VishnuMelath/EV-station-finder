import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class AddStation extends StatefulWidget {
  const AddStation({super.key});

  @override
  State<AddStation> createState() => _AddStationState();
}

class _AddStationState extends State<AddStation> {
  int temp = 0;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  // final _connectionsController = TextEditingController();
  final List<TextEditingController> _supply = [];
  final List<TextEditingController> _voltage = [];
  final List<TextEditingController> _controllers = [];
  final List<TextEditingController> _power = [];
  final List<TextEditingController> _amps = [];
  final List<TextEditingController> _status = [];
  final List<TextEditingController> _quantity = [];
  void _addFormField() {
    setState(() {
      _controllers.add(TextEditingController());
      _supply.add(TextEditingController());
      _voltage.add(TextEditingController());
      _power.add(TextEditingController());
      _amps.add(TextEditingController());
      _status.add(TextEditingController());
      _quantity.add(TextEditingController());
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (!_formKey.currentState!.validate()) {
        return;
      }
      final name = _nameController.text;
      final address = _addressController.text;
      final latitude = double.parse(_latitudeController.text);
      final longitude = double.parse(_longitudeController.text);
      final connections = List.generate(
        _controllers.length,
        (index) => {
          "ConnectionTypeID": 1,
          "ConnectionType": {"Title": _controllers[index].text},
          "CurrentTypeID": 1,
          "CurrentType": {"Title": _supply[index].text},
          "LevelID": 1,
          "PowerKW": double.parse(_power[index].text),
          "Voltage": double.parse(_voltage[index].text),
          "Amps": double.parse(_amps[index].text),
          "Quantity": int.parse(_quantity[index].text),
          "StatusTypeID": 1,
          "StatusType": {"Title": _status[index].text},
        },
      );

      final data = {
        'DataProviderID': '1',
        'OperatorID': '1',
        'UsageTypeID': '4',
        'AddressInfo': {
          'Title': name,
          'AddressLine1': address,
          'Latitude': latitude,
          'Longitude': longitude,
        },
        'Connections': connections,
      };
      final url = Uri.parse('https://api.openchargemap.io/v3/poi/');
      final response = await http.post(
        url,
        body: json.encode(data),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-API-Key': 'c3f03625-53cc-4787-845b-0c4f1126aeb4',
        },
      );
      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Location added'),
            content:
                const Text('The location has been added to OpenChargeMap.'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(
                'There was an verror while adding the location. Please try again later.${response.reasonPhrase}${response.statusCode}$data'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      }
      // print('Form submitted successfully');
    }
  }

  void _removeFormField(int index) {
    setState(() {
      _controllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Container(
              margin: const EdgeInsets.all(10.0),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              decoration: BoxDecoration(
                border: Border.all(
                    style: BorderStyle.solid,
                    color: const Color.fromARGB(99, 132, 127, 127)),
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(144, 255, 255, 255)
                        .withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Address',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an address';
                      }
                      return null;
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _latitudeController,
                          decoration: const InputDecoration(
                            labelText: 'Latitude',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a latitude';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid latitude';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: TextFormField(
                          controller: _longitudeController,
                          decoration: const InputDecoration(
                            labelText: 'Longitude',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a longitude';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid longitude';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  for (var i = 0; i < _controllers.length; i++, temp++)
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                            style: BorderStyle.solid,
                            color: const Color.fromARGB(99, 132, 127, 127)),
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(144, 255, 255, 255)
                                .withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text("Equipment ${i + 1}"),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: _controllers[i],
                                      decoration: const InputDecoration(
                                        labelText: 'Connection type',
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter Connection Type';
                                        }
                                        return null;
                                      },
                                    ),
                                    TextFormField(
                                      controller: _supply[i],
                                      decoration: const InputDecoration(
                                        labelText: 'Supplytype',
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'please enter Supply type';
                                        }
                                        return null;
                                      },
                                    ),
                                    TextFormField(
                                      controller: _power[i],
                                      decoration: const InputDecoration(
                                        labelText: 'Power(kW)',
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'please enter Power(kW)';
                                        }
                                        return null;
                                      },
                                    ),
                                    TextFormField(
                                      controller: _amps[i],
                                      decoration: const InputDecoration(
                                        labelText: 'Amps',
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter Amps';
                                        }
                                        return null;
                                      },
                                    ),
                                    TextFormField(
                                      controller: _status[i],
                                      decoration: const InputDecoration(
                                        labelText: 'Status',
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'enter status';
                                        }
                                        return null;
                                      },
                                    ),
                                    TextFormField(
                                      controller: _quantity[i],
                                      decoration: const InputDecoration(
                                        labelText: 'Quantity',
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'enter status';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _removeFormField(i),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Text("Add equipment "),
                      ElevatedButton(
                        onPressed: _addFormField,
                        child: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Add Station'),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
