import 'package:meta/meta.dart';
import 'dart:ui' as ui;

// Widgets are configurations which know how to create Elements.
abstract class GameWidget {
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

class GameRenderContext {
  ui.Canvas canvas;
}

abstract class GameRenderObject {
  // FIXME: This should be 3d.
  void position(ui.Offset position);

  @protected
  void render(GameRenderContext context);
}

abstract class GameRenderObjectWidget extends GameWidget {
  GameRenderObject createRenderObject();
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
