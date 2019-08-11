import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_flutter_mobile/src/app_module.dart';
import 'package:whatsapp_flutter_mobile/src/login/login_bloc.dart';
import 'package:whatsapp_flutter_mobile/src/login/login_module.dart';
import 'package:whatsapp_flutter_mobile/src/shared/models/message_model.dart';
import '../app_bloc.dart';
import 'home_bloc.dart';
import 'home_module.dart';
import 'message_blob/message_blob_component.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var bloc = HomeModule.to.bloc<HomeBloc>();
  var loginBloc = LoginModule.to.bloc<LoginBloc>();
  var appBloc = AppModule.to.bloc<AppBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          color: Theme.of(context).primaryColor,
          width: double.infinity,
          height: double.infinity,
          child: SafeArea(
            child: Row(
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(25),
                    onTap: loginBloc.logout,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Icon(Icons.arrow_back, color: Colors.white),
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: CachedNetworkImage(
                              imageUrl:
                                  "https://flutterando.com.br/wp-content/uploads/2019/06/flutterando_logo.png",
                              height: 25,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Text(
                    "Flutterando Chat",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 21,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.autorenew,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    appBloc.darkModeController
                        .add(!appBloc.darkModeController.value);
                  },
                )
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            color: Theme.of(context).backgroundColor,
            child: Opacity(
              opacity: 0.07,
              child: Image.asset(
                "assets/background-chat.png",
                fit: BoxFit.contain,
                repeat: ImageRepeat.repeat,
              ),
            ),
          ),
          StreamBuilder<List<MessageModel>>(
            stream: bloc.itemsController,
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(),
                  ),
                );
              return Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.separated(
                      separatorBuilder: (context, index) => SizedBox(height: 5),
                      reverse: true,
                      physics: BouncingScrollPhysics(),
                      controller: bloc.scrollController,
                      itemCount: snapshot.data.length + 1,
                      itemBuilder: (context, index) {
                        if (index == snapshot.data.length)
                          return StreamBuilder<bool>(
                            stream: bloc.moreController,
                            builder: (context, snapshot) {
                              return snapshot.data ?? true
                                  ? Center(
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        margin: EdgeInsets.all(15),
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                  : Container();
                            },
                          );
                        else {
                          bool isCurrentUser =
                              (appBloc.userController.value.id ==
                                  snapshot.data[index].user.id);
                          return MessageBlobComponent(
                            me: isCurrentUser,
                            message: snapshot.data[index],
                          );
                        }

                        // ? buildMe(snapshot.data[index])
                        // : buildOther(snapshot.data[index]);
                      },
                    ),
                  ),
                  _buildInputBox()
                  // Container(
                  //   margin: EdgeInsets.all(8),
                  //   child: TextField(
                  //     controller: bloc.controller,
                  //     textInputAction: TextInputAction.done,
                  //     onSubmitted: (text) => bloc.sendMessage(),
                  //     decoration: InputDecoration(
                  //       fillColor: Colors.white,
                  //       filled: true,
                  //       suffixIcon: IconButton(
                  //         icon: Icon(Icons.send),
                  //         onPressed: bloc.sendMessage,
                  //       ),
                  //       border: OutlineInputBorder(),
                  //     ),
                  //   ),
                  // )
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInputBox() {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 121.96),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: <Widget>[
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: TextField(
                    maxLines: null,
                    controller: bloc.controller,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: "Digite aqui",
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 5),
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(23),
                onTap: () => bloc.sendMessage(),
                child: CircleAvatar(
                  radius: 23,
                  backgroundColor: Theme.of(context)
                      .floatingActionButtonTheme
                      .backgroundColor,
                  child: Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // Container(
      //   decoration: BoxDecoration(
      //     color: Color(0XFFefefef),
      //     border: Border(
      //       top: BorderSide(color: Colors.grey[300]),
      //       left: BorderSide(color: Colors.grey[300]),
      //     ),
      //   ),
      //   padding: EdgeInsets.symmetric(vertical: 10),
      //   width: double.infinity,
      //   child:
      //   Row(
      //     crossAxisAlignment: CrossAxisAlignment.end,
      //     children: <Widget>[
      //       Expanded(
      //         child: Stack(
      //           children: <Widget>[
      //             Padding(
      //               padding: const EdgeInsets.symmetric(horizontal: 57),
      //               child: ClipRRect(
      //                 borderRadius: BorderRadius.circular(22),
      //                 child: Container(
      //                   padding: EdgeInsets.symmetric(horizontal: 15),
      //                   decoration: BoxDecoration(
      //                     color: Colors.white,
      //                     borderRadius: BorderRadius.circular(22),
      //                   ),
      //                   child: TextField(
      //                     maxLines: null,
      //                     keyboardType: TextInputType.multiline,
      //                     decoration: InputDecoration(
      //                       hintText: "Type a message",
      //                       border: InputBorder.none,
      //                       contentPadding:
      //                           const EdgeInsets.symmetric(vertical: 10),
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //             ),
      //             Positioned(
      //               left: 0,
      //               bottom: -5,
      //               child: IconButton(
      //                 padding: EdgeInsets.symmetric(horizontal: 19),
      //                 icon: Icon(Icons.sentiment_very_satisfied, size: 26),
      //                 onPressed: () {},
      //                 color: Colors.grey,
      //               ),
      //             ),
      //             Positioned(
      //               right: 0,
      //               bottom: -5,
      //               child: IconButton(
      //                 padding: EdgeInsets.symmetric(horizontal: 19),
      //                 icon: Icon(
      //                   Icons.mic,
      //                   size: 26,
      //                 ),
      //                 onPressed: () {},
      //                 color: Colors.grey,
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
