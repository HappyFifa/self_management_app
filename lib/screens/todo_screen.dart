import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';
import '../widgets/todo_item.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  void _showAddTaskDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tugas Baru'),
        content: TextField(
          controller: titleController,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Judul Tugas'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                Provider.of<TodoProvider>(context, listen: false)
                    .addTodo(titleController.text);
                Navigator.of(ctx).pop();
              }
            },
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Tugas')),
      body: Consumer<TodoProvider>(
        builder: (ctx, todoProvider, child) {
          // Show loading indicator while data is being loaded
          if (todoProvider.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Memuat tugas...'),
                ],
              ),
            );
          }

          // Show empty state if no todos
          if (todoProvider.items.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.task_alt, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Belum ada tugas',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tekan tombol + untuk menambah tugas baru',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // Show todos list
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: todoProvider.items.length,
            itemBuilder: (ctx, i) =>
                TodoItemWidget(todo: todoProvider.items[i]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        tooltip: 'Tambah Tugas',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
