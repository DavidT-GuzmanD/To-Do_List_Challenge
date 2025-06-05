
import 'package:flutter/material.dart';

class TodayPage extends StatelessWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Hoy',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.grey.shade50,
        elevation: 0,
      ),
      body: const Center(
        child: Text(
          'Tareas de Hoy',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}