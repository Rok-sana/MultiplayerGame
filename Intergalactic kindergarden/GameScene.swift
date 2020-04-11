//
//  GameScene.swift
//  Intergalactic kindergarden
//
//  Created by Oksana Bolibok on 01.03.2020.
//  Copyright © 2020 Oksana Bolibok. All rights reserved.
//

import SpriteKit
import GameplayKit


let numColumns = 4
let numRows = 4
let π = CGFloat.pi

class GameScene: SKScene {
    
    let cropLayer = SKCropNode()
    let maskLayer = SKNode()
    
    let gameLayer = SKNode()
    let childLayer = SKNode()
    let catLayer = SKNode()
    
    let childWidth: CGFloat = 70.0
    let childHeight: CGFloat = 70.0
    
    var randomColors: [UIColor] = []
    
    let transferService = TransferService()
    
    var setConnectionSctring: ((String) -> ())?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        transferService.delegate = self
        let background = SKSpriteNode(color: .gray, size: size)
        addChild(background)
        addChild(gameLayer)
        for _ in 0...13 {
            randomColors.append(ChildType.random().color)
        }
        
        let layerPosition = CGPoint(
            x: -childWidth * CGFloat(numColumns) / 2,
            y: -childHeight * CGFloat(numRows) / 2)
        
        childLayer.position = layerPosition
        gameLayer.addChild(childLayer)
        gameLayer.addChild(catLayer)
        
    }
    
    func addSprites(for children: Set<Child>) {
        for child in children {
            let sprite = SKSpriteNode(imageNamed: child.imageName)
            sprite.size = CGSize(width: childWidth, height: childHeight)
            sprite.position = pointFor(column: child.column, row: child.row)
            sprite.zPosition = 10
           
            childLayer.addChild(sprite)
            child.sprite = sprite
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    
    private func convertPoint(_ point: CGPoint) -> (column: Int, row: Int) {
      if point.x >= 0 && point.x < CGFloat(numColumns) * childWidth &&
        point.y >= 0 && point.y < CGFloat(numRows) * childHeight {
        return (Int(point.x / childWidth), Int(point.y / childHeight))
      } else {
        return ( 0, 0)
      }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
         let touch:UITouch = touches.first!
         let positionInScene = touch.location(in: childLayer)
        spawnCat(point: positionInScene)
        transferService.send(position: "\(positionInScene.x)\(positionInScene.y)")
        print("\(convertPoint(positionInScene))")
         let touchedNode = self.atPoint(positionInScene)
       
       
        
        
    }
    
  func pointFor(column: Int, row: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(column) * childWidth + childWidth / 2,
            y: CGFloat(row) * childHeight + childHeight / 2)
    }
    
    
    func spawnCat(point: CGPoint) {
       
        let cat = SKSpriteNode(imageNamed: "cat")
        cat.name = "cat"
        cat.position = CGPoint(
            x: point.x,
            y: point.y)
        cat.setScale(0)
        cat.zPosition = 10
       addChild(cat)
    
        let appear = SKAction.scale(to: 0.8, duration: 0.5)
        cat.zRotation = -π / 16.0
        let leftWiggle = SKAction.rotate(byAngle: π/8.0, duration: 0.5)
        let rightWiggle = leftWiggle.reversed()
        let fullWiggle = SKAction.sequence([leftWiggle, rightWiggle])
        let scaleUp = SKAction.scale(by: 1.0, duration: 0.25)
        let scaleDown = scaleUp.reversed()
        let fullScale = SKAction.sequence([scaleUp, scaleDown, scaleUp, scaleDown])
        let group = SKAction.group([fullScale, fullWiggle])
        let groupWait = SKAction.repeat(group, count: 1)
        let disappear = SKAction.scale(to: 0, duration: 0.5)
        let removeFromParent = SKAction.removeFromParent()
        let actions = [appear, groupWait, disappear, removeFromParent]
        cat.run(SKAction.sequence(actions))
    }
}


extension SKSpriteNode {
    
    func drawBorder(color: UIColor, width: CGFloat) {
        let shapeNode = SKShapeNode(rect: frame)
        shapeNode.fillColor = .clear
        shapeNode.strokeColor = color
        shapeNode.lineWidth = width
        addChild(shapeNode)
    }
}

extension GameScene: TransferServiceDelegate {

    func connectedDevicesChanged(manager: TransferService, connectedDevices: [String]) {
         
        setConnectionSctring?("Connections: \(connectedDevices)")
    }

    func dataChanged(manager: TransferService, position: [Int]) {
       var currentPosition = pointFor(column: position.first!, row: position.last!)
        currentPosition = CGPoint(x: currentPosition.x/2, y: currentPosition.y/2)
         spawnCat(point: currentPosition)
//            switch colorString {
//            case "red":
//                self.connectionLabel.backgroundColor = .red
//            case "yellow":
//                self.connectionLabel.backgroundColor = .yellow
//            default:
//                NSLog("%@", "Unknown color value received: \(colorString)")
//            }
    }
}
