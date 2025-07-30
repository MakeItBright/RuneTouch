//
//  EnemyNode.swift
//  GameScene
//
//  Created by Juri Breslauer on 7/30/25.
//

import SpriteKit

final class EnemyNode: SKSpriteNode {
    let runeType: RuneType

    init(runeType: RuneType) {
            self.runeType = runeType
            let texture = SKTexture(imageNamed: "\(runeType.rawValue)_enemy")
            
            let targetSize = CGSize(width: 64, height: 64)
            super.init(texture: texture, color: .clear, size: targetSize)

            self.name = "enemy"
        self.physicsBody = SKPhysicsBody(rectangleOf: targetSize)
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.enemy
        self.physicsBody?.contactTestBitMask = PhysicsCategory.fallZone | PhysicsCategory.ground
        self.physicsBody?.collisionBitMask = PhysicsCategory.ground
        
        
        }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
