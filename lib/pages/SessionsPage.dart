import 'package:flutter/material.dart';
import 'package:knitting_counter/models/user_session.dart';
import 'package:knitting_counter/models/user_session_repository.dart';

class SessionsPage extends StatefulWidget {
  final IUserSessionRepository sessionRepository;
  const SessionsPage({Key? key, required this.sessionRepository})
    : super(key: key);

  @override
  State<SessionsPage> createState() => _SessionsPageState();
}

class _SessionsPageState extends State<SessionsPage> {
  List<UserSession> _sessions = [];
  bool _managementMode = false;
  Set<String> _selectedSessionIds = {};

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    final sessions = await widget.sessionRepository.getAllSessions();
    sessions.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    setState(() {
      _sessions = sessions;
    });
  }

  void _onSessionTap(UserSession session) {
    if (_managementMode) {
      setState(() {
        if (_selectedSessionIds.contains(session.id)) {
          _selectedSessionIds.remove(session.id);
        } else {
          _selectedSessionIds.add(session.id);
        }
      });
    } else {
      Navigator.pushReplacementNamed(context, '/third', arguments: session.id);
    }
  }

  void _onSessionLongPress(UserSession session) {
    setState(() {
      _managementMode = true;
      _selectedSessionIds = {session.id};
    });
  }

  void _cancelManagement() {
    setState(() {
      _managementMode = false;
      _selectedSessionIds.clear();
    });
  }

  Future<void> _deleteSelectedSessions() async {
    for (final id in _selectedSessionIds) {
      await widget.sessionRepository.deleteSession(id);
    }
    _cancelManagement();
    await _loadSessions();
  }

  String _formatDate(DateTime date) {
    return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sessions'),
        actions: _managementMode
            ? [
                IconButton(
                  icon: const Icon(Icons.cancel),
                  onPressed: _cancelManagement,
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: _selectedSessionIds.isEmpty
                      ? null
                      : _deleteSelectedSessions,
                ),
              ]
            : null,
      ),
      body: ListView.builder(
        itemCount: _sessions.length,
        itemBuilder: (context, index) {
          final session = _sessions[index];
          final selected = _selectedSessionIds.contains(session.id);
          return GestureDetector(
            onTap: () => _onSessionTap(session),
            onLongPress: () => _onSessionLongPress(session),
            child: Container(
              color: selected ? Colors.teal.withOpacity(0.2) : null,
              child: ListTile(
                leading: _managementMode
                    ? Checkbox(
                        value: selected,
                        onChanged: (_) => _onSessionTap(session),
                      )
                    : null,
                title: Text(session.patternName),
                subtitle: Text(
                  'Rows: ${session.rowCount}  •  Updated: ${_formatDate(session.updatedAt)}',
                ),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
          );
        },
      ),
    );
  }
}
