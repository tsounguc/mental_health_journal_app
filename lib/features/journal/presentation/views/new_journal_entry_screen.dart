import 'package:flutter/material.dart';
import 'package:mental_health_journal_app/features/journal/presentation/widgets/journal_form_field.dart';

class NewJournalEntryScreen extends StatefulWidget {
  const NewJournalEntryScreen({super.key});

  static const id = '/new-journal-entry';

  @override
  State<NewJournalEntryScreen> createState() => _NewJournalEntryScreenState();
}

class _NewJournalEntryScreenState extends State<NewJournalEntryScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _tags = <String>[];
  String? _selectedMood;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _addTag(String tag) {
    setState(() {
      if (!_tags.contains(tag)) {
        _tags.add(tag);
      }
    });
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  void _saveEntry() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Journal Entry'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveEntry,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 25,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25),
              JournalFormField(
                fieldTitle: 'Title',
                hintText: 'Title',
                controller: _titleController,
                borderRadius: BorderRadius.circular(16),
              ),
              const SizedBox(height: 10),
              JournalFormField(
                fieldTitle: 'Content',
                controller: _contentController,
                borderRadius: BorderRadius.circular(16),
                minLines: 8,
                maxLines: null,
                textInputAction: null,
              ),
              const SizedBox(height: 16),
              const Text(
                'Mood Selector',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedMood,
                items: ['Happy', 'Sad', 'Angry', 'Neutral']
                    .map(
                      (mood) => DropdownMenuItem(
                        value: mood,
                        child: Text(mood),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedMood = value;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  hintText: 'Select Mood',
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Tags',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Wrap(
                spacing: 8,
                children: _tags
                    .map(
                      (tag) => Chip(
                        label: Text(tag),
                        onDeleted: () => _removeTag(tag),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 8),
              JournalFormField(
                fieldTitle: 'Add Tag',
                onFieldSubmitted: _addTag,
                borderRadius: BorderRadius.circular(16),
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton.icon(
                onPressed: _saveEntry,
                icon: const Icon(Icons.save),
                label: const Text('Save Entry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
