import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/services_locator.dart';
import '../../../profile/presentation/views/profile_view.dart';
import '../cubit/circles_cubit.dart';
import '../cubit/home_cubit.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import 'home_view.dart';
import 'my_circles_view.dart';
import 'transactions_view.dart';

class MainLayoutView extends StatefulWidget {
  final int initialIndex;

  const MainLayoutView({super.key, this.initialIndex = 0});

  @override
  State<MainLayoutView> createState() => _MainLayoutViewState();
}

class _MainLayoutViewState extends State<MainLayoutView> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeCubit>(
          create: (_) => getIt<HomeCubit>(),
        ),
        BlocProvider<CirclesCubit>(
          create: (_) => getIt<CirclesCubit>(),
        ),
      ],
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: const [
            HomeView(),
            MyCirclesView(),
            TransactionsView(),
            ProfileView(),
          ],
        ),
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
