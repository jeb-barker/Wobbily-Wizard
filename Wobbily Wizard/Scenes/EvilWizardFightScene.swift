//
//  EvilWizardFightScene.swift
//  Wobbily Wizard
//
//  Created by Jeb Barker on 11/11/25.
//

import SpriteKit

class EvilWizardFightScene: SKScene {
    
    var evilWizard: SKSpriteNode!
    var crystalBall: SKLabelNode!
    var circles : [SKShapeNode]?
    var circleLabels : [SKLabelNode]?
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        evilWizard.zPosition = -2
        
        addChild(evilWizard)
    }
    
    func loadCircles() {
        circles = []
        circleLabels = []
        
        let centerx = frame.width/2
        let centery = frame.height/4
        let radius = frame.width/10
        let thetaStep = (2*Double.pi)/5
        
        let crystalBall = SKShapeNode(circleOfRadius: radius*1.6)
        crystalBall.position = CGPoint(x: centerx, y: centery)
        crystalBall.strokeColor = .blue
        crystalBall.fillColor = .blue
        crystalBall.zPosition = -1
        addChild(crystalBall)
        
        //we can use the bang operator (!) since we know that circles has a value of []
        for i in 0 ..< 5 {
            //Circles
            circles!.append(SKShapeNode(circleOfRadius: 20))
            let px = centerx + cos(thetaStep * Double(i) + Double.pi/2) * radius
            let py = centery + sin(thetaStep * Double(i) + Double.pi/2) * radius
            circles![i].position =
            CGPoint(x: px, y: py)
            circles![i].strokeColor = circles![i].strokeColor.withAlphaComponent(1) // start transparent
            circles![i].lineWidth = 3
            addChild(circles![i])
            
            //Circle Labels
            circleLabels!.append(SKLabelNode(fontNamed: "Chalkduster"))
            circleLabels![i].text = "\(i+1)"
            circleLabels![i].fontSize = 20
            circleLabels![i].fontColor = SKColor.white
            circleLabels![i].fontColor = circleLabels![i].fontColor?.withAlphaComponent(0)
            circleLabels![i].position = CGPoint(x: px, y: py)
            circleLabels![i].zPosition = 1
            addChild(circleLabels![i])
        }
    }
    
    func updateCircles(enemyShape: [Int]) {
        if let circles, let circleLabels {
            
            for circleLabel in circleLabels {
                circleLabel.text = ""
            }
            
            for (i, candleNum) in enemyShape.enumerated() {
                circles[candleNum].fillColor = .white
                //set the color of the labels to blue
                circleLabels[candleNum].fontColor = .blue
                //set the text of the label to the ordering
                if circleLabels[candleNum].text == "" {
                    circleLabels[candleNum].text! += "\(i+1)"
                }
                else {
                    circleLabels[candleNum].text! += ", \(i+1)"
                }
                
            }
        }
    }
    
    
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.clear
        self.scaleMode = .aspectFit
        
        self.setupWizard()
        self.startAnimation()
        self.loadCircles()
    }
    
    
    func startAnimation() {
        let idleAnimation = SKAction.animate(with: playerIdleTextures, timePerFrame: 0.1)
        
        evilWizard.run(SKAction.repeatForever(idleAnimation), withKey: "EvilWizardTaunt2")
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if let circles, let circleLabels {
            
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0
            
            for i in 0 ..< 5 {
                circles[i].fillColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
                //set the stroke color to be slightly more transparent
                circles[i].fillColor = circles[i].fillColor.withAlphaComponent(alpha - (0.005))
                
                circleLabels[i].fontColor?.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
                //set the stroke color to be slightly more transparent
                circleLabels[i].fontColor! = (circleLabels[i].fontColor!.withAlphaComponent(alpha - (0.005)))
            }
        }
    }
}
