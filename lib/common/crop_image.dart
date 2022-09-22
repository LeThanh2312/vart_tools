import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as image;

const dotTotalSize = 32.0; // fixed corner dot size.

enum EdgeAlignment {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}

typedef CornerDotBuilder = Widget Function(
    double size, EdgeAlignment edgeAlignment);

typedef CroppingAreaBuilder = Rect Function(Rect imageRect);

enum CropStatus { nothing, loading, ready, cropping }

/// Widget for the entry point of crop_your_image.
class Crop extends StatelessWidget {
  /// original image data
  final Uint8List image;

  /// callback when cropping completed
  final ValueChanged<Uint8List> onCropped;

  /// fixed aspect ratio of cropping area.
  /// null, by default, means no fixed aspect ratio.
  final double? aspectRatio;

  /// initial size of cropping area.
  /// Set double value less than 1.0.
  /// if initialSize is 1.0 (or null),
  /// cropping area would expand as much as possible.
  final double? initialSize;

  /// Builder for initial [Rect] of cropping area based on viewport.
  /// Builder is called when calculating initial cropping area passing
  /// [Rect] of [Crop] viewport.
  final CroppingAreaBuilder? initialAreaBuilder;

  /// Initial [Rect] of cropping area.
  /// This [Rect] must be based on the rect of [image] data, not screen.
  ///
  /// e.g. If the original image size is 1280x1024,
  /// giving [Rect.fromLTWH(240, 212, 800, 600)] as [initialArea] would
  /// result in covering exact center of the image with 800x600 image size.
  ///
  /// If [initialArea] is given, [initialSize] is ignored.
  /// In other hand, [aspectRatio] is still enabled although initial shape of
  /// cropping area depends on [initialArea]. Once user moves cropping area
  /// with their hand, the shape of cropping area is calculated depending on [aspectRatio].
  final Rect? initialArea;

  /// flag if cropping image with circle shape.
  /// if [true], [aspectRatio] is fixed to 1.
  final bool withCircleUi;

  /// conroller for control crop actions
  final CropController? controller;

  /// Callback called when cropping area moved.
  final ValueChanged<Rect>? onMoved;

  /// Callback called when status of Crop widget is changed.
  ///
  /// note: Currently, the very first callback is [CropStatus.ready]
  /// which is called after loading [image] data for the first time.
  final ValueChanged<CropStatus>? onStatusChanged;

  /// [Color] of the mask widget which is placed over the cropping editor.
  final Color? maskColor;

  /// [Color] of the base color of the cropping editor.
  final Color baseColor;

  /// Corner radius of cropping area
  final double radius;

  /// builder for corner dot widget.
  /// [CornerDotBuilder] passes [size] which indicates the size of each dots
  /// and [EdgeAlignment] which indicates the position of each dots.
  /// If default dot Widget with different color is needed, [DotControl] is available.
  final CornerDotBuilder? cornerDotBuilder;

  /// If [true], cropping area is fixed and CANNOT be moved.
  /// [false] by default.
  final bool fixArea;

  /// * Experimental Feature *
  /// If [true], users can move and zoom image.
  /// [false] by default.
  final bool interactive;

  final int rotationTurns;

  const Crop({
    Key? key,
    required this.image,
    required this.onCropped,
    this.aspectRatio,
    this.initialSize,
    this.initialAreaBuilder,
    this.initialArea,
    this.withCircleUi = false,
    this.controller,
    this.onMoved,
    this.onStatusChanged,
    this.maskColor,
    this.baseColor = Colors.white,
    this.radius = 0,
    this.cornerDotBuilder,
    this.fixArea = false,
    this.interactive = false,
    required this.rotationTurns,
  })  : assert((initialSize ?? 1.0) <= 1.0,
            'initialSize must be less than 1.0, or null meaning not specified.'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (c, constraints) {
        final newData = MediaQuery.of(c).copyWith(
          size: constraints.biggest,
        );
        return MediaQuery(
          data: newData,
          child: _CropEditor(
            image: image,
            onCropped: onCropped,
            aspectRatio: aspectRatio,
            initialSize: initialSize,
            initialAreaBuilder: initialAreaBuilder,
            initialArea: initialArea,
            withCircleUi: withCircleUi,
            controller: controller,
            onMoved: onMoved,
            onStatusChanged: onStatusChanged,
            maskColor: maskColor,
            baseColor: baseColor,
            radius: radius,
            cornerDotBuilder: cornerDotBuilder,
            fixArea: fixArea,
            interactive: interactive,
            rotationTurns: rotationTurns,
          ),
        );
      },
    );
  }
}

class _CropEditor extends StatefulWidget {
  final Uint8List image;
  final ValueChanged<Uint8List> onCropped;
  final double? aspectRatio;
  final double? initialSize;
  final CroppingAreaBuilder? initialAreaBuilder;
  final Rect? initialArea;
  final bool withCircleUi;
  final CropController? controller;
  final ValueChanged<Rect>? onMoved;
  final ValueChanged<CropStatus>? onStatusChanged;
  final Color? maskColor;
  final Color baseColor;
  final double radius;
  final CornerDotBuilder? cornerDotBuilder;
  final bool fixArea;
  final bool interactive;
  final int rotationTurns;

  const _CropEditor({
    Key? key,
    required this.image,
    required this.onCropped,
    this.aspectRatio,
    this.initialSize,
    this.initialAreaBuilder,
    this.initialArea,
    this.withCircleUi = false,
    this.controller,
    this.onMoved,
    this.onStatusChanged,
    this.maskColor,
    required this.baseColor,
    required this.radius,
    this.cornerDotBuilder,
    required this.fixArea,
    required this.interactive,
    required this.rotationTurns,
  }) : super(key: key);

  @override
  _CropEditorState createState() => _CropEditorState();
}

class _CropEditorState extends State<_CropEditor> {
  late CropController _cropController;
  late Rect _rect;
  image.Image? _targetImage;
  late Rect _imageRect;

  double? _aspectRatio;
  bool _isFitVertically = false;
  Future<image.Image?>? _lastComputed;

  bool get _isImageLoading => _lastComputed != null;

  _Calculator get calculator => _isFitVertically
      ? const _VerticalCalculator()
      : const _HorizontalCalculator();

  set rect(Rect newRect) {
    setState(() {
      _rect = newRect;
    });
    widget.onMoved?.call(_rect);
  }

  // for zooming
  int _pointerNum = 0;
  double _scale = 1.0;
  double _baseScale = 1.0;

  void _startScale(ScaleStartDetails detail) {
    _baseScale = _scale;
  }

  void _updateScale(ScaleUpdateDetails detail) {
    // move
    var movedLeft = _imageRect.left + detail.focalPointDelta.dx;
    if (movedLeft + _imageRect.width < _rect.right) {
      movedLeft = _rect.right - _imageRect.width;
    }

    var movedTop = _imageRect.top + detail.focalPointDelta.dy;
    if (movedTop + _imageRect.height < _rect.bottom) {
      movedTop = _rect.bottom - _imageRect.height;
    }
    setState(() {
      _imageRect = Rect.fromLTWH(
        min(_rect.left, movedLeft),
        min(_rect.top, movedTop),
        _imageRect.width,
        _imageRect.height,
      );
    });

    // scale
    if (_pointerNum >= 2) {
      _applyScale(
        _baseScale * detail.scale,
        focalPoint: detail.localFocalPoint,
      );
    }
  }

  void _applyScale(
    double nextScale, {
    Offset? focalPoint,
  }) {
    late double baseHeight;
    late double baseWidth;
    final ratio = _targetImage!.height / _targetImage!.width;

    if (_isFitVertically) {
      baseHeight = MediaQuery.of(context).size.height;
      baseWidth = baseHeight / ratio;
    } else {
      baseWidth = MediaQuery.of(context).size.width;
      baseHeight = baseWidth * ratio;
    }

    // width
    final newWidth = baseWidth * nextScale;
    final horizontalFocalPointBias = focalPoint == null
        ? 0.5
        : (focalPoint.dx - _imageRect.left) / _imageRect.width;
    final leftPositionDelta =
        (newWidth - _imageRect.width) * horizontalFocalPointBias;

    // height
    final newHeight = baseHeight * nextScale;
    final verticalFocalPointBias = focalPoint == null
        ? 0.5
        : (focalPoint.dy - _imageRect.top) / _imageRect.height;
    final topPositionDelta =
        (newHeight - _imageRect.height) * verticalFocalPointBias;

    // position
    final newLeft = max(min(_rect.left, _imageRect.left - leftPositionDelta),
        _rect.right - newWidth);
    final newTop = max(min(_rect.top, _imageRect.top - topPositionDelta),
        _rect.bottom - newHeight);

    if (newWidth < _rect.width || newHeight < _rect.height) {
      return;
    }
    // apply
    setState(() {
      _imageRect = Rect.fromLTRB(
        newLeft,
        newTop,
        newLeft + newWidth,
        newTop + newHeight,
      );
      _scale = nextScale;
    });
  }

  @override
  void initState() {
    _cropController = widget.controller ?? CropController();
    _cropController.delegate = CropControllerDelegate()
      ..onCrop = _crop
      ..onChangeAspectRatio = (aspectRatio) {
        _resizeWith(aspectRatio, null);
      }
      ..onChangeWithCircleUi = (withCircleUi) {
        _resizeWith(null, null);
      }
      ..onImageChanged = _resetImage
      ..onChangeRect = (newRect) {
        rect = calculator.correct(newRect, _imageRect);
      }
      ..onChangeArea = (newArea) {
        _resizeWith(_aspectRatio, newArea);
      };

    super.initState();
  }

  @override
  void didChangeDependencies() {
    final future = compute(_fromByteData, widget.image);
    _lastComputed = future;
    future.then((converted) {
      if (_lastComputed == future) {
        _targetImage = converted;
        _resetCroppingArea();

        setState(() {
          _lastComputed = null;
        });
        widget.onStatusChanged?.call(CropStatus.ready);
      }
    });
    super.didChangeDependencies();
  }

  /// reset image to be cropped
  void _resetImage(Uint8List targetImage) {
    widget.onStatusChanged?.call(CropStatus.loading);
    final future = compute(_fromByteData, targetImage);
    _lastComputed = future;
    future.then((converted) {
      if (_lastComputed == future) {
        setState(() {
          _targetImage = converted;
          _lastComputed = null;
        });
        _resetCroppingArea();
        widget.onStatusChanged?.call(CropStatus.ready);
      }
    });
  }

  /// reset [Rect] of cropping area with current state
  void _resetCroppingArea() {
    final screenSize = MediaQuery.of(context).size;

    final imageRatio = _targetImage!.width / _targetImage!.height;
    _isFitVertically = imageRatio < screenSize.aspectRatio;

    _imageRect = calculator.imageRect(screenSize, imageRatio);

    if (widget.initialAreaBuilder != null) {
      rect = widget.initialAreaBuilder!(Rect.fromLTWH(
        0,
        0,
        screenSize.width,
        screenSize.height,
      ));
    } else {
      _resizeWith(widget.aspectRatio, widget.initialArea);
    }

    if (widget.interactive) {
      final initialScale = calculator.scaleToCover(screenSize, _imageRect);
      _applyScale(initialScale);
    }
  }

  /// resize cropping area with given aspect ratio.
  void _resizeWith(double? aspectRatio, Rect? initialArea) {
    if (initialArea == null) {
      rect = calculator.initialCropRect(
        MediaQuery.of(context).size,
        _imageRect,
        _aspectRatio ?? 1,
        widget.initialSize ?? 1,
      );
    } else {
      final screenSizeRatio = calculator.screenSizeRatio(
        _targetImage!,
        MediaQuery.of(context).size,
      );
      rect = Rect.fromLTWH(
        _imageRect.left + initialArea.left / screenSizeRatio,
        _imageRect.top + initialArea.top / screenSizeRatio,
        initialArea.width / screenSizeRatio,
        initialArea.height / screenSizeRatio,
      );
    }
  }

  /// crop given image with given area.
  Future<void> _crop(bool withCircleShape) async {
    assert(_targetImage != null);

    final screenSizeRatio = calculator.screenSizeRatio(
      _targetImage!,
      MediaQuery.of(context).size,
    );

    widget.onStatusChanged?.call(CropStatus.cropping);

    // use compute() not to block UI update
    final cropResult = await compute(
      withCircleShape ? _doCropCircle : _doCrop,
      [
        _targetImage!,
        Rect.fromLTWH(
          (_rect.left - _imageRect.left) * screenSizeRatio / _scale,
          (_rect.top - _imageRect.top) * screenSizeRatio / _scale,
          _rect.width * screenSizeRatio / _scale,
          _rect.height * screenSizeRatio / _scale,
        ),
      ],
    );
    widget.onCropped(cropResult);

    widget.onStatusChanged?.call(CropStatus.ready);
  }

  @override
  Widget build(BuildContext context) {
    return _isImageLoading
        ? const Center(child: CircularProgressIndicator())
        : Stack(
            children: [
              Listener(
                onPointerDown: (_) => _pointerNum++,
                onPointerUp: (_) => _pointerNum--,
                child: GestureDetector(
                  onScaleStart: widget.interactive ? _startScale : null,
                  onScaleUpdate: widget.interactive ? _updateScale : null,
                  child: Container(
                    color: widget.baseColor,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Stack(
                      children: [
                        Positioned(
                          left: _imageRect.left,
                          top: _imageRect.top,
                          child: Center(
                            child: RotatedBox(
                              quarterTurns: widget.rotationTurns,
                              child: Image.memory(
                                widget.image,
                                width: _isFitVertically
                                    ? null
                                    : MediaQuery.of(context).size.width * _scale,
                                height: _isFitVertically
                                    ? MediaQuery.of(context).size.height * _scale
                                    : null,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              IgnorePointer(
                child: ClipPath(
                  clipper: _CropAreaClipper(_rect, widget.radius),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: widget.maskColor ?? Colors.black.withAlpha(100),
                  ),
                ),
              ),
              if (!widget.interactive && !widget.fixArea)
                Positioned(
                  left: _rect.left,
                  top: _rect.top,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      rect = calculator.moveRect(
                        _rect,
                        details.delta.dx,
                        details.delta.dy,
                        _imageRect,
                      );
                    },
                    child: Container(
                      width: _rect.width,
                      height: _rect.height,
                      color: Colors.transparent,
                    ),
                  ),
                ),
              Positioned(
                left: _rect.left - (dotTotalSize / 2),
                top: _rect.top - (dotTotalSize / 2),
                child: GestureDetector(
                  onPanUpdate: widget.fixArea
                      ? null
                      : (details) {
                          rect = calculator.moveTopLeft(
                            _rect,
                            details.delta.dx,
                            details.delta.dy,
                            _imageRect,
                            _aspectRatio,
                          );
                        },
                  child: widget.cornerDotBuilder
                          ?.call(dotTotalSize, EdgeAlignment.topLeft) ??
                      const DotControl(),
                ),
              ),
              Positioned(
                left: _rect.right - (dotTotalSize / 2),
                top: _rect.top - (dotTotalSize / 2),
                child: GestureDetector(
                  onPanUpdate: widget.fixArea
                      ? null
                      : (details) {
                          rect = calculator.moveTopRight(
                            _rect,
                            details.delta.dx,
                            details.delta.dy,
                            _imageRect,
                            _aspectRatio,
                          );
                        },
                  child: widget.cornerDotBuilder
                          ?.call(dotTotalSize, EdgeAlignment.topRight) ??
                      const DotControl(),
                ),
              ),
              Positioned(
                left: _rect.left - (dotTotalSize / 2),
                top: _rect.bottom - (dotTotalSize / 2),
                child: GestureDetector(
                  onPanUpdate: widget.fixArea
                      ? null
                      : (details) {
                          rect = calculator.moveBottomLeft(
                            _rect,
                            details.delta.dx,
                            details.delta.dy,
                            _imageRect,
                            _aspectRatio,
                          );
                        },
                  child: widget.cornerDotBuilder
                          ?.call(dotTotalSize, EdgeAlignment.bottomLeft) ??
                      const DotControl(),
                ),
              ),
              Positioned(
                left: _rect.right - (dotTotalSize / 2),
                top: _rect.bottom - (dotTotalSize / 2),
                child: GestureDetector(
                  onPanUpdate: widget.fixArea
                      ? null
                      : (details) {
                          rect = calculator.moveBottomRight(
                            _rect,
                            details.delta.dx,
                            details.delta.dy,
                            _imageRect,
                            _aspectRatio,
                          );
                        },
                  child: widget.cornerDotBuilder
                          ?.call(dotTotalSize, EdgeAlignment.bottomRight) ??
                      const DotControl(),
                ),
              ),
            ],
          );
  }
}

class _CropAreaClipper extends CustomClipper<Path> {
  _CropAreaClipper(this.rect, this.radius);

  final Rect rect;
  final double radius;

  @override
  Path getClip(Size size) {
    return Path()
      ..addPath(
        Path()
          ..moveTo(rect.left, rect.top + radius)
          ..arcToPoint(Offset(rect.left + radius, rect.top),
              radius: Radius.circular(radius))
          ..lineTo(rect.right - radius, rect.top)
          ..arcToPoint(Offset(rect.right, rect.top + radius),
              radius: Radius.circular(radius))
          ..lineTo(rect.right, rect.bottom - radius)
          ..arcToPoint(Offset(rect.right - radius, rect.bottom),
              radius: Radius.circular(radius))
          ..lineTo(rect.left + radius, rect.bottom)
          ..arcToPoint(Offset(rect.left, rect.bottom - radius),
              radius: Radius.circular(radius))
          ..close(),
        Offset.zero,
      )
      ..addRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height))
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class DotControl extends StatelessWidget {
  const DotControl({
    Key? key,
    this.color = Colors.white,
    this.padding = 8,
  }) : super(key: key);

  /// [Color] of this widget. [Colors.white] by default.
  final Color color;

  /// The size of transparent padding which exists to make dot easier to touch.
  /// Though total size of this widget cannot be changed,
  /// but visible size can be changed by setting this value.
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: dotTotalSize,
      height: dotTotalSize,
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(dotTotalSize),
          child: Container(
            width: dotTotalSize - (padding * 2),
            height: dotTotalSize - (padding * 2),
            color: color,
          ),
        ),
      ),
    );
  }
}

/// process cropping image.
/// this method is supposed to be called only via compute()
Uint8List _doCrop(List<dynamic> cropData) {
  final originalImage = cropData[0] as image.Image;
  final rect = cropData[1] as Rect;
  return Uint8List.fromList(
    image.encodePng(
      image.copyCrop(
        originalImage,
        rect.left.toInt(),
        rect.top.toInt(),
        rect.width.toInt(),
        rect.height.toInt(),
      ),
    ),
  );
}

/// process cropping image with circle shape.
/// this method is supposed to be called only via compute()
Uint8List _doCropCircle(List<dynamic> cropData) {
  final originalImage = cropData[0] as image.Image;
  final rect = cropData[1] as Rect;
  return Uint8List.fromList(
    image.encodePng(
      image.copyCropCircle(
        originalImage,
        center:
            image.Point(rect.left + rect.width / 2, rect.top + rect.height / 2),
        radius: min(rect.width, rect.height) ~/ 2,
      ),
    ),
  );
}

// decode orientation awared Image.
image.Image _fromByteData(Uint8List data) {
  final tempImage = image.decodeImage(data);
  assert(tempImage != null);

  // check orientation
  switch (tempImage?.exif.data[0x0112] ?? -1) {
    case 3:
      return image.copyRotate(tempImage!, 180);
    case 6:
      return image.copyRotate(tempImage!, 90);
    case 8:
      return image.copyRotate(tempImage!, -90);
  }
  return tempImage!;
}

class CropController {
  late CropControllerDelegate _delegate;

  /// setter for [CropControllerDelegate]
  set delegate(CropControllerDelegate value) => _delegate = value;

  /// crop given image with current configuration
  void crop() => _delegate.onCrop(false);

  /// crop given image with current configuration and circle shape.
  void cropCircle() => _delegate.onCrop(true);

  /// Change image to be cropped.
  /// When image is changed, [Rect] of cropping area will be reset.
  set image(Uint8List value) => _delegate.onImageChanged(value);

  /// change fixed aspect ratio
  /// if [value] is null, cropping area can be moved without fixed aspect ratio.
  set aspectRatio(double? value) => _delegate.onChangeAspectRatio(value);

  /// change if cropping with circle shaped UI.
  /// if [value] is true, [aspectRatio] automatically fixed with 1
  set withCircleUi(bool value) => _delegate.onChangeWithCircleUi(value);

  /// change [Rect] of cropping area.
  /// the value is corrected if it indicates outside of the image.
  set rect(Rect value) => _delegate.onChangeRect(value);

  /// change [Rect] of cropping area based on [Rect] of original imgage.
  set area(Rect value) => _delegate.onChangeArea(value);
}

/// Delegate of actions from [CropController]
class CropControllerDelegate {
  /// callback that [CropController.crop] is called.
  /// the meaning of the value is if cropping a image with circle shape.
  late ValueChanged<bool> onCrop;

  /// callback that [CropController.image] is set.
  late ValueChanged<Uint8List> onImageChanged;

  /// callback that [CropController.aspectRatio] is set.
  late ValueChanged<double?> onChangeAspectRatio;

  /// callback that [CropController.withCircleUi] is changed.
  late ValueChanged<bool> onChangeWithCircleUi;

  /// callback that [CropController.rect] is changed.
  late ValueChanged<Rect> onChangeRect;

  /// callback that [CropController.area] is changed.
  late ValueChanged<Rect> onChangeArea;
}

abstract class _Calculator {
  const _Calculator();

  /// calculates [Rect] of image to fit the screenSize.
  Rect imageRect(Size screenSize, double imageRatio);

  /// calculates [Rect] of initial cropping area.
  Rect initialCropRect(
      Size screenSize, Rect imageRect, double aspectRatio, double sizeRatio);

  /// calculates initial scale of image to cover _CropEditor
  double scaleToCover(Size screenSize, Rect imageRect);

  /// calculates ratio of [targetImage] and [screenSize]
  double screenSizeRatio(image.Image targetImage, Size screenSize);

  /// calculates [Rect] of the result of user moving the cropping area.
  Rect moveRect(Rect original, double deltaX, double deltaY, Rect imageRect) {
    if (original.left + deltaX < imageRect.left) {
      deltaX = (original.left - imageRect.left) * -1;
    }
    if (original.right + deltaX > imageRect.right) {
      deltaX = imageRect.right - original.right;
    }
    if (original.top + deltaY < imageRect.top) {
      deltaY = (original.top - imageRect.top) * -1;
    }
    if (original.bottom + deltaY > imageRect.bottom) {
      deltaY = imageRect.bottom - original.bottom;
    }
    return Rect.fromLTWH(
      original.left + deltaX,
      original.top + deltaY,
      original.width,
      original.height,
    );
  }

  /// calculates [Rect] of the result of user moving the top-left dot.
  Rect moveTopLeft(Rect original, double deltaX, double deltaY, Rect imageRect,
      double? aspectRatio) {
    final newLeft =
        max(imageRect.left, min(original.left + deltaX, original.right - 40));
    final newTop =
        min(max(original.top + deltaY, imageRect.top), original.bottom - 40);
    if (aspectRatio == null) {
      return Rect.fromLTRB(
        newLeft,
        newTop,
        original.right,
        original.bottom,
      );
    } else {
      if (deltaX.abs() > deltaY.abs()) {
        var newWidth = original.right - newLeft;
        var newHeight = newWidth / aspectRatio;
        if (original.bottom - newHeight < imageRect.top) {
          newHeight = original.bottom - imageRect.top;
          newWidth = newHeight * aspectRatio;
        }

        return Rect.fromLTRB(
          original.right - newWidth,
          original.bottom - newHeight,
          original.right,
          original.bottom,
        );
      } else {
        var newHeight = original.bottom - newTop;
        var newWidth = newHeight * aspectRatio;
        if (original.right - newWidth < imageRect.left) {
          newWidth = original.right - imageRect.left;
          newHeight = newWidth / aspectRatio;
        }
        return Rect.fromLTRB(
          original.right - newWidth,
          original.bottom - newHeight,
          original.right,
          original.bottom,
        );
      }
    }
  }

  /// calculates [Rect] of the result of user moving the top-right dot.
  Rect moveTopRight(Rect original, double deltaX, double deltaY, Rect imageRect,
      double? aspectRatio) {
    final newTop =
        min(max(original.top + deltaY, imageRect.top), original.bottom - 40);
    final newRight =
        max(min(original.right + deltaX, imageRect.right), original.left + 40);
    if (aspectRatio == null) {
      return Rect.fromLTRB(
        original.left,
        newTop,
        newRight,
        original.bottom,
      );
    } else {
      if (deltaX.abs() > deltaY.abs()) {
        var newWidth = newRight - original.left;
        var newHeight = newWidth / aspectRatio;
        if (original.bottom - newHeight < imageRect.top) {
          newHeight = original.bottom - imageRect.top;
          newWidth = newHeight * aspectRatio;
        }

        return Rect.fromLTWH(
          original.left,
          original.bottom - newHeight,
          newWidth,
          newHeight,
        );
      } else {
        var newHeight = original.bottom - newTop;
        var newWidth = newHeight * aspectRatio;
        if (original.left + newWidth > imageRect.right) {
          newWidth = imageRect.right - original.left;
          newHeight = newWidth / aspectRatio;
        }
        return Rect.fromLTRB(
          original.left,
          original.bottom - newHeight,
          original.left + newWidth,
          original.bottom,
        );
      }
    }
  }

  /// calculates [Rect] of the result of user moving the bottom-left dot.
  Rect moveBottomLeft(Rect original, double deltaX, double deltaY,
      Rect imageRect, double? aspectRatio) {
    final newLeft =
        max(imageRect.left, min(original.left + deltaX, original.right - 40));
    final newBottom =
        max(min(original.bottom + deltaY, imageRect.bottom), original.top + 40);

    if (aspectRatio == null) {
      return Rect.fromLTRB(
        newLeft,
        original.top,
        original.right,
        newBottom,
      );
    } else {
      if (deltaX.abs() > deltaY.abs()) {
        var newWidth = original.right - newLeft;
        var newHeight = newWidth / aspectRatio;
        if (original.top + newHeight > imageRect.bottom) {
          newHeight = imageRect.bottom - original.top;
          newWidth = newHeight * aspectRatio;
        }

        return Rect.fromLTRB(
          original.right - newWidth,
          original.top,
          original.right,
          original.top + newHeight,
        );
      } else {
        var newHeight = newBottom - original.top;
        var newWidth = newHeight * aspectRatio;
        if (original.right - newWidth < imageRect.left) {
          newWidth = original.right - imageRect.left;
          newHeight = newWidth / aspectRatio;
        }
        return Rect.fromLTRB(
          original.right - newWidth,
          original.top,
          original.right,
          original.top + newHeight,
        );
      }
    }
  }

  /// calculates [Rect] of the result of user moving the bottom-right dot.
  Rect moveBottomRight(Rect original, double deltaX, double deltaY,
      Rect imageRect, double? aspectRatio) {
    final newRight =
        min(imageRect.right, max(original.right + deltaX, original.left + 40));
    final newBottom =
        max(min(original.bottom + deltaY, imageRect.bottom), original.top + 40);
    if (aspectRatio == null) {
      return Rect.fromLTRB(
        original.left,
        original.top,
        newRight,
        newBottom,
      );
    } else {
      if (deltaX.abs() > deltaY.abs()) {
        var newWidth = newRight - original.left;
        var newHeight = newWidth / aspectRatio;
        if (original.top + newHeight > imageRect.bottom) {
          newHeight = imageRect.bottom - original.top;
          newWidth = newHeight * aspectRatio;
        }

        return Rect.fromLTWH(
          original.left,
          original.top,
          newWidth,
          newHeight,
        );
      } else {
        var newHeight = newBottom - original.top;
        var newWidth = newHeight * aspectRatio;
        if (original.left + newWidth > imageRect.right) {
          newWidth = imageRect.right - original.left;
          newHeight = newWidth / aspectRatio;
        }
        return Rect.fromLTWH(
          original.left,
          original.top,
          newWidth,
          newHeight,
        );
      }
    }
  }

  /// correct [Rect] not to exceed [Rect] of image.
  Rect correct(Rect rect, Rect imageRect) {
    return Rect.fromLTRB(
      max(rect.left, imageRect.left),
      max(rect.top, imageRect.top),
      min(rect.right, imageRect.right),
      min(rect.bottom, imageRect.bottom),
    );
  }
}

class _HorizontalCalculator extends _Calculator {
  const _HorizontalCalculator();

  @override
  Rect imageRect(Size screenSize, double imageRatio) {
    final imageScreenHeight = screenSize.width / imageRatio;
    final top = (screenSize.height - imageScreenHeight) / 2;
    final bottom = top + imageScreenHeight;
    return Rect.fromLTWH(0, top, screenSize.width, bottom - top);
  }

  @override
  Rect initialCropRect(
      Size screenSize, Rect imageRect, double aspectRatio, double sizeRatio) {
    final imageRatio = imageRect.width / imageRect.height;
    final imageScreenHeight = screenSize.width / imageRatio;

    final initialSize = imageRatio > aspectRatio
        ? Size((imageScreenHeight * aspectRatio) * sizeRatio,
            imageScreenHeight * sizeRatio)
        : Size(screenSize.width * sizeRatio,
            (screenSize.width / aspectRatio) * sizeRatio);

    return Rect.fromLTWH(
      (screenSize.width - initialSize.width) / 2,
      (screenSize.height - initialSize.height) / 2,
      initialSize.width,
      initialSize.height,
    );
  }

  @override
  double scaleToCover(Size screenSize, Rect imageRect) {
    return screenSize.height / imageRect.height;
  }

  @override
  double screenSizeRatio(image.Image targetImage, Size screenSize) {
    return targetImage.width / screenSize.width;
  }
}

class _VerticalCalculator extends _Calculator {
  const _VerticalCalculator();

  @override
  Rect imageRect(Size screenSize, double imageRatio) {
    final imageScreenWidth = screenSize.height * imageRatio;
    final left = (screenSize.width - imageScreenWidth) / 2;
    final right = left + imageScreenWidth;
    return Rect.fromLTWH(left, 0, right - left, screenSize.height);
  }

  @override
  Rect initialCropRect(
      Size screenSize, Rect imageRect, double aspectRatio, double sizeRatio) {
    final imageRatio = imageRect.width / imageRect.height;
    final imageScreenWidth = screenSize.height * imageRatio;

    final initialSize = imageRatio < aspectRatio
        ? Size(imageScreenWidth * sizeRatio,
            imageScreenWidth / aspectRatio * sizeRatio)
        : Size((screenSize.height * aspectRatio) * sizeRatio,
            screenSize.height * sizeRatio);

    return Rect.fromLTWH(
      (screenSize.width - initialSize.width) / 2,
      (screenSize.height - initialSize.height) / 2,
      initialSize.width,
      initialSize.height,
    );
  }

  @override
  double scaleToCover(Size screenSize, Rect imageRect) {
    return screenSize.width / imageRect.width;
  }

  @override
  double screenSizeRatio(image.Image targetImage, Size screenSize) {
    return targetImage.height / screenSize.height;
  }
}
