import 'package:flutter/material.dart';
import 'package:grading_assistant/result.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Grading Assistant'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // int _counter = 0;
  final TextEditingController txtController = TextEditingController();
  final TextEditingController scoreController = TextEditingController();
  final TextEditingController answerController = TextEditingController();
  final TextEditingController askController = TextEditingController();

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      // _counter++;
    });
  }

  final picker = ImagePicker();
  File? _imageFile;
  String _base64String = '';

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);
      final bytesOfIamge = await pickedFile.readAsBytes();
      setState(() {
        _base64String = base64.encode(bytesOfIamge);
      });
    } else {
      print('No image selected.');
    }
  }

  final apiUrl = 'https://eeea-222-252-4-89.ngrok-free.app/get_result';

  Future onGetResult() async {
    // Uint8List _bytes = await _imageFile.readAsBytes();
    // String _base64String = base64.encode(_bytes);
    try
    {
    final response = await http.post(
      Uri.parse(apiUrl),
      // headers: <String, String>{
      //   'Content-Type': 'application/json; charset=UTF-8',
      // },
      body: jsonEncode({
        'question': askController.text,
        'sample': answerController.text,
        'grade': scoreController.text,
        'images': [_base64String]
      }),
    );

    if (response.statusCode == 200) {
      txtController.text = response.body;
      // Navigate to the result screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(result: response.body),
        ),
      );
    } else {
      txtController.text = 'Request failed with status: ${response.statusCode}';
    }
    }
    catch(ex) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(result: ex.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      // body: Center(
      //   // Center is a layout widget. It takes a single child and positions it
      //   // in the middle of the parent.
      //   child: Column(
      //     // Column is also a layout widget. It takes a list of children and
      //     // arranges them vertically. By default, it sizes itself to fit its
      //     // children horizontally, and tries to be as tall as its parent.
      //     //
      //     // Invoke "debug painting" (press "p" in the console, choose the
      //     // "Toggle Debug Paint" action from the Flutter Inspector in Android
      //     // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
      //     // to see the wireframe for each widget.
      //     //
      //     // Column has various properties to control how it sizes itself and
      //     // how it positions its children. Here we use mainAxisAlignment to
      //     // center the children vertically; the main axis here is the vertical
      //     // axis because Columns are vertical (the cross axis would be
      //     // horizontal).
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       const Text(
      //         'You have pushed the button this many times:',
      //       ),
      //       Text(
      //         '$_counter',
      //         style: Theme.of(context).textTheme.headlineMedium,
      //       ),
      //     ],
      //   ),
      // ),

      body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        margin: EdgeInsets.only(left: 20, right: 10, top: 30),
                        padding: EdgeInsets.only(left: 20, right: 0),
                        // height: 50,
                        child: TextField(
                          maxLines: 1,
                          controller: askController,
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 8, 50),
                            fontSize: 15,
                          ),
                          decoration: InputDecoration(
                            labelText: "Question",
                            labelStyle: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 15,
                            ),
                            border: InputBorder.none,
                            focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 0, 8, 50))),
                            errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 0, 8, 50))),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFFEEEEEE))),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 0, 8, 50))),
                            filled: true,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: EdgeInsets.only(left: 0, right: 10, top: 30),
                        padding: EdgeInsets.only(left: 10, right: 10),
                        // width: width > 700 ? 450 : null,
                        // height: 50,
                        child: TextField(
                          controller: scoreController,
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 8, 50),
                            fontSize: 15,
                          ),
                          decoration: InputDecoration(
                            labelText: "Score",
                            labelStyle: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 15,
                            ),
                            border: InputBorder.none,
                            focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 0, 8, 50))),
                            errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 0, 8, 50))),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFFEEEEEE))),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 0, 8, 50))),
                            filled: true,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                  padding: EdgeInsets.only(left: 20, right: 20),
                  width: width > 700 ? 450 : null,
                  // height: 50,
                  child: TextField(
                    maxLines: 3,
                    minLines: 3,
                    controller: answerController,
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 8, 50),
                      fontSize: 15,
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      labelText: "Sample Answer",
                      labelStyle: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 15,
                      ),
                      border: InputBorder.none,
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color.fromARGB(255, 0, 8, 50))),
                      errorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color.fromARGB(255, 0, 8, 50))),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFEEEEEE))),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color.fromARGB(255, 0, 8, 50))),
                      filled: true,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                if (_imageFile != null) Image.file(_imageFile!),
                FilledButton(
                  child: Text("Select Image"),
                  onPressed: pickImage,
                ),
                SizedBox(
                  height: 20,
                ),
                FilledButton(
                  child: Text("Upload Image"),
                  onPressed: onGetResult,
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                  padding: EdgeInsets.only(left: 20, right: 20),
                  width: width > 700 ? 450 : null,
                  height: 50,
                  child: TextField(
                    controller: txtController,
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 8, 50),
                      fontSize: 15,
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      labelText: "Response",
                      labelStyle: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 15,
                      ),
                      border: InputBorder.none,
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color.fromARGB(255, 0, 8, 50))),
                      errorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color.fromARGB(255, 0, 8, 50))),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFEEEEEE))),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color.fromARGB(255, 0, 8, 50))),
                      filled: true,
                    ),
                  ),
                ),
              ],
            ),
          )),

      // Thêm phần chọn ảnh vào đây

      // Hiển thị ảnh đã chọn ở đây

      // Nút bẩm gửi ảnh qua API ở đây

      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.home),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
