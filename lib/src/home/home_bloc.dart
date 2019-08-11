import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:whatsapp_flutter_mobile/src/app_bloc.dart';
import 'package:whatsapp_flutter_mobile/src/shared/models/message_model.dart';
import 'package:rxdart/subjects.dart';

import 'home_repository.dart';

class HomeBloc extends BlocBase {
  final HomeRepository repository;
  final AppBloc appBloc;
  final controller = TextEditingController();
  var scrollController = ScrollController();
  int count = 20;
  var moreController = BehaviorSubject.seeded(false);
  var itemsController = BehaviorSubject<List<MessageModel>>();

  Stream<List<MessageModel>> messagesOut;

  HomeBloc(this.repository, this.appBloc) {
    messagesOut = repository.getMessages()
      ..listen((data) => itemsController.add(data))
      ..listen(
        (data) {
          if (!moreController.isClosed) {
            moreController.add(count <= data.length);
            count += 20;
          }
        },
      );

    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent 
          && moreController.value) {
        count += 20;
        print("busca");
        repository.setLimit(count);
      }
    });
  }

  void sendMessage() async {
    if (controller.text.trim().isNotEmpty) {
      List<MessageModel> newList = List.from(itemsController.value);

      newList.add(
        MessageModel(
          content: controller.text.trim(),
          user: appBloc.userController.value,
          id: 0,
        ),
      );

      itemsController.add(newList);
      repository.sendMessage(controller.text.trim());
      await Future.delayed(Duration(milliseconds: 300));
      controller.clear();
    }
  }

  //dispose will be called automatically by closing its streams
  @override
  void dispose() async {
    moreController.close();
    controller.dispose();
    repository.dispose();
    await itemsController.drain();
    itemsController.close();
    super.dispose();
  }
}
