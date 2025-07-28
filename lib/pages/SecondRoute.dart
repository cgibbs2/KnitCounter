import 'package:flutter/material.dart';
import 'package:knitting_counter/models/user_session.dart';
import 'package:knitting_counter/models/user_session_repository.dart';

class SecondRoute extends StatefulWidget {
  final IUserSessionRepository sessionRepository;
  const SecondRoute({Key? key, required this.sessionRepository})
    : super(key: key);

  @override
  State<SecondRoute> createState() => _SecondRouteState();
}

class _SecondRouteState extends State<SecondRoute> {
  final _sessionNameController = TextEditingController();
  final _patternNameController = TextEditingController();
  List<_RepeatSectionInput> _repeatSections = [_RepeatSectionInput()];

  @override
  void dispose() {
    _sessionNameController.dispose();
    _patternNameController.dispose();
    for (final section in _repeatSections) {
      section.dispose();
    }
    super.dispose();
  }

  void _addRepeatSection() {
    setState(() {
      _repeatSections.add(_RepeatSectionInput());
    });
  }

  void _removeRepeatSection(int index) {
    setState(() {
      _repeatSections[index].dispose();
      _repeatSections.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Session')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _sessionNameController,
              decoration: const InputDecoration(labelText: 'Session Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _patternNameController,
              decoration: const InputDecoration(labelText: 'Pattern Name'),
            ),
            const SizedBox(height: 24),
            Text(
              'Repeat Intervals',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ..._repeatSections.asMap().entries.map((entry) {
              final i = entry.key;
              final section = entry.value;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        TextField(
                          controller: section.labelController,
                          decoration: const InputDecoration(labelText: 'Label'),
                        ),
                        TextField(
                          controller: section.intervalController,
                          decoration: const InputDecoration(
                            labelText: 'Interval',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        TextField(
                          controller: section.instructionsController,
                          decoration: const InputDecoration(
                            labelText: 'Instructions (optional)',
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: _repeatSections.length > 1
                        ? () => _removeRepeatSection(i)
                        : null,
                  ),
                ],
              );
            }),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add Repeat Interval'),
                onPressed: _addRepeatSection,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Back'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Validate input
                    final sessionName = _sessionNameController.text.trim();
                    final patternName = _patternNameController.text.trim();
                    if (sessionName.isEmpty || patternName.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Session and Pattern names are required.',
                          ),
                        ),
                      );
                      return;
                    }
                    final repeatSections = <RepeatSection>[];
                    for (final section in _repeatSections) {
                      final label = section.labelController.text.trim();
                      final intervalText = section.intervalController.text
                          .trim();
                      if (label.isEmpty || intervalText.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'All repeat intervals must have a label and interval.',
                            ),
                          ),
                        );
                        return;
                      }
                      final interval = int.tryParse(intervalText);
                      if (interval == null || interval <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Interval must be a positive integer.',
                            ),
                          ),
                        );
                        return;
                      }
                      repeatSections.add(
                        RepeatSection(
                          label: label,
                          interval: interval,
                          instructions:
                              section.instructionsController.text.trim().isEmpty
                              ? null
                              : section.instructionsController.text.trim(),
                        ),
                      );
                    }
                    if (repeatSections.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'At least one repeat interval is required.',
                          ),
                        ),
                      );
                      return;
                    }

                    // Create UserSession and save
                    try {
                      final now = DateTime.now();
                      final session = UserSession(
                        id: UniqueKey().hashCode.toString(),
                        patternName: patternName,
                        repeatSections: repeatSections,
                        currentSectionIndex: 0,
                        rowCount: 0,
                        sectionRowCounts: List.filled(repeatSections.length, 0),
                        createdAt: now,
                        updatedAt: now,
                      );
                      final repo = widget.sessionRepository;
                      await repo.saveSession(session);
                      if (mounted) {
                        Navigator.pushReplacementNamed(
                          context,
                          '/third',
                          arguments: session.id,
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to create session: $e')),
                      );
                    }
                  },
                  child: const Text('Create session'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RepeatSectionInput {
  final labelController = TextEditingController();
  final intervalController = TextEditingController();
  final instructionsController = TextEditingController();

  void dispose() {
    labelController.dispose();
    intervalController.dispose();
    instructionsController.dispose();
  }
}
