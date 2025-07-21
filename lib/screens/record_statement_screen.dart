import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../core/theme/app_theme.dart';
import '../core/router/app_router.dart';
import '../core/services/audio_service.dart';
import '../models/habit_item.dart';
import '../providers/habit_provider.dart';

class RecordStatementScreen extends StatefulWidget {
  final String statement;
  final String? habitId;
  final String? habitTitle;

  const RecordStatementScreen({
    super.key,
    required this.statement,
    this.habitId,
    this.habitTitle,
  });

  @override
  State<RecordStatementScreen> createState() => _RecordStatementScreenState();
}

class _RecordStatementScreenState extends State<RecordStatementScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  
  bool _isRecording = false;
  bool _isPlaying = false;
  String? _recordingPath;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeAudio();
  }

  void _setupAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _initializeAudio() async {
    print('Initializing audio service...');
    await AudioService.initialize();
    print('Audio service initialized');
  }

  @override
  void dispose() {
    _pulseController.dispose();
    AudioService.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      print('🎤 User tapped record button');
      final hasPermission = await AudioService.requestPermission();
      if (!hasPermission) {
        if (mounted) {
          _showPermissionDialog();
        }
        return;
      }

      final path = await AudioService.startRecording();
      if (path != null) {
        setState(() {
          _isRecording = true;
          _recordingPath = path;
        });
        _pulseController.repeat(reverse: true);
        _startTimer();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('录音启动失败，请重试')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('录音出错: $e')),
        );
      }
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('需要麦克风权限'),
          content: const Text(
            '为了录制您的习惯语句，需要访问麦克风权限。\n\n'
            '请按照以下步骤操作：\n'
            '1. 点击"去设置"按钮\n'
            '2. 找到"麦克风"选项\n'
            '3. 打开麦克风权限\n'
            '4. 返回App重试',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await openAppSettings();
              },
              child: const Text('去设置'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _stopRecording() async {
    final path = await AudioService.stopRecording();
    if (path != null) {
      setState(() {
        _isRecording = false;
        _recordingPath = path;
      });
      _pulseController.stop();
      _stopTimer();
    }
  }

  Future<void> _playRecording() async {
    if (_recordingPath != null) {
      await AudioService.playRecording(_recordingPath!);
      setState(() {
        _isPlaying = true;
      });
      
      // Stop playing after audio ends (simplified)
      await Future.delayed(const Duration(seconds: 5));
      setState(() {
        _isPlaying = false;
      });
    }
  }

  Future<void> _stopPlaying() async {
    await AudioService.stopPlaying();
    setState(() {
      _isPlaying = false;
    });
  }

  void _startTimer() {
    // Simple timer implementation for demonstration
    // In a real app, you'd use a proper timer
  }

  void _stopTimer() {
    // Stop the timer
  }

  void _reRecord() {
    setState(() {
      _recordingPath = null;
    });
  }

  Future<void> _saveAndContinue() async {
    if (_recordingPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先录制语音')),
      );
      return;
    }

    final habitProvider = Provider.of<HabitProvider>(context, listen: false);
    
    try {
      final habit = HabitItem(
        title: widget.habitTitle ?? widget.statement.split('。')[0], // Use habitTitle or first part as title
        statement: widget.statement,
        audioPath: _recordingPath!,
      );

      await habitProvider.addHabit(habit);
      
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRouter.mainNavigation,
          (route) => false,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('保存失败: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('录制语句'),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Statement display
              Expanded(
                flex: 2,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.statement,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimaryColor,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '说慢一点，说满5秒以上',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondaryColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Recording controls
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Recording button
                    AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _isRecording ? _pulseAnimation.value : 1.0,
                          child: GestureDetector(
                            onTap: _isRecording ? _stopRecording : _startRecording,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: _isRecording ? Colors.red : AppTheme.primaryColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: (_isRecording ? Colors.red : AppTheme.primaryColor)
                                        .withOpacity(0.3),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Icon(
                                _isRecording ? Icons.stop : Icons.mic,
                                color: Colors.white,
                                size: 48,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Status text
                    Text(
                      _isRecording
                          ? '正在录音...'
                          : _recordingPath != null
                              ? '录音完成'
                              : '点击开始录音',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Control buttons
                    if (_recordingPath != null && !_isRecording) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Play button
                          OutlinedButton.icon(
                            onPressed: _isPlaying ? _stopPlaying : _playRecording,
                            icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow),
                            label: Text(_isPlaying ? '停止' : '播放'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                          ),
                          
                          // Re-record button
                          OutlinedButton.icon(
                            onPressed: _reRecord,
                            icon: const Icon(Icons.refresh),
                            label: const Text('重录'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Save button
                      SizedBox(
                        width: double.infinity,
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: AppTheme.primaryGradient,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: ElevatedButton(
                            onPressed: _saveAndContinue,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              shadowColor: Colors.transparent,
                            ),
                            child: const Text(
                              '保存并继续',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}