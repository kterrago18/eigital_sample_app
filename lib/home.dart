import 'package:eigital_sample_app/views/screens/calculator_screen.dart';
import 'package:eigital_sample_app/views/screens/map_screen.dart';
import 'package:eigital_sample_app/views/screens/news_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/home/home_screen_cubit.dart';
import 'cubit/home/home_screen_state.dart';
import 'cubit/map/map_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static List<Widget> pages = [
    BlocProvider<MapCubit>(
      create: (_) => MapCubit(),
      child: const MapScreen(),
    ),
    NewsScreen(),
    const CalculatorScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeScreenCubit, HomeScreenState>(
      listener: (_, __) {},
      builder: (context, state) {
        final HomeScreenCubit cubit = BlocProvider.of(context);
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Eigital Sample App',
            ),
          ),
          body: IndexedStack(
            index: cubit.selectedIndex,
            children: pages,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.selectedIndex,
            onTap: (index) {
              cubit.selectedIndex = index;
            },
            selectedItemColor:
                Theme.of(context).textSelectionTheme.selectionColor,
            items: _buildBottomNavigationBar(),
          ),
        );
      },
    );
  }

  List<BottomNavigationBarItem> _buildBottomNavigationBar() {
    return const [
      BottomNavigationBarItem(
        icon: Icon(Icons.map),
        label: 'Map',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.article),
        label: 'News',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.calculate),
        label: 'Calculator',
      ),
    ];
  }
}
