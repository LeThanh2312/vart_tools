import 'package:flutter/material.dart';

class DragBottomConvertTextWidget extends StatefulWidget {
  const DragBottomConvertTextWidget({
    Key? key,
    required this.listString,
    required this.isSelectAll,
    required this.onChangeSelectAll,
    required this.controller,
    required this.controllerEdit,
  }) : super(key: key);
  final List<String>? listString;
  final bool isSelectAll;
  final void Function(bool value) onChangeSelectAll;
  final List<TextEditingController> controller;
  final List<TextEditingController> controllerEdit;


  @override
  State<DragBottomConvertTextWidget> createState() =>
      _DragBottomConvertTextWidgetState();
}

class _DragBottomConvertTextWidgetState
    extends State<DragBottomConvertTextWidget> {
  late bool isCheckChangeText;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.listString != null && widget.controllerEdit.isEmpty) {
      for (var item in widget.listString!) {
        widget.controller.add(TextEditingController(text: item));
        widget.controllerEdit.add(TextEditingController(text: item));
      }
      isCheckChangeText = false;
    } else{

    }
    return DraggableScrollableSheet(
      initialChildSize: 0.30,
      minChildSize: 0.15,
      maxChildSize: 0.85,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            color: Colors.white,
          ),
          child: Stack(
            children: [
              (widget.listString != null && widget.listString!.isNotEmpty)
                  ? Container(
                      height: MediaQuery.of(context).size.height * 0.9,
                      width: MediaQuery.of(context).size.width,
                      padding:
                          const EdgeInsets.only(top: 30, left: 10, right: 10),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemCount: widget.listString!.length,
                              itemBuilder: (context, index) {
                                return TextField(
                                  autofocus: false,
                                  controller: widget.controllerEdit[index],
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.black,
                                    decoration: TextDecoration.none,
                                  ),
                                  decoration: const InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                      //  when the TextFormField in focused
                                    ),
                                  ),
                                  onChanged: (text){
                                    isCheckChangeText = true;
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(
                      height: MediaQuery.of(context).size.height * 0.9,
                      width: MediaQuery.of(context).size.width,
                      margin:
                          const EdgeInsets.only(top: 20, left: 10, right: 10),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: const SizedBox(
                          height: 100,
                          child: Center(
                            child: Text(
                              'Không nhận dạng được văn bản',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ),
              IgnorePointer(
                ignoring: false,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    color: Colors.grey[200],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 60,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 10),
                        height: 10,
                        width: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey),
                      ),
                      InkWell(
                        onTap: () {
                          // widget.onChangeSelectAll(!widget.isSelectAll);
                          // setState(() {
                          //
                          // });
                          if(widget.isSelectAll && isCheckChangeText){
                            _showDialogSelectAll();
                          }else{
                            widget.onChangeSelectAll(!widget.isSelectAll);
                          }
                        },
                        child: Text(
                          'Chọn tất cả',
                          style: TextStyle(
                            color: widget.isSelectAll
                                ? Colors.green
                                : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget CustomDraggingHeader() {
    return Container(
      height: 5,
      width: 30,
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(16)),
    );
  }

  Future<void> _showDialogSelectAll() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Thực hiện thao tác sẽ xóa hết dữ liệu đã thay đổi?',
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text(
                'Hủy',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text(
                'Đồng ý',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                widget.onChangeSelectAll(!widget.isSelectAll);
                widget.controllerEdit.clear();
                setState(() {});
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}
