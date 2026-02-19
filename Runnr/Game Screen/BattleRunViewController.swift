import UIKit
import RealityKit
import ARKit
import Combine

class BattleRunViewController: UIViewController {

    @IBOutlet weak var labelCaptureCount: UILabel!
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
    let totalCapturedCount = 0
    private let cameraRig = Entity()
    private var orbitCenter: SIMD3<Float> = .zero

    override func viewDidLoad() {
       super.viewDidLoad()
       setupUI()
       setupAR()
       Task { await loadBoard() }
       view.overrideUserInterfaceStyle = .dark
    }
    
   @IBAction func buttonBack(_ sender: Any) {
       self.dismiss(animated: true, completion: nil)
   }
    func setupUI() {
            viewEnds.layer.cornerRadius = viewEnds.bounds.height / 2
            viewEnds.layer.borderWidth = 1
            viewEnds.layer.borderColor = UIColor.accent.cgColor
            
            [imageYour, imageFriends].forEach {
                $0?.layer.cornerRadius = ($0?.bounds.height ?? 0) / 2
                $0?.layer.borderWidth = 2
                $0?.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
                $0?.clipsToBounds = true
            }

            updatePointsLabels()
//            viewYou.backgroundColor = .systemCyan
//            viewFriend.backgroundColor = .systemPurple
        viewYou.layer.borderWidth = 1
        viewYou.layer.borderColor = UIColor.cyan.cgColor
        viewFriend.layer.borderWidth = 1
        viewFriend.layer.borderColor = UIColor.purple.cgColor
            viewYou.layer.cornerRadius = 15
            viewFriend.layer.cornerRadius = 15
        
        viewYou.layer.shadowColor = UIColor.accent.withAlphaComponent(0.5).cgColor
        viewYou.layer.shadowOpacity = 0.5
        viewYou.layer.shadowRadius = self.viewYou.frame.height / 2
        viewFriend.layer.shadowColor = UIColor.accent.withAlphaComponent(0.5).cgColor
        viewFriend.layer.shadowOpacity = 0.5
        viewFriend.layer.shadowRadius = self.viewFriend.frame.height / 2
        }
        
        func setupAR() {
            arView.cameraMode = .nonAR
            
            // 1. CLEAR THE BLACK: Load stars.hdr as a Skybox
            Task {
                do {
                    // Ensure "stars" matches the name in your Assets.xcassets
                    let texture = try await TextureResource.load(named: "stars")
                    var skyMaterial = UnlitMaterial()
                    skyMaterial.color = .init(tint: .white, texture: .init(texture))
                    
                    // Create a massive sphere (Skybox)
                    let skySphere = MeshResource.generateSphere(radius: 100)
                    let skyEntity = ModelEntity(mesh: skySphere, materials: [skyMaterial])
                    
                    // Flip scale so texture is visible from INSIDE the sphere
                    skyEntity.scale = [-1, 1, 1]
                    
                    let skyAnchor = AnchorEntity(world: .zero)
                    skyAnchor.addChild(skyEntity)
                    arView.scene.addAnchor(skyAnchor)
                    
                    // Optional: Slow space rotation
                    let rotation = skyEntity.makeContinuousRotation(around: [0, 1, 0], period: 600)
                    skyEntity.playAnimation(rotation)
                    
                } catch {
                    print("Failed to load stars.hdr, defaulting to black: \(error)")
                    arView.environment.background = .color(.black)
                }
            }
            
            // 2. LIGHTING
            let lightAnchor = AnchorEntity(world: .zero)
            let sun = DirectionalLight()
            sun.light.intensity = 12000
            sun.look(at: [0, 0, 0], from: [5, 10, 5], relativeTo: nil)
            lightAnchor.addChild(sun)
            
            let nebulaLight = PointLight()
            nebulaLight.light.intensity = 5000
            nebulaLight.light.color = .systemPurple
            nebulaLight.position = [-5, 5, -5]
            lightAnchor.addChild(nebulaLight)
            
            arView.scene.addAnchor(lightAnchor)

            // 3. CAMERA
            let camera = PerspectiveCamera()
            cameraRig.addChild(camera)
            let rigAnchor = AnchorEntity(world: .zero)
            rigAnchor.addChild(cameraRig)
            arView.scene.addAnchor(rigAnchor)

            // GESTURES
            arView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
            arView.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:))))
            arView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:))))
        }
        
        @MainActor
        func loadBoard() async {
            do {
                
                guard let localURL = await downloadTerritoryFile() else {
                    print("File download failed")
                    return
                }

                let root = try await Entity(contentsOf: localURL)
                let boardAnchor = AnchorEntity(world: .zero)
                boardAnchor.addChild(root)
                arView.scene.addAnchor(boardAnchor)

                root.scale = [9.0, 9.0, 9.0]
                root.position = [0, 0, 0]
                root.orientation = simd_quatf(angle: 0.785, axis: [1, 0, 0])

                self.frame(entity: root)
                boardController = BoardController(root: root, game: game)
                
                for id in game.tiles.keys {
                    if let controller = boardController { updateTileMaterial(id: id, controller: controller) }
                }
                updateCaptureCounter()
            } catch {
                print("Load failed: \(error)")
            }
        }

        // MARK: - Handlers & Materials
        @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
            let location = recognizer.location(in: arView)
            if let firstHit = arView.hitTest(location).first {
                var entity: Entity? = firstHit.entity
                while let current = entity {
                    if current.name.hasPrefix("Tile_") {
                        handleTileTap(id: current.name)
                        return
                    }
                    entity = current.parent
                }
            }
        }

        func updateTileMaterial(id: String, controller: BoardController) {
            guard let model = controller.tileEntities[id], let tileData = game.tiles[id] else { return }
            let color = ownerColor(for: tileData.owner)
            
            var material = PhysicallyBasedMaterial()
            material.baseColor = .init(tint: color.withAlphaComponent(0.6))
            material.metallic = 1.0
            material.roughness = 0.15
            material.emissiveColor = .init(color: color)
            material.emissiveIntensity = (tileData.owner == .none) ? 0.2 : 3.0
            material.blending = .transparent(opacity: 0.8)

            if var modelComponent = model.model {
                modelComponent.materials = [material]
                model.model = modelComponent
            }
        }

        // ... Rest of your existing functions (handlePinch, handlePan, ownerColor, etc.) ...
        
        @objc private func handlePinch(_ recognizer: UIPinchGestureRecognizer) {
            let scale = Float(recognizer.scale)
            recognizer.scale = 1
            let delta = (1.0 - scale) * 4.0
            let forward = cameraRig.orientation.act([0, 0, -1])
            cameraRig.position += forward * delta
        }

        @objc private func handlePan(_ recognizer: UIPanGestureRecognizer) {
            let translation = recognizer.translation(in: arView)
            recognizer.setTranslation(.zero, in: arView)
            let rot = simd_quatf(angle: Float(translation.x) * 0.005, axis: [0, 1, 0]) * simd_quatf(angle: Float(translation.y) * 0.005, axis: cameraRig.orientation.act([1, 0, 0]))
            cameraRig.position = orbitCenter + rot.act(cameraRig.position - orbitCenter)
            cameraRig.orientation = rot * cameraRig.orientation
        }

        private func frame(entity: Entity) {
            let bounds = entity.visualBounds(relativeTo: nil)
            let center = (bounds.max + bounds.min) * 0.5
            let radius = max(bounds.max.x - bounds.min.x, bounds.max.z - bounds.min.z) * 1.5
            let cameraPos = center + SIMD3<Float>(0, radius * 0.6, radius * 1.2)
            orbitCenter = center
            cameraRig.position = cameraPos
            cameraRig.look(at: center, from: cameraPos, relativeTo: nil)
        }
        
        private func handleTileTap(id: String) {
            guard let controller = boardController, let tile = game.tiles[id] else { return }
            if game.canCapture(tile: tile, cost: 10) {
                game.capture(tileID: id, cost: 10)
                controller.tileEntities[id]?.playPopAnimation()
                updateTileMaterial(id: id, controller: controller)
                updatePointsLabels()
                updateCaptureCounter()
                animateScoreBounce()
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            }
        }
        
        private func ownerColor(for owner: TileOwner) -> UIColor {
            switch owner {
            case .none: return .darkGray
            case .player(.me): return .systemCyan
            case .player(.lea): return .systemPurple
            }
        }

        func updatePointsLabels() {
            labelYourPoints.text = "⚛︎ \(game.points[.me] ?? 0)"
            labelFriendsPoints.text = "⚛︎ \(game.points[.lea] ?? 0)"
        }

        func updateCaptureCounter() {
            let captured = game.tiles.values.filter { if case .player(.me) = $0.owner { return true }; return false }.count
            labelCaptureCount?.text = "SECTOR STATUS: \(captured) / \(game.tiles.count)"
        }

        private func animateScoreBounce() {
            UIView.animate(withDuration: 0.1, animations: { self.viewYou.transform = CGAffineTransform(scaleX: 1.1, y: 1.1) }) { _ in
                UIView.animate(withDuration: 0.1) { self.viewYou.transform = .identity }
            }
        }
    }

    // MARK: - Helper Extensions
    extension Entity {
        func playPopAnimation() {
            let originalScale = self.scale
            self.move(to: Transform(scale: originalScale * 1.15, rotation: orientation, translation: position), relativeTo: parent, duration: 0.1)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.move(to: Transform(scale: originalScale, rotation: self.orientation, translation: self.position), relativeTo: self.parent, duration: 0.2)
            }
        }
        
        func makeContinuousRotation(around axis: SIMD3<Float>, period: Double) -> AnimationResource {
            var transform = Transform.identity
            transform.rotation = simd_quatf(angle: .pi * 2, axis: axis)
            return try! AnimationResource.generate(with: FromToByAnimation(to: transform, duration: period, bindTarget: .transform, repeatMode: .repeat))
        }
        
        func visit(_ body: (Entity) -> Void) {
            body(self); for child in children { child.visit(body) }
        }
    }

    // MARK: - Core Logic Classes

    final class BattleRunGame {
        var tiles: [String: TileState] = [:]
        var points: [Player: Int] = [.me: 100, .lea: 300]
        var currentPlayer: Player = .me
        func canCapture(tile: TileState, cost: Int) -> Bool {
            if case .none = tile.owner { return (points[currentPlayer] ?? 0) >= cost }
            return false
        }
        func capture(tileID: String, cost: Int) {
            guard let tile = tiles[tileID], canCapture(tile: tile, cost: cost) else { return }
            points[currentPlayer]! -= cost
            tiles[tileID]?.owner = .player(currentPlayer)
        }
    }

    final class BoardController {
        let root: Entity
        let game: BattleRunGame
        var tileEntities: [String: ModelEntity] = [:]
        init(root: Entity, game: BattleRunGame) { self.root = root; self.game = game; setupTiles() }
        private func setupTiles() {
            root.visit { entity in
                if entity.name.hasPrefix("Tile_") {
                    if let model = entity as? ModelEntity { registerTile(model, withName: entity.name) }
                    else if let child = entity.children.first(where: { $0 is ModelEntity }) as? ModelEntity { registerTile(child, withName: entity.name) }
                }
            }
        }
        private func registerTile(_ entity: ModelEntity, withName name: String) {
            entity.generateCollisionShapes(recursive: false)
            if #available(iOS 18.0, *) {
                entity.components.set(InputTargetComponent())
            } else {
                // Fallback on earlier versions
            }
            tileEntities[name] = entity
            game.tiles[name] = TileState(id: name, owner: .none)
        }
    }
