import 'package:go_router/go_router.dart';

import 'package:aad/screens/accounts/accounts_screen.dart';
import 'package:aad/screens/accounts/edit_account_screen.dart';
import 'package:aad/screens/accounts/new_account_screen.dart';
import 'package:aad/screens/home/home_screen.dart';
import 'package:aad/screens/categories/categories_screen.dart';
import 'package:aad/screens/categories/edit_categories_screen.dart';
import 'package:aad/screens/stats/stats_screen.dart';
import 'package:aad/screens/transactions/transactions_screen.dart';
import 'package:aad/widgets/app_shell.dart';

final router = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/accounts',
      builder: (context, state) => const AccountsScreen(),
      routes: [
        GoRoute(
          path: 'new',
          builder: (context, state) => const NewAccountScreen(),
        ),
        GoRoute(
          path: ':id/edit',
          builder: (context, state) =>
              EditAccountScreen(accountId: state.pathParameters['id']!),
        ),
      ],
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/categories',
              builder: (context, state) => const CategoriesScreen(),
              routes: [
                GoRoute(
                  path: 'edit',
                  builder: (context, state) => const EditCategoriesScreen(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/transactions',
              builder: (context, state) => const TransactionsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/stats',
              builder: (context, state) => const StatsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
