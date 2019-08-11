import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:whatsapp_flutter_mobile/src/shared/models/user_model.dart';
import 'package:hydrated/hydrated.dart';

class AppBloc extends BlocBase {
  var userController = HydratedSubject<UserModel>(
    "currentUserLogedIn",
    hydrate: (str) => UserModel.fromJsonString(str),
    persist: (model) => model?.toJsonString(),
  );

  var darkModeController = HydratedSubject("darkMode", seedValue: false);
  bool get isDarkMode => darkModeController.value;

  //dispose will be called automatically by closing its streams
  @override
  void dispose() {
    userController.close();
    darkModeController.close();
    super.dispose();
  }
}
