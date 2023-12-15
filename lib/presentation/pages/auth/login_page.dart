import 'package:accountant/application/login/login_cubit.dart';
import 'package:accountant/helpers/show_message.dart';
import 'package:accountant/presentation/pages/home/home_page.dart';
import 'package:accountant/presentation/widgets/loading.dart';
import 'package:accountant/presentation/widgets/padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _emailController;

  late final TextEditingController _passwordController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        state.whenOrNull(
            error: (err) => showFoxMessage(err),
            success: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
                (route) => false));
      },
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(title: const Text("Tizimga kirish")),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FoxWayPadding(
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    decoration: const InputDecoration(hintText: "Email pochta"),
                  ),
                ),
                FoxWayPadding(
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(hintText: "Parol"),
                  ),
                )
              ],
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => context.read<LoginCubit>().login(
                  email: _emailController.text,
                  password: _passwordController.text),
              label: state.maybeMap(
                  orElse: () => const Text("Kirish"),
                  loading: (r) => const FoxLoadingWidget()),
            ));
      },
    );
  }
}
