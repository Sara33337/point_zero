import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:point_zero/features/finance/presentation/finance_cubit/finance_cubit.dart';
import 'package:point_zero/features/finance/presentation/screens/finance_screen.dart';
import 'package:point_zero/features/inventory/presentation/inventory_cubit/inventory_cubit.dart';
import 'package:point_zero/features/inventory/presentation/screens/inventory_screen.dart';
import 'package:point_zero/features/pos/presentation/cubit/exchange_cubit/exchange_cubit.dart';
import 'package:point_zero/features/pos/presentation/cubit/pos_cubit/pos_cubit.dart';
import 'package:point_zero/features/pos/presentation/screens/pos_screen.dart';
import 'package:point_zero/injection_container.dart' as di;

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    // GoRoute(
    //   path: '/',
    //   builder: (BuildContext context, GoRouterState state) {
    //      return LoginScreen();
    //   },
    // ),
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => di.sl<PosCubit>()..loadProducts()),
            BlocProvider(create: (_) => di.sl<ExchangeCubit>()),
          ],
       
          child: const PosScreen(),
        );
      },
    ),

    GoRoute(
      path: '/finance_screen',
      builder: (BuildContext context, GoRouterState state) {
        return BlocProvider(
          create: (_) => di.sl<FinanceCubit>()..loadMonthlyData(),

          child: FinanceScreen(),
        );
      },
    ),

    GoRoute(
      path: '/inventory_screen',
      builder: (BuildContext context, GoRouterState state) {
        return BlocProvider(
          create: (_) => di.sl<InventoryCubit>()..loadProducts(),

          child: InventoryScreen(),
        );
      },
    ),
  ],
);
