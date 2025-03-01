
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_theme.dart';

class WorkoutVideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final String title;
  
  const WorkoutVideoPlayerScreen({
    Key? key,
    required this.videoUrl,
    required this.title,
  }) : super(key: key);

  @override
  State<WorkoutVideoPlayerScreen> createState() => _WorkoutVideoPlayerScreenState();
}

class _WorkoutVideoPlayerScreenState extends State<WorkoutVideoPlayerScreen> {
  bool _isPlaying = true;
  bool _isFullScreen = false;
  double _currentPosition = 0.0;
  final double _totalDuration = 180.0; // Mock 3 minutes
  bool _isControlsVisible = true;
  bool _isBuffering = false;
  
  // Timer to hide controls
  late Timer _timer;
  
  @override
  void initState() {
    super.initState();
    
    // Enter full screen mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    
    // Set up timer to hide controls
    _timer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isControlsVisible = false;
        });
      }
    });
    
    // Simulate buffering
    setState(() {
      _isBuffering = true;
    });
    
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isBuffering = false;
        });
      }
    });
    
    // Simulate video progress
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (mounted && _isPlaying && _currentPosition < _totalDuration) {
        setState(() {
          _currentPosition += 0.1;
          if (_currentPosition >= _totalDuration) {
            _isPlaying = false;
            _currentPosition = _totalDuration;
          }
        });
      }
    });
  }
  
  @override
  void dispose() {
    _timer.cancel();
    // Exit full screen mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }
  
  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
    _resetControlsTimer();
  }
  
  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });
    if (_isFullScreen) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
    _resetControlsTimer();
  }
  
  void _resetControlsTimer() {
    _timer.cancel();
    setState(() {
      _isControlsVisible = true;
    });
    _timer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isControlsVisible = false;
        });
      }
    });
  }
  
  void _toggleControls() {
    setState(() {
      _isControlsVisible = !_isControlsVisible;
    });
    if (_isControlsVisible) {
      _resetControlsTimer();
    } else {
      _timer.cancel();
    }
  }
  
  void _seek(double position) {
    setState(() {
      _currentPosition = position;
    });
    _resetControlsTimer();
  }
  
  String _formatDuration(double seconds) {
    final int mins = seconds ~/ 60;
    final int secs = (seconds % 60).round();
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleControls,
        child: Stack(
          children: [
            // Video Content (Mocked with a placeholder)
            Center(
              child: _isBuffering
                  ? const CircularProgressIndicator(color: Colors.white)
                  : AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        color: Colors.black54,
                        child: Center(
                          child: Text(
                            'Video: ${widget.title}',
                            style: const TextStyle(color: Colors.white54),
                          ),
                        ),
                      ),
                    ),
            ),
            
            // Video Controls (visible only when _isControlsVisible is true)
            if (_isControlsVisible)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                    stops: const [0.0, 0.15, 0.85, 1.0],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top Bar
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Text(
                            widget.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              _isFullScreen
                                  ? Icons.fullscreen_exit
                                  : Icons.fullscreen,
                              color: Colors.white,
                            ),
                            onPressed: _toggleFullScreen,
                          ),
                        ],
                      ),
                    ),
                    
                    // Center Play/Pause Button
                    IconButton(
                      iconSize: 70,
                      icon: Icon(
                        _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                        color: Colors.white.withOpacity(0.8),
                      ),
                      onPressed: _togglePlayPause,
                    ),
                    
                    // Bottom Controls
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                _formatDuration(_currentPosition),
                                style: const TextStyle(color: Colors.white),
                              ),
                              Expanded(
                                child: SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                                    trackHeight: 4,
                                  ),
                                  child: Slider(
                                    value: _currentPosition,
                                    min: 0.0,
                                    max: _totalDuration,
                                    activeColor: AppTheme.primaryColor,
                                    inactiveColor: Colors.grey[600],
                                    onChanged: _seek,
                                  ),
                                ),
                              ),
                              Text(
                                _formatDuration(_totalDuration),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.replay_10, color: Colors.white),
                                onPressed: () {
                                  _seek((_currentPosition - 10).clamp(0, _totalDuration));
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  _isPlaying ? Icons.pause : Icons.play_arrow,
                                  color: Colors.white,
                                ),
                                onPressed: _togglePlayPause,
                              ),
                              IconButton(
                                icon: const Icon(Icons.forward_10, color: Colors.white),
                                onPressed: () {
                                  _seek((_currentPosition + 10).clamp(0, _totalDuration));
                                },
                              ),
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
      ),
    );
  }
}
