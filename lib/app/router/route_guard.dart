import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';

class RouteGuard extends StatelessWidget {
  final Widget child;

  const RouteGuard({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthBloc>().state;

    if (!state.isAuthenticated) {
      return const SizedBox.shrink();
    }

    return child;
  }
}
