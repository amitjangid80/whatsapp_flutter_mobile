import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_flutter_mobile/src/shared/models/message_model.dart';

import 'message_blob_clipper.dart';

class MessageBlobComponent extends StatelessWidget {
  final bool me;
  final MessageModel message;

  const MessageBlobComponent({
    Key key,
    this.me,
    this.message,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: me ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        if (!me)
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 7),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: CachedNetworkImage(
                height: 50,
                width: 50,
                imageUrl: message.user.picture,
                placeholder: (context, url) => new CircularProgressIndicator(),
                errorWidget: (context, url, error) => new Icon(Icons.error),
              ),
            ),
          ),
        Container(
          margin: EdgeInsets.only(top: 20),
          alignment: me ? Alignment.topRight : Alignment.topLeft,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.65,
            child: ClipPath(
              clipper: MessageClipper(me: me),
              child: Container(
                color: me
                    ? Theme.of(context).selectedRowColor
                    : Theme.of(context).unselectedWidgetColor,
                padding: EdgeInsets.fromLTRB(me ? 9 : 19, 6, me ? 17 : 7, 3),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (!me)
                      Text(
                        "~${message.user.name}",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    SizedBox(height: 5),
                    Text(
                      message.content,
                      style: TextStyle(
                          fontSize: 14, color: Theme.of(context).cardColor),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        message.formatedDateTime,
                        style: TextStyle(fontSize: 10, color: Theme.of(context).disabledColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (me)
          Padding(
            padding: const EdgeInsets.only(left: 7, right: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: CachedNetworkImage(
                height: 50,
                width: 50,
                imageUrl: message.user.picture,
                placeholder: (context, url) => new CircularProgressIndicator(),
                errorWidget: (context, url, error) => new Icon(Icons.error),
              ),
            ),
          ),
      ],
    );
  }
}
