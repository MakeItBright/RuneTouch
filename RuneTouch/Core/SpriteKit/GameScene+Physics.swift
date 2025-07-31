//
//   GameScene+Physics.swift
//  RuneTouch
//
//  Created by Juri Breslauer on 7/31/25.
//

import SpriteKit

extension GameScene {
    func handleContact(_ contact: SKPhysicsContact) {
        let nodes = [contact.bodyA.node, contact.bodyB.node]
        
        if nodes.contains(where: { $0?.name == "enemy" && nodes.contains { $0?.name == "fallZone" } }) {
            if let enemy = nodes.first(where: { $0?.name == "enemy" }) {
                Logger.log("📉 Враг пересёк границу", level: .info)
                fallenEnemies.insert(enemy!)
                checkGameOver()
            }
        }
    }
}
