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
    print('===== show text ===== ${widget.listString}');
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
                          const EdgeInsets.only(top: 0, left: 10, right: 10),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 50,
                            ),
                            ...List.generate(
                                widget.listString!.length,
                                (index) => Container(
                                    height: 50,
                                    child: Text(widget.listString![index])))
                            // ListView.builder(
                            //     shrinkWrap: true,
                            //     physics: const BouncingScrollPhysics(),
                            //     itemCount: widget.listString!.length,
                            //     itemBuilder: (context, index) {
                            //       TextEditingController textController =
                            //           TextEditingController();
                            //       textController.text =
                            //           widget.listString![index];
                            //       return TextField(
                            //         autofocus: false,
                            //         keyboardType: TextInputType.multiline,
                            //         style: const TextStyle(
                            //           decoration: TextDecoration.none,
                            //         ),
                            //         controller: textController,
                            //       );
                            //     }),
                          ],
                        ),
                      ),
                    )
                  : Container(
                      height: MediaQuery.of(context).size.height * 0.9,
                      width: MediaQuery.of(context).size.width,
                      margin:
                          const EdgeInsets.only(top: 20, left: 10, right: 10),
                      child: const Center(
                        child: Text(
                          'Không nhận dạng được văn bản',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
              IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    color: Colors.grey[200],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 10),
                        height: 10,
                        width: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey),
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
