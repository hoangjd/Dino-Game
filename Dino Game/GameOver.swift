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
    var starCount: Int!
    
    init(size: CGSize, starCount: Int!) {
        super.init(size: size)
        
        let gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
        let score = SKLabelNode(fontNamed: "Chalkduster")
        gameOverLabel.text = ("GameOver")
        score.text = String(starCount!)
        
        gameOverLabel.fontSize = 60
        score.fontSize = 40
        
        gameOverLabel.position = CGPoint(x: size.width/2, y: size.height/2 + 100)
        score.position = CGPoint(x: size.width/2, y: size.height/2 )
    
        self.addChild(gameOverLabel)
        self.addChild(score)
        
        let flipTransition = SKTransition.doorsCloseHorizontal(withDuration: 1.0)
        let newScene = GameScene(size: self.size)
        newScene.scaleMode = .aspectFill
        
        self.view?.presentScene(newScene, transition: flipTransition)
        
        
        
    //    button.removeFromSuperview()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {
        button = UIButton(frame: CGRect(x: self.size.width/2 - 142, y: size.height/2 + 50, width: 300, height: 100))
        button.titleLabel?.font = UIFont(name: "chalkDuster", size: 30)
        button.setTitle("Begin New Game", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(goBack(sender:)), for: .touchUpInside)

        self.view?.addSubview(button)
        
        
    }
    
    @objc func goBack(sender: UIButton) {
        let flipTransition = SKTransition.doorsCloseHorizontal(withDuration: 1.0)
        let newScene = GameScene(size: self.size)
        newScene.scaleMode = .aspectFill
        
        self.view?.presentScene(newScene, transition: flipTransition)
        button.removeFromSuperview()
    }
    
    
}
