# rolo

Playing with functional reactive gaming ideas.  Inspired by Bolo from the 80s.


# Notes

Are games just inherently stateful?
Do you rebuild the model every tick?
Is traversing through levels just represented as transforms on the model?
Can you change the phases? Presumably only through rebuilding the root?


Simple is fast.k
Pipeline
* Input
* Animation // Is this "behavior"?  Is this run on the server?
* Build
* Layout // Is this basically physics?
* Paint
* Composite
* Rasterize
* Model (a tree of state)?
 * How many dimensions?
  * Transform
  * Velocity? (Is there a delta-transform?)
 * Key
 * Behaviors
  * Physics (mass, velocity, size, material, compression behavior)
 * Time based triggers (e.g. add tank)
 * Input-based triggers
* Physics (feedback behaviors within model)
 * Is this just a "behavior"?
 * Inputs: Positions of things
* Animation (time-based computation of states for render?)
 * What visuals and auditory to produce based on passed in state?
 * Sprites
* Render (visuals, sound)
 * Is this the same as animation?
* Shaders (post-processing on visuals/sounds)

Where are Widgets in this?  Are they behaviors?

InputHandler(
    child: Tank(position: Offset(0,0))
)
Rock(position: Offset(1, 1))
Pillbox(Position: Offset(2, 2))


Model
 - Do Model's have types?
 - What validates the things?
Mob(
 key: 'player'
 position: ..,
 size: ..,  // Is this part of the model?


How do we associate behaviors with Models?
Can behaviors run at different layers?

X Tank:
* Model of Tank
* Just a normal Mob with Id?
X Steering behavior:
* Applied to Tank, as behavior, consumed on input before physics?
X Collision behavior:
* Applied to Tank
X Firing behavior
* Applied to tank, as behavior, consuemd on input before model?
X Pilbox behavior
* Applied to Pillbox, as behavior, before model?
Visuals of Tank
* Sprite applied to Tank
Animation of Tank
* Animation applied to Tank?
X Death of pillbox?
* Value trigger based on named model value?
Dead pillbox vs. alive one?
* Different model object on vs other?
X Health points of tank?
* named model value?
X Death of tank?
* Value triggers based on named model values?
X Slowdown due to terrain?
* Behaviors run every step to set max speed based on terrain?
X Refill stations?
* Collision triggers which cause model changes?
X Visibility changes from brush?
* Triggers which change visibility model?
* Or recomputing every step? e.g. Visiblility update pass? (custom phase?)


// Why is this separate?  Does this need to be a class?
// Is this just another child object?
class HealthData extends CustomData {
    double health;
}

class ProjectileBehavior {
    void onTrigger(world) =>
        world.byAddingModel(Projectile());
}

World(
    customPhases: [
        VisibilityPhase(), // post physics
        DamagePhase(), // post physics
        MaxSpeedFromTerrain(), // pre-input?
        HealFromTerrain(), // post-physics?
    ]
    models:[
    Mob(
        id: 'tank',
        transform: Transform.offset(0,1),
        children: [
            SteeringBehavior(
                angleSpeed: 1,
            ),
            InputTrigger(triggers: input.action1,
                behavior: ProjectileBehavior(create: () => Bullet(), cooldown: 0.5),
            )
            CollisionRadius(behavior: HardBodyCollision()),
            HealthData(),
            EventTrigger('ondeath', (model) => model.withAnimationVariant('dead')),
        }
    ),
    Mob(
        id: 'pillbox'
        children: [
            LineOfSightTrigger(result: ProjectileBehavior),
            HealthData(),
        ],
    ),
    Mob(
        id: 'refillstation'
    )
])


Important to have diagnostics?  e.g. be able to list all the phases?



Game(
    model: Model([
        Mob(
            key: Key('player'),
            transform: Transform.zero(),
            behavior
        )
    ])
    behavior:
    triggers:
)


Scene(
    children:[
        Mob(
            key: Key("player"),
            position: Offset(0,0),
            size: Size(1,1),
            physics: Solid(),
            collions: SolidCollisions(),
            behaviors: [
                InputHandler()
            ]
        ),
        Mob(
            position: Offset(1,1),

        ),
        Mob(
            
        )
    ]
)




Model layer consists of objects moving around?
Behaviors can act on Model
Physics explains how those objects move and interact with each other.
Input produces values which feed into physics?

Are associated behaviors just behaviors which re-queue themselves every tick?

Examples of behaviors
Special physics?  (e.g pong reflections)
Pathing (e.g. minions)
Collision behaviors (e.g. pong reflections, damage on collision, etc.)

loop:
 state = model(state)
 shaders(render(animation(physics(state))))
Bolo.
Start by driving the tank.
Need stream of inputs from keyboard
Keyboard input stream changes when keys go up/down.

Can it be event driven, but behavior producing?
e.g. an event happens and it queues a behavior?
Why don't you modify yourself directly?
Because expressing