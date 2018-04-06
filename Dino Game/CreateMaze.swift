//
//  CreateMaze.swift
//  Dino Game
//
//  Created by Joseph Hoang on 4/5/18.
//  Copyright © 2018 Joe Hoang. All rights reserved.
//

import Foundation
import SpriteKit

class CreateMaze {
    var blockArray: [[SingleBlockLoc]] = [[SingleBlockLoc]]()
    
    init() {
       setupGrid()
    }
    
    
    func setupGrid(){

        for i in 0...20 {
            var newArray = [SingleBlockLoc]()
            for j in 0...10 {
                var val = SingleBlockLoc()
                val.locationY = i
                val.locationX = j
                val.hasBeenTaken = false
                newArray.append(val)
            }
            blockArray.append(newArray)
        }
    }
    
    func addNewBlock(x: Int, y: Int) {
//        let singleBlock = SKSpriteNode(imageNamed: "block")
//        singleBlock.size = CGSize(width: 64, height: 64)
//        singleBlock.position = CGPoint(x:singleBlock.frame.size.width/2 + CGFloat(64*x), y: singleBlock.frame.size.width/2 + CGFloat(64*(y+1)))
//        //     singleBlock.physicsBody = SKPhysicsBody(rectangleOf: singleBlock.size, center: singleBlock.position)
//        GameScene.addChild(singleBlock)
        blockArray[x][y].hasBeenTaken = false
    }
    
    
}
