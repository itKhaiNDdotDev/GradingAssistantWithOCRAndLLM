import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final String textOCROutput;
  final String comment;
  final String grade;

  ResultScreen({
    required this.textOCROutput,
    required this.comment,
    required this.grade,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result'),
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              children: [
                Container(),
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                      margin: EdgeInsets.only(left: 20, right: 10),
                      padding: EdgeInsets.only(left: 20, right: 0),
                      child: Text('Output of OCR')),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: EdgeInsets.only(left: 0, right: 40, top: 30),
                    child: TextField(
                      minLines: 3,
                      maxLines: 6,
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
                        hintStyle:
                            TextStyle(color: Color.fromARGB(255, 3, 3, 3)),
                        hintText: textOCROutput,
                        labelStyle: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 15,
                        ),
                        filled: true,
                        enabled: false,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                      margin: EdgeInsets.only(left: 20, right: 10, top: 30),
                      padding: EdgeInsets.only(left: 20, right: 0),
                      child: Text('Grade')),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: EdgeInsets.only(left: 0, right: 40, top: 30),
                    child: TextField(
                      style: TextStyle(
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
                        hintStyle:
                            TextStyle(color: Color.fromARGB(255, 3, 3, 3)),
                        hintText: grade,
                        labelStyle: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 15,
                        ),
                        filled: true,
                        enabled: false,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                      margin: EdgeInsets.only(left: 20, right: 10),
                      padding: EdgeInsets.only(left: 20, right: 0),
                      child: Text('Comment')),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: EdgeInsets.only(left: 0, right: 40, top: 30),
                    child: TextField(
                      minLines: 3,
                      maxLines: 6,
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
                        hintStyle:
                            TextStyle(color: Color.fromARGB(255, 3, 3, 3)),
                        hintText: comment,
                        labelStyle: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 15,
                        ),
                        filled: true,
                        enabled: false,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.home),
      ),
    );
  }
}
