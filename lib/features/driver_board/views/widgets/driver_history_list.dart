import 'package:flutter/material.dart';
import '../../models/driver_model.dart';

class DriverHistoryList extends StatefulWidget {
  final List<HistoryEntry> history;
  const DriverHistoryList({super.key, required this.history});

  @override
  State<DriverHistoryList> createState() => _DriverHistoryListState();
}

class _DriverHistoryListState extends State<DriverHistoryList> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late List<HistoryEntry> _internalList;

  @override
  void initState() {
    super.initState();
    _internalList = List.from(widget.history);
  }

  @override
  void didUpdateWidget(DriverHistoryList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.history.length > _internalList.length) {
      _internalList.insert(0, widget.history.first);
      _listKey.currentState?.insertItem(0, duration: const Duration(milliseconds: 450));
    } else if (widget.history.length != _internalList.length) {
      _internalList = List.from(widget.history);
    }
  }

  Color _getLogColor(String statusText) {
    if (statusText == "Boşta") return Colors.grey;
    if (statusText == "Yük Bekliyor") return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    if (_internalList.isEmpty) {
      return const Center(child: Text("Geçmiş kaydı bulunamadı."));
    }
    return AnimatedList(
      key: _listKey,
      initialItemCount: _internalList.length,
      itemBuilder: (context, index, animation) {
        final entry = _internalList[index];
        return SlideTransition(
          position: animation.drive(Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero).chain(CurveTween(curve: Curves.easeOutCubic))),
          child: SizeTransition(
            sizeFactor: animation,
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(entry.statusText, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: _getLogColor(entry.statusText))),
              trailing: Text("${entry.timestamp.hour.toString().padLeft(2, '0')}:${entry.timestamp.minute.toString().padLeft(2, '0')}", style: const TextStyle(color: Colors.grey, fontSize: 13)),
            ),
          ),
        );
      },
    );
  }
}