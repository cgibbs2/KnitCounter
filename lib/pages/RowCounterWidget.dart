import 'package:flutter/material.dart';
import 'package:knitting_counter/widgets/action_bar.dart';
import 'package:knitting_counter/models/user_session.dart';
import 'package:knitting_counter/models/user_session_repository.dart';

class RowCounterWidget extends StatefulWidget {
  final IUserSessionRepository sessionRepository;
  final String? sessionId;
  const RowCounterWidget({
    Key? key,
    required this.sessionRepository,
    this.sessionId,
  }) : super(key: key);

  @override
  State<RowCounterWidget> createState() => _RowCounterWidgetState();
}

class _RowCounterWidgetState extends State<RowCounterWidget> {
  UserSession? _session;
  int _lastRowCount = 0;

  @override
  void initState() {
    super.initState();
    _initSession();
  }

  Future<void> _initSession() async {
    if (widget.sessionId != null) {
      final loaded = await widget.sessionRepository.getSession(
        widget.sessionId!,
      );
      if (loaded != null) {
        setState(() {
          _session = loaded;
        });
      }
    } else {
      // If no sessionId, create a new session in memory (not saved yet)
      setState(() {
        _session = UserSession(
          id: UniqueKey().toString(),
          patternName: '',
          repeatSections: [RepeatSection(label: 'Default', interval: 8)],
          currentSectionIndex: 0,
          rowCount: 0,
          sectionRowCounts: [0],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      });
    }
  }

  Future<void> _saveCurrentSession() async {
    if (_session == null) return;
    final now = DateTime.now();
    _session = _session!.copyWith(updatedAt: now);
    await widget.sessionRepository.saveSession(_session!);
  }

  void _incrementRow() {
    if (_session == null) return;
    setState(() {
      _lastRowCount = _session!.rowCount;
      final updatedSectionRowCounts = List<int>.from(
        _session!.sectionRowCounts,
      );
      for (int i = 0; i < updatedSectionRowCounts.length; i++) {
        updatedSectionRowCounts[i] = updatedSectionRowCounts[i] + 1;
      }
      _session = _session!.copyWith(
        rowCount: _session!.rowCount + 1,
        sectionRowCounts: updatedSectionRowCounts,
      );
    });
    _saveCurrentSession();
  }

  void _resetCounter() {
    if (_session == null) return;
    setState(() {
      _lastRowCount = _session!.rowCount;
      // Reset all section row counts to 0
      final resetSectionRowCounts = List<int>.filled(
        _session!.sectionRowCounts.length,
        0,
      );
      _session = _session!.copyWith(
        rowCount: 0,
        sectionRowCounts: resetSectionRowCounts,
      );
    });
    _saveCurrentSession();
  }

  void _undo() {
    if (_session == null) return;
    setState(() {
      _session = _session!.copyWith(
        rowCount: _lastRowCount,
        sectionRowCounts: List<int>.from(_session!.sectionRowCounts)
          ..[0] = _lastRowCount,
      );
    });
    _saveCurrentSession();
  }

  @override
  Widget build(BuildContext context) {
    if (_session == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final repeatSections = _session!.repeatSections;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color.fromARGB(255, 3, 255, 159),
            const Color.fromARGB(255, 4, 189, 245),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Knitting Row Counter'),
          backgroundColor: Colors.teal,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 24),
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _incrementRow,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: TextField(
                  controller: TextEditingController(
                    text: _session!.patternName,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Pattern',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _session = _session!.copyWith(patternName: value);
                    });
                    _saveCurrentSession();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Current Row',
                  style: TextStyle(fontSize: 32),
                  textAlign: TextAlign.center,
                ),
              ),
              Text(
                '${_session!.rowCount}',
                style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ...List.generate(repeatSections.length, (i) {
                        final section = repeatSections[i];
                        final sectionRowCount =
                            _session!.sectionRowCounts.length > i
                            ? _session!.sectionRowCounts[i]
                            : 0;
                        final currentRepeatRow =
                            (sectionRowCount % section.interval) + 1;
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 24.0,
                          ),
                          child: Card(
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    section.label,
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Interval: ${section.interval}',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  if (section.instructions != null &&
                                      section.instructions!.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        'Instructions: ${section.instructions}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Current Row: $currentRepeatRow of ${section.interval}',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                      SizedBox(height: 80), // Space for sticky buttons
                    ],
                  ),
                ),
              ),
              Container(
                color: Colors.transparent,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 24,
                ),
                child: ActionBar(
                  onReset: _resetCounter,
                  onUndo: _undo,
                  onBack: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
