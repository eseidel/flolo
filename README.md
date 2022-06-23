# rolo

Playing with functional reactive gaming ideas.  Inspired by Bolo from the 80s.


# Notes

Pipeline
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