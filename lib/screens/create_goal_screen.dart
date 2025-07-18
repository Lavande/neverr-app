import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/router/app_router.dart';
import '../core/services/deepseek_service.dart';
import '../models/habit_category.dart';

class CreateGoalScreen extends StatefulWidget {
  const CreateGoalScreen({super.key});

  @override
  State<CreateGoalScreen> createState() => _CreateGoalScreenState();
}

class _CreateGoalScreenState extends State<CreateGoalScreen> {
  final TextEditingController _customHabitController = TextEditingController();
  final TextEditingController _statementController = TextEditingController();
  HabitCategory? _selectedCategory;
  bool _isLoadingStatement = false;
  bool _isCustomHabit = false;

  @override
  void dispose() {
    _customHabitController.dispose();
    _statementController.dispose();
    super.dispose();
  }

  Future<void> _generateStatement() async {
    if (_selectedCategory == null && _customHabitController.text.trim().isEmpty) {
      return;
    }

    setState(() {
      _isLoadingStatement = true;
    });

    try {
      final habitKeyword = _selectedCategory?.name ?? _customHabitController.text.trim();
      final isPositiveHabit = HabitCategory.positiveHabits.contains(_selectedCategory);
      
      final statement = await DeepSeekService.generateHabitStatement(
        habitKeyword: habitKeyword,
        isPositive: isPositiveHabit,
      );

      _statementController.text = statement;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('生成语句失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoadingStatement = false;
      });
    }
  }

  void _proceedToRecording() {
    if (_statementController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先输入或生成语句')),
      );
      return;
    }

    final habitTitle = _selectedCategory?.name ?? _customHabitController.text.trim();
    Navigator.of(context).pushNamed(
      AppRouter.recordStatement,
      arguments: {
        'statement': _statementController.text.trim(),
        'habitTitle': habitTitle,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('创建目标'),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                '你想改变什么？',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '选择一个习惯分类，或者输入自定义习惯',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Toggle between categories and custom
              Row(
                children: [
                  Expanded(
                    child: _buildToggleButton(
                      '预设分类',
                      !_isCustomHabit,
                      () => setState(() => _isCustomHabit = false),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildToggleButton(
                      '自定义',
                      _isCustomHabit,
                      () => setState(() => _isCustomHabit = true),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // Categories or custom input
              if (_isCustomHabit)
                _buildCustomHabitInput()
              else
                _buildCategorySelection(),
              
              const SizedBox(height: 32),
              
              // Statement generation
              _buildStatementSection(),
              
              const SizedBox(height: 32),
              
              // Continue button
              SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: _statementController.text.trim().isNotEmpty
                        ? AppTheme.primaryGradient
                        : null,
                    color: _statementController.text.trim().isEmpty
                        ? Colors.grey.shade300
                        : null,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton(
                    onPressed: _statementController.text.trim().isNotEmpty
                        ? _proceedToRecording
                        : null,
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
                      '继续录制',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.transparent,
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondaryColor,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textSecondaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildCustomHabitInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '输入习惯名称',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _customHabitController,
          decoration: InputDecoration(
            hintText: '例如：熬夜、暴饮暴食、拖延等',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          onChanged: (value) {
            if (value.isNotEmpty) {
              setState(() {
                _selectedCategory = null;
              });
            }
          },
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: _customHabitController.text.trim().isNotEmpty && !_isLoadingStatement
                ? _generateStatement
                : null,
            child: _isLoadingStatement
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('生成语句'),
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '戒除坏习惯',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        _buildCategoryGrid(HabitCategory.predefinedCategories),
        
        const SizedBox(height: 24),
        
        Text(
          '培养好习惯',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        _buildCategoryGrid(HabitCategory.positiveHabits),
      ],
    );
  }

  Widget _buildCategoryGrid(List<HabitCategory> categories) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: categories.map((category) {
        final isSelected = _selectedCategory == category;
        
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedCategory = category;
              _customHabitController.clear();
            });
            _generateStatement();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : Colors.white,
              border: Border.all(
                color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  category.icon,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 6),
                Text(
                  category.name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: isSelected ? AppTheme.primaryColor : AppTheme.textPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStatementSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '生成的语句',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _statementController,
          decoration: InputDecoration(
            hintText: '点击上方按钮生成语句，或直接输入自定义语句',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 12),
        Text(
          '💡 提示：语句应该简洁、坚定且易于记忆。建议长度在20字以内。',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondaryColor,
          ),
        ),
      ],
    );
  }
}