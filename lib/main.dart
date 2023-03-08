import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OpenAI Demo',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _inputText = '';
  String _responseText = '';

  Future<void> _makeApiCall(String input) async {
    final uri = Uri.parse('https://api.openai.com/v1/completions');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer YOUR-OPENAI-API-KEY'
    };
    final body = jsonEncode({
      'model': 'text-davinci-003',
      'prompt': input,
      'temperature': 0,
      'max_tokens': 100,
    });

    final response = await http.post(uri, headers: headers, body: body);
    final responseData = jsonDecode(response.body);

    setState(() {
      _responseText = responseData['choices'][0]['text'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OpenAI Demo'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            onChanged: (value) => _inputText = value,
            decoration: InputDecoration(
              hintText: 'Enter your prompt',
              contentPadding: EdgeInsets.all(10.0),
            ),
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () => _makeApiCall(_inputText),
            child: Text('Submit'),
          ),
          SizedBox(height: 20.0),
          Text(
            _responseText,
            style: TextStyle(fontSize: 18.0),
          ),
        ],
      ),
    );
  }
}
