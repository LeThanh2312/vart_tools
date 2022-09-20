import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:vart_tools/res/app_color.dart';

class PopupNewFolder extends StatelessWidget {
  const PopupNewFolder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
          child: Column(
        children: [
          Text("Tạo thư mục mới"),
          Divider(
            height: 15,
            thickness: 1,
            color: AppColors.grayColor,
          ),
        ],
      )),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Thư mục mới',
              isDense: true,
              contentPadding: EdgeInsets.all(15),
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Hủy'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.grayColor,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Đồng ý'),
              ),
            ],
          ),
        )
      ],
    );
  }
}
