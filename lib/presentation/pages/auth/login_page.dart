import 'package:accountant/application/login/login_cubit.dart';
import 'package:accountant/presentation/pages/set_password/set_password_page.dart';
import 'package:accountant/presentation/pages/password_page.dart';
import 'package:accountant/presentation/widgets/loading.dart';
import 'package:accountant/presentation/widgets/padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

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
            error: (err) =>  EasyLoading.showError(err),
            success: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const SetPasswordPage()),
                (route) => false));
      },
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(title: const Text("Tizimga kirish")),
            body: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 150.0,
                  width: 150.w,
                  child: Image.asset("assets/logo.png"),
                ),
                Gap(60.h),
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
