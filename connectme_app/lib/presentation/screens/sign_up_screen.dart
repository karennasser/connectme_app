import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/utils/validators.dart';
import '../blocs/auth_cubit.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _name.dispose(); _email.dispose(); _password.dispose(); _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(title: const Text('Create account')),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(width * .07),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(controller: _name, decoration: const InputDecoration(labelText: 'Full name'), validator: Validators.fullName),
                  const SizedBox(height: 14),
                  TextFormField(controller: _email, decoration: const InputDecoration(labelText: 'Email'), keyboardType: TextInputType.emailAddress, validator: Validators.email),
                  const SizedBox(height: 14),
                  TextFormField(controller: _password, obscureText: true, decoration: const InputDecoration(labelText: 'Password'), validator: Validators.password),
                  const SizedBox(height: 14),
                  TextFormField(controller: _confirm, obscureText: true, decoration: const InputDecoration(labelText: 'Confirm password'), validator: (v) => Validators.confirmPassword(v, _password.text)),
                  const SizedBox(height: 24),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) => Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (state.message != null) Text(state.message!, style: const TextStyle(color: Colors.red)),
                        FilledButton(
                          onPressed: state.status == AuthStatus.loading ? null : () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthCubit>().signUp(_name.text, _email.text, _password.text);
                              Navigator.pop(context);
                            }
                          },
                          child: const Text('Create account'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
