import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_dev_tools/bloc_dev_tools.dart';

import 'package:flutter_login/authentication/authentication.dart';
import 'package:flutter_login/splash/splash.dart';
import 'package:flutter_login/login/login.dart';
import 'package:flutter_login/home/home.dart';
import 'package:flutter_login/common/common.dart';

void main() {
  BlocSupervisor().delegate = DevBlocDelegate();
  runApp(App());
}

class App extends StatefulWidget {
  @override
  State<App> createState() => AppState();
}

class AppState extends State<App> {
  final AuthenticationBloc _authenticationBloc = AuthenticationBloc();

  AppState() {
    _authenticationBloc.dispatch(AppStart());
  }

  @override
  void dispose() {
    _authenticationBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      bloc: _authenticationBloc,
      child: MaterialApp(
        home: BlocBuilder<AuthenticationEvent, AuthenticationState>(
          bloc: _authenticationBloc,
          builder: (BuildContext context, AuthenticationState state) {
            List<Widget> widgets = [];

            if (state.isAuthenticated) {
              widgets.add(HomePage());
            } else {
              widgets.add(LoginPage());
            }

            if (state.isInitializing) {
              widgets.add(SplashPage());
            }

            if (state.isLoading) {
              widgets.add(LoadingIndicator());
            }

            return Stack(
              children: widgets,
            );
          },
        ),
      ),
    );
  }
}
