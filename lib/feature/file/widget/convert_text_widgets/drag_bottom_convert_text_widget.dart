import 'package:flutter/material.dart';

class DragBottomConvertTextWidget extends StatefulWidget {
  const DragBottomConvertTextWidget({
    Key? key,
    required this.listString,
    required this.isSelectAll,
    required this.onChangeSelectAll,
  }) : super(key: key);
  final List<String>? listString;
  final bool isSelectAll;
  final void Function(bool value) onChangeSelectAll;

  @override
  State<DragBottomConvertTextWidget> createState() =>
      _DragBottomConvertTextWidgetState();
}

class _DragBottomConvertTextWidgetState
    extends State<DragBottomConvertTextWidget> {
  List<TextEditingController> controller = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.listString != null) {
      for (var item in widget.listString!) {
        controller.add(TextEditingController());
      }
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
                                  controller[index].text =
                                      widget.listString![index];
                                  return SizedBox(
                                    height: 25,
                                    child: TextField(
                                      autofocus: false,
                                      controller: controller[index],
                                      keyboardType: TextInputType.multiline,
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
                                    ),
                                  );
                                }),
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
                          widget.onChangeSelectAll(!widget.isSelectAll);
                          setState(() {});
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
}
