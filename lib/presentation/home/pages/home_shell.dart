import 'package:fitness_app/core/bloc/nav_bloc.dart';
import 'package:fitness_app/core/coreWidget/appbar_widget.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fitness_app/core/config/assets_path.dart';

class HomeShell extends StatelessWidget {
  const HomeShell({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final items = [
      NavItem(svgPath: AssetsPath.apb1, label: localizations.navHome),
      NavItem(svgPath: AssetsPath.apb2, label: localizations.navDiscover),
      NavItem(svgPath: AssetsPath.apb5, label: localizations.navProfile),
    ];

    final pages = [
      _Page(title: localizations.navHome),
      _Page(title: localizations.navDiscover),
      _Page(title: localizations.navProfile),
    ];

    return BlocProvider(
      create: (_) => NavBloc(),
      child: BlocBuilder<NavBloc, NavState>(
        builder: (context, state) {
          return Scaffold(
            body: IndexedStack(index: state.index, children: pages),
            bottomNavigationBar: CustomFloatingNavBar(
              selectedIndex: state.index,
              items: items,
              onItemSelected: (i) => context.read<NavBloc>().add(NavEvent(i)),
            ),
          );
        },
      ),
    );
  }
}

class _Page extends StatelessWidget {
  final String title;
  const _Page({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(title));
  }
}
