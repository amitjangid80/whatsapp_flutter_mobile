import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:whatsapp_flutter_mobile/src/shared/models/message_model.dart';
import 'package:whatsapp_flutter_mobile/src/shared/models/user_model.dart';

import 'app_bloc.dart';
import 'app_module.dart';

class AppRepository extends Disposable {
  final HasuraConnect connection;
  var appBloc = AppModule.to.bloc<AppBloc>();

  Snapshot currentSnapshot;

  AppRepository(this.connection);

  void setLimit(int limit) => currentSnapshot.changeVariable({"limit": limit});

  Stream<List<MessageModel>> getMessages([int limit = 20]) {
    var query = """
      subscription (\$limit:Int!) {
        messages(order_by: {id: desc}, limit: \$limit) {
          user {
            email
            id
            name
            picture
          }
          content
          id
          create_at
        }
      }
    """;
    currentSnapshot = connection.subscription(query, variables: {"limit": limit});
    return currentSnapshot.stream
        .map((json) => MessageModel.fromJsonList(json["data"]["messages"]));
  }

  Future<void> sendMessage(String message) async {
    await connection.mutation(
      """
      sendchat(\$id:Int!,\$message:String!){
        insert_messages(objects: {content: \$message, user_id: \$id}) {
          affected_rows
        }
      }
    """,
      variables: {"id": appBloc.userController.value.id, "message": message},
    );
  }

  Future<UserModel> login(String email) async {
    var query = """
    login(\$email:String!){
      users(where: {email: {_eq: \$email}}) {
        id
        name
        picture
      }
    }
    """;

    var response = await connection.query(
      query,
      variables: {"email": email},
    );
    return UserModel.fromJsonList(response["data"]["users"]).last;
  }

  //dispose will be called automatically by closing its streams
  @override
  void dispose() {
    currentSnapshot.close();
    // connection.dispose();
  }
}
