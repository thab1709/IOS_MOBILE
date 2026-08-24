// @dart=2.9

import 'dart:io';
import 'dart:ui' as ui;

import 'package:evnmobile/src/htdct/common/themes/colorx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_painter/flutter_painter.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:get/get.dart';

import 'add_text_controller.dart';


class FlutterPainterExample extends StatefulWidget {
  const FlutterPainterExample(this.file, {Key key}) : super(key: key);
  final File file;
  @override
  FlutterPainterExampleState createState() => FlutterPainterExampleState();
}

class FlutterPainterExampleState extends State<FlutterPainterExample> with AutomaticKeepAliveClientMixin<FlutterPainterExample> {
  static const Color red = Color(0xFFFF0000);
  FocusNode textFocusNode = FocusNode();
  PainterController controller;
  ui.Image backgroundImage;
  Paint shapePaint = Paint()
    ..strokeWidth = 5
    ..color = Colors.red
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  final addTextController = Get.put(AddTextController());

  @override
  void initState() {
    super.initState();
    controller = PainterController(
        settings: PainterSettings(
            text: TextSettings(
              focusNode: textFocusNode,
              textStyle: const TextStyle(
                  fontWeight: FontWeight.bold, color: red, fontSize: 18),
            ),
            freeStyle: const FreeStyleSettings(
              color: red,
              strokeWidth: 5,
            ),
            shape: ShapeSettings(
              paint: shapePaint,
            ),
            scale: const ScaleSettings(
              enabled: true,
              minScale: 1,
              maxScale: 5,
            )));
    // Listen to focus events of the text field
    textFocusNode.addListener(onFocus);
    // Initialize background
    initBackground();
  }

  /// Fetches image from an [ImageProvider] (in this example, [NetworkImage])
  /// to use it as a background
  Future initBackground() async {
    // Extension getter (.image) to get [ui.Image] from [ImageProvider]
    final image =  await FileImage(widget.file).image;

    setState(() {
      backgroundImage = image;
      controller.background = image.backgroundDrawable;
    });
  }

  /// Updates UI when the focus changes
  void onFocus() {
    setState(() {});
  }

  Widget buildDefault(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColorGray,
        body: Stack(
          children: [
            if (backgroundImage != null)
            // Enforces constraints
              Positioned.fill(
                child: Center(
                  child: AspectRatio(
                    aspectRatio:
                    backgroundImage.width / backgroundImage.height,
                    child: FlutterPainter(
                      controller: controller,
                    ),
                  ),
                ),
              ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: ValueListenableBuilder(
                valueListenable: controller,
                builder: (context, _, __) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Container(
                        constraints: const BoxConstraints(
                          maxWidth: 400,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: const BoxDecoration(
                          borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                          color: Colors.white54,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (controller.freeStyleMode !=
                                FreeStyleMode.none) ...[
                              const Divider(),
                              const Text('Cài dặt bút vẽ tự do'),
                              // Control free style stroke width
                              Row(
                                children: [
                                  const Expanded(
                                      flex: 1, child: Text('Cỡ nét')),
                                  Expanded(
                                    flex: 3,
                                    child: Slider.adaptive(
                                        min: 2,
                                        max: 25,
                                        value: controller.freeStyleStrokeWidth,
                                        onChanged: setFreeStyleStrokeWidth),
                                  ),
                                ],
                              ),
                              if (controller.freeStyleMode ==
                                  FreeStyleMode.draw)
                                Row(
                                  children: [
                                    const Expanded(
                                        flex: 1, child: Text('Màu')),
                                    // Control free style color hue
                                    Expanded(
                                      flex: 3,
                                      child: Slider.adaptive(
                                          min: 0,
                                          max: 359.99,
                                          value: HSVColor.fromColor(
                                              controller.freeStyleColor)
                                              .hue,
                                          activeColor:
                                          controller.freeStyleColor,
                                          onChanged: setFreeStyleColor),
                                    ),
                                  ],
                                ),
                            ],
                            if (textFocusNode.hasFocus) ...[
                              const Divider(),
                              const Text('Cài đặt chữ'),
                              // Control text font size
                              Row(
                                children: [
                                  const Expanded(
                                      flex: 1, child: Text('Cỡ chữ')),
                                  Expanded(
                                    flex: 3,
                                    child: Slider.adaptive(
                                        min: 8,
                                        max: 96,
                                        value:
                                        controller.textStyle.fontSize ?? 14,
                                        onChanged: setTextFontSize),
                                  ),
                                ],
                              ),

                              // Control text color hue
                              Row(
                                children: [
                                  const Expanded(flex: 1, child: Text('Màu')),
                                  Expanded(
                                    flex: 3,
                                    child: Slider.adaptive(
                                        min: 0,
                                        max: 359.99,
                                        value: HSVColor.fromColor(
                                            controller.textStyle.color ??
                                                red)
                                            .hue,
                                        activeColor: controller.textStyle.color,
                                        onChanged: setTextColor),
                                  ),
                                ],
                              ),
                            ],
                            if (controller.shapeFactory != null) ...[
                              const Divider(),
                              const Text('Cài đặt hình'),

                              // Control text color hue
                              Row(
                                children: [
                                  const Expanded(
                                      flex: 1, child: Text('Chiều rộng viền')),
                                  Expanded(
                                    flex: 3,
                                    child: Slider.adaptive(
                                        min: 2,
                                        max: 25,
                                        value: controller
                                            .shapePaint?.strokeWidth ??
                                            shapePaint.strokeWidth,
                                        onChanged: (value) =>
                                            setShapeFactoryPaint(
                                                (controller.shapePaint ??
                                                    shapePaint)
                                                    .copyWith(
                                                  strokeWidth: value,
                                                ))),
                                  ),
                                ],
                              ),

                              // Control shape color hue
                              Row(
                                children: [
                                  const Expanded(flex: 1, child: Text('Màu')),
                                  Expanded(
                                    flex: 3,
                                    child: Slider.adaptive(
                                        min: 0,
                                        max: 359.99,
                                        value: HSVColor.fromColor(
                                            (controller.shapePaint ??
                                                shapePaint)
                                                .color)
                                            .hue,
                                        activeColor: (controller.shapePaint ??
                                            shapePaint)
                                            .color,
                                        onChanged: (hue) =>
                                            setShapeFactoryPaint(
                                                (controller.shapePaint ??
                                                    shapePaint)
                                                    .copyWith(
                                                  color: HSVColor.fromAHSV(
                                                      1, hue, 1, 1)
                                                      .toColor(),
                                                ))),
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  const Expanded(
                                      flex: 1, child: Text('Điền hình')),
                                  Expanded(
                                    flex: 3,
                                    child: Center(
                                      child: Switch(
                                          value: (controller.shapePaint ??
                                              shapePaint)
                                              .style ==
                                              PaintingStyle.fill,
                                          onChanged: (value) =>
                                              setShapeFactoryPaint(
                                                  (controller.shapePaint ??
                                                      shapePaint)
                                                      .copyWith(
                                                    style: value
                                                        ? PaintingStyle.fill
                                                        : PaintingStyle.stroke,
                                                  ))),
                                    ),
                                  ),
                                ],
                              ),
                            ]
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: ValueListenableBuilder(
          valueListenable: controller,
          builder: (context, _, __) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Free-style eraser
              IconButton(
                icon: const Icon(
                  PhosphorIcons.arrow_clockwise,
                  color: Colors.black,
                ),
                onPressed: controller.canRedo ? redo : null,
              ),
              // Undo action
              IconButton(
                icon: const Icon(
                  PhosphorIcons.arrow_counter_clockwise,
                  color: Colors.black,
                ),
                onPressed: controller.canUndo ? undo : null,
              ),
              IconButton(
                icon: Icon(
                  PhosphorIcons.eraser,
                  color: controller.freeStyleMode == FreeStyleMode.erase
                      ? Colors.red
                      : Colors.black,
                ),
                onPressed: toggleFreeStyleErase,
              ),
              // Free-style drawing
              IconButton(
                icon: Icon(
                  PhosphorIcons.scribble_loop,
                  color: controller.freeStyleMode == FreeStyleMode.draw
                      ? Colors.red
                      : Colors.black,
                ),
                onPressed: toggleFreeStyleDraw,
              ),
              // Add text
              IconButton(
                icon: Icon(
                  PhosphorIcons.text_aa,
                  color: textFocusNode.hasFocus
                      ? Colors.red
                      : Colors.black,
                ),
                onPressed: addText,
              ),
              // Add sticker image

              // Add shapes
              if (controller.shapeFactory == null)
                PopupMenuButton<ShapeFactory>(
                  tooltip: 'Thêm hình',
                  itemBuilder: (context) => <ShapeFactory, String>{
                    LineFactory(): 'Đường thẳng',
                    ArrowFactory(): 'Mũi tên',
                    DoubleArrowFactory(): 'Mũi tên hai chiều',
                    RectangleFactory(): 'Tứ giác',
                    OvalFactory(): 'Hình Oval',
                  }
                      .entries
                      .map((e) => PopupMenuItem(
                      value: e.key,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            getShapeIcon(e.key),
                            color: Colors.black,
                          ),
                          Text(' ${e.value}')
                        ],
                      )))
                      .toList(),
                  onSelected: selectShape,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      getShapeIcon(controller.shapeFactory),
                      color: controller.shapeFactory != null
                          ? Colors.red
                          : Colors.black,
                    ),
                  ),
                )
              else
                IconButton(
                  icon: Icon(
                    getShapeIcon(controller.shapeFactory),
                    color: Colors.red,
                  ),
                  onPressed: () => selectShape(null),
                ),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return buildDefault(context);
  }

  static IconData getShapeIcon(ShapeFactory shapeFactory) {
    if (shapeFactory is LineFactory) return PhosphorIcons.line_segment;
    if (shapeFactory is ArrowFactory) return PhosphorIcons.arrow_up_light;
    if (shapeFactory is DoubleArrowFactory) {
      return PhosphorIcons.arrows_horizontal;
    }
    if (shapeFactory is RectangleFactory) return PhosphorIcons.rectangle;
    if (shapeFactory is OvalFactory) return PhosphorIcons.circle;
    return PhosphorIcons.polygon;
  }

  void undo() {
    controller.undo();
  }

  void redo() {
    controller.redo();
  }

  void toggleFreeStyleDraw() {
    controller.freeStyleMode = controller.freeStyleMode != FreeStyleMode.draw
        ? FreeStyleMode.draw
        : FreeStyleMode.none;
  }

  void toggleFreeStyleErase() {
    controller.freeStyleMode = controller.freeStyleMode != FreeStyleMode.erase
        ? FreeStyleMode.erase
        : FreeStyleMode.none;
  }

  void addText() {
    if (controller.freeStyleMode != FreeStyleMode.none) {
      controller.freeStyleMode = FreeStyleMode.none;
    }
    controller.addText();
  }

  void setFreeStyleStrokeWidth(double value) {
    controller.freeStyleStrokeWidth = value;
  }

  void setFreeStyleColor(double hue) {
    controller.freeStyleColor = HSVColor.fromAHSV(1, hue, 1, 1).toColor();
  }

  void setTextFontSize(double size) {
    // Set state is just to update the current UI, the [FlutterPainter] UI updates without it
    setState(() {
      controller.textSettings = controller.textSettings.copyWith(
          textStyle:
          controller.textSettings.textStyle.copyWith(fontSize: size));
    });
  }

  void setShapeFactoryPaint(Paint paint) {
    // Set state is just to update the current UI, the [FlutterPainter] UI updates without it
    setState(() {
      controller.shapePaint = paint;
    });
  }

  void setTextColor(double hue) {
    controller.textStyle = controller.textStyle
        .copyWith(color: HSVColor.fromAHSV(1, hue, 1, 1).toColor());
  }

  void selectShape(ShapeFactory factory) {
    controller.shapeFactory = factory;
  }
  Future renderImage() async {
    if(textFocusNode?.hasFocus == true) {
      textFocusNode.unfocus();
      setState(() {

      });
    }
    await Future.delayed(const Duration(milliseconds: 300));
    if (backgroundImage == null) return;
    final backgroundImageSize = Size(
        backgroundImage.width.toDouble(), backgroundImage.height.toDouble());

    // Render the image
    // Returns a [ui.Image] object, convert to to byte data and then to Uint8List
    final imageFuture = await controller.renderImage(backgroundImageSize);
    final bytes = await imageFuture.pngBytes;

    await widget.file.writeAsBytes(bytes);
  }

  void removeSelectedDrawable() {
    final selectedDrawable = controller.selectedObjectDrawable;
    if (selectedDrawable != null) controller.removeDrawable(selectedDrawable);
  }

  void flipSelectedImageDrawable() {
    final imageDrawable = controller.selectedObjectDrawable;
    if (imageDrawable is! ImageDrawable) return;

    controller.replaceDrawable(
        imageDrawable, imageDrawable.copyWith(hidden: !imageDrawable.hidden));
  }

  @override
  bool get wantKeepAlive => true;
}
