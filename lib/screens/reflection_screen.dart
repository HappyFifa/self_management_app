import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/reflection_provider.dart';

class ReflectionScreen extends StatelessWidget {
  const ReflectionScreen({super.key});

  void _showAddReflectionDialog(BuildContext context) {
    final TextEditingController contentController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Refleksi Hari Ini'),
        content: TextField(
          controller: contentController,
          autofocus: true,
          maxLines: 5,
          decoration: const InputDecoration(
              labelText: 'Apa yang kamu rasakan?',
              border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              if (contentController.text.isNotEmpty) {
                Provider.of<ReflectionProvider>(context, listen: false)
                    .addReflection(contentController.text);
                Navigator.of(ctx).pop();
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catatan Refleksi')),
      body: Consumer<ReflectionProvider>(
        builder: (ctx, reflectionProvider, child) => reflectionProvider
                .reflections.isEmpty
            ? const Center(child: Text('Belum ada catatan refleksi.'))
            : ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: reflectionProvider.reflections.length,
                itemBuilder: (ctx, i) {
                  final reflection = reflectionProvider.reflections[i];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: ListTile(
                      contentPadding: const EdgeInsets.fromLTRB(
                          16, 16, 8, 16), // Adjust padding for button
                      title: Text(
                        DateFormat('EEEE, d MMMM y', 'id_ID')
                            .format(reflection.date),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            fontSize: 14),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(reflection.content,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black87)),
                      ),
                      trailing: IconButton(
                        icon:
                            const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () {
                          Provider.of<ReflectionProvider>(context,
                                  listen: false)
                              .removeReflection(reflection.id);
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddReflectionDialog(context),
        tooltip: 'Tulis Refleksi',
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }
}