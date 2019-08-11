import 'package:flutter/material.dart';
import 'package:whatsapp_flutter_mobile/src/app_module.dart';
import 'package:whatsapp_flutter_mobile/src/home/home_module.dart';
import 'package:whatsapp_flutter_mobile/src/login/login_module.dart';
import 'package:whatsapp_flutter_mobile/src/shared/models/user_model.dart';

import 'app_bloc.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = AppModule.to.bloc<AppBloc>();
    return MaterialApp(
      title: 'Flutterando Chat',
      home: StreamBuilder<bool>(
          stream: bloc.darkModeController,
          builder: (context, darkSnapshot) {
            bool isDark = darkSnapshot.data ?? false;
            return Theme(
              data: ThemeData(
                primaryColor: isDark
                    ? Color(0xFF1E1E1E)
                    : Color(0xFF045F52),
                backgroundColor: isDark
                    ? Color(0xFF181C1B)
                    : Color(0xFFE5DDD5),
                unselectedWidgetColor: isDark
                    ? Color(0xFF232E31)
                    : Color(0xFFFFFFFF),
                selectedRowColor: isDark
                    ? Color(0xFF3C6685)
                    : Color(0xFFDCF8C6),
                cardColor: isDark
                    ? Colors.white
                    : Colors.black,
                disabledColor: isDark
                    ? Colors.grey
                    : Colors.black,
                floatingActionButtonTheme: FloatingActionButtonThemeData(
                  backgroundColor: isDark 
                    ? Color(0xFF3C6685) 
                    : Color(0xFF045F52)
                ),
              ),
              child: StreamBuilder<UserModel>(
                stream: bloc.userController,
                builder: (context, snapshot) {
                  return snapshot.hasData ? HomeModule() : LoginModule();
                },
              ),
            );
          },),
    );
  }
}
