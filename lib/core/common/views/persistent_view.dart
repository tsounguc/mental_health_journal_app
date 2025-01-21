import 'package:flutter/material.dart';
import 'package:mental_health_journal_app/core/common/app/providers/tab_navigator.dart';
import 'package:provider/provider.dart';

class PersistentView extends StatefulWidget {
  const PersistentView({this.body, super.key});
  final Widget? body;

  @override
  State<PersistentView> createState() => _PersistentViewState();
}

class _PersistentViewState extends State<PersistentView> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.body ?? context.watch<TabNavigator>().currentpage.child;
  }

  @override
  bool get wantKeepAlive => true;
}
