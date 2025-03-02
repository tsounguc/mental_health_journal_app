import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_journal_app/core/resources/media_resources.dart';

class SafeModeScreen extends StatefulWidget {
  const SafeModeScreen({super.key});

  static const id = '/safe-mode';

  @override
  State<SafeModeScreen> createState() => _SafeModeScreenState();
}

class _SafeModeScreenState extends State<SafeModeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _sizeAnimation;
  late Animation<double> _fadeAnimation;
  bool isBreathingIn = true;

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _sizeAnimation = Tween<double>(begin: 0.7, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Fade Animation for Text
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Listen to animation status to switch text
    _animationController
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() => isBreathingIn = false); // Switch to "Breathe Out"
          _animationController.reverse(); // Shrink back
        } else if (status == AnimationStatus.dismissed) {
          setState(() => isBreathingIn = true); // Switch to "Breathe In"
          _animationController.forward(); // Expand again
        }
      })

      // Start breathing animation loop
      ..forward();

    _playMusic();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _toggleMusic() async {
    if (_audioPlayer.state == PlayerState.playing) {
      await _pauseMusic();
      setState(() {
        isPlaying = false;
      });
    } else if (_audioPlayer.state == PlayerState.paused) {
      await _resumeMusic();
      setState(() {
        isPlaying = true;
      });
    } else if (_audioPlayer.state == PlayerState.stopped) {
      await _playMusic();
      setState(() {
        isPlaying = true;
      });
    } else if (_audioPlayer.state == PlayerState.completed) {
      await _stopMusic();
      setState(() {
        isPlaying = false;
      });
      // await _playMusic();
      // setState(() {
      //   isPlaying = true;
      // });
    } else {
      await _stopMusic();
      setState(() {
        isPlaying = false;
      });
    }
  }

  Future<void> _playMusic() async {
    await _audioPlayer.play(
      AssetSource(MediaResources.meditationMusic),
    );
  }

  Future<void> _resumeMusic() async {
    await _audioPlayer.resume();
  }

  Future<void> _pauseMusic() async {
    await _audioPlayer.pause();
  }

  Future<void> _stopMusic() async {
    await _audioPlayer.stop();
  }

  void _exitSafeMode(BuildContext context) {
    _stopMusic();
    Navigator.pop(context);
    Future.delayed(const Duration(milliseconds: 300), () {
      _showSelfCareSuggestion(context);
    });
  }

  void _showSelfCareSuggestion(BuildContext context) {
    final suggestions = <String>[
      'Write something positive about your day ✍🏻✍🏽✍🏾',
      'Take a short mindfulness break 🏝️',
      'Reflect on a happy moment 💭',
      'Listen to your favorite song 🎶',
      'Go for a short walk outside🚶🏻🚶🚶🏽',
    ];

    final suggestion = (suggestions..shuffle()).first; // Pick a random suggestion

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Self-Care Suggestion'),
        content: Text(suggestion),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade900,
        foregroundColor: Colors.white,
        title: const Text(
          'Safe Mode',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 5),
              Column(
                children: [
                  // Fading "Breathe in / Breathe out" Text
                  AnimatedBuilder(
                    animation: _fadeAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: Text(
                          isBreathingIn ? 'Breathe in...' : 'Breathe out...',
                          style: const TextStyle(fontSize: 24, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 50),

                  AnimatedBuilder(
                    animation: _sizeAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _sizeAnimation.value,
                        child: Container(
                          width: 325,
                          height: 325,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blueAccent,
                          ),
                          child: Center(
                            child: ImageIcon(
                              isBreathingIn
                                  ? const AssetImage(
                                      MediaResources.breatheIn,
                                    )
                                  : const AssetImage(MediaResources.breatheOut),
                              size: 125,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: _toggleMusic,
                    icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                    label: Text(
                      _audioPlayer.state == PlayerState.paused
                          ? 'Resume Music'
                          : isPlaying
                              ? 'Pause Music'
                              : 'Listen to Calm Music',
                      style: const TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () => _exitSafeMode(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Positive Reflection',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context), // Exit Safe Mode
                    style: ElevatedButton.styleFrom(
                      // backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Exit',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10)
            ],
          ),
        ),
      ),
    );
  }
}
