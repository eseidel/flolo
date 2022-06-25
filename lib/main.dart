import 'package:flutter/material.dart';

void main() {
  runApp(const FloloApp());
}

class Projectile {
  
}

class ProjectileBehavior {
    void onTrigger(world) =>
        world.byAddingModel(Projectile());
}

class World {
}

class GameObject {

}

// Stateful?
class Mob : {
  String id;
  Transform transform;
  List<
}

Object build() {

// These are all descriptions which get turned into GameObjects/Elements?
return World(
    // extraPhases: [
    //     VisibilityPhase(), // post physics
    //     DamagePhase(), // post physics
    //     MaxSpeedFromTerrain(), // pre-input?
    //     HealFromTerrain(), // post-physics?
    // ]
    models:[
    Mob(
        id: 'tank',
        transform: Transform.offset(0,1), // initial state?
        children: [
            SteeringBehavior(
                angleSpeed: 1,
            ),
            InputTrigger(triggers: input.action1,
                behavior: ProjectileBehavior(create: () => Bullet(), cooldown: 0.5),
            )
            CollisionRadius(behavior: HardBodyCollision()),
            HealthData(), // stateful
            EventTrigger('ondeath', (model) => model.withAnimationVariant('dead')),
        }
    ),
    Mob(
        id: 'pillbox'
        physicsBehaviors: [
            LineOfSightTrigger(result: ProjectileBehavior),
        ],
        customData: HealthData(),
    ),
    Mob(
        id: 'refillstation'
    )
]);
}

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

class State {}

// These take in states and queue transforms.
class Behavior {}

class Model {
  State currentState = State();
  List<Behavior> behaviorQueue;
}

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

class FloloApp extends StatelessWidget {
  const FloloApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flolo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const FloloHome(),
    );
  }
}

class FloloHome extends StatefulWidget {
  const FloloHome({super.key});

  @override
  State<FloloHome> createState() => _FloloHomeState();
}

class _FloloHomeState extends State<FloloHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: CustomPaint(
        painter: FloloPainter(),
      )),
    );
  }
}

class FloloPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = Colors.green;
    canvas.drawCircle(const Offset(100, 100), 10, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
