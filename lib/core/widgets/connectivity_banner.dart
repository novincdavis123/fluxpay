import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../connectivity/connectivity_cubit.dart';
import '../connectivity/connectivity_state.dart';

class ConnectivityBanner extends StatelessWidget {
  const ConnectivityBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityCubit, ConnectivityState>(
      builder: (context, state) {
        final isConnected = state.isConnected;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),

          height: isConnected ? 0 : 42,

          width: double.infinity,

          color: Colors.red,

          alignment: Alignment.center,

          child: SafeArea(
            bottom: false,

            child: Text(
              isConnected ? '' : 'No internet connection',

              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      },
    );
  }
}
