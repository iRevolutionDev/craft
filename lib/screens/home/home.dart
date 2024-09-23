import 'package:craft/app/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:craft/app/bloc/authentication_bloc/authentication_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
                return switch (state) {
                  AuthenticationSuccess(user: final user) =>
                    Text('${user.username} ${user.id}'),
                  _ => const Text('Loading...'),
                };
              },
            ),
          ],
        ),
      ),
    );
  }
}
