//
//  GameOverScene.swift
//  BouncingBall
//
//  Created by Jack Youstra on 12/29/14.
//  Copyright (c) 2014 HouseMixer. All rights reserved.
//

import AVFoundation
import SpriteKit

class GameOverScene: SKScene {
    let backgroundSoundLocation = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("kirbydeathsound", ofType: "mp3")!)
    var backgroundAudioPlayer = AVAudioPlayer()
    
    override init(size: CGSize){
        super.init(size: size)
        
        backgroundColor = SKColor.whiteColor()
        let message = "You Lost :("
        // a node that represents a block of text.
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = message
        label.fontSize = 40
        label.fontColor = SKColor.redColor()
        label.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        addChild(label)
        
        backgroundColor = SKColor.whiteColor()
        // a node that represents a block of text.
        let label2 = SKLabelNode(fontNamed: "Chalkduster")
        label2.text = "Tap Taco to Begin"
        label2.fontSize = 28
        label2.fontColor = SKColor.redColor()
        label2.position = CGPoint(x: self.size.width/2, y: self.size.height/15)
        addChild(label2)
        
        let endButton = SKSpriteNode(imageNamed: "TacoBackground.jpg");
        endButton.name = "ok_button_name"; // only change if change down below too in touchesbegan
        endButton.setScale(0.8);
        endButton.position = CGPoint(x: self.size.width/1.8, y: self.size.height/3)
        addChild(endButton);
        
        let highScore = NSUserDefaults.standardUserDefaults().objectForKey("TacoHighScore") as! Float!
        let highScoreLabel = SKLabelNode(text: "High Score: \(highScore)")
        highScoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/1.1)
        highScoreLabel.fontSize = 40
        highScoreLabel.fontColor = SKColor.blackColor()
        addChild(highScoreLabel)
    }

    override func didMoveToView(view: SKView) {
        backgroundAudioPlayer = AVAudioPlayer(contentsOfURL: backgroundSoundLocation, error: nil)
        backgroundAudioPlayer.prepareToPlay()
        backgroundAudioPlayer.play()
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch: UITouch! = touches.first as! UITouch!;
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