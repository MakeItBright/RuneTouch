//
//  GameScene.swift
//  GameScene
//
//  Created by Juri Breslauer on 7/30/25.
//

import SpriteKit
import LoggerKit
#if DEBUG
import ZIPFoundation
import UIKit
import UniformTypeIdentifiers
#endif

struct PhysicsCategory {
    static let enemy: UInt32 = 0x1 << 0
    static let ground: UInt32 = 0x1 << 1
    static let fallZone: UInt32 = 0x1 << 2
}

class GameScene: SKScene, SKPhysicsContactDelegate {

#if DEBUG
    private let saveRunes = false
    private var labelForCurrentGesture: RuneType? = .ice
    private var debugButtons: [SKLabelNode] = []
#endif

    private var touchPoints: [CGPoint] = []
    private var lineNode: SKShapeNode?
    private let runeUseCase = RecognizeRuneUseCase()
    private var spawnTimer: Timer?

    private var missedEnemies: Int = 0
    private let maxMisses = 3
    private var isGameOver = false

    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        physicsWorld.gravity = CGVector(dx: 0, dy: -3)
        physicsWorld.contactDelegate = self

        startSpawningEnemies()

        let bg = SKSpriteNode(imageNamed: "background")
        bg.zPosition = -10
        bg.position = .zero
        bg.size = size
        addChild(bg)
        backgroundColor = .clear
        
        let fallDetector = SKNode()
        fallDetector.name = "fallZone"
        fallDetector.position = CGPoint(x: 0, y: -size.height / 2 + 40)
        fallDetector.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width, height: 10))
        fallDetector.physicsBody?.isDynamic = false
        fallDetector.physicsBody?.categoryBitMask = PhysicsCategory.fallZone
        fallDetector.physicsBody?.contactTestBitMask = PhysicsCategory.enemy
        fallDetector.physicsBody?.collisionBitMask = 0
        fallDetector.alpha = 0.0 // невидимая
        addChild(fallDetector)

        let ground = SKSpriteNode(color: .darkGray, size: CGSize(width: size.width, height: 20))
        ground.position = CGPoint(x: 0, y: -size.height / 2 + 10)
        ground.zPosition = 2
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = PhysicsCategory.ground
        ground.physicsBody?.contactTestBitMask = PhysicsCategory.enemy
        addChild(ground)
    }

    private func startSpawningEnemies() {
        spawnTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            DispatchQueue.main.async {
                self?.spawnEnemy()
            }
        }
    }

    private func spawnEnemy() {
        guard !isGameOver else { return }

        let allTypes: [RuneType] = [.fire, .ice, .lightning]
        let type = allTypes.randomElement()!
        let enemy = EnemyNode(runeType: type)

        let x = CGFloat.random(in: -size.width / 2...size.width / 2)
        enemy.position = CGPoint(x: x, y: size.height / 2 + 50)
        enemy.zPosition = 1

        // Физика
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody?.affectedByGravity = true
        enemy.physicsBody?.categoryBitMask = PhysicsCategory.enemy
        enemy.physicsBody?.contactTestBitMask = PhysicsCategory.ground
        enemy.physicsBody?.collisionBitMask = PhysicsCategory.ground

        addChild(enemy)
    }

    nonisolated func didBegin(_ contact: SKPhysicsContact) {
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node

        DispatchQueue.main.async {
            self.handleContact(nodeA: nodeA, nodeB: nodeB)
        }
    }
    @MainActor
    private func handleContact(nodeA: SKNode?, nodeB: SKNode?) {
        let names = [nodeA?.name, nodeB?.name]

        if names.contains("fallZone"), let enemy = [nodeA, nodeB].first(where: { $0?.name == "enemy" }) {
            Logger.log("📉 Враг пересёк границу", level: .info)
            fallenEnemies.insert(enemy!)
            checkGameOver()
        }
    }
    
    private var fallenEnemies: Set<SKNode> = []

    private func checkGameOver() {
        Logger.log("📉 Упавших врагов: \(fallenEnemies.count)", level: .debug)
        if fallenEnemies.count >= maxMisses {
            isGameOver = true
            spawnTimer?.invalidate()
            showGameOver()
        }
    }
    private func showGameOver() {
        let label = SKLabelNode(text: "💀 Game Over")
        label.fontSize = 48
        label.fontColor = .red
        label.zPosition = 100
        label.position = CGPoint.zero
        addChild(label)

        let fade = SKAction.sequence([
            SKAction.wait(forDuration: 2.0),
            SKAction.fadeOut(withDuration: 1),
            SKAction.removeFromParent()
        ])
        label.run(fade)
    }

//    @MainActor
//    private func checkFallenEnemies() {
//        Logger.log("🔎 Начинаем проверку всех узлов", level: .debug)
//
//        var count = 0
//
//        for node in children {
//            guard node.name == "enemy" else { continue }
//
//            let y = node.position.y
//            let dy = node.physicsBody?.velocity.dy ?? 999
//
//            Logger.log("🧩 Node: \(node.name ?? "nil"), y=\(Int(y)), dy=\(Int(dy))", level: .debug)
//
//            let isOnGround = y < (-size.height / 2 + 50)
//            let isStill = abs(dy) < 50 // ⚠️ увеличим порог!
//
//            if isOnGround && isStill {
//                count += 1
//            }
//        }
//
//        Logger.log("📉 Упавших врагов: \(count)", level: .debug)
//
//        if count >= maxMisses {
//            isGameOver = true
//            spawnTimer?.invalidate()
//
//            let label = SKLabelNode(text: "💀 Game Over")
//            label.fontSize = 48
//            label.fontColor = .red
//            label.zPosition = 100
//            label.position = CGPoint.zero
//            addChild(label)
//
//            let fade = SKAction.sequence([
//                SKAction.wait(forDuration: 2.0),
//                SKAction.fadeOut(withDuration: 1),
//                SKAction.removeFromParent()
//            ])
//            label.run(fade)
//        }
//    }






    private func destroyEnemies(with type: RuneType) {
        for node in children {
            guard let enemy = node as? EnemyNode else { continue }
            if enemy.runeType == type {
                enemy.removeFromParent()

                let boom = SKLabelNode(text: "💥")
                boom.position = enemy.position
                boom.zPosition = 10
                addChild(boom)
                boom.run(SKAction.sequence([
                    SKAction.fadeOut(withDuration: 0.5),
                    SKAction.removeFromParent()
                ]))
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let tappedNodes = nodes(at: location)
            if tappedNodes.contains(where: { $0.name == "backButton" }) {
                goToMainMenu()
                return
            }
        }
#if DEBUG
        for touch in touches {
            let location = touch.location(in: self)
            let nodes = nodes(at: location)
            for node in nodes {
                if node.name == "exportButton" {
                    exportAllRunes()
                    return
                } else if node.name == "deleteButton" {
                    deleteAllRuneFiles()
                    return
                }
            }
        }
#endif
        touchPoints = []
        if let point = touches.first?.location(in: self) {
            touchPoints.append(point)
        }
        lineNode?.removeFromParent()
        lineNode = nil
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        touchPoints.append(point)

        let path = CGMutablePath()
        path.addLines(between: touchPoints)

        if lineNode == nil {
            lineNode = SKShapeNode()
            lineNode?.strokeColor = .blue
            lineNode?.lineWidth = 4
            addChild(lineNode!)
        }
        lineNode?.path = path
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
#if DEBUG
        if saveRunes, let label = labelForCurrentGesture {
            saveGesture(touchPoints, as: label)
        }
#endif
        guard let rune = runeUseCase.execute(inputPoints: touchPoints) else {
            Logger.log("Не удалось распознать руну", level: .error)
            return
        }
        Logger.log("✨ Распознано: \(rune.rawValue)", level: .success)
        showRuneLabel(type: rune)
        destroyEnemies(with: rune)
    }

    private func showRuneLabel(type: RuneType) {
        let label = SKLabelNode(text: "✨ \(type.rawValue.capitalized)")
        label.fontSize = 32
        label.fontColor = .black
        label.position = CGPoint.zero
        label.zPosition = 10
        addChild(label)

        let fade = SKAction.sequence([
            SKAction.fadeOut(withDuration: 1),
            SKAction.removeFromParent()
        ])
        label.run(fade)
    }

    private func goToMainMenu() {
        Logger.log("⬅️ Назад в меню", level: .info)
    }

#if DEBUG
    private func saveGesture(_ points: [CGPoint], as label: RuneType) {
        let normalized = normalize(points)
        let floatArray = normalized.flatMap { [Float($0.x), Float($0.y)] }
        let dict: [String: Any] = ["label": label.rawValue, "points": floatArray]

        if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
           let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filename = docDir.appendingPathComponent("rune_\(UUID().uuidString).json")
            try? jsonData.write(to: filename)
            Logger.log("Сохранено: \(filename.lastPathComponent)", level: .success)
        }
    }

    private func normalize(_ points: [CGPoint]) -> [CGPoint] {
        guard let minX = points.map({ $0.x }).min(),
              let minY = points.map({ $0.y }).min(),
              let maxX = points.map({ $0.x }).max(),
              let maxY = points.map({ $0.y }).max() else { return points }

        let width = max(maxX - minX, 1)
        let height = max(maxY - minY, 1)

        return points.map { pt in
            CGPoint(x: (pt.x - minX) / width, y: (pt.y - minY) / height)
        }
    }

    private func exportAllRunes() {
        guard let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

        let runeFiles = (try? FileManager.default.contentsOfDirectory(at: docDir, includingPropertiesForKeys: nil))?.filter { $0.pathExtension == "json" } ?? []
        let exportURL = docDir.appendingPathComponent("runes_export.zip")
        try? FileManager.default.removeItem(at: exportURL)

        guard let archive = Archive(url: exportURL, accessMode: .create) else { return }
        for fileURL in runeFiles {
            try? archive.addEntry(with: fileURL.lastPathComponent, fileURL: fileURL)
        }

        let activity = UIActivityViewController(activityItems: [exportURL], applicationActivities: nil)
        if let window = UIApplication.shared.connectedScenes.compactMap({ ($0 as? UIWindowScene)?.windows.first }).first {
            window.rootViewController?.present(activity, animated: true)
        }
    }

    private func deleteAllRuneFiles() {
        guard let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

        let runeFiles = (try? FileManager.default.contentsOfDirectory(at: docDir, includingPropertiesForKeys: nil))?.filter { $0.pathExtension == "json" } ?? []
        for fileURL in runeFiles {
            try? FileManager.default.removeItem(at: fileURL)
        }
        print("🧹 Все руны удалены (\(runeFiles.count) файлов)")
    }
#endif
}
