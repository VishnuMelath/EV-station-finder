import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../config/global.dart';

class FeedbackView extends StatefulWidget {
  const FeedbackView({super.key});

  @override
  State<FeedbackView> createState() => _FeedbackViewState();
}

class _FeedbackViewState extends State<FeedbackView> {
  List feedbackList = [];
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getFeedback(),
        builder: (context, snap) {
          return ListView.builder(
              itemCount: feedbackList.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration:
                              BoxDecoration(border: Border.all(width: 0.5)),
                          child: Column(
                            children: [
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Title(
                                        color: const Color.fromARGB(
                                            255, 7, 12, 58),
                                        child: Text(
                                          "${feedbackList[index][0]}",
                                          style: const TextStyle(fontSize: 20),
                                        )),
                                  )),
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(" ${feedbackList[index][1]}"),
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          removeFeedback(feedbackList[index][3]);
                        },
                        icon: const Icon(Icons.delete_forever))
                  ],
                );
              });
        });
  }

  Future _getFeedback() async {
    var ip = await printIps();
    Uri apiUrl = Uri.parse('http://192.168.0.104:8080/showfeedback');
    http.Response response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      feedbackList = jsonDecode(response.body);
    } else {}
  }

  void removeFeedback(int id) async {
    var ip = await printIps();
    Uri apiUrl = Uri.parse('http://192.168.0.104:8080/deletefeedback');
    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    Map<String, String> body = {
      'email': id.toString(),
    };
    http.Response response =
        await http.post(apiUrl, headers: headers, body: body);
    final data = response.body;

    setState(() {
      feedbackList.removeWhere((item) => item[3] == id);
    });
  }
}
