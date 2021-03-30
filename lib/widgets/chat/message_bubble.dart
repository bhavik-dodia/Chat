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
    final now = DateTime.now();
    final dateTime = DateTime.fromMillisecondsSinceEpoch(
      int.parse(timestamp),
    );
    if (dateTime.difference(now).inMinutes == 0) {
      return 'Just now';
    } else if (dateTime.difference(now).inDays == 1) {
      return 'Yesterday, ' + DateFormat.jm().format(dateTime);
    } else if (dateTime.difference(now).inDays == 0) {
      return DateFormat.jm().format(dateTime);
    } else if (dateTime.difference(now).inDays <= 7) {
      return DateFormat('E • h:mm a').format(dateTime);
    } else if (dateTime.difference(now).inDays <= 365) {
      return DateFormat('MMM, d • h:mm a').format(dateTime);
    } else {
      return DateFormat('MMM d, y • h:mm a').format(dateTime);
    }
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
          ? EdgeInsets.only(top: 7.5, bottom: 7.5, left: pad)
          : EdgeInsets.only(top: 7.5, bottom: 7.5, right: pad),
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
          Column(
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
            ],
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
