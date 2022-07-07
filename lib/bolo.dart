import 'dart:ui' as ui;
import 'game_framework.dart';

class ProjectileBehavior {}

// Scene

class RigidBodyWidget extends GameWidget {
  final double mass;
  final double maxSpeed;
  final List<GameWidget> children;

  const RigidBodyWidget({
    this.mass = 1.0,
    this.maxSpeed = 1.0,
    this.children = const [],
  });

  @override
  GameElement createElement() {
    return GameMultiChildRenderObjectElement(this);
  }
}

class CircleRenderObject extends GameRenderObject {
  ui.Offset position = ui.Offset.zero;

  @override
  void setPosition(ui.Offset position) {
    this.position = position;
  }

  @override
  void render(GameRenderContext context) {
    var circlePaint = ui.Paint()
      ..color = const ui.Color.fromARGB(255, 0, 255, 0);
    context.canvas.drawCircle(ui.Offset.zero, 10.0, circlePaint);
  }
}

class CircleWidget extends GameLeafRenderObjectWidget {
  @override
  GameRenderObject createRenderObject(GameBuildContext context) =>
      CircleRenderObject();
}

class GameInputManager {
  static GameInputManager _instance = GameInputManager();

  // FIXME: Cheating for now.
  static GameInputManager of(GameBuildContext context) {
    return _instance;
  }

  double get leftRight => 0.0;
  double get upDown => 0.0;
}

class GamePhysicsChange {
  final double angularAcceleration;
  final double linearAcceleration;

  GamePhysicsChange({
    this.angularAcceleration = 0.0,
    this.linearAcceleration = 0.0,
  });
}

class GamePhysicsBehavior {}

class EitherOrSteeringBehavior extends GamePhysicsBehavior {
  double angularAcceleration;
  double linearAcceleration;

  EitherOrSteeringBehavior({
    required this.angularAcceleration,
    required this.linearAcceleration,
  });

  GamePhysicsChange onTick(GameBuildContext context) {
    var input = GameInputManager.of(context);
    return GamePhysicsChange(
      angularAcceleration: input.leftRight * angularAcceleration,
      linearAcceleration: input.upDown * linearAcceleration,
    );
  }
}

class TankState extends GameState<Tank> {
  double maxSpeed = 10;

  @override
  GameWidget build(GameBuildContext context) {
    return RigidBodyWidget(
      // mass: 1,
      // maxSpeed: maxSpeed,
      // maxAngularSpeed: 1.0,
      behaviors: [
        // if left is down, apply left steering force.
        // if right is down apply right steering force.
        // if neither or both are down, apply zero steering force.

        // if back is down apply backwards/braking force.
        // if forward is down apply acceleration.
        // if neither or both are down, apply zero acceleration.
        EitherOrSteeringBehavior(
          angularAcceleration: 0.1,
          linearAcceleration: 0.1,
        ),

        // if fire is down, and not on cooldown, fire a projectile.
        // ProjectileBehavior(create: () => Bullet(), cooldown: 0.5),

        // OnPositionChanged((position) {
        //   setState(() {
        //     maxSpeed = Map.cellAtPosition(position).terrain.maxSpeed;
        //   })
        // }),
        // How does this get rendered?
      ],
    );
  }
}

class Tank extends GameStatefulWidget {
  @override
  TankState createState() => TankState();
}

class PillboxState extends GameState<Pillbox> {
  @override
  GameWidget build(GameBuildContext context) {
    return CircleWidget();
  }
}

class Pillbox extends GameStatefulWidget {
  @override
  PillboxState createState() => PillboxState();
}

class Bolo extends GameStatelessWidget {
  @override
  GameWidget build(GameBuildContext context) {
    return GameStack(children: [
      Tank(),
      Pillbox(),
    ]);
  }
}

// return World(
//     // extraPhases: [
//     //     VisibilityPhase(), // post physics
//     //     DamagePhase(), // post physics
//     //     MaxSpeedFromTerrain(), // pre-input?
//     //     HealFromTerrain(), // post-physics?
//     // ]
//     models:[
//     Mob(
//         id: 'tank',
//         transform: Transform.offset(0,1), // initial state?
//         children: [
//             SteeringBehavior(
//                 angleSpeed: 1,
//             ),
//             InputTrigger(triggers: input.action1,
//                 behavior: ProjectileBehavior(create: () => Bullet(), cooldown: 0.5),
//             )
//             CollisionRadius(behavior: HardBodyCollision()),
//             HealthData(), // stateful
//             EventTrigger('ondeath', (model) => model.withAnimationVariant('dead')),
//         }
//     ),
//     Mob(
//         id: 'pillbox'
//         physicsBehaviors: [
//             LineOfSightTrigger(result: ProjectileBehavior),
//         ],
//         customData: HealthData(),
//     ),
//     Mob(
//         id: 'refillstation'
//     )
// ]);
// }


// These take in states and queue transforms.

// class Model {
//   State currentState = State();
//   List<Behavior> behaviorQueue;
// }

// What is a prefab?
// A tree of objects with associated behaviors?
//

// games have tons of state that exists only in the animation system
// think of waves in a lake
// as long as the game doesn't care where the waves are
// the state is purely animation state
// you can run as fancy a waves simulation as you want

// Bolo stuff
// Create tank model (on-connect event driven?)
// Tank can move (behavior on input generates velocity delta)
// Tank can turn (behavior on input generates angular delta)
// Tank can shoot (behavior on input generates new model object + behaviors)
// Shots can move
// Shots can collide with things and affect state on collision