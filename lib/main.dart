import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flolo/game_framework.dart';

ui.Color color = const ui.Color(0xFF00FF00);

class GameBinding {
  GameBuildOwner buildOwner = GameBuildOwner();
  GamePipelineOwner pipelineOwner = GamePipelineOwner();

  void beginFrame(Duration timeStamp) {
    // Input
    // Transitory, per-frame callbacks (e.g. animation?)
    // Build
    buildOwner.build();
    // Physics
    pipelineOwner.tickPhysics();
    pipelineOwner.flushRender();
    // Behaviors (shooting pillboxes, etc.)
  }

  void drawFrame() {
    final ui.Rect paintBounds =
        ui.Offset.zero & (ui.window.physicalSize / ui.window.devicePixelRatio);
    final ui.Picture picture = paint(paintBounds);
    final ui.Scene scene = composite(picture, paintBounds);
    ui.window.render(scene);
  }
}

ui.Picture paint(ui.Rect paintBounds) {
  final ui.PictureRecorder recorder = ui.PictureRecorder();
  final ui.Canvas canvas = ui.Canvas(recorder, paintBounds);

  final ui.Size size = paintBounds.size;
  canvas.drawCircle(
    size.center(ui.Offset.zero),
    size.shortestSide * 0.45,
    ui.Paint()..color = color,
  );
  return recorder.endRecording();
}

ui.Scene composite(ui.Picture picture, ui.Rect paintBounds) {
  final double devicePixelRatio = ui.window.devicePixelRatio;

  // This transform scales the x and y coordinates by the devicePixelRatio.
  final Float64List deviceTransform = Float64List(16)
    ..[0] = devicePixelRatio
    ..[5] = devicePixelRatio
    ..[10] = 1.0
    ..[15] = 1.0;

  // We build a very simple scene graph with two nodes. The root node is a
  // transform that scale its children by the device pixel ratio. This transform
  // lets us paint in "logical" pixels which are converted to device pixels by
  // this scaling operation.
  final ui.SceneBuilder sceneBuilder = ui.SceneBuilder()
    ..pushTransform(deviceTransform)
    ..addPicture(ui.Offset.zero, picture)
    ..pop();

  return sceneBuilder.build();
}

// void handlePointerDataPacket(ui.PointerDataPacket packet) {
//   for (final ui.PointerData datum in packet.data) {
//     if (datum.change == ui.PointerChange.down) {
//       // If the pointer went down, we change the color of the circle to blue.
//       color = const ui.Color(0xFF0000FF);
//       ui.window.scheduleFrame();
//     } else if (datum.change == ui.PointerChange.up) {
//       color = const ui.Color(0xFF00FF00);
//       ui.PlatformDispatcher.instance.scheduleFrame();
//     }
//   }
// }

bool handleKeyData(ui.KeyData datum) {
  if (datum.type == ui.KeyEventType.down) {
    // If the key went down, we change the color of the circle to blue.
    color = const ui.Color(0xFF0000FF);
    ui.window.scheduleFrame();
  } else if (datum.type == ui.KeyEventType.up) {
    color = const ui.Color(0xFF00FF00);
    ui.PlatformDispatcher.instance.scheduleFrame();
  }
  return true; // Handled.
}

void main() {
  GameBinding binding = GameBinding();

  // ui.PlatformDispatcher.instance.onPointerDataPacket = handlePointerDataPacket;
  ui.PlatformDispatcher.instance.onBeginFrame = binding.beginFrame;
  ui.PlatformDispatcher.instance.onDrawFrame = binding.drawFrame;
  ui.PlatformDispatcher.instance.onKeyData = handleKeyData;

  // kick off a frame
  ui.PlatformDispatcher.instance.scheduleFrame();
}
