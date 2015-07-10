//
//  MainMenu.swift
//  BouncingBall
//
//  Created by FRED WANG on 7/10/15.
//  Copyright (c) 2015 HouseMixer. All rights reserved.
//

import SpriteKit

class MainMenu : SKScene{
    override func didMoveToView(view: SKView) {
      
        
        let fakebutton = SKSpriteNode(imageNamed: "titletaco")
        fakebutton.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        fakebutton.size = CGSize(width: self.size.width/2, height: self.size.height/5)
        addChild(fakebutton)
        // more labels
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let highScore: Float? = NSUserDefaults.valueForKey("TacoHighScore") as! Float?
        if highScore != nil{
            // there is high score
            let highScoreLabel = SKLabelNode(text: String(format: "High Score: ", highScore as Float!))
            highScoreLabel.position = CGPoint(x: 75, y: self.size.height - 75)
            highScoreLabel.fontSize = 24
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let reveal = SKTransition.flipHorizontalWithDuration(0.5) // quick flip
        let gameOverScene = GameScene(size: self.size)// make the scene
        self.view?.presentScene(gameOverScene, transition: reveal)
    }
}
