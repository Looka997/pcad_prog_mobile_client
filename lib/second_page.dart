import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SecondRoute extends StatefulWidget {

  final String plate;
  final String brand;

  SecondRoute({Key? key, required this.plate, required this.brand}) : super(key: key);

  @override
  _SecondRouteState createState() => _SecondRouteState();


}

class _SecondRouteState extends State<SecondRoute>{

  final textController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool pressed = false;
  final String host = "192.168.1.1:4567";

  Future<bool> _wasParked() async {
    final http.Response response = await http
      .get(Uri.http(host, '/users/' + widget.plate));
    if (response.statusCode!= 200)
      throw Exception('Failed to load last movement');
    String state = jsonDecode(response.body)['state'];
    return state == 'ENTRATA';
  }

  void _setPressed({bool print = false}) async{
    bool parked = await _wasParked();
    setState(() {
      if (print)
        textController.text += "Connected";
      pressed = parked;
    });
    
  }
  @override
  void initState() {
    super.initState();
    _setPressed(print: true);
  }

  Future<http.Response> _createMessage(String plate, String brand){
    return http.post(
      Uri.http(host, "/users"),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'request' : pressed? 'USCITA' : 'ENTRATA',
        'plate' : plate,
        'brand' : brand,
        'date' : DateTime.now().toUtc().toIso8601String()
        }),
    );
  }

  String _formatDate(DateTime now){
    return (
      now.year.toString() + "-" + now.month.toString() + "-" + now.day.toString()
      + " " + now.hour.toString() + ":" + now.minute.toString() + ":" + now.second.toString() 
    );
  }

  void _sendMessage() async{
    var response = await _createMessage(widget.plate, widget.brand);
    
    setState(() {
      if (response.statusCode == 200){
        String result = jsonDecode(response.body)['result'];
        if (result != 'SUCCESS'){
          textController.text += "\nCould not " + 
            (pressed? "un" : "") + "park";
            _setPressed();
          return;
        }
        pressed = !pressed;
        textController.text += "\n" 
          + (pressed? "Parked!" : "Unparked!")
          + " at " + _formatDate(DateTime.now());
      }else
        textController.text += "\nParking may be closed?";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mobile parking client"),
      ),
      body: Center(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
                Scrollbar(
                  child:  TextField(
                    controller: textController,
                    readOnly: true,
                    minLines: 20,
                    maxLines: 20,
                    showCursor: true,
                  ), 
                  controller: _scrollController,
                  isAlwaysShown: true,
                ),
                ElevatedButton(
                  onPressed: () => _sendMessage(),
                  child: pressed? Text("Exit") : Text("Enter"),
                  style: ElevatedButton.styleFrom(
                    primary: pressed? Colors.red : Colors.blue,
                  ),
                ),
                Text("on host: " + host),
              ],
            ),
        ),
      ),
    );
  }
}