//
//  GameScene.swift
//  GameScene
//
//  Created by Juri Breslauer on 7/30/25.
//
//  Главная игровая сцена с рисованием рун и иконками

import SpriteKit
import LoggerKit
#if DEBUG
import ZIPFoundation
import UIKit
import UniformTypeIdentifiers
#endif

class GameScene: SKScene {
    
    
#if DEBUG
    private let saveRunes = true // <- включение режима сбора
    private var labelForCurrentGesture: RuneType? = .lightning // <- меняем вручную перед запуском
#endif
#if DEBUG
    private var debugButtons: [SKLabelNode] = []
#endif
    
    private var touchPoints: [CGPoint] = []
    private var lineNode: SKShapeNode?
    
    private let runeUseCase = RecognizeRuneUseCase(recognizer: RuneRecognizer())
    
    override func didMove(to view: SKView) {
        backgroundColor = .white
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
#if DEBUG
        let exportButton = SKLabelNode(text: "📤 Экспорт")
        exportButton.fontSize = 20
        exportButton.fontColor = .blue
        exportButton.position = CGPoint(x: size.width / 2 - 80, y: size.height / 2 - 40)
        exportButton.name = "exportButton"
        
        let deleteButton = SKLabelNode(text: "🗑 Удалить")
        deleteButton.fontSize = 20
        deleteButton.fontColor = .red
        deleteButton.position = CGPoint(x: size.width / 2 - 80, y: size.height / 2 - 80)
        deleteButton.name = "deleteButton"
        
        addChild(exportButton)
        addChild(deleteButton)
        debugButtons = [exportButton, deleteButton]
#endif
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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
    // 🧠 Конец касания: распознаём руну
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
    }
    
    // 🏷 Показываем результат
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
    
#if DEBUG
    private func saveGesture(_ points: [CGPoint], as label: RuneType) {
        let normalized = normalize(points)
        let floatArray = normalized.flatMap { [Float($0.x), Float($0.y)] }
        
        let dict: [String: Any] = [
            "label": label.rawValue,
            "points": floatArray
        ]
        
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
            CGPoint(x: (pt.x - minX) / width,
                    y: (pt.y - minY) / height)
        }
    }
#endif
    
#if DEBUG
    
    
    private func exportAllRunes() {
        guard let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let runeFiles = (try? FileManager.default.contentsOfDirectory(at: docDir, includingPropertiesForKeys: nil))?
            .filter { $0.pathExtension == "json" } ?? []
        
        let exportURL = docDir.appendingPathComponent("runes_export.zip")
        try? FileManager.default.removeItem(at: exportURL)
        
        guard let archive = Archive(url: exportURL, accessMode: .create) else { return }
        
        for fileURL in runeFiles {
            try? archive.addEntry(with: fileURL.lastPathComponent, fileURL: fileURL)
        }
        
        let activity = UIActivityViewController(activityItems: [exportURL], applicationActivities: nil)
        if let window = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.windows.first })
            .first {
            window.rootViewController?.present(activity, animated: true)
        }
    }
#endif
#if DEBUG
    private func deleteAllRuneFiles() {
        guard let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let runeFiles = (try? FileManager.default.contentsOfDirectory(at: docDir, includingPropertiesForKeys: nil))?
            .filter { $0.pathExtension == "json" } ?? []
        
        for fileURL in runeFiles {
            try? FileManager.default.removeItem(at: fileURL)
        }
        
        print("🧹 Все руны удалены (\(runeFiles.count) файлов)")
    }
#endif
    
    
}
