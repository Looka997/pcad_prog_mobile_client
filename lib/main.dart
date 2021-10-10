
import 'package:flutter/material.dart';
import 'package:flutter_application_1/second_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Mobile parking client'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: PlateBrandForm(),
      ),
    );
  }
}

class PlateBrandForm extends StatefulWidget {
  const PlateBrandForm({Key? key}) : super(key: key);

  @override
  State<PlateBrandForm> createState() => _PlateBrandFormState();

}

class _PlateBrandFormState extends State<PlateBrandForm>{
  String selectedBrand = 'HONDA'; 


  final textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _login() {
    if (_formKey.currentState!.validate()){
      Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context) => SecondRoute(
            plate: textController.text,
            brand: selectedBrand,
            )
          ),
      );
    }
  }

  @override 
  void dispose(){
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Plate:"),
              SizedBox(
                width: 150,
                child:  TextFormField(
                  validator: (value){
                    if (value == null || value.isEmpty)
                      return 'Please enter some text';
                    return null;
                  },
                  controller: textController,
                  decoration: InputDecoration(
                    labelText: 'AA000AA',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Brand:"),
              DropdownButton<String>(
                value: selectedBrand
            ,
                icon: const Icon(Icons.arrow_downward_rounded),
                iconSize: 24,
                elevation: 16,
                onChanged: (String? newValue) {
                    setState(() {
                      selectedBrand
                   = newValue!;
                    });
                },
                items: <String>['HONDA', 'MAZDA', 'FIAT', 'VOLKSWAGEN', 'TOYOTA', 'BMW', 'ALFA']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                }).toList(),
              ),
            ],
          ),
          FloatingActionButton(
            onPressed: _login,
            child: Icon(Icons.login_outlined),
          ),
        ],
      ),
    );
  }
}
