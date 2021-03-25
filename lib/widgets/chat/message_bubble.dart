import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_3.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final String message, timestamp;
  final bool isSender, read;

  MessageBubble(
      {Key key, this.message, this.isSender, this.read, this.timestamp})
      : super(key: key);

  String getTime(String timestamp) {
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
    DateFormat format;
    format = dateTime.difference(DateTime.now()).inMilliseconds <= 86400000
        ? DateFormat('jm')
        : DateFormat.yMd('en_US');
    return format
        .format(DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    final pad = MediaQuery.of(context).size.width * 0.2;
    return ChatBubble(
      elevation: 0,
      clipper: ChatBubbleClipper3(
        type: isSender ? BubbleType.sendBubble : BubbleType.receiverBubble,
        radius: 20,
      ),
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      margin: isSender
          ? EdgeInsets.only(top: 15, left: pad)
          : EdgeInsets.only(top: 15, right: pad),
      backGroundColor: isSender
          ? isLight
              ? theme.accentColor.withOpacity(0.15)
              : Colors.blueAccent[100]
          : Colors.grey[isLight ? 200 : 700],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          SelectableText(
            message,
            style: GoogleFonts.overlock(
              fontSize: 17,
              color: isSender
                  ? isLight
                      ? theme.accentColor
                      : Colors.black
                  : null,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              SelectableText(
                getTime(timestamp),
                style: TextStyle(
                  fontSize: 10.0,
                  color: isSender
                      ? isLight
                          ? Colors.grey
                          : Colors.grey[850]
                      : Colors.grey[isLight ? 500 : 300],
                ),
              ),
              Visibility(
                visible: isSender,
                child: Icon(
                  Icons.done_all_rounded,
                  color: read
                      ? Colors.blueAccent
                      : isLight
                          ? Colors.grey
                          : Colors.grey[800],
                  size: 18.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
