import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:taskly/ui/homescreen/homescreen.dart';
import 'package:taskly/utils/colorutitls.dart';

class DialogUtils {
  static onAlertWithCustomImagePressed(context, title, desc, dialogButtonMsg,
      dialogButtonMsg2, bool isVisible, Function _deleteConfirm) {
    List<DialogButton> buttons = List();
    if (isVisible) {
      buttons.add(DialogButton(
        color: ColorUtils.itemColor,
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          dialogButtonMsg2,
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ));
    }
    buttons.add(
      DialogButton(
        color: isVisible ? ColorUtils.deleteButtonColor : ColorUtils.themeColor,
        child: Text(
          dialogButtonMsg,
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        onPressed: () {
          Navigator.pop(context);
          if (isVisible) {
            _deleteConfirm.call();
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          }
        },
        width: 100,
      ),
    );
    Alert(
      context: context,
      title: title,
      desc: desc,
      image: Visibility(
        visible: !isVisible,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  blurRadius: 10, color: ColorUtils.itemColor, spreadRadius: 1)
            ],
          ),
          child: CircleAvatar(
            backgroundColor: Colors.green,
            child: Icon(Icons.check),
          ),
        ),
      ),
      buttons: buttons,
    ).show();
  }

  static showColorPiker(context, Function functionColor, Color selectedColor) {
    List<ColorSwatch> colors = List();
    ColorUtils.colorsInfo.forEach((key, value) {
      colors.add(ColorSwatch(value.value, {key: value}));
    });

    openDialog(
      context,
      "Color Piker",
      Container(
        height: 300,
        child: MaterialColorPicker(
          onColorChange: (Color color) {
            print("test");
          },
          onMainColorChange: (Color color) {
            print("test");
            var key = ColorUtils.colorsInfo.keys.firstWhere(
                (k) => ColorUtils.colorsInfo[k].value == color.value,
                orElse: () => null);
            functionColor.call(color, key);
            Navigator.pop(context);
          },
          selectedColor: selectedColor,
          colors: colors,
        ),
      ),
    );
  }

  static void openDialog(context, String title, Widget content) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          title: Text(title),
          content: content,
          actions: [
            FlatButton(
              child: Text('CANCEL'),
              onPressed: Navigator.of(context).pop,
            ),
          ],
        );
      },
    );
  }
}
