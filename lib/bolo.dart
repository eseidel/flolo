import 'dart:ui' as ui;
import 'game_framework.dart';

class Projectile {}

class ProjectileBehavior {
  void onTrigger(world) => world.byAddingModel(Projectile());
}

class World {}

// Scene

class GameScene extends GameStatelessWidget {
  // renders in order?
}

class CircleRenderObject extends GameRenderObject {
  @override
  void render(GameRenderContext context) {
    var _paint = ui.Paint()..color = ui.Color.fromARGB(255, 0, 255, 0);
    context.canvas.drawCircle(ui.Offset.zero, 10.0, _paint);
  }
}

class CircleWidget extends GameRenderObjectWidget {
  @override
  GameRenderObject createRenderObject() => CircleRenderObject();
}

class TankState extends GameState<Tank> {
  @override
  GameWidget build(GameBuildContext context) {
    return CircleWidget();
  }
}

class Tank extends GameStatefulWidget {
  @override
  TankState createState() => TankState();
}

class Pillbox extends GameStatefulWidget {}

class Bolo extends GameStatelessWidget {
  @override
  GameWidget build(GameBuildContext context) {
    return GameScene(children: [
      Tank(),
      Pillbox(),
    ]);
  }
}

// Stateful?
// class Mob : {
//   String id;
//   Transform transform;
//   List<
// }

// Object build() {

// // These are all descriptions which get turned into GameObjects/Elements?
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

void loop() {
  // Collect which phases to run?
  // Run each phase.
  // Show output.
}

// class MOB {
//   final String name;
//   final Offset offset;
//   final Offset velocity;

//   const MOB(
//       {required this.name, required this.offset, this.velocity = Offset.zero});
// }

// These take in states and queue transforms.
class Behavior {}

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