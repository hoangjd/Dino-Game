//
//  GameScene.swift
//  Dino Game
//
//  Created by Joseph Hoang on 4/5/18.
//  Copyright © 2018 Joe Hoang. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    struct PhysicsCategory {
        static let Block: UInt32 = 0x1 << 0
        static let Border: UInt32 = 0x1 << 1
        static let FoodStar: UInt32 = 0x1 << 2
        static let Rock: UInt32 = 0x1 << 3
        static let Character: UInt32 = 0x1 << 4
        static let Water: UInt32 = 0x1 << 5
    }
    
    var maze = CreateMaze()
    var blockCreationTimer = 0
    var addRockTimer = 0
    let starCountLabel  = SKLabelNode(fontNamed: "Chalkduster")
    let rockCountLabel = SKLabelNode(fontNamed: "Chalkduster")
    let heartCountLabel = SKLabelNode(fontNamed: "Chalkduster")
    let batteryCountLabel = SKLabelNode(fontNamed: "Chalkduster")
    let character = SKSpriteNode(imageNamed: "app-icon")
    
    var starCount: Int!
    var rockCount: Int!
    var heartCount: Int!
    var batteryCount: Int!
    
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        initializeEverything()
        makeBackground()
        makeBounderies()
        startBlockTimer()
        startGetRockTimer()
        setInitialCharacterLoc()
        addFood()
        addStar()
        bottomCornerStats()
        createWater()
        addGestures()
        

        
//        var circle = SKShapeNode!
//        var circle = SKShapeNode(circleOfRadius: 30)
//        circle.fillColor = SKColor.blue
//        circle.position = CGPoint(x: 200, y: 700)
//        addChild(circle)
//        circle.physicsBody = SKPhysicsBody(circleOfRadius: circle.frame.width/2)

       
    }
    
    func initializeEverything() {
        maze = CreateMaze()
        blockCreationTimer = 0
        addRockTimer = 0
        starCount = 0
        rockCount = 10
        heartCount = 3
        batteryCount = 100
        initializeLabels()

    }
    
    func initializeLabels() {
        starCountLabel.fontSize = 35
        rockCountLabel.fontSize = 35
        heartCountLabel.fontSize = 35
        batteryCountLabel.fontSize = 35
        
        starCountLabel.fontColor = SKColor.white
        rockCountLabel.fontColor = SKColor.white
        heartCountLabel.fontColor = SKColor.white
        batteryCountLabel.fontColor = SKColor.white
        
        starCountLabel.text = String(starCount)
        rockCountLabel.text = String(rockCount)
        heartCountLabel.text = String(heartCount)
        batteryCountLabel.text = String(batteryCount)
        
        
    }

    
    func startBlockTimer() {
        var blockCreationTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(addRandomBlock(sender:)), userInfo: nil, repeats: true)
    }
    
    func startGetRockTimer() {
        var getRocksTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(addRocks(sender:)), userInfo: nil, repeats: true)
    }
    
    func makeBackground() {
        let background = SKSpriteNode(imageNamed: "bg")
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        background.size = self.size
        addChild(background)
    }
    
    
    func makeBounderies() {
        let bottom = CGFloat(64 / 2)
        let top = CGFloat(1024 - 64 / 2)
        let top1 = CGFloat(top - 64)
        

        let boundTop = SKSpriteNode()
        boundTop.position = CGPoint(x: self.frame.width/2, y: 896)
        boundTop.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height:1))
                addChild(boundTop)
        boundTop.physicsBody?.isDynamic = false
      
        //left of first water
        let boundBottom = SKSpriteNode()
        boundBottom.position = CGPoint(x: 512/2, y: 64)
        boundBottom.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 512, height:1))
          addChild(boundBottom)
        boundBottom.physicsBody?.isDynamic = false
        
        //middle of two water
        let boundBottom1 = SKSpriteNode()
        boundBottom1.position = CGPoint(x: 576 + 256/2, y: 64)
        boundBottom1.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 256, height:1))
        addChild(boundBottom1)
        boundBottom1.physicsBody?.isDynamic = false
        
          //right of last water
        let boundBottom2 = SKSpriteNode()
        boundBottom2.position = CGPoint(x: 896 + 235/2, y: 64)
        boundBottom2.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 235, height:1))
        addChild(boundBottom2)
        boundBottom2.physicsBody?.isDynamic = false
        
        let boundLeft = SKSpriteNode()
        boundLeft.position = CGPoint(x: 0, y:self.frame.height/2)
        boundLeft.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height:self.frame.height))
        addChild(boundLeft)
        boundLeft.physicsBody?.isDynamic = false
        
        let boundRight = SKSpriteNode()
        boundRight.position = CGPoint(x: 1344, y:self.frame.height/2)
        boundRight.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height:self.frame.height))
        addChild(boundRight)
        boundRight.physicsBody?.isDynamic = false
        
        createCollisionBitmasks(item: "border" , node: boundTop)
        createCollisionBitmasks(item: "border" , node: boundBottom)
        createCollisionBitmasks(item: "border" , node: boundBottom1)
        createCollisionBitmasks(item: "border" , node: boundBottom2)
        createCollisionBitmasks(item: "border" , node: boundLeft)
        createCollisionBitmasks(item: "border" , node: boundRight)
        
        makeBoundary(yloc: bottom)
        makeBoundary(yloc: top)
        makeBoundary(yloc: top1)
        
    }
    
    func createWater() {
        addNewItem(item: "water", x: 8, y: -1)
        addNewItem(item: "water", x: 13, y: -1)
//        var water1 = SKSpriteNode(imageNamed: "water")
//        water1.size = CGSize(width: 64, height: 64)
//        water1.position = CGPoint(x:water1.frame.size.width/2 + 512, y: water1.frame.size.height/2)
//        water1.physicsBody = SKPhysicsBody(rectangleOf: water1.size, center: water1.anchorPoint)
//        self.addChild(water1)
//      //  water1.physicsBody?.affectedByGravity = false
//        water1.physicsBody?.isDynamic = false
    }
    
    func bottomCornerStats() {
        var image = ""
        var label: SKLabelNode!
        for i in 0...3 {
            switch i {
            case 0:
                image = "star"
                label = starCountLabel
            case 1:
                image = "rock"
                label = rockCountLabel
            case 2:
                image = "heart"
                label = heartCountLabel
            case 3:
                image = "battery"
                label = batteryCountLabel
            default:
                break
            }
            let object = SKSpriteNode(imageNamed: "\(image)")
            if image == "battery" {
                object.size = CGSize(width: 100, height: 100)
            } else {
                object.size = CGSize(width: 64, height: 64)
            }
            object.position = CGPoint(x:object.frame.size.width/2 + CGFloat(64*i), y: 32)
            label.position.x = object.position.x
            label.position.y = 20
            self.addChild(object)
            self.addChild(label)
        }
    }
    
    func updateLabelCounts() {
        starCountLabel.text = String(starCount)
        rockCountLabel.text = String(rockCount)
        heartCountLabel.text = String(heartCount)
        batteryCountLabel.text = String(batteryCount)
    }


    func makeBoundary(yloc: CGFloat) {
        for i in 0...21 {
            let singleBlock = SKSpriteNode(imageNamed: "block")
            singleBlock.size = CGSize(width: 64, height: 64)
            singleBlock.position = CGPoint(x:singleBlock.frame.size.width/2 + CGFloat(64*i), y: yloc)
            self.addChild(singleBlock)

        }
    }
    
    func setInitialCharacterLoc(){
     //   let character = SKSpriteNode(imageNamed: "app-icon")
        character.size = CGSize(width: 64, height: 64)
        character.position = CGPoint(x:character.frame.size.width/2, y: character.frame.size.height/2 + 64)
        character.physicsBody = SKPhysicsBody(rectangleOf: character.size, center: character.anchorPoint)
        addChild(character)
        character.physicsBody?.isDynamic = true
        character.physicsBody?.affectedByGravity = false
        character.physicsBody?.allowsRotation = false
        
        createCollisionBitmasks(item: "character", node: character)
        
        maze.blockArray[0][0].hasBeenTaken = true
    }
    
    @objc func addRandomBlock(sender: Timer) {
        blockCreationTimer += 1

        addItem(itemToBe: "block")

        if blockCreationTimer == 15 {
            sender.invalidate()
        }
        
    }
    
    @objc func addRocks(sender: Timer) {
        addRockTimer += 1
        
        if addRockTimer % 30 == 0 {
            if rockCount <= 10 {
                rockCount! += 10
                updateLabelCounts()
            } else {
                rockCount = 20
                updateLabelCounts()
            }
        }
    }
    

    func addFood() {
        addItem(itemToBe: "food")
    }
    
    func addStar() {
        addItem(itemToBe: "star")
    }
    
    
    func addItem(itemToBe: String) {
        var randX = Int(arc4random_uniform(20))
        var randY = Int(arc4random_uniform(10))
        
        if maze.blockArray[randX][randY].hasBeenTaken {
            while maze.blockArray[randX][randY].hasBeenTaken {
                randX = Int(arc4random_uniform(20))
                randY = Int(arc4random_uniform(10))
            }
        }
        addNewItem(item: itemToBe , x: randX, y: randY)
        
            maze.blockArray[randX][randY].hasBeenTaken = true
    }
    
    
    func addNewItem(item: String, x: Int, y: Int) {
        let object = SKSpriteNode(imageNamed: item)
        object.size = CGSize(width:64, height:64)
        object.position = CGPoint(x:object.frame.size.width/2 + CGFloat(64*x), y: object.frame.size.width/2 + CGFloat(64*(y+1)))
        object.physicsBody = SKPhysicsBody(rectangleOf: object.size, center: object.anchorPoint)
        self.addChild(object)
        object.physicsBody?.isDynamic = false
        
        createCollisionBitmasks(item: item, node: object)
        
       
    }
    
    func addGestures() {
        let directions: [UISwipeGestureRecognizerDirection] = [.right, .left, .up, .down]
        for direction in directions {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipe(sender:)))
            swipe.direction = direction
        self.view?.addGestureRecognizer(swipe)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(throwRock(sender:)))
        self.view?.addGestureRecognizer(tap)
    }
    
    @objc func throwRock(sender: UITapGestureRecognizer) {
      //  for touch in (touches as! Set<UITouch>) {
        if rockCount > 0 {
            var location = sender.location(in: sender.view)
            location = self.convertPoint(fromView: location)
            print (location)
        
            var rock = SKSpriteNode(imageNamed:"rock")
        
            rock.position = character.position
        
            rock.size = CGSize(width: 40, height: 40)
            rock.physicsBody = SKPhysicsBody(rectangleOf: rock.size)
            self.addChild(rock)
        
            rock.physicsBody?.affectedByGravity = false
        
            createCollisionBitmasks(item: "rock", node: rock)
        
            var dx = CGFloat(location.x - character.position.x)
            var dy = CGFloat(location.y - character.position.y)
        
            let magnitude = sqrt(dx * dx + dy * dy)
        
            dx /= magnitude
            dy /= magnitude
        
            let vector = CGVector(dx: 50 * dx, dy: 50 * dy)
        
            rock.physicsBody?.applyImpulse(vector)
            rockCount! -= 1
            updateLabelCounts()
        }
            
            
 
    }
    
    @objc func respondToSwipe(sender: UISwipeGestureRecognizer) {
        let currentX = character.anchorPoint.x
        let currentY = character.anchorPoint.y
        var newPos: CGFloat
        
        switch sender.direction {
        case UISwipeGestureRecognizerDirection.left:
//            character.removeAction(forKey: "move")
            moveCharacter(xCoordinate: -1302, yCoordinate: currentY)
//            let move = SKAction.moveBy(x: -1302, y: currentY, duration: 10)
//            character.run(move)
//            print("left")
        case UISwipeGestureRecognizerDirection.right:
//            newPos = -1302
//            let move = SKAction.moveBy(x: 1302, y: currentY, duration: 10)
//            character.run(move)
//            print("right")
               moveCharacter(xCoordinate: 1302, yCoordinate: currentY)
        case UISwipeGestureRecognizerDirection.up:
//            let move = SKAction.moveBy(x: currentX, y: 864, duration: 10)
//            character.run(move)
//            print("up")
               moveCharacter(xCoordinate: currentX, yCoordinate: 864)
        case UISwipeGestureRecognizerDirection.down:
//            let move = SKAction.moveBy(x: currentX, y: -864, duration: 10)
//            character.run(move)
//            print("down")
               moveCharacter(xCoordinate: currentX, yCoordinate: -864)
        default:
            break
        }
        
        
    }
    
    func moveCharacter(xCoordinate: CGFloat, yCoordinate: CGFloat) {
        character.removeAction(forKey: "move")
        let move = SKAction.moveBy(x: xCoordinate, y: yCoordinate, duration: 10)
        character.run(move, withKey: "move")
    }
    
    func createCollisionBitmasks(item: String, node: SKSpriteNode){
        switch item {
        case "block":
            node.physicsBody?.categoryBitMask = PhysicsCategory.Block
 //           node.physicsBody?.contactTestBitMask = PhysicsCategory.Rock
       //     node.physicsBody?.collisionBitMask = PhysicsCategory.Rock
        case "food":
            node.physicsBody?.categoryBitMask = PhysicsCategory.FoodStar
        case "star":
            node.physicsBody?.categoryBitMask = PhysicsCategory.FoodStar
        case "rock":
            node.physicsBody?.categoryBitMask = PhysicsCategory.Rock
            node.physicsBody?.collisionBitMask = PhysicsCategory.Rock
   //         node.physicsBody?.contactTestBitMask = PhysicsCategory.Border
        case "character":
            node.physicsBody?.categoryBitMask = PhysicsCategory.Character
            node.physicsBody?.contactTestBitMask = PhysicsCategory.Border | PhysicsCategory.Block
            node.physicsBody?.collisionBitMask = PhysicsCategory.Border | PhysicsCategory.Block
          //  node.physicsBody?.contactTestBitMask = PhysicsCategory.Border | PhysicsCategory.Block
        case "border":
            node.physicsBody?.categoryBitMask = PhysicsCategory.Border
            node.physicsBody?.contactTestBitMask = PhysicsCategory.Character
            node.physicsBody?.collisionBitMask = PhysicsCategory.Rock | PhysicsCategory.Character
        case "water":
            node.physicsBody?.categoryBitMask = PhysicsCategory.Water
         //   node.physicsBody?.contactTestBitMask = PhysicsCategory.Character
        default:
            break
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
//        if (contact.bodyA.categoryBitMask == PhysicsCategory.Rock && contact.bodyB.categoryBitMask == PhysicsCategory.Border) || (contact.bodyB.categoryBitMask == PhysicsCategory.Rock && contact.bodyA.categoryBitMask == PhysicsCategory.Border){
//
//            print("rock hit wall")
//
////            circle.removeAction(forKey: "move")
////
////            circle.physicsBody?.isDynamic = true
//        }
        
        if (contact.bodyA.categoryBitMask == PhysicsCategory.Character && contact.bodyB.categoryBitMask == PhysicsCategory.Border) || (contact.bodyB.categoryBitMask == PhysicsCategory.Character && contact.bodyA.categoryBitMask == PhysicsCategory.Border){
            character.removeAction(forKey: "move")
    
        }
        
        if (contact.bodyA.categoryBitMask == PhysicsCategory.Character && contact.bodyB.categoryBitMask == PhysicsCategory.Block) || (contact.bodyB.categoryBitMask == PhysicsCategory.Character && contact.bodyA.categoryBitMask == PhysicsCategory.Block){
            character.removeAction(forKey: "move")
          //  character.removeAction(forKey: "move")
        }
        
        
//        if (contact.bodyA.categoryBitMask == PhysicsCategory.Ball && contact.bodyB.categoryBitMask == PhysicsCategory.Ground) || (contact.bodyB.categoryBitMask == PhysicsCategory.Ball && contact.bodyA.categoryBitMask == PhysicsCategory.Ground){
//
//            print("Ball hits ground")
//        }
        
    }
    
    
    

    
    
//    func touchDown(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.green
//            self.addChild(n)
//        }
//    }
//
//    func touchMoved(toPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.blue
//            self.addChild(n)
//        }
//    }
//
//    func touchUp(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.red
//            self.addChild(n)
//        }
//    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for touch in (touches as! Set<UITouch>) {
//            let location = touch.location(in: self)
//
//            var rock = SKSpriteNode(imageNamed:"rock")
//
//            rock.position = character.position
//
//            rock.size = CGSize(width: 40, height: 40)
//            rock.physicsBody = SKPhysicsBody(rectangleOf: rock.size)
//            self.addChild(rock)
//
//            rock.physicsBody?.affectedByGravity = false
//
//            createCollisionBitmasks(item: "rock", node: rock)
//
//            var dx = CGFloat(location.x - character.position.x)
//            var dy = CGFloat(location.y - character.position.y)
//
//            let magnitude = sqrt(dx * dx + dy * dy)
//
//            dx /= magnitude
//            dy /= magnitude
//
//            let vector = CGVector(dx: 70 * dx, dy: 70 * dy)
//
//            rock.physicsBody?.applyImpulse(vector)
//
//
//        }
//    }
//
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
//    }
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
//
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
