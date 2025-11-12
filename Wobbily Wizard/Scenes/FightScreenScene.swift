//
//  FightScreen.swift
//  Wobbily Wizard
//
//  Created by Jeb Barker on 11/4/25.
//

import SpriteKit

class FightScreenScene: SKScene {
    
    private var currentPath: SKShapeNode?
    private var circles : [SKShapeNode]?
    private var pathPoints : [Int]?
    
    private var fightModel : FightModel
    
    init(fightModel : FightModel, size : CGSize) {
        self.fightModel = fightModel
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var tempAtlas: SKTextureAtlas {
        return SKTextureAtlas(named: "Wizard Walk Atlas")
    }
    private var tempTex: SKTexture {
        return tempAtlas.textureNamed("frame_0000")
    }
    
    override func didMove(to view: SKView) {
        self.scaleMode = .aspectFill
        loadCircles()
        
    }
    
    func loadCircles() {
        circles = []
        
        let centerx = frame.width/2
        let centery = frame.height/2
        let radius = frame.width/4
        let thetaStep = (2*Double.pi)/5
        for i in 0 ..< 5 {
            circles!.append(SKShapeNode(circleOfRadius: 20))
            let px = centerx + cos(thetaStep * Double(i) + Double.pi/2) * radius
            let py = centery + sin(thetaStep * Double(i) + Double.pi/2) * radius
            circles![i].position =
            CGPoint(x: px, y: py)
            addChild(circles![i])
        }
    }
    
    func circleCollision(_ point: CGPoint) -> Int? {
        for (index, circle) in circles!.enumerated() {
            if circle.contains(point) {
                return index
            }
        }
        return nil
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        //reset the canvas
        pathPoints = []
        currentPath = nil
        self.removeAllChildren()
        self.loadCircles()
        if let circle = circleCollision(touch.location(in: self)) {
            if pathPoints?.last != circle {
                pathPoints?.append(circle)
            }
        }
        
        let path = UIBezierPath()
        path.move(to: touch.location(in: self))
        let shapeNode = SKShapeNode(path: path.cgPath)
        
        // path visuals
        shapeNode.strokeColor = .white
        shapeNode.lineWidth = 4
        
        addChild(shapeNode)
        currentPath = shapeNode
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let shapeNode = currentPath else { return }
        
        //Possibly add candles visited to the path
        if let circle = circleCollision(touch.location(in: self)) {
            if pathPoints?.last != circle {
                pathPoints?.append(circle)
            }
        }
        let path = UIBezierPath(cgPath: shapeNode.path!)
        path.addLine(to: touch.location(in: self))
        shapeNode.path = path.cgPath
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*
         
         */
        self.fightModel.onShapeDrawn(candles: self.pathPoints!)
    }
    
    override func update(_ currentTime: TimeInterval) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        currentPath?.strokeColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        if alpha <= 0 {
            self.removeAllChildren()
            self.loadCircles()
        }
        //set the stroke color to be slightly more transparent
        currentPath?.strokeColor = currentPath?.strokeColor.withAlphaComponent(alpha - (0.005)) ?? UIColor.red
    }
}
