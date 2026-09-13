import 'package:asmrapp/screens/contents/playlists_content.dart';
import 'package:flutter/material.dart';
import 'package:asmrapp/widgets/mini_player/mini_player.dart';
import 'package:asmrapp/widgets/drawer_menu.dart';
import 'package:asmrapp/screens/contents/home_content.dart';
import 'package:asmrapp/screens/contents/recommend_content.dart';
import 'package:asmrapp/screens/contents/popular_content.dart';
import 'package:asmrapp/screens/search_screen.dart';
import 'package:provider/provider.dart';
import 'package:asmrapp/presentation/viewmodels/home_viewmodel.dart';
import 'package:asmrapp/presentation/viewmodels/popular_viewmodel.dart';
import 'package:asmrapp/presentation/viewmodels/recommend_viewmodel.dart';
import 'package:asmrapp/presentation/viewmodels/auth_viewmodel.dart';
import 'package:asmrapp/presentation/viewmodels/playlists_viewmodel.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _pageController = PageController(initialPage: 1);
  int _currentIndex = 1;

  late final HomeViewModel _homeViewModel;
  late final PopularViewModel _popularViewModel;
  late final RecommendViewModel _recommendViewModel;
  late final PlaylistsViewModel _playlistsViewModel;

  final _titles = const ['我的收藏', '发现声音', '为你推荐', '本周热门'];
  final _eyebrows = const ['COLLECTION', 'Y U R O', 'FOR YOU', 'TRENDING'];

  final _pages = const [
    PlaylistsContent(),
    HomeContent(),
    RecommendContent(),
    PopularContent(),
  ];

  @override
  void initState() {
    super.initState();
    _homeViewModel = HomeViewModel();
    _popularViewModel = PopularViewModel();
    _recommendViewModel = RecommendViewModel(
      Provider.of<AuthViewModel>(context, listen: false),
    );
    _playlistsViewModel = PlaylistsViewModel();
  }

  void _onPageChanged(int index) => setState(() => _currentIndex = index);

  void _onTabTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  void _toggleFilter(BuildContext context) {
    if (_currentIndex == 1) {
      context.read<HomeViewModel>().toggleFilterPanel();
    } else if (_currentIndex == 2) {
      context.read<RecommendViewModel>().toggleFilterPanel();
    } else if (_currentIndex == 3) {
      context.read<PopularViewModel>().toggleFilterPanel();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _homeViewModel.dispose();
    _popularViewModel.dispose();
    _recommendViewModel.dispose();
    _playlistsViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _homeViewModel),
        ChangeNotifierProvider.value(value: _popularViewModel),
        ChangeNotifierProvider.value(value: _recommendViewModel),
        ChangeNotifierProvider.value(value: _playlistsViewModel),
      ],
      child: Builder(
        builder: (context) {
          final totalCount = _currentIndex == 1
              ? context.watch<HomeViewModel>().pagination?.totalCount
              : _currentIndex == 2
                  ? context.watch<RecommendViewModel>().pagination?.totalCount
                  : _currentIndex == 3
                      ? context.watch<PopularViewModel>().pagination?.totalCount
                      : null;
          final colors = Theme.of(context).colorScheme;

          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 74,
              titleSpacing: 4,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _eyebrows[_currentIndex],
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_titles[_currentIndex]),
                      if (totalCount != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: colors.primaryContainer,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            '$totalCount',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: colors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              actions: [
                if (_currentIndex != 0)
                  IconButton(
                    tooltip: '筛选',
                    icon: const Icon(Icons.tune_rounded),
                    onPressed: () => _toggleFilter(context),
                  ),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: IconButton.filledTonal(
                    tooltip: '搜索',
                    icon: const Icon(Icons.search_rounded),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SearchScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
            drawer: const DrawerMenu(),
            body: PageView(
              controller: _pageController,
              physics: const ClampingScrollPhysics(),
              onPageChanged: _onPageChanged,
              children: _pages,
            ),
            bottomNavigationBar: DecoratedBox(
              decoration: BoxDecoration(
                color: colors.surfaceContainer,
                border: Border(
                  top: BorderSide(
                      color: colors.outlineVariant.withOpacity(0.55)),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const MiniPlayer(),
                  NavigationBar(
                    selectedIndex: _currentIndex,
                    onDestinationSelected: _onTabTapped,
                    destinations: const [
                      NavigationDestination(
                        icon: Icon(Icons.favorite_outline_rounded),
                        selectedIcon: Icon(Icons.favorite_rounded),
                        label: '收藏',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.explore_outlined),
                        selectedIcon: Icon(Icons.explore_rounded),
                        label: '发现',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.auto_awesome_outlined),
                        selectedIcon: Icon(Icons.auto_awesome_rounded),
                        label: '推荐',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.local_fire_department_outlined),
                        selectedIcon: Icon(Icons.local_fire_department_rounded),
                        label: '热门',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
