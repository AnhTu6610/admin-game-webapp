import 'package:flutter/cupertino.dart';

typedef OnTapYes();

showCommonDialog(BuildContext context, {String? title, String? content, OnTapYes? onTapYes}) {
  return showCupertinoDialog(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: Text(
          title ?? "",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        content: Text(content ?? ""),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context);
              if (onTapYes != null) onTapYes();
            },
            child: Text("Yes"),
          ),
        ],
      );
    },
  );
}
