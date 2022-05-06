import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic> post = {};
  List<dynamic> comments = [];

  bool _showLoading = true;
  bool _showComments = true;
  final r = Random();

  late double _alto;
  late double _ancho;
  late Color _color;

  @override
  void initState() {
    super.initState();

    _alto = r.nextDouble();
    _ancho = r.nextDouble();
    _color = Color((r.nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);

    _fetchData();
  }

  Future<String> _futureError() async {
    throw Exception('my error');
  }

  Future _fetchData() async {
    setState(() {
      _showLoading = true;
    });
    final results = await Future.wait([
      http.get(Uri.parse('http://jsonplaceholder.typicode.com/posts/1')),
      http.get(Uri.parse('http://jsonplaceholder.typicode.com/comments')),
      Future.delayed(const Duration(seconds: 5)),
      // _futureError().catchError((e) {
      //   return 'error';
      // }),
    ]);

    setState(() {
      post = json.decode(results[0].body);
      comments = json.decode(results[1].body);
      _showLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Concurrencia"),
        actions: _showLoading
            ? []
            : [
                IconButton(
                  onPressed: _fetchData,
                  icon: const Icon(Icons.refresh),
                ),
              ],
      ),
      body: _showLoading
          ? _loading(context)
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post['title'],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 30)),
                  const SizedBox(height: 10),
                  _showCommentsToggle(),
                  const SizedBox(height: 10),
                  if (!_showComments)
                    Text(post['body'], style: const TextStyle(fontSize: 14)),
                  if (_showComments) Expanded(child: _commentList())
                ],
              ),
            ),
    );
  }

  _showCommentsToggle() {
    return Row(
      children: [
        const Text(
          'Show comments',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          child: CupertinoSwitch(
            value: _showComments,
            onChanged: (bool value) {
              setState(() {
                _showComments = value;
              });
            },
          ),
          onTap: () {
            setState(() {
              _showComments = !_showComments;
            });
          },
        ),
      ],
    );
  }

  Widget _loading(BuildContext context) {
    Size _size = MediaQuery.of(context).size;

    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(seconds: 1),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _alto = r.nextDouble();
                    _ancho = r.nextDouble();
                    _color = Color((r.nextDouble() * 0xFFFFFF).toInt())
                        .withOpacity(1.0);
                  });
                },
                child: Container(
                  height: _alto * _size.height,
                  width: _ancho * _size.width,
                  color: _color,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text('Cargando'),
            ),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _commentList() {
    return ListView.builder(
        padding: const EdgeInsets.only(),
        itemCount: comments.length,
        itemBuilder: (context, x) {
          final comment = comments[x];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                comment['email'],
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Text(comment['body'], style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 15)
            ],
          );
        });
  }
}
