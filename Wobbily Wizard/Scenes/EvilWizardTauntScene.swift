//
//  EvilWizardTauntScene.swift
//  Wobbily Wizard
//
//  Created by Jeb Barker on 11/10/25.
//

import SpriteKit

class EvilWizardTauntScene: SKScene {
    
    var evilWizard: SKSpriteNode!
    
    private var wizardAtlas: SKTextureAtlas {
        return SKTextureAtlas(named: "Evil Wizard Taunt Atlas")
    }
    
    private var wizardTexture: SKTexture {
        return wizardAtlas.textureNamed("frame_0000")
    }
    
    private var playerIdleTextures: [SKTexture] {
        return [
            wizardAtlas.textureNamed("wiz_frame_0000"),
            wizardAtlas.textureNamed("wiz_frame_0001"),
            wizardAtlas.textureNamed("wiz_frame_0002"),
            wizardAtlas.textureNamed("wiz_frame_0003"),
            wizardAtlas.textureNamed("wiz_frame_0004"),
            wizardAtlas.textureNamed("wiz_frame_0005"),
            wizardAtlas.textureNamed("wiz_frame_0006"),
            wizardAtlas.textureNamed("wiz_frame_0007"),
            wizardAtlas.textureNamed("wiz_frame_0008"),
            wizardAtlas.textureNamed("wiz_frame_0009"),
            wizardAtlas.textureNamed("wiz_frame_0010"),
            wizardAtlas.textureNamed("wiz_frame_0011"),
        ]
    }
    
    private func setupWizard() {
        evilWizard = SKSpriteNode(texture: wizardTexture)
        evilWizard.position = CGPoint(x: frame.width/2, y: frame.height/2)
        evilWizard.size.width = frame.width * (2/3)
        evilWizard.size.height = frame.height * (2/3)
        
        addChild(evilWizard)
    }
    
    
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.clear
        self.scaleMode = .aspectFill
        
        self.setupWizard()
        self.startAnimation()
    }
    
    
    func startAnimation() {
        let idleAnimation = SKAction.animate(with: playerIdleTextures, timePerFrame: 0.1)
        
        evilWizard.run(SKAction.repeatForever(idleAnimation), withKey: "EvilWizardTaunt")
    }
}
