//
//  GameOver.swift
//  Dino Game
//
//  Created by Joseph Hoang on 4/7/18.
//  Copyright © 2018 Joe Hoang. All rights reserved.
//

import UIKit
import SpriteKit

class GameOver: SKScene {

    var button: UIButton!
    
    init(size: CGSize, won: Bool) {
        super.init(size: size)
        
        let gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameOverLabel.text = (won ? "You Win!" : "You Lose")
        gameOverLabel.fontSize = 60
        
        gameOverLabel.position = CGPoint(x: size.width/2, y: size.height/2)
        self.addChild(gameOverLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//        let flipTransition = SKTransition.doorsCloseHorizontal(withDuration: 1.0)
//        let newScene = GameScene(size: self.size)
//        newScene.scaleMode = .aspectFill
//        
//        self.view?.presentScene(newScene, transition: flipTransition)
//        
//        button.removeFromSuperview()
//        
//        
//    }
}
