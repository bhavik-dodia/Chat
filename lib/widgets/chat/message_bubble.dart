import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_3.dart';
import 'package:google_fonts/google_fonts.dart';

class MessageBubble extends StatelessWidget {
  final String message, imageUrl, name;
  final bool isSender;

  const MessageBubble(
      {Key key, this.message, this.isSender, this.imageUrl, this.name})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    final pad = MediaQuery.of(context).size.width * 0.2;
    return
        // ChatBubble(
        //   elevation: 0,
        //   clipper: ChatBubbleClipper3(
        //     type: isSender ? BubbleType.sendBubble : BubbleType.receiverBubble,
        //     radius: 20,
        //   ),
        //   alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
        //   margin: isSender
        //       ? EdgeInsets.only(top: 15, left: pad)
        //       : EdgeInsets.only(top: 15, right: pad),
        //   backGroundColor: isSender
        //       ? isLight
        //           ? theme.accentColor.withOpacity(0.15)
        //           : Colors.blueAccent[100]
        //       : Colors.grey[isLight ? 200 : 700],
        //   child: SelectableText(
        //     message,
        //     style: GoogleFonts.overlock(
        //       fontSize: 17,
        //       color: isSender
        //           ? isLight
        //               ? theme.accentColor
        //               : Colors.black
        //           : null,
        //     ),
        //   ),
        // );
        isSender
            ? ChatBubble(
              elevation: 0,
              clipper: ChatBubbleClipper3(
                type: BubbleType.sendBubble,
                radius: 20,
              ),
              alignment: Alignment.centerRight,
              margin: EdgeInsets.only(top: 15, left: pad),
              backGroundColor: isLight
                  ? theme.accentColor.withOpacity(0.15)
                  : Colors.blueAccent[100],
              child: SelectableText(
                message,
                style: GoogleFonts.overlock(
                  fontSize: 17,
                  color: isLight ? theme.accentColor : Colors.black,
                ),
              ),
            )
            : Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                    height: 40.0,
                    width: 40.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: ChatBubble(
                      elevation: 0,
                      clipper: ChatBubbleClipper3(
                        type: BubbleType.receiverBubble,
                        radius: 20,
                      ),
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(top: 15, right: pad),
                      backGroundColor: Colors.grey[isLight ? 200 : 700],
                      child: SelectableText(
                        message,
                        style: GoogleFonts.overlock(fontSize: 17),
                      ),
                    ),
                  ),
              ],
            );
  }
}
