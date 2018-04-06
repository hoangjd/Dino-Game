//
//  GameScene.swift
//  Dino Game
//
//  Created by Joseph Hoang on 4/5/18.
//  Copyright © 2018 Joe Hoang. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var maze = CreateMaze()
    var blockCreationTimer = 0
    
    override func didMove(to view: SKView) {
        maze = CreateMaze()
        blockCreationTimer = 0
        makeBackground()
        makeBounderies()
        startBlockTimer()
        setInitialCharacterLoc()

        
//        var circle = SKShapeNode!
//        var circle = SKShapeNode(circleOfRadius: 30)
//        circle.fillColor = SKColor.blue
//        circle.position = CGPoint(x: 200, y: 700)
//        addChild(circle)
//        circle.physicsBody = SKPhysicsBody(circleOfRadius: circle.frame.width/2)

       
    }
    
    func startBlockTimer() {
        var blockCreationTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(addRandomBlock(sender:)), userInfo: nil, repeats: true)
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
        
        let boundTop = SKNode()
        boundTop.position = CGPoint(x: self.frame.width/2, y: 896)
        boundTop.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height:1))
                addChild(boundTop)
        boundTop.physicsBody?.isDynamic = false
      
        let boundBottom = SKNode()
        boundBottom.position = CGPoint(x: self.frame.width/2, y: 64)
        boundBottom.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height:1))
          addChild(boundBottom)
        boundBottom.physicsBody?.isDynamic = false
        
        let boundLeft = SKNode()
        boundLeft.position = CGPoint(x: 0, y:self.frame.height/2)
        boundLeft.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height:self.frame.height))
        addChild(boundLeft)
        
        let boundRight = SKNode()
        boundRight.position = CGPoint(x: 1344, y:self.frame.height/2)
        boundRight.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height:self.frame.height))
        addChild(boundRight)

        
        
        makeBoundary(yloc: bottom)
        makeBoundary(yloc: top)
        makeBoundary(yloc: top1)
        
    }
    func makeBoundary(yloc: CGFloat) {
        for i in 0...21 {
            let singleBlock = SKSpriteNode(imageNamed: "block")
            singleBlock.size = CGSize(width: 64, height: 64)
            singleBlock.position = CGPoint(x:singleBlock.frame.size.width/2 + CGFloat(64*i), y: yloc)
       //     singleBlock.physicsBody = SKPhysicsBody(rectangleOf: singleBlock.size, center: singleBlock.position)
            self.addChild(singleBlock)
      //      singleBlock.physicsBody?.isDynamic = false
        }
    }
    
    func setInitialCharacterLoc(){
        let character = SKSpriteNode(imageNamed: "app-icon")
        character.size = CGSize(width: 64, height: 64)
        character.position = CGPoint(x:character.frame.size.width/2, y: character.frame.size.height/2 + 64)
        addChild(character)
        maze.blockArray[0][0].hasBeenTaken = true
    }
    
    @objc func addRandomBlock(sender: Timer) {
        blockCreationTimer += 1

        addItem(itemToBe: "block")

        if blockCreationTimer == 15 {
            sender.invalidate()
        }
        
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
        object.physicsBody = SKPhysicsBody(rectangleOf: object.size, center: object.position)
        addChild(object)
        object.physicsBody?.isDynamic = false
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
//        if let label = self.label {
//            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//        }
//
//        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
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
