
import 'dart:async';
import 'package:flutter/material.dart';

class RestTimerWidget extends StatefulWidget {
  final int defaultRestTime; // in seconds
  final VoidCallback? onTimerComplete;
  
  const RestTimerWidget({
    Key? key,
    this.defaultRestTime = 60,
    this.onTimerComplete,
  }) : super(key: key);

  @override
  State<RestTimerWidget> createState() => _RestTimerWidgetState();
}

class _RestTimerWidgetState extends State<RestTimerWidget> with SingleTickerProviderStateMixin {
  late Timer _timer;
  int _secondsRemaining = 60;
  bool _isRunning = false;
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _animation;
  
  final List<int> _presetTimes = [30, 60, 90, 120, 180];
  
  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.defaultRestTime;
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }
  
  @override
  void dispose() {
    if (_isRunning) {
      _timer.cancel();
    }
    _animationController.dispose();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
    });
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _stopTimer();
          if (widget.onTimerComplete != null) {
            widget.onTimerComplete!();
          }
        }
      });
    });
  }
  
  void _stopTimer() {
    if (_isRunning) {
      _timer.cancel();
      setState(() {
        _isRunning = false;
      });
    }
  }
  
  void _resetTimer() {
    _stopTimer();
    setState(() {
      _secondsRemaining = widget.defaultRestTime;
    });
  }
  
  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    
    if (_isExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }
  
  void _setCustomTime(int seconds) {
    _stopTimer();
    setState(() {
      _secondsRemaining = seconds;
      _isExpanded = false;
    });
    _animationController.reverse();
  }
  
  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text(
              'Rest Timer',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              _isRunning ? 'Timer running' : 'Timer paused',
            ),
            trailing: IconButton(
              icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
              onPressed: _toggleExpanded,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatTime(_secondsRemaining),
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    if (!_isRunning)
                      FloatingActionButton(
                        heroTag: 'restTimerPlay',
                        mini: true,
                        onPressed: _startTimer,
                        backgroundColor: Colors.green,
                        child: const Icon(Icons.play_arrow),
                      )
                    else
                      FloatingActionButton(
                        heroTag: 'restTimerPause',
                        mini: true,
                        onPressed: _stopTimer,
                        backgroundColor: Colors.orange,
                        child: const Icon(Icons.pause),
                      ),
                    const SizedBox(width: 8),
                    FloatingActionButton(
                      heroTag: 'restTimerReset',
                      mini: true,
                      onPressed: _resetTimer,
                      backgroundColor: Colors.red,
                      child: const Icon(Icons.refresh),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizeTransition(
            sizeFactor: _animation,
            child: Column(
              children: [
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Preset Times:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: _presetTimes.map((seconds) {
                          return ActionChip(
                            label: Text(_formatTime(seconds)),
                            onPressed: () => _setCustomTime(seconds),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Custom Time:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Slider(
                              value: _secondsRemaining.toDouble(),
                              min: 5,
                              max: 300,
                              divisions: 59,
                              label: _formatTime(_secondsRemaining),
                              onChanged: (value) {
                                setState(() {
                                  _secondsRemaining = value.round();
                                });
                              },
                            ),
                          ),
                          Text(_formatTime(_secondsRemaining)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
