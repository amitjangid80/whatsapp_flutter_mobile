import 'package:whatsapp_flutter_mobile/src/app_module.dart';
import 'package:whatsapp_flutter_mobile/src/login/login_bloc.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_flutter_mobile/src/login/login_page.dart';

import '../app_repository.dart';

class LoginModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc((i) => LoginBloc(AppModule.to.get<AppRepository>())),
      ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => LoginPage();

  static Inject get to => Inject<LoginModule>.of();
}
