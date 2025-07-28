import 'package:flutter/material.dart';
import '../main.dart'; // Import your RowCounterWidget

class HomeRoute extends StatelessWidget {
  const HomeRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Knitting Counter'),
        backgroundColor: const Color.fromARGB(255, 4, 189, 245),
        foregroundColor: Colors.white,
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('What would you like to do?', style: TextStyle(fontSize: 24)),
            SizedBox(height: 40),

            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  const Color.fromARGB(255, 4, 189, 245),
                ),
                foregroundColor: WidgetStateProperty.all(Colors.white),
              ),
              child: const Text('New Session?'),
              onPressed: () {
                Navigator.pushNamed(context, '/second');
              },
            ), // ElevatedButton
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  const Color.fromARGB(255, 4, 189, 245),
                ),
                foregroundColor: WidgetStateProperty.all(Colors.white),
              ),
              child: const Text('Previous Session?'),
              onPressed: () {
                Navigator.pushNamed(context, '/sessions');
              },
            ), // ElevatedButton
          ],
        ),
      ),
    );
  }
}
