import 'package:flutter/material.dart';

class FirstRoute extends StatelessWidget {
  const FirstRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('First Screen')),
      body: Center(
        child: ElevatedButton(
          child: const Text('Open second screen'),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const SecondRoute()));
          },
        ),
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  const SecondRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Second Screen')),
      body: Center(
        child: ElevatedButton(
          child: const Text('Back First screen'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
class Todo {
  final String title;
  final String description;

  Todo(this.title, this.description);
}
final todos = List<Todo>.generate(
  20,
      (i) => Todo(
    'Todo $i',
    'A description of what needs to be done for Todo $i',
  ),
);
