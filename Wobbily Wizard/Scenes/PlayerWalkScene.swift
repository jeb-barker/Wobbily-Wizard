//
//  PlayerWalkScene.swift
//  Wobbily Wizard
//
//  Created by Jeb Barker on 10/21/25.
//

import SpriteKit

class PlayerWalkScene: SKScene {
    
    var player: SKSpriteNode!
    var rotatingCircle: SKSpriteNode!
    
    private var playerAtlas: SKTextureAtlas {
        return SKTextureAtlas(named: "Wizard Walk Atlas")
    }
    
    private var playerTexture: SKTexture {
        return playerAtlas.textureNamed("frame_0000")
    }
    
    private var playerIdleTextures: [SKTexture] {
        return [
            playerAtlas.textureNamed("frame_0000"),
            playerAtlas.textureNamed("frame_0001"),
            playerAtlas.textureNamed("frame_0002"),
            playerAtlas.textureNamed("frame_0003"),
            playerAtlas.textureNamed("frame_0004"),
            playerAtlas.textureNamed("frame_0005"),
            playerAtlas.textureNamed("frame_0006"),
            playerAtlas.textureNamed("frame_0007"),
            playerAtlas.textureNamed("frame_0008"),
            playerAtlas.textureNamed("frame_0009"),
            playerAtlas.textureNamed("frame_0010"),
            playerAtlas.textureNamed("frame_0011"),
            playerAtlas.textureNamed("frame_0012"),
            playerAtlas.textureNamed("frame_0013"),
            playerAtlas.textureNamed("frame_0014"),
            playerAtlas.textureNamed("frame_0015"),
            playerAtlas.textureNamed("frame_0016"),
            playerAtlas.textureNamed("frame_0017"),
            playerAtlas.textureNamed("frame_0018"),
            playerAtlas.textureNamed("frame_0019"),
            playerAtlas.textureNamed("frame_0020"),
            playerAtlas.textureNamed("frame_0021"),
            playerAtlas.textureNamed("frame_0022"),
        ]
    }
    
    private func setupPlayer() {
        player = SKSpriteNode(texture: playerTexture)
        player.position = CGPoint(x: frame.width/2, y: frame.height * (2/3))
        player.size.width = frame.width * (2/5)
        player.size.height = frame.height * (2/5)
        player.scale(to: player.size)
        
        addChild(player)
    }
    
    private func setupRotatingCircle() {
        // Create the rotating image node
        rotatingCircle = SKSpriteNode(imageNamed: "home_globe")
        rotatingCircle.position = CGPoint(x: frame.width/2, y: -frame.height/2)
        rotatingCircle.size = CGSize(width: frame.width * 2, height: frame.width * 2)
        rotatingCircle.zPosition = -1 // make sure player is rendered over top of the globe
        
        addChild(rotatingCircle)
    }
    
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.clear
        self.scaleMode = .aspectFill
        
        self.setupRotatingCircle()
        self.setupPlayer()
        self.startIdleAnimation()
        self.startCircleRotation()
    }
    
    private func startCircleRotation() {
        let rotate = SKAction.rotate(byAngle: CGFloat.pi * 2, duration: 120.0)
        let repeatRotation = SKAction.repeatForever(rotate)
        rotatingCircle.run(repeatRotation)
    }
    
    func startIdleAnimation() {
        let idleAnimation = SKAction.animate(with: playerIdleTextures, timePerFrame: 0.05)
        
        player.run(SKAction.repeatForever(idleAnimation), withKey: "playerWizardWalk")
    }
}
