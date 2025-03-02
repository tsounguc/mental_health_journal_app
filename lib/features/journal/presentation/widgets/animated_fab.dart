import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mental_health_journal_app/features/journal/presentation/views/journal_editor_screen.dart';
import 'package:mental_health_journal_app/features/journal/presentation/views/safe_mode_screen.dart';

class AnimatedFAB extends StatefulWidget {
  const AnimatedFAB({super.key});

  @override
  State<AnimatedFAB> createState() => _AnimatedFABState();
}

class _AnimatedFABState extends State<AnimatedFAB> with SingleTickerProviderStateMixin {
  bool _showAddIcon = true;
  Timer? _timer;
  late AnimationController _animationController;
  late Animation<Offset> _slideOutAnimation;
  late Animation<Offset> _slideInAnimation;

  @override
  void initState() {
    super.initState();
    _startAnimationCycle();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _slideOutAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -1), // Moves the icon up
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideInAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // Starts from below
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimationCycle() {
    _timer = Timer.periodic(const Duration(milliseconds: 10000), (timer) {
      _animateIconChange();
    });
  }

  void _animateIconChange() {
    _animationController.forward().then((_) {
      setState(() {
        _showAddIcon = !_showAddIcon;
      });
      _animationController.reverse();

      // Wait 2 seconds before switching back
      Future.delayed(const Duration(seconds: 2), () {
        _animationController.forward().then((_) {
          setState(() {
            _showAddIcon = !_showAddIcon;
          });
          _animationController.reverse();
        });
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    return GestureDetector(
      onDoubleTap: () async {
        final confirmSafeMode = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Enter Safe Mode'),
            content: const Text(
              'Safe Mode provides a calming experience. Do you want to proceed?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Enter Safe Mode'),
              ),
            ],
          ),
        );

        if (true == confirmSafeMode) {
          await navigator.pushNamed(SafeModeScreen.id);
        }
      },
      child: FloatingActionButton(
        onPressed: () {
          navigator.pushNamed(JournalEditorScreen.id);
        },
        tooltip: 'Tap to write a journal, Double-tap for Safe Mode',
        child: Stack(
          alignment: Alignment.center,
          children: [
            SlideTransition(
              position: _showAddIcon ? _slideOutAnimation : _slideInAnimation,
              child: Icon(
                Icons.add,
                key: const ValueKey('add'),
                color: _showAddIcon ? null : Colors.transparent,
              ),
            ),
            SlideTransition(
              position: _showAddIcon ? _slideInAnimation : _slideOutAnimation,
              child: Icon(
                Icons.self_improvement,
                key: const ValueKey('self_improvement'),
                color: !_showAddIcon ? null : Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
