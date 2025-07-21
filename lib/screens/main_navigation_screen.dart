import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../core/router/app_router.dart';
import '../providers/habit_provider.dart';
import '../providers/app_settings_provider.dart';
import '../widgets/habit_card.dart';
import 'settings_screen.dart';
import 'data_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final habitProvider = Provider.of<HabitProvider>(context, listen: false);
    await habitProvider.loadHabits();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          HomeTab(),
          DataScreen(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.surfaceColor,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: AppTheme.textSecondaryColor,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '首页',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: '数据',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '设置',
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0 ? FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AppRouter.createGoal);
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ) : null,
    );
  }
}

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  Future<void> _refreshData() async {
    final habitProvider = Provider.of<HabitProvider>(context, listen: false);
    await habitProvider.refreshHabits();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _refreshData,
        color: AppTheme.primaryColor,
        backgroundColor: AppTheme.surfaceColor,
        child: Consumer2<HabitProvider, AppSettingsProvider>(
          builder: (context, habitProvider, settingsProvider, child) {
            return CustomScrollView(
              slivers: [
                // App Bar
                SliverAppBar(
                  backgroundColor: AppTheme.backgroundColor,
                  elevation: 0,
                  expandedHeight: 140,
                  floating: true,
                  pinned: false,
                  automaticallyImplyLeading: false,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 50, 24, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            settingsProvider.getGreeting(),
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimaryColor,
                              fontSize: 28,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            settingsProvider.getMotivationalMessage(),
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppTheme.textSecondaryColor,
                              fontSize: 16,
                            ),
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                // Habits Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '我的习惯',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimaryColor,
                          ),
                        ),
                        Text(
                          '共${habitProvider.totalActiveHabits}个',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
                
                // Habits List
                if (habitProvider.isLoading)
                  const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  )
                else if (habitProvider.activeHabits.isEmpty)
                  SliverToBoxAdapter(
                    child: _buildEmptyState(context),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final habit = habitProvider.activeHabits[index];
                        return Padding(
                          padding: EdgeInsets.fromLTRB(
                            24,
                            0,
                            24,
                            index == habitProvider.activeHabits.length - 1 ? 100 : 16,
                          ),
                          child: HabitCard(
                            habit: habit,
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                AppRouter.habitDetail,
                                arguments: habit,
                              );
                            },
                          ),
                        );
                      },
                      childCount: habitProvider.activeHabits.length,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              Icons.self_improvement,
              size: 60,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '还没有习惯项目',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '点击右下角的 + 按钮\n开始创建你的第一个习惯改变项目',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRouter.createGoal);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('开始创建'),
          ),
        ],
      ),
    );
  }
}