import Foundation

var barriers: [Shape] = []
var targets: [Shape] = []

// Declaring ball shape and size (length and width)
let ball = OvalShape(width: 40, height: 40)

// Function for the ball
fileprivate func setupBall() {
    // Added ball
    ball.position = Point(x: 250, y: 400)
    scene.add(ball)
    
    // Setting Ball Appearance
    ball.fillColor = .blue
    
    // Ball Physics
    ball.hasPhysics = true
    ball.isDraggable = false
    ball.bounciness = 0.6
    
    // Tracks ball collision
    ball.onCollision = ballCollided(with:)
    
    // Ball tap callback feature to allow the user to modify barrier
    scene.trackShape(ball)
    ball.onExitedScene = ballExitedScene
    ball.onTapped = resetGame
}

// Function for the barrier
fileprivate func addBarrier(at position: Point, width: Double, height: Double, angle: Double) {
    
    // Assigns barrier coordinate points value from parameters
    let barrierPoints = [
        Point(x: 0, y: 0),
        Point(x: 0, y: height),
        Point(x: width, y: height),
        Point(x: width, y: 0)
        
    ]
    
    // Assigns the barrier a variable and gives it a shape
    let barrier = PolygonShape(points: barrierPoints)
    
    // Adds this particular barrier to the array of barriers
    barriers.append(barrier)
    
    // Assigning starting co-ordinates
    barrier.position = position
   
    // Barrier physics
    barrier.hasPhysics = true
    barrier.isImmobile = true
    
    // Adding barrier to screen
    scene.add(barrier)
    
    // Setting barrier appearance
    barrier.fillColor = .brown
    
    // Tweaking Barrier to have an angle
    barrier.angle = angle
}

/* Teleports the ball to 0, -80 (off-screen) which allows ballExitedScene()
 to activate and enables the user to move the barrier */
 func resetGame() {
    ball.position = Point(x: 0, y: -80)
}

// Allows the barrier to be draggable when ball is off-screen
func ballExitedScene() {
    for barrier in barriers {
        barrier.isDraggable = true
    }
    
    // Counts how many targets the user has hit
    var hitTargets = 0
    for target in targets {
        if target.fillColor == .green {
            hitTargets += 1
        }
    }
    
    // Provides a pop-up to celeberate the user winning
    if hitTargets == targets.count {
        scene.presentAlert(text: "You won!", completion: alertDismissed)
    }
}

func alertDismissed(){}

// Declaring funnel
let funnelPoints = [
    Point(x: 0, y: 50),
    Point(x: 80, y: 50),
    Point(x: 60, y: 0),
    Point(x: 20, y: 20),
]

// Assinging the funnel shape
let funnel = PolygonShape(points:funnelPoints)

// Function for the Funnel
fileprivate func setupFunnel() {
    // Added funnel
    funnel.position = Point(x: 200, y: scene.height - 25)
    scene.add(funnel)
    
    // Setting funnel appearance
    funnel.fillColor = .gray
    
    // Funnel physics
    funnel.isDraggable = false
    
    // Drops ball upon tap
    funnel.onTapped = dropBall
}

// Function for when dropping the ball
func dropBall () {
    ball.position = funnel.position
    ball.stopAllMotion()
    
    for barrier in barriers {
        barrier.isDraggable = false
    }
    
    for target in targets {
        target.fillColor = .orange
    }
}

// Function for the target
fileprivate func addTarget(at position: Point) {
    // Assigns target coordinate points
    let targetPoints = [
        Point(x: 10, y: 0),
        Point(x: 0, y: 10),
        Point(x: 10, y: 20),
        Point(x: 20, y: 10)
    ]
    
    // Assigns the target points a variable and gives it a shape
    let target = PolygonShape(points: targetPoints)
    
    // Adds the target to the array of targets
    targets.append(target)
    
    // Added Target
    target.position = position
    scene.add(target)
    
    // Target physics
    target.hasPhysics = true
    target.isImmobile = true
    target.isDraggable = false
    
    // Setting target appearance
    target.fillColor = .orange
    
    // Naming the target (useful when checking for collisions with ball)
    target.name = "target"
}

// Function for checking ball collisions with target
func ballCollided(with otherShape: Shape) {
    // Checks if the collision is with a target
    if otherShape.name != "target" {return}
    
    /* Changes the target color to green, letting the user know that this
     target has been hit */
    otherShape.fillColor = .green
}

func setup() {
    
    // Adding a ball to the game by calling the setupBall function
    setupBall()

    // Adding barriers by calling the addBarrier function
    addBarrier(at: Point(x: 200, y: 150), width: 80, height: 25, angle: 0.1)
    addBarrier(at: Point(x: 300, y: 150), width: 100, height: 25, angle: 0.3)

    // Calling setupFunnel to add funnel at the top
    setupFunnel()
    
    // Adding targets by calling the addTarget function
    addTarget(at: Point(x: 133, y: 614))
    addTarget(at: Point(x: 111, y: 474))
    addTarget(at: Point(x: 256, y: 280))
    addTarget(at: Point(x: 151, y: 242))
    addTarget(at: Point(x: 272, y: 87))
    
    // Resetting the game by teleporting the ball to y = -80
    resetGame()
}
