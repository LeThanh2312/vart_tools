import 'package:flutter/material.dart';

class DragBottomConvertTextWidget extends StatefulWidget {
  const DragBottomConvertTextWidget({Key? key, required this.listString})
      : super(key: key);
  final List<String>? listString;

  @override
  State<DragBottomConvertTextWidget> createState() =>
      _DragBottomConvertTextWidgetState();
}

class _DragBottomConvertTextWidgetState
    extends State<DragBottomConvertTextWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('===== show text =====');
    return DraggableScrollableSheet(
      initialChildSize: 0.30,
      minChildSize: 0.15,
      maxChildSize: 0.85,
      builder: (BuildContext context, ScrollController scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Card(
            elevation: 12.0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            margin: const EdgeInsets.all(0),
            child: Stack(
              children: [
                // SizedBox(
                //         height: MediaQuery.of(context).size.height * 0.79,
                //         child: SingleChildScrollView(
                //           child: widget.listString != null
                //               ? ListView.builder(
                //                   shrinkWrap: true,
                //                   physics: const BouncingScrollPhysics(),
                //                   itemCount: widget.listString!.length,
                //                   itemBuilder: (context, index) =>
                //                       Text(widget.listString![index]),
                //                 )
                //               : Container(),
                //         ),
                //       ),
                Container(
                  margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
                  child: widget.listString != null
                      ? SingleChildScrollView(
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemCount: widget.listString!.length,
                              itemBuilder: (context, index) {
                                TextEditingController textController =
                                    TextEditingController();
                                textController.text = widget.listString![index];
                                return TextField(
                                  autofocus: false,
                                  keyboardType: TextInputType.multiline,
                                  style: const TextStyle(
                                    decoration: TextDecoration.none,
                                  ),
                                  controller: textController,
                                );
                              }),
                        )
                      : Container(
                          height: MediaQuery.of(context).size.height * 0.79,
                          margin: const EdgeInsets.only(
                              top: 20, left: 10, right: 10),
                          child: const Center(
                            child: Text(
                              'Không nhận dạng được văn bản',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                      color: Colors.grey,
                    ),
                    child: Center(
                      child: CustomDraggingHeader(),
                    ),
                  ),
                ),
              ],
            ),
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
