import 'dart:convert';

import 'package:ev/widgets/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../config/global.dart';

class Profile extends StatefulWidget {
  String id;
  Profile({super.key, required this.id});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late String id;
  @override
  void initState() {
    id = widget.id;
    super.initState();
  }

  TextEditingController feedbackcontroller = TextEditingController();
  List list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Profile '),
        actions: const [],
      ),
      body: FutureBuilder<List>(
          future: getUserData(id),
          builder: (context, snap) {
            switch (snap.connectionState) {
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              default:
                if (snap.hasData) {
                  list = snap.data!;
                  return Container(
                    width: double.infinity,
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
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: IntrinsicHeight(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Icon(Icons.person_2, size: 50),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            " ${list[0][1]}",
                                            style:
                                                const TextStyle(fontSize: 30),
                                          ),
                                        ],
                                      ),
                                      const Divider(
                                        color:
                                            Color.fromARGB(88, 111, 106, 106),
                                      )
                                    ],
                                  ),
                                ),
                                PopupMenuButton(
                                  onSelected: (value) {
                                    if (value == 1) {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context3) {
                                        return const Login();
                                      }));
                                    }
                                  },
                                  icon: const Icon(Icons.more_vert),
                                  itemBuilder: (contextpop) => [
                                    const PopupMenuItem(
                                      value: 2,
                                      child: Text('edit Profile'),
                                    ),
                                    const PopupMenuItem(
                                      value: 1,
                                      child: Text('Logout'),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              _showFeedbackDialog(context);
                            },
                            style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all<Size>(
                                    const Size(double.infinity, 100))),
                            child: const Text(
                              "Click here to send feedback",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 78, 36, 36)),
                            ),
                          )
                        ]),
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: Text(snap.error.toString()),
                  );
                }
            }
          }),
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    // Set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Send Feedback"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Please leave your feedback below:"),
          const SizedBox(height: 10),
          TextField(
            controller: feedbackcontroller,
            decoration: const InputDecoration(hintText: 'Feedback'),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: const Text("Send"),
          onPressed: () async {
            await sendfeedback(feedbackcontroller.text);
            Navigator.of(context).pop();
          },
        ),
      ],
    );

    // Show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  sendfeedback(String feedback) async {
    var ip = await printIps();
    Uri apiUrl = Uri.parse('http://192.168.0.104:8080/addfeedback');
    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    Map<String, String> body = {
      'name': list[0][1],
      'feedback': feedback,
    };
    http.Response response =
        await http.post(apiUrl, headers: headers, body: body);
    final data = response.body;
  }

  Future<List> getUserData(String id) async {
    var ip = await printIps();
    Uri apiUrl1 = Uri.parse('http://192.168.0.104:8080/userdata');
    Map<String, String> headers1 = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    Map<String, String> body1 = {
      'email': id,
    };
    http.Response response1 =
        await http.post(apiUrl1, headers: headers1, body: body1);
    final data1 = jsonDecode(response1.body);
    return data1;
  }
}
