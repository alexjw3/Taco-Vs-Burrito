//
//  GameOverScene.swift
//  BouncingBall
//
//  Created by Jack Youstra on 12/29/14.
//  Copyright (c) 2014 HouseMixer. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    override init(size: CGSize){
        super.init(size: size)
        
        backgroundColor = SKColor.whiteColor()
        let message = "You Lost :["
        
        // a node that represents a block of text.
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = message
        label.fontSize = 40
        label.fontColor = SKColor.redColor()
        label.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        addChild(label)
        
        let endButton = SKSpriteNode(imageNamed: "ok_button");
        endButton.name = "ok_button_name"; // only change if change down below too in touchesbegan
        endButton.setScale(0.3);
        endButton.position = CGPoint(x: self.size.width/2, y: self.size.height/3)
        addChild(endButton);
    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touch: UITouch! = touches.anyObject() as UITouch!;
        let location = touch?.locationInNode(self) as CGPoint!;
        let nodeAtTouch = self.nodeAtPoint(location);
        if nodeAtTouch.name == "ok_button_name"{
            let restartAction = SKAction.runBlock { () -> Void in
                let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                let scene = GameScene(size: self.size) // referrs to previous scene
                self.view?.presentScene(scene, transition: reveal)
            }
            self.runAction(restartAction);
        }
        
    }
    
    required init (coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}