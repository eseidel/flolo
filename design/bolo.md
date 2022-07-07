Minimal design for bolo.

Features
* Steerable tank
* Damage/Health
* Projectiles


Future?
* HUD
* Network play
* Death timer




map.yaml
terrain:
 ...
structures:
  walls:
  enemies:
    pillboxs:
      0,0
      1,1
  refills:
    0,0


class Tank : Widget {
    fn build {
        RigidBody(
            mass: 1.0,
            maxVelocity: 10.0,
            maxAngularVelocity: 10.0,
            behaviors: [
                EitherOrSteeringBehavior(angularAcceleration: 0.1, linearAcceleration: 0.1),
                CollisionBounce(spring: 1.0),
            ]
        ),
        InputTrigger(input.fire, trigger: (context) => context.add(Projectile())),
    }
}

// Container/lifetime manager for Projectile objects.
class Projectiles : Widget {

}


class Projectile: Widget {
    double damage = 10.0;
    bool hasCollided = false;


    fn build {
        if (hasCollided) {
            return Animation(
                name: 'projectile_explosion',
                duration: 1.0,
                onComplete: Projectiles.of(context).removeThis(context),
            )
        }

        RigidBody(
            mass: 0.1,
            initialVelocity: 10.0,
            maxVelocity: 10.0,
            maxAngularVelocity: 0.0,
            behaviors: [
                CollisionTrigger(trigger: (collider) {
                    setState(() => hasCollided = true);
                    queueGameAction(DamageAction(
                        target: collider.other,
                        amount: damage,
                    ));
                })
            ]
        )
    }
}

class Pillbox : Widget {
    // hp
    // sight radius
    // last fired
    fn build {
        Behavior()
    }
}

class Bolo : Widget {
    fn build {
        Scene() {
            Map.loadFrom('map.yaml'),
            Projectiles(),
            Tank(),
            Hud(),
        }
    }
}