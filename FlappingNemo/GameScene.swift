//
//  GameScene.swift
//  SplashyFish
//
//  Created by Tyler Blair on 2017-03-10.
//  Copyright © 2017 Tyler Blair. All rights reserved.
//

import SpriteKit
import GameplayKit

protocol GameViewControllerDelegate: class {
    func callMethod(inputProperty:String)
}

enum GameState {
    case showingLogo
    case playing
    case dead
}


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    weak var gameViewControllerDelegate:GameViewControllerDelegate?
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var bubbleLabel: SKLabelNode!
    
    var backgroundMusic: SKAudioNode!
    var logo: SKSpriteNode!
    var gameOver: SKSpriteNode!
    
    var gameState = GameState.showingLogo
    var clicks = 0 {
        didSet {
            bubbleLabel.text = "BUBBLES: \(clicks)"
        }
    }
    var score = 0 {
        didSet {
            scoreLabel.text = "SCORE: \(score)"
        }
    }
    
    var canJelly = true
    var canBird = true
    //set to 5
    var jellyStartCount = 5
    //set to 20
    var birdStartCount = 20
    var maxClicks = 10
    
    
    override func didMove(to view: SKView) {
        
       
        createPlayer()
        createSea()
        createBackground()
        createGround()
        //startRocks()
        createScore()
        createBubbles()
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)
        physicsWorld.contactDelegate = self
        //gameViewControllerDelegate?.callMethod(inputProperty: "call game view controller method")
        if let musicURL = Bundle.main.url(forResource: "music", withExtension: "m4a") {
            //UNCOMMENT THIS IS FOR MY SOUNDS
            backgroundMusic = SKAudioNode(url: musicURL)
            addChild(backgroundMusic)
        }
        createLogos()
        
    }
    func createPlayer() {
        let playerTexture = SKTexture(imageNamed: "player-1")
        player = SKSpriteNode(texture: playerTexture)
        player.zPosition = 10
        player.position = CGPoint(x: frame.width / 6, y: frame.height * 0.75)
        
        addChild(player)
        
        player.physicsBody = SKPhysicsBody(texture: playerTexture, size: playerTexture.size())
        player.physicsBody!.contactTestBitMask = player.physicsBody!.collisionBitMask
        player.physicsBody?.isDynamic = false
        
        ///REMOVE TO MAKE HIM NOT DIE ON IMPACT
        player.physicsBody?.collisionBitMask = 0
        
        let frame2 = SKTexture(imageNamed: "player-2")
        let frame3 = SKTexture(imageNamed: "player-3")
        let animation = SKAction.animate(with: [playerTexture, frame2, frame3, frame2], timePerFrame: 0.01)
        let runForever = SKAction.repeatForever(animation)
        
        player.run(runForever)
    }
    func createSea() {
        let topSky = SKSpriteNode(color: UIColor(hue: 0.65, saturation: 0.14, brightness: 0.97, alpha: 1), size: CGSize(width: frame.width, height: frame.height * 0.33))
        topSky.anchorPoint = CGPoint(x: 0.5, y: 1)
        
        let bottomSea = SKSpriteNode(color: UIColor(hue: 0.55, saturation: 0.16, brightness: 0.90, alpha: 1), size: CGSize(width: frame.width, height: frame.height * 0.67))
        topSky.anchorPoint = CGPoint(x: 0.5, y: 1)
        
        topSky.position = CGPoint(x: frame.midX, y: frame.height)
        bottomSea.position = CGPoint(x: frame.midX, y: bottomSea.frame.height / 2)
        
        addChild(topSky)
        addChild(bottomSea)
        
        bottomSea.zPosition = -40
        topSky.zPosition = -40
    }
    
    func createBackground() {
        let backgroundTexture = SKTexture(imageNamed: "background2")
        
        for i in 0 ... 1 {
            let background = SKSpriteNode(texture: backgroundTexture)
            background.zPosition = -30
            background.anchorPoint = CGPoint.zero
            background.position = CGPoint(x: (backgroundTexture.size().width * CGFloat(i)) - CGFloat(1 * i), y: 400)
            addChild(background)
            let moveLeft = SKAction.moveBy(x: -backgroundTexture.size().width, y: 0, duration: 20)
            let moveReset = SKAction.moveBy(x: backgroundTexture.size().width, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            
            background.run(moveForever)
        }
    }
    func createGround() {
        let groundTexture = SKTexture(imageNamed: "ground2")
        
        for i in 0 ... 1 {
            let ground = SKSpriteNode(texture: groundTexture)
            ground.zPosition = -10
            ground.position = CGPoint(x: (groundTexture.size().width / 2.0 + (groundTexture.size().width * CGFloat(i))), y: groundTexture.size().height / 2)
            
            ground.physicsBody = SKPhysicsBody(texture: ground.texture!, size: ground.texture!.size())
            ground.physicsBody?.isDynamic = false
            
            addChild(ground)
            
            let moveLeft = SKAction.moveBy(x: -groundTexture.size().width, y: 0, duration: 5)
            let moveReset = SKAction.moveBy(x: groundTexture.size().width, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            
            ground.run(moveForever)
        }
    }
    
    func createBird(){
        let birdTexture = SKTexture(imageNamed: "Bird1-1")
        let bird = SKSpriteNode(texture: birdTexture)
        bird.physicsBody = SKPhysicsBody(texture: birdTexture, size: birdTexture.size())
        bird.physicsBody?.isDynamic = false
        bird.zPosition = frame.height
        addChild(bird)
        
        let xPosition = frame.width + bird.frame.width
        
        let max = Int(frame.height)
        let min = Int(frame.height / 2 + bird.frame.height)
        let rand = GKRandomDistribution(lowestValue: min, highestValue: max)
        
        
        let yPosition = CGFloat(rand.nextInt())
        
        
        // this next value affects the width of the gap between rocks
        // make it smaller to make your game harder – if you're feeling evil!
        let birdDistance: CGFloat = 50
        
        bird.position = CGPoint(x: xPosition, y: yPosition - birdDistance)
        //jellyFish.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        
        
        let endPosition = frame.width + (bird.frame.width * 2)
        
        let moveAction = SKAction.moveBy(x: -endPosition, y: 0, duration: 8.5)
        let moveSequence = SKAction.sequence([moveAction, SKAction.removeFromParent()])
        let frame2 = SKTexture(imageNamed: "Bird1-2")
        let frame3 = SKTexture(imageNamed: "Bird1-3")
        let animation = SKAction.animate(with: [birdTexture, frame2, frame2, frame3,frame3, birdTexture], timePerFrame: 0.01)
        let runForever = SKAction.repeatForever(animation)
        bird.run(moveSequence)
        bird.run(runForever)
        
    }
    func startBird() {
        
        let create = SKAction.run { [unowned self] in
            self.createBird()
        }
        
        let wait = SKAction.wait(forDuration: 4)
        let sequence = SKAction.sequence([create, wait])
        let repeatForever = SKAction.repeatForever(sequence)
        
        run(repeatForever)
        
    }
    
    
    
    func createJellyFish(){
        let jellyTexture = SKTexture(imageNamed: "JellyFish1-1")
        let jellyFish = SKSpriteNode(texture: jellyTexture)
        jellyFish.physicsBody = SKPhysicsBody(texture: jellyTexture, size: jellyTexture.size())
        jellyFish.physicsBody?.isDynamic = false
        jellyFish.zPosition = -10
        
        addChild(jellyFish)
        
        let xPosition = frame.width + jellyFish.frame.width
        
        let max = Int(frame.height / 2)
        let rand = GKRandomDistribution(lowestValue: 0, highestValue: max)
        
        
        let yPosition = CGFloat(rand.nextInt())
        
        
        // this next value affects the width of the gap between rocks
        // make it smaller to make your game harder – if you're feeling evil!
        let jellyDistance: CGFloat = 30
        
        jellyFish.position = CGPoint(x: xPosition, y: yPosition - jellyDistance)
        //jellyFish.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        
        
        let endPosition = frame.width + (jellyFish.frame.width * 2)
        
        let moveAction = SKAction.moveBy(x: -endPosition, y: 0, duration: 3.2)
        let moveSequence = SKAction.sequence([moveAction, SKAction.removeFromParent()])
        let frame2 = SKTexture(imageNamed: "JellyFish1-2")
        let frame3 = SKTexture(imageNamed: "JellyFish1-3")
        let animation = SKAction.animate(with: [jellyTexture, frame2, frame2, frame3], timePerFrame: 0.01)
        let runForever = SKAction.repeatForever(animation)
        jellyFish.run(moveSequence)
        jellyFish.run(runForever)
        
    }
    func startJellyFish() {
       
        let create = SKAction.run { [unowned self] in
            self.createJellyFish()
        }
        
        let wait = SKAction.wait(forDuration: 2)
        let sequence = SKAction.sequence([create, wait])
        let repeatForever = SKAction.repeatForever(sequence)

        
        run(repeatForever)
        
    }
    
    
    
    func createRocks() {
        // 1
        let rockTexture = SKTexture(imageNamed: "rock")
        
        let topRock = SKSpriteNode(texture: rockTexture)
        topRock.physicsBody = SKPhysicsBody(texture: rockTexture, size: rockTexture.size())
        topRock.physicsBody?.isDynamic = false
        topRock.zRotation = CGFloat.pi
        topRock.xScale = -1.0
        
        let bottomRock = SKSpriteNode(texture: rockTexture)
        bottomRock.physicsBody = SKPhysicsBody(texture: rockTexture, size: rockTexture.size())
        bottomRock.physicsBody?.isDynamic = false
        
        topRock.zPosition = -20
        bottomRock.zPosition = -20
        
        // 2
        let rockCollision = SKSpriteNode(color: UIColor.red, size: CGSize(width: 32, height: frame.height))
        rockCollision.physicsBody = SKPhysicsBody(rectangleOf: rockCollision.size)
        rockCollision.physicsBody?.isDynamic = false
        rockCollision.name = "scoreDetect"
        rockCollision.isHidden = true
        
        //addChild(topRock)
        addChild(bottomRock)
        addChild(rockCollision)
        
        // 3
        let xPosition = frame.width + topRock.frame.width
        
        let max = Int(frame.height / 2 )
        let rand = GKRandomDistribution(lowestValue: -100, highestValue: max)
        let yPosition = CGFloat(rand.nextInt())
        
        // this next value affects the width of the gap between rocks
        // make it smaller to make your game harder – if you're feeling evil!
        let rockDistance: CGFloat = 70
        
        // 4
        topRock.position = CGPoint(x: xPosition, y: yPosition + topRock.size.height + rockDistance)
        bottomRock.position = CGPoint(x: xPosition, y: yPosition - rockDistance)
        rockCollision.position = CGPoint(x: xPosition + (rockCollision.size.width * 2), y: frame.midY)
        
        let endPosition = frame.width + (topRock.frame.width * 2)
        
        let moveAction = SKAction.moveBy(x: -endPosition, y: 0, duration: 6.2)
        let moveSequence = SKAction.sequence([moveAction, SKAction.removeFromParent()])
        
        //topRock.run(moveSequence)
        bottomRock.run(moveSequence)
        rockCollision.run(moveSequence)
    }
    func startRocks() {
        let create = SKAction.run { [unowned self] in
            self.createRocks()
        }
        
        let wait = SKAction.wait(forDuration: 3)
        let sequence = SKAction.sequence([create, wait])
        let repeatForever = SKAction.repeatForever(sequence)
        
        run(repeatForever)
    }
    
    func createScore() {
        scoreLabel = SKLabelNode(fontNamed: "Optima-ExtraBlack")
        scoreLabel.fontSize = 24
        
        scoreLabel.position = CGPoint(x: frame.maxX - 20, y: frame.maxY - 40)
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.text = "SCORE: 0"
        scoreLabel.fontColor = UIColor.black
        
        addChild(scoreLabel)
    }
    
    func createBubbles() {
        bubbleLabel = SKLabelNode(fontNamed: "Optima-ExtraBlack")
        bubbleLabel.fontSize = 24
        
        bubbleLabel.position = CGPoint(x: frame.maxX - 20, y: frame.maxY - 60)
        bubbleLabel.horizontalAlignmentMode = .right
        bubbleLabel.text = "BUBBLES: 0"
        bubbleLabel.fontColor = UIColor.black
        
        addChild(bubbleLabel)
    }
    
    func createLogos() {
        logo = SKSpriteNode(imageNamed: "logo")
        logo.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(logo)
        
        gameOver = SKSpriteNode(imageNamed: "gameover")
        gameOver.position = CGPoint(x: frame.midX, y: frame.midY)
        gameOver.alpha = 0
        addChild(gameOver)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch gameState {
        case .showingLogo:
            gameState = .playing
            
            let fadeOut = SKAction.fadeOut(withDuration: 0.5)
            let remove = SKAction.removeFromParent()
            let wait = SKAction.wait(forDuration: 0.5)
            let activatePlayer = SKAction.run { [unowned self] in
                self.player.physicsBody?.isDynamic = true
                self.startRocks()
                //self.startJellyFish()
                //self.startBird()
                
            }
            
            let sequence = SKAction.sequence([fadeOut, wait, activatePlayer, remove])
            logo.run(sequence)
            
        case .playing:
            
            player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            if (self.score > jellyStartCount && self.canJelly == true){
                self.canJelly = false
                self.startJellyFish()

            }
            if (self.score > birdStartCount && self.canBird == true){
                self.canBird = false
                self.startBird()
                
            }
            ///check to see where the player is and changes tap power!!!!
            if (player.position.y > frame.height / 2){
                
                if ((clicks > 0) && player.position.y > (frame.height / 2 )){
                    player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 10 + clicks))
                    clicks = clicks - 1
                }
                else{player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 0))}
                
            }
            else if(player.position.y < frame.height / 2 ){
                player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 20))
            }
            
            
        case .dead:
            //gameViewControllerDelegate?.callMethod(inputProperty: "call game view controller method")
            let scene = GameScene(fileNamed: "GameScene")!
            let transition = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 1)
            self.view?.presentScene(scene, transition: transition)
            
            
            
            
            
            
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "scoreDetect" || contact.bodyB.node?.name == "scoreDetect" {
            if contact.bodyA.node == player {
                contact.bodyB.node?.removeFromParent()
            } else {
                contact.bodyA.node?.removeFromParent()
            }
            
            
            score += 1
            
            return
        }
        
        guard contact.bodyA.node != nil && contact.bodyB.node != nil else {
            return
        }
        if contact.bodyA.node == player || contact.bodyB.node == player {
            if let explosion = SKEmitterNode(fileNamed: "PlayerExplosion") {
                explosion.position = player.position
                addChild(explosion)
            }
            
            let sound = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
            run(sound)
            
            gameOver.alpha = 1
            gameState = .dead
            backgroundMusic.run(SKAction.stop())
            speed = 0
            canJelly = true
            canBird = true
            //Changes back to main viewcontroller by seding Die message
            gameViewControllerDelegate?.callMethod(inputProperty: "Die")
            player.removeFromParent()
          
        }
    }
    override func update(_ currentTime: TimeInterval) {
        if (player.position.y < (frame.height / 2 + player.frame.height)){
            clicks = maxClicks
        }
        guard player != nil else { return }
        let value = player.physicsBody!.velocity.dy * 0.001
        let rotate = SKAction.rotate(toAngle: value, duration: 0.1)
        
        player.run(rotate)
    }
}
