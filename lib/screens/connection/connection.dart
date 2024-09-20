import 'package:craft/i18n/translations.g.dart';
import 'package:flutter/material.dart';
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

  void _submit() {
    if ((_formKey.currentState?.saveAndValidate()) ?? false) {
      final values = _formKey.currentState?.value;
    }
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
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.ip(),
                            ]),
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
                        value: true,
                        onChanged: null),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.all(20),
                      ),
                      onPressed: widget._isValid ? _submit : null,
                      child: Text(t.screens.connection.connect),
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
