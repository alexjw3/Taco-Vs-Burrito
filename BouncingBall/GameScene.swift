//
//  GameScene.swift
//  BouncingBall
//
//  Created by Jack Youstra on 12/28/14.
//  Copyright (c) 2014 HouseMixer. All rights reserved.
//

import SpriteKit
import AVFoundation

struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Ball      : UInt32 = 0b1
    static let Wall      : UInt32 = 0b10
    static let Dagger    : UInt32 = 0b100
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let pokeball = SKSpriteNode(imageNamed: "Pokeball")
    
    let popSoundLocation = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bubblepop", ofType: "mp3")!)
    var bumpAudioPlayer = AVAudioPlayer()
    
    let backgroundSoundLocation = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Background theme", ofType: "mp3")!)
    var backgroundAudioPlayer = AVAudioPlayer()
    
    override func didMoveToView(view: SKView) {
        // prepare audio
        bumpAudioPlayer = AVAudioPlayer(contentsOfURL: popSoundLocation, error: nil)
        bumpAudioPlayer.prepareToPlay()
        
        backgroundAudioPlayer = AVAudioPlayer(contentsOfURL: backgroundSoundLocation, error: nil)
        backgroundAudioPlayer.prepareToPlay()
        backgroundAudioPlayer.play()
        
        backgroundColor = SKColor.whiteColor()
        
        pokeball.position = CGPoint(x: size.width * 0.2, y: size.height * 0.5)
        pokeball.setScale(0.25)
        
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: frame);  //Physics body of Scene
        // wall collision detecting
        self.physicsBody?.categoryBitMask = PhysicsCategory.Wall // what it is
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Ball // what should be registered
        self.physicsBody?.collisionBitMask = PhysicsCategory.None // what bouncing should be handled by physics engine
        
        pokeball.physicsBody = SKPhysicsBody(circleOfRadius: pokeball.frame.width/2);
        pokeball.physicsBody?.dynamic = true;
        pokeball.physicsBody?.friction = 0.0 // changeable from here onward
        pokeball.physicsBody?.restitution = 1.0 // bouncy
        pokeball.physicsBody?.linearDamping = 0.5 // air resistance
        pokeball.physicsBody?.angularDamping = 0.1 // rotation resistance
        
        // collision detecting
        pokeball.physicsBody?.categoryBitMask = PhysicsCategory.Ball
        pokeball.physicsBody?.contactTestBitMask = PhysicsCategory.Dagger | PhysicsCategory.Wall
        pokeball.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        addChild(pokeball)
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -4.8)
        
        var block = { () -> Void in
            let x = CGFloat(arc4random()%UInt32(self.frame.width))
            let y = self.frame.height*0.95
            self.createDagger(CGPoint(x: x, y: y))
        }
        var actionBuilder = SKAction.runBlock(block)
        
        actionBuilder = SKAction.sequence([
            SKAction.waitForDuration(0.5),
            actionBuilder
        ])
        
        actionBuilder = SKAction.repeatActionForever(actionBuilder)
        runAction(actionBuilder)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        // play audio
        bumpAudioPlayer.play()
        
        /* Called when a touch begins */
        let touch: AnyObject! = touches.anyObject() // guarunteed to be a touch
        let touchLocation = touch.locationInNode(self) // get location
        let x = pokeball.position.x - touchLocation.x
        let y = pokeball.position.y - touchLocation.y
        pokeball.physicsBody?.applyImpulse(CGVector(dx: x, dy: y), atPoint: touchLocation)
        
        
    }
    
    func createDagger(point: CGPoint) -> Void{
        let dagger = SKSpriteNode(imageNamed: "IronDagger_SK")
        dagger.position = point
        dagger.setScale(0.05)
        dagger.zRotation = CGFloat(M_PI)
        
        dagger.physicsBody = SKPhysicsBody(rectangleOfSize: dagger.frame.size)
        // collision detecting
        dagger.physicsBody?.categoryBitMask = PhysicsCategory.Dagger
        dagger.physicsBody?.contactTestBitMask = PhysicsCategory.Ball
        dagger.physicsBody?.collisionBitMask = PhysicsCategory.None
        addChild(dagger)
    }

    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
    }
    
    // protocol method
    func didBeginContact(contact: SKPhysicsContact) {
        // something collided, end game
        //println("quit") REPLACED
        self.gameOver()
    }
    
    func gameOver(){
        backgroundAudioPlayer.stop()
        let reveal = SKTransition.flipHorizontalWithDuration(0.5) // quick flip
        let gameOverScene = GameOverScene(size: self.size)// make the scene
        self.view?.presentScene(gameOverScene, transition: reveal)
    }
}




