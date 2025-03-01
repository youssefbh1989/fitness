
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:wakelock/wakelock.dart';
import 'dart:async';

import '../../core/utils/size_config.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final String? thumbnailUrl;
  final String title;
  final String? description;
  final bool autoPlay;
  final bool looping;
  final bool showControls;
  final double aspectRatio;
  final Function(Duration)? onPositionChanged;
  final Function()? onVideoCompleted;

  const VideoPlayerWidget({
    Key? key,
    required this.videoUrl,
    this.thumbnailUrl,
    required this.title,
    this.description,
    this.autoPlay = false,
    this.looping = false,
    this.showControls = true,
    this.aspectRatio = 16 / 9,
    this.onPositionChanged,
    this.onVideoCompleted,
  }) : super(key: key);

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isPlaying = false;
  bool _isBuffering = false;
  bool _showControls = true;
  double _currentSpeed = 1.0;
  Timer? _hideControlsTimer;
  Timer? _positionUpdateTimer;
  
  final List<double> _availableSpeeds = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _controller = VideoPlayerController.network(widget.videoUrl);
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      setState(() {});
      
      // Setup listeners after initialization
      _controller.addListener(_videoPlayerListener);
      
      // Configure auto-play, looping etc.
      _controller.setLooping(widget.looping);
      if (widget.autoPlay) {
        _playVideo();
      }
      
      // Start position update timer
      _startPositionUpdateTimer();
    });
  }
  
  void _startPositionUpdateTimer() {
    _positionUpdateTimer?.cancel();
    _positionUpdateTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (_controller.value.isPlaying && widget.onPositionChanged != null) {
        widget.onPositionChanged!(_controller.value.position);
      }
    });
  }
  
  void _videoPlayerListener() {
    // Check if video is buffering
    final bool isBuffering = _controller.value.isBuffering;
    if (isBuffering != _isBuffering) {
      setState(() {
        _isBuffering = isBuffering;
      });
    }
    
    // Check if playing state changed
    final bool isPlaying = _controller.value.isPlaying;
    if (isPlaying != _isPlaying) {
      setState(() {
        _isPlaying = isPlaying;
      });
      
      // Manage wakelock based on playing state
      if (isPlaying) {
        Wakelock.enable();
      } else {
        Wakelock.disable();
      }
      
      // Manage controls visibility timer
      if (isPlaying) {
        _startHideControlsTimer();
      } else {
        _cancelHideControlsTimer();
        setState(() {
          _showControls = true;
        });
      }
    }
    
    // Check if video completed
    if (_controller.value.position >= _controller.value.duration) {
      if (widget.onVideoCompleted != null) {
        widget.onVideoCompleted!();
      }
      
      if (!widget.looping) {
        _cancelHideControlsTimer();
        setState(() {
          _showControls = true;
        });
      }
    }
  }
  
  void _playVideo() {
    _controller.play();
    setState(() {
      _isPlaying = true;
    });
    Wakelock.enable();
    _startHideControlsTimer();
  }
  
  void _pauseVideo() {
    _controller.pause();
    setState(() {
      _isPlaying = false;
      _showControls = true;
    });
    Wakelock.disable();
    _cancelHideControlsTimer();
  }
  
  void _togglePlayPause() {
    if (_controller.value.isPlaying) {
      _pauseVideo();
    } else {
      _playVideo();
    }
  }
  
  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
    
    if (_showControls && _controller.value.isPlaying) {
      _startHideControlsTimer();
    } else {
      _cancelHideControlsTimer();
    }
  }
  
  void _startHideControlsTimer() {
    _cancelHideControlsTimer();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _controller.value.isPlaying) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }
  
  void _cancelHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = null;
  }
  
  void _setPlaybackSpeed(double speed) {
    _controller.setPlaybackSpeed(speed);
    setState(() {
      _currentSpeed = speed;
    });
    _startHideControlsTimer();
  }
  
  void _seekRelative(Duration duration) {
    final newPosition = _controller.value.position + duration;
    final videoDuration = _controller.value.duration;
    
    if (newPosition < Duration.zero) {
      _controller.seekTo(Duration.zero);
    } else if (newPosition > videoDuration) {
      _controller.seekTo(videoDuration);
    } else {
      _controller.seekTo(newPosition);
    }
    
    // Show controls after seeking
    setState(() {
      _showControls = true;
    });
    _startHideControlsTimer();
  }
  
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${duration.inHours > 0 ? '${twoDigits(duration.inHours)}:' : ''}$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return _buildVideoPlayer();
            } else {
              return _buildLoadingView();
            }
          },
        ),
        if (widget.title.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.screenWidth! * 0.05,
              vertical: SizeConfig.screenHeight! * 0.01,
            ),
            child: Text(
              widget.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        if (widget.description != null && widget.description!.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.screenWidth! * 0.05,
              vertical: SizeConfig.screenHeight! * 0.01,
            ),
            child: Text(
              widget.description!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
      ],
    );
  }
  
  Widget _buildVideoPlayer() {
    return GestureDetector(
      onTap: _toggleControls,
      child: AspectRatio(
        aspectRatio: widget.aspectRatio,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Video player
            VideoPlayer(_controller),
            
            // Buffering indicator
            if (_isBuffering)
              const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
              
            // Tap to play overlay (only when not playing and controls hidden)
            if (!_isPlaying && !_showControls)
              Center(
                child: IconButton(
                  icon: const Icon(Icons.play_arrow, size: 50, color: Colors.white),
                  onPressed: _playVideo,
                ),
              ),
              
            // Controls overlay
            if (widget.showControls && _showControls)
              AnimatedOpacity(
                opacity: _showControls ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 250),
                child: Container(
                  color: Colors.black.withOpacity(0.4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Top bar with title and speed control
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // This could be a back button or title
                            IconButton(
                              icon: const Icon(Icons.arrow_back, color: Colors.white),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            
                            // Speed selector
                            PopupMenuButton<double>(
                              initialValue: _currentSpeed,
                              tooltip: 'Playback speed',
                              icon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${_currentSpeed}x',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  const Icon(Icons.speed, color: Colors.white),
                                ],
                              ),
                              onSelected: _setPlaybackSpeed,
                              itemBuilder: (context) {
                                return _availableSpeeds.map((speed) {
                                  return PopupMenuItem<double>(
                                    value: speed,
                                    child: Text('${speed}x'),
                                  );
                                }).toList();
                              },
                            ),
                          ],
                        ),
                      ),
                      
                      // Center play/pause button
                      _buildCenterControls(),
                      
                      // Bottom progress bar and controls
                      Column(
                        children: [
                          _buildProgressBar(),
                          _buildBottomControls(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCenterControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.replay_10, color: Colors.white, size: 40),
          onPressed: () => _seekRelative(const Duration(seconds: -10)),
        ),
        const SizedBox(width: 16),
        IconButton(
          icon: Icon(
            _isPlaying ? Icons.pause : Icons.play_arrow,
            color: Colors.white,
            size: 60,
          ),
          onPressed: _togglePlayPause,
        ),
        const SizedBox(width: 16),
        IconButton(
          icon: const Icon(Icons.forward_10, color: Colors.white, size: 40),
          onPressed: () => _seekRelative(const Duration(seconds: 10)),
        ),
      ],
    );
  }
  
  Widget _buildProgressBar() {
    return ValueListenableBuilder(
      valueListenable: _controller,
      builder: (context, VideoPlayerValue value, child) {
        final position = value.position;
        final duration = value.duration;
        
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                _formatDuration(position),
                style: const TextStyle(color: Colors.white),
              ),
              Expanded(
                child: Slider(
                  value: position.inMilliseconds.toDouble(),
                  min: 0,
                  max: duration.inMilliseconds.toDouble(),
                  onChanged: (value) {
                    _controller.seekTo(Duration(milliseconds: value.toInt()));
                  },
                  activeColor: Theme.of(context).primaryColor,
                  inactiveColor: Colors.white24,
                ),
              ),
              Text(
                _formatDuration(duration),
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildBottomControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(
              widget.looping ? Icons.repeat_on : Icons.repeat,
              color: widget.looping ? Theme.of(context).primaryColor : Colors.white,
            ),
            onPressed: () {
              final newLooping = !_controller.value.isLooping;
              _controller.setLooping(newLooping);
              setState(() {});
            },
          ),
          IconButton(
            icon: const Icon(Icons.hd, color: Colors.white),
            onPressed: () {
              // Show quality selector (not implemented in this example)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Quality options coming soon')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.fullscreen, color: Colors.white),
            onPressed: () {
              // Enter fullscreen mode (would be implemented differently in a real app)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fullscreen mode coming soon')),
              );
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildLoadingView() {
    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (widget.thumbnailUrl != null)
            CachedNetworkImage(
              imageUrl: widget.thumbnailUrl!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              placeholder: (context, url) => Container(
                color: Colors.black,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.black45,
                child: const Icon(Icons.error, color: Colors.white),
              ),
            )
          else
            Container(color: Colors.black),
          const Center(
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    _positionUpdateTimer?.cancel();
    _controller.removeListener(_videoPlayerListener);
    _controller.dispose();
    Wakelock.disable();
    super.dispose();
  }
}
