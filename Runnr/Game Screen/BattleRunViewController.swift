    //
    //  BattleRunViewController.swift
    //  Runnr
    //
    //  Created by Archit Kankaria on 17/12/25.
    //

    import UIKit
    import RealityKit
    import ARKit
    import Combine

    class BattleRunViewController: UIViewController {

        
        @IBOutlet weak var arView: ARView!
        @IBOutlet weak var viewFriend: UIView!
        @IBOutlet weak var viewYou: UIView!
        @IBOutlet weak var imageFriends: UIImageView!
        @IBOutlet weak var imageYour: UIImageView!
        @IBOutlet weak var labelFriendsPoints: UILabel!
        @IBOutlet weak var labelYourPoints: UILabel!
        @IBOutlet weak var labelTime: UILabel!
        @IBOutlet weak var viewEnds: UIView!
     
        let game = BattleRunGame()
        var boardController: BoardController?
        
        // Camera rig for orbiting and zooming
        private let cameraRig = Entity()
        private var orbitCenter: SIMD3<Float> = .zero

        override func viewDidLoad() {
            super.viewDidLoad()
            setupUI()
            setupAR()
            Task { await loadBoard() }
        }

        func setupUI() {
            viewEnds.layer.cornerRadius = viewEnds.bounds.height / 2
            viewEnds.layer.borderWidth = 1
            viewEnds.layer.borderColor = UIColor(red: 173/255, green: 248/255, blue: 69/255, alpha: 1).cgColor
            labelTime.text = "10 days 3 hrs"
            
            [imageYour, imageFriends].forEach {
                $0?.layer.cornerRadius = ($0?.bounds.height ?? 0) / 2
                $0?.clipsToBounds = true
            }

            updatePointsLabels()
            viewYou.backgroundColor = .systemCyan
            viewFriend.backgroundColor = .systemPink
            viewYou.layer.cornerRadius = 10
            viewFriend.layer.cornerRadius = 10
        }
        
        func setupAR() {
            arView.cameraMode = .nonAR
            // FIXED: Pure black background
            arView.environment.background = .color(.black)
            
            let lightAnchor = AnchorEntity(world: .zero)
            let sun = DirectionalLight()
            sun.light.intensity = 10000
            sun.look(at: [0, 0, 0], from: [0, 5, 5], relativeTo: nil)
            lightAnchor.addChild(sun)
            arView.scene.addAnchor(lightAnchor)

            // Camera setup
            let camera = PerspectiveCamera()
            cameraRig.addChild(camera)
            let rigAnchor = AnchorEntity(world: .zero)
            rigAnchor.addChild(cameraRig)
            arView.scene.addAnchor(rigAnchor)

            // Gestures
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            arView.addGestureRecognizer(tap)
            let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
            arView.addGestureRecognizer(pinch)
            let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
            arView.addGestureRecognizer(pan)
        }
        
        @MainActor
        func loadBoard() async {
            do {
                let root = try await Entity.load(named: "Territory")
                let boardAnchor = AnchorEntity(world: .zero)
                boardAnchor.addChild(root)
                arView.scene.addAnchor(boardAnchor)

                root.scale = [7.0, 7.0, 7.0]
                root.position = [0, 0, 0]
                root.orientation = simd_quatf(angle: 0.785, axis: [1, 0, 0])

                self.frame(entity: root)
                boardController = BoardController(root: root, game: game)
                print("✅ Board loaded. \(boardController!.tileEntities.count) tiles")
            } catch {
                print("❌ Load failed: \(error)")
            }
        }

        @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
            let location = recognizer.location(in: arView)
            guard let controller = boardController else { return }
            
            // Match screen tap to 3D tiles
            for (id, entity) in controller.tileEntities {
                let worldPos = entity.position(relativeTo: nil)
                if let screenPos = arView.project(worldPos) {
                    let dx = Float(screenPos.x) - Float(location.x)
                    let dy = Float(screenPos.y) - Float(location.y)
                    let distance = sqrtf(dx*dx + dy*dy)
                    
                    if distance < 80 { // Hit area
                        handleTileTap(id: id)
                        return
                    }
                }
            }
        }
        
        private func handleTileTap(id: String) {
            guard let controller = boardController, let tile = game.tiles[id] else { return }
            
            print("👆 Tapped: \(id) | Current Points: \(game.points[game.currentPlayer] ?? 0)")

            if game.canCapture(tile: tile, cost: 10) {
                game.capture(tileID: id, cost: 10)
                updateTileMaterial(id: id, controller: controller)
                updatePointsLabels()
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                print("✅ Captured: \(id)")
            } else {
                print("❌ Capture Failed: Check points or owner")
            }
        }

        func updateTileMaterial(id: String, controller: BoardController) {
            guard let model = controller.tileEntities[id],
                  let tileData = game.tiles[id] else { return }
            
            let color = ownerColor(for: tileData.owner)
            let material = SimpleMaterial(color: color, isMetallic: false)
            
            // FIXED: Explicitly update the ModelComponent to force color refresh
            if var modelComponent = model.model {
                modelComponent.materials = [material]
                model.model = modelComponent
            }
        }

        private func ownerColor(for owner: TileOwner) -> UIColor {
            switch owner {
            case .none: return .gray
            case .player(.me): return .systemBlue
            case .player(.lea): return .systemYellow
            }
        }

        func updatePointsLabels() {
            labelYourPoints.text = "Ⓡ \(game.points[.me] ?? 0)"
            labelFriendsPoints.text = "Ⓡ \(game.points[.lea] ?? 0)"
        }

        // Camera controls
        @objc private func handlePinch(_ recognizer: UIPinchGestureRecognizer) {
            let scale = Float(recognizer.scale); recognizer.scale = 1
            let delta = (1 - scale) * 2.0
            cameraRig.position += cameraRig.orientation.act([0, 0, -1]) * delta
        }

        @objc private func handlePan(_ recognizer: UIPanGestureRecognizer) {
            let translation = recognizer.translation(in: arView); recognizer.setTranslation(.zero, in: arView)
            let rot = simd_quatf(angle: Float(translation.x) * 0.005, axis: [0, 1, 0]) * simd_quatf(angle: Float(translation.y) * 0.005, axis: cameraRig.orientation.act([1, 0, 0]))
            cameraRig.position = orbitCenter + rot.act(cameraRig.position - orbitCenter)
            cameraRig.orientation = rot * cameraRig.orientation
        }

        private func frame(entity: Entity) {
            let bounds = entity.visualBounds(relativeTo: nil)
            let center = (bounds.max + bounds.min) * 0.5
            let radius = max(bounds.max.x - bounds.min.x, bounds.max.z - bounds.min.z) * 1.5
            let cameraPos = center + SIMD3<Float>(0, radius * 0.5, radius * 1.5)
            orbitCenter = center
            cameraRig.position = cameraPos
            cameraRig.look(at: center, from: cameraPos, relativeTo: nil)
        }
    }

    // MARK: - Game Logic

    enum Player { case me, lea }
    enum TileOwner { case none, player(Player) }
    struct TileState { let id: String; var owner: TileOwner }

    final class BattleRunGame {
        var tiles: [String: TileState] = [:]
        var points: [Player: Int] = [.me: 100, .lea: 300]
        var currentPlayer: Player = .me

        func canCapture(tile: TileState, cost: Int) -> Bool {
            if case .none = tile.owner { return (points[currentPlayer] ?? 0) >= cost }
            return false
        }

        func capture(tileID: String, cost: Int) {
            guard canCapture(tile: tiles[tileID]!, cost: cost) else { return }
            points[currentPlayer]! -= cost
            tiles[tileID]?.owner = .player(currentPlayer)
        }
    }

    final class BoardController {
        let root: Entity
        let game: BattleRunGame
        var tileEntities: [String: ModelEntity] = [:]

        init(root: Entity, game: BattleRunGame) {
            self.root = root; self.game = game; setupTiles()
        }

        private func setupTiles() {
            root.visit { entity in
                guard let modelEntity = entity as? ModelEntity, entity.name.hasPrefix("Tile_") else { return }
                // Ensure collision is generated for hit testing
                modelEntity.generateCollisionShapes(recursive: false)
                modelEntity.components.set(InputTargetComponent())
                self.tileEntities[entity.name] = modelEntity
                self.game.tiles[entity.name] = TileState(id: entity.name, owner: .none)
            }
        }
    }

    extension Entity {
        func visit(_ body: (Entity) -> Void) {
            body(self); for child in children { child.visit(body) }
        }
    }
