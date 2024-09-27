import 'package:craft/app/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:craft/app/bloc/group_bloc/group_bloc.dart';
import 'package:craft/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class AuthenticationPage extends StatelessWidget {
  AuthenticationPage({super.key});

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              child: FormBuilder(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    children: [
                      Text(
                        'Welcome to Craft',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      FormBuilderTextField(
                        name: 'username',
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Username',
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          padding: const EdgeInsets.all(20),
                        ),
                        onPressed: () {
                          if (_formKey.currentState?.saveAndValidate() ??
                              false) {
                            final username = _formKey.currentState
                                ?.fields['username']?.value as String;

                            context.read<GroupBloc>().add(GroupLoad());

                            context
                                .read<AuthenticationBloc>()
                                .add(AuthenticationLogin(username: username));
                          }
                        },
                        child: BlocBuilder<AuthenticationBloc,
                            AuthenticationState>(builder: (context, state) {
                          return switch (state) {
                            AuthenticationLoading() =>
                              const CircularProgressIndicator(),
                            _ => Text(
                                'Login',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                          };
                        }),
                      ),
                      BlocListener<AuthenticationBloc, AuthenticationState>(
                          listener: (context, state) {
                            switch (state) {
                              case AuthenticationSuccess():
                                {
                                  HomeRoute().pushReplacement(context);
                                  break;
                                }
                            }
                          },
                          child: const SizedBox()),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
