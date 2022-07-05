import 'package:meta/meta.dart';
import 'dart:ui' as ui;

class GameBuildOwner {
  final List<GameElement> _dirtyElements = [];

  void build() {}
}

class GamePipelineOwner {
  void tickPhysics() {}
  void flushRender() {}
}

// Widgets are configurations which know how to create Elements.
abstract class GameWidget {
  final GameKey? key;
  const GameWidget({this.key});

  GameElement createElement();
}

// class GameElementVisitor {}

// Elements are held in a tree represent the instantiated UI.
abstract class GameElement implements GameBuildContext {
  GameWidget? widget;

  GameElement(this.widget);

  void markNeedsBuild() {}
  void performRebuild();
  // mount
  // update
  // unmount
  // void visitChildren(GameElementVisitor visitor) {}
}

abstract class GameComponentElement extends GameElement {
  GameComponentElement(super.widget);

  @protected
  GameWidget build();

  @override
  void performRebuild() {}
}

class GameBuildContext {}

// Unclear if needed?
class GameKey {}

class GameRenderContext {
  final ui.Canvas canvas;

  GameRenderContext(this.canvas);

  void renderChild(GameRenderObject child) {
    child.render(this);
  }
}

abstract class GameRenderObject {
  // FIXME: This should be 3d.
  // FIXME: is this parent data?
  void setPosition(ui.Offset position);

  @protected
  void render(GameRenderContext context);
}

abstract class GameLeafRenderObjectWidget extends GameRenderObjectWidget {
  const GameLeafRenderObjectWidget();

  @override
  GameLeafRenderObjectElement createElement() =>
      GameLeafRenderObjectElement(this);
}

class GameLeafRenderObjectElement extends GameRenderObjectElement {
  GameLeafRenderObjectElement(GameLeafRenderObjectWidget widget)
      : super(widget);
}

abstract class GameMultiChildRenderObjectWidget extends GameRenderObjectWidget {
  const GameMultiChildRenderObjectWidget(
      {super.key, this.children = const <GameWidget>[]});

  final List<GameWidget> children;

  @override
  GameMultiChildRenderObjectElement createElement() =>
      GameMultiChildRenderObjectElement(this);
}

class GameMultiChildRenderObjectElement extends GameRenderObjectElement {
  GameMultiChildRenderObjectElement(super.widget);
}

abstract class GameRenderObjectWidget extends GameWidget {
  const GameRenderObjectWidget({super.key});

  @override
  @factory
  GameRenderObjectElement createElement();

  @protected
  @factory
  GameRenderObject createRenderObject(GameBuildContext context);

  @protected
  void updateRenderObject(
      GameBuildContext context, covariant GameRenderObject renderObject) {}
}

class GameRenderObjectElement extends GameElement {
  GameRenderObjectElement(super.widget);

  @override
  void performRebuild() {}
}

class GameStatelessElement extends GameComponentElement {
  GameStatelessElement(super.widget);

  @override
  @protected
  GameWidget build() => (widget as GameStatelessWidget).build(this);
}

abstract class GameState<T extends GameStatefulWidget> {
  @protected
  GameWidget build(GameBuildContext context);
}

class GameStatefulElement extends GameComponentElement {
  GameStatefulElement(super.widget);

  @override
  GameWidget build() => state.build(this);

  GameState<GameStatefulWidget> get state => _state!;
  GameState<GameStatefulWidget>? _state;
}

abstract class GameStatelessWidget extends GameWidget {
  const GameStatelessWidget({super.key});

  @protected
  GameWidget build(GameBuildContext context);

  @override
  GameStatelessElement createElement() => GameStatelessElement(this);
}

abstract class GameStatefulWidget extends GameWidget {
  @override
  GameStatefulElement createElement() => GameStatefulElement(this);

  @protected
  @factory
  GameState createState();
}

class GameStack extends GameMultiChildRenderObjectWidget {
  const GameStack({super.children});

  @override
  GameRenderObject createRenderObject(GameBuildContext context) {
    return GameRenderStack();
  }

  // renders in order?
}

class GameRenderStack extends GameRenderObject {
  List<GameRenderObject> children = <GameRenderObject>[];

  GameRenderStack({children = const <GameRenderObject>[]});

  @override
  void setPosition(ui.Offset position) {}

  @override
  @protected
  void render(GameRenderContext context) {
    for (var child in children) {
      context.renderChild(child);
    }
  }
}
