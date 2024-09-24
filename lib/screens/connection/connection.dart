import 'package:craft/app/bloc/connection_bloc/connection_bloc.dart';
import 'package:craft/i18n/translations.g.dart';
import 'package:craft/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class ConnectionPage extends StatefulWidget {
  ConnectionPage({super.key});

  late bool _alwaysConnect = true;
  late bool _isValid = false;

  @override
  State<ConnectionPage> createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  Future<void> _submit(BuildContext context) async {
    if (!mounted) return;

    if (!((_formKey.currentState?.saveAndValidate()) ?? false)) {
      return;
    }

    final values = _formKey.currentState?.value;

    context.read<ConnectionBloc>().add(ConnectToServer(
        ip: values?['ip'] as String,
        port: int.parse(values?['port'] as String),
        alwaysConnect: widget._alwaysConnect));

    context.read<ConnectionBloc>().stream.listen((state) {
      switch (state) {
        case ConnectionSuccess():
          AuthenticationRoute().go(context);
          break;
        case ConnectionFailure():
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Failed to connect to server"),
            backgroundColor: Colors.red,
          ));
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            child: Container(
              margin: const EdgeInsets.all(20),
              constraints: const BoxConstraints(maxWidth: 400),
              child: FormBuilder(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: () {
                  setState(() {
                    widget._isValid = _formKey.currentState?.isValid ?? false;
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.screens.connection.title,
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 3,
                          child: FormBuilderTextField(
                            name: 'ip',
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: t.screens.connection.form.host,
                            ),
                            validator: FormBuilderValidators.compose(
                                [FormBuilderValidators.required()]),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: FormBuilderTextField(
                            name: 'port',
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: t.screens.connection.form.port,
                            ),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.numeric(),
                            ]),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    CheckboxListTile(
                        title: Text(t.screens.connection.always_connect),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        value: widget._alwaysConnect,
                        onChanged: (value) {
                          setState(() {
                            widget._alwaysConnect = value ?? false;
                          });
                        }),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        padding: const EdgeInsets.all(20),
                      ),
                      onPressed:
                          widget._isValid ? () => _submit(context) : null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BlocBuilder<ConnectionBloc, ConnectionBlocState>(
                              builder: (context, state) {
                            return switch (state) {
                              ConnectionLoading() => const SizedBox(
                                  width: 20,
                                  child: CircularProgressIndicator(),
                                ),
                              _ => const SizedBox(),
                            };
                          }),
                          Text(t.screens.connection.connect,
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
