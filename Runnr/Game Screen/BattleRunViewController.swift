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
    var game: BattleRunGame!
    var boardController: BoardController?
    let totalCapturedCount = 0
    private let cameraRig = Entity()
    private var orbitCenter: SIMD3<Float> = .zero
    var gameID: UUID?
    var capturedTiles: [TerritoryHexTile] = []

    override func viewDidLoad() {
       super.viewDidLoad()
       self.gameID = DataSource.shared.getGameID()
       let myPoints = DataSource.shared.getTotalRunnrPoints()
       self.game = BattleRunGame(myPoints: myPoints)
       setupUI()
       setupAR()
       Task { await loadBoard() }
       view.overrideUserInterfaceStyle = .dark
    }
    
   @IBAction func buttonBack(_ sender: Any) {
       // Batch upsert all captured tiles before leaving
       if !capturedTiles.isEmpty {
           let tilesToSave = capturedTiles
           let backgroundTaskID = UIApplication.shared.beginBackgroundTask(withName: "BatchUpsertTiles") {
               // End the task if time expires.
           }
           Task {
               await upsertGameTiles(tilesToSave)
               UIApplication.shared.endBackgroundTask(backgroundTaskID)
           }
       }
       self.dismiss(animated: true, completion: nil)
   }
    func setupUI() {
            
            [imageYour, imageFriends].forEach {
                $0?.layer.cornerRadius = ($0?.bounds.height ?? 0) / 2
                $0?.layer.borderWidth = 2
                $0?.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
                $0?.clipsToBounds = true
            }

        updatePointsLabels()
        viewYou.layer.borderWidth = 1
        viewYou.layer.borderColor = UIColor.accent.cgColor
        viewFriend.layer.borderWidth = 1
        viewFriend.layer.borderColor = UIColor.lightGray.cgColor
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
            sun.light.intensity = 2000
            sun.look(at: [0, 0, 0], from: [0, 10, 0], relativeTo: nil)
            lightAnchor.addChild(sun)
            
            let nebulaLight = PointLight()
            nebulaLight.light.intensity = 5000
            nebulaLight.light.color = .lightGray
            nebulaLight.position = [0, 5, 0]
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
                
                 // Fetch previously captured tiles from Supabase and apply ownership
                 guard let myUserID = DataSource.shared.getUserProfile().userID else {
                     print("DEBUG: myUserID is nil. Aborting tile fetch.")
                     return
                 }
                 print("DEBUG: Active UserID: \(myUserID)")

                 // If gameID is nil because they bypassed the main menu, fetch it dynamically.
                 if self.gameID == nil {
                     if let activeGame = await fetchActiveGameForUser(userID: myUserID) {
                         self.gameID = activeGame.gameID
                         print("DEBUG: Dynamically fetched gameID: \(String(describing: self.gameID))")
                         if let newGameID = self.gameID {
                             DataSource.shared.setGameID(newGameID)
                         }
                     }
                 }

                 if let gameID = self.gameID {
                     print("DEBUG: Fetching tiles for gameID: \(gameID)")
                     if let savedTiles = await fetchGameTileStatus(gameID: gameID) {
                         print("DEBUG: Fetched \(savedTiles.count) saved tiles from DB")
                         for savedTile in savedTiles {
                             
                             // 1. Map "Tile_01" -> "Tile_1"
                             var localTileID = savedTile.tileID
                             if localTileID.hasPrefix("Tile_0") {
                                 localTileID = localTileID.replacingOccurrences(of: "Tile_0", with: "Tile_")
                             }
                             
                             // 2. Map "Tile_19" -> "Tile_0" if geometry uses 0 instead of 19
                             if localTileID == "Tile_19" && game.tiles["Tile_0"] != nil {
                                 localTileID = "Tile_0"
                             }
                             
                             if game.tiles[localTileID] != nil {
                                 if let ownerID = savedTile.ownerID {
                                     // Only assign if it's explicitly owned by someone
                                     let player: Player = (ownerID == myUserID) ? .me : .lea
                                     game.tiles[localTileID]?.owner = .player(player)
                                     print("DEBUG: Assigned tile \(localTileID) to \(player)")
                                 } else {
                                     // DB says it's unowned
                                     game.tiles[localTileID]?.owner = .none
                                 }
                             } else {
                                 print("DEBUG: Tile \(localTileID) NOT found in local game geometry")
                             }
                         }
                     }
                 } else {
                     print("DEBUG: gameID is entirely nil, skipping fetch.")
                 }
                 
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

//        func updateTileMaterial(id: String, controller: BoardController) {
//            guard let tileEntity = controller.tileEntities[id], let tileData = game.tiles[id] else { return }
//            
//            let isCaptured = tileData.owner != .none
//            let color = ownerColor(for: tileData.owner)
//            
//            let material: Material
//            if isCaptured {
//                material = UnlitMaterial(color: color)
//            } else {
//                material = SimpleMaterial(color: .white, isMetallic: false)
//            }
//            
//            // Apply scale reduction to create gaps between adjacent hexes
//            tileEntity.scale = [0.95, 0.95, 0.95]
//
//            // Deep-visit the entire Tile subtree
//            tileEntity.visit { entity in
//                guard var component = entity.components[ModelComponent.self] else { return }
//                component.materials = [material]
//                entity.components.set(component)
//            }
//        }
    func updateTileMaterial(id: String, controller: BoardController) {
        guard let tileEntity = controller.tileEntities[id], let tileData = game.tiles[id] else { return }
        
        let isCaptured = tileData.owner != .none
        let baseColor = ownerColor(for: tileData.owner)
        
        tileEntity.scale = [0.92, 0.92, 0.92]

        var material: Material
        if isCaptured {
            var unlitMaterial = UnlitMaterial(color: baseColor.withAlphaComponent(0.85))
            unlitMaterial.blending = .transparent(opacity: .init(floatLiteral: 1.0))
            material = unlitMaterial
        } else {
            var pbrMaterial = PhysicallyBasedMaterial()
            pbrMaterial.baseColor = .init(tint: UIColor.white.withAlphaComponent(0.3))
            pbrMaterial.roughness = 0.5
            pbrMaterial.metallic = 0.0
            pbrMaterial.clearcoat = .init(floatLiteral: 1.0)
            pbrMaterial.blending = .transparent(opacity: .init(floatLiteral: 1.0))
            material = pbrMaterial
        }

        tileEntity.visit { entity in
            guard var component = entity.components[ModelComponent.self] else { return }
            component.materials = [material]
            entity.components.set(component)
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
            if game.canCapture(tile: tile, cost: 100) {
                game.capture(tileID: id, cost: 100)
                controller.tileEntities[id]?.playPopAnimation()
                updateTileMaterial(id: id, controller: controller)
                updatePointsLabels()
                updateCaptureCounter()
                animateScoreBounce()
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                
                // Deduct points from DataSource (in-memory) so the rest of the app sees updated points
                if var stats = DataSource.shared.getUserStats(),
                   let userID = stats.userID as UUID? {
                    stats.totalPointsEarned -= 100
                    DataSource.shared.setUserStats(stats)
                    // Persist deducted points to Supabase
                    Task { await updateUserStats(userID: userID, newStats: stats) }
                }
                
                // Upsert tile immediately so capture survives force-quit
                if let gameID = self.gameID, let userID = DataSource.shared.getUserProfile().userID {
                    
                    // Format back to DB format: e.g. "Tile_1" -> "Tile_01", "Tile_0" -> "Tile_19"
                    var dbTileID = id
                    if id.hasPrefix("Tile_") && id.count == 6 {
                        let number = id.dropFirst(5)
                        dbTileID = "Tile_0\(number)"
                    } else if id == "Tile_0" {
                        dbTileID = "Tile_19"
                    }
                    
                    let hexTile = TerritoryHexTile(tileID: dbTileID, ownerID: userID, gameID: gameID)
                    capturedTiles.append(hexTile)
                    
                    let backgroundTaskID = UIApplication.shared.beginBackgroundTask(withName: "UpsertTile_\(id)") {
                        // End the task if time expires.
                    }
                    
                    Task {
                        await upsertGameTiles([hexTile])
                        UIApplication.shared.endBackgroundTask(backgroundTaskID)
                    }
                }
            }
        }
        
        private func ownerColor(for owner: TileOwner) -> UIColor {
            switch owner {
            case .none: 
                return .darkGray
            case .player(.me):
                return .accent
            case .player(.lea):
                return .lightGray
            }
        }

        func updatePointsLabels() {
            labelYourPoints.text = "⚛︎ \(game.points[.me] ?? 0)"
            labelFriendsPoints.text = "⚛︎ \(game.points[.lea] ?? 0)"
        }

        func updateCaptureCounter() {
            let captured = game.tiles.values.filter { if case .player(.me) = $0.owner { return true }; return false }.count
            labelCaptureCount?.text = "YOUR TERRITORY: \(captured)"
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
        var points: [Player: Int]
        var currentPlayer: Player = .me
        
        init(myPoints: Int) {
            self.points = [.me: myPoints, .lea: 0]
        }
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
        // Store the Tile_ root entity (not just one child ModelEntity)
        var tileEntities: [String: Entity] = [:]
        init(root: Entity, game: BattleRunGame) { self.root = root; self.game = game; setupTiles() }
        private func setupTiles() {
            root.visit { [weak self] entity in
                guard let self else { return }
                // Register every Tile_ entity exactly once (skip if parent already registered)
                if entity.name.hasPrefix("Tile_") && !self.tileEntities.keys.contains(entity.name) {
                    self.registerTile(entity, withName: entity.name)
                }
            }
        }
        private func registerTile(_ entity: Entity, withName name: String) {
            // Recursive so every nested mesh gets a collision shape and can be hit-tested
            entity.generateCollisionShapes(recursive: true)
            if #available(iOS 18.0, *) {
                entity.components.set(InputTargetComponent())
            }
            tileEntities[name] = entity
            game.tiles[name] = TileState(id: name, owner: .none)
        }
    }

