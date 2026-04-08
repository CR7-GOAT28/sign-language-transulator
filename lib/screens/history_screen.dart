import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<String> history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final items = prefs.getStringList('translation_history') ?? [];
    setState(() {
      history = items.reversed.toList();
    });
  }

  Future<void> _clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('translation_history');
    setState(() {
      history = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F7FB),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "History",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _clearHistory,
            icon: const Icon(Icons.delete_outline_rounded, color: Colors.black),
          )
        ],
      ),
      body: history.isEmpty
          ? const Center(
        child: Text(
          "No history yet",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      )
          : ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: history.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Text(
              history[index],
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          );
        },
      ),
    );
  }
}