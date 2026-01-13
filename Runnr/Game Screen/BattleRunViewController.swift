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
        

       func setupUI() {
           viewEnds.layer.cornerRadius = viewEnds.bounds.height / 2
           viewEnds.layer.borderWidth = 1
           viewEnds.layer.borderColor = UIColor(red: 173/255, green: 248/255, blue: 69/255, alpha: 1).cgColor
           
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
       
       @IBAction func buttonBack(_ sender: Any) {
           self.dismiss(animated: true, completion: nil)
       }

       func setupAR() {
           arView.cameraMode = .nonAR
           arView.environment.background = .color(.black)
           
           let lightAnchor = AnchorEntity(world: .zero)
           let sun = DirectionalLight()
           sun.light.intensity = 10000
           sun.look(at: [0, 0, 0], from: [0, 5, 5], relativeTo: nil)
           lightAnchor.addChild(sun)
           arView.scene.addAnchor(lightAnchor)

           let camera = PerspectiveCamera()
           cameraRig.addChild(camera)
           let rigAnchor = AnchorEntity(world: .zero)
           rigAnchor.addChild(cameraRig)
           arView.scene.addAnchor(rigAnchor)

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

               root.scale = [9.0, 9.0, 9.0]
               root.position = [0, 0, 0]
               root.orientation = simd_quatf(angle: 0.785, axis: [1, 0, 0])

               self.frame(entity: root)
               boardController = BoardController(root: root, game: game)
               updateCaptureCounter()
           } catch {
               print("❌ Load failed: \(error)")
           }
       }

       @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
           let location = recognizer.location(in: arView)
           let results = arView.hitTest(location)
           
           if let firstHit = results.first {
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
       
       private func handleTileTap(id: String) {
           guard let controller = boardController, let tile = game.tiles[id] else { return }
           
           if game.canCapture(tile: tile, cost: 10) {
               game.capture(tileID: id, cost: 10)
               
               if let tileEntity = controller.tileEntities[id],
                  let updatedTile = game.tiles[id] {
                   tileEntity.playPopAnimation()
               }
               
               updateTileMaterial(id: id, controller: controller)
               updatePointsLabels()
               updateCaptureCounter()
               animateScoreBounce()
               
               UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
           }
       }



       func updateTileMaterial(id: String, controller: BoardController) {
           guard let model = controller.tileEntities[id], let tileData = game.tiles[id] else { return }
           let color = ownerColor(for: tileData.owner)
           
           // Use material blending instead of OpacityComponent to keep children opaque
           var material = UnlitMaterial(color: color)
           material.blending = .transparent(opacity: 0.75)
           
           if var modelComponent = model.model {
               modelComponent.materials = [material]
               model.model = modelComponent
               // Ensure child entities (flags) aren't affected by parent transparency
               if #available(iOS 18.0, *) {
                   model.components.remove(OpacityComponent.self)
               } else {
                   // Fallback on earlier versions
               }
           }
       }

       private func ownerColor(for owner: TileOwner) -> UIColor {
           switch owner {
           case .none: return .darkGray
           case .player(.me): return .systemCyan
           case .player(.lea): return .systemYellow
           }
       }

       func updatePointsLabels() {
           labelYourPoints.text = "Ⓡ \(game.points[.me] ?? 0)"
           labelFriendsPoints.text = "Ⓡ \(game.points[.lea] ?? 0)"
       }

       func updateCaptureCounter() {
           let captured = game.tiles.values.filter { if case .player(.me) = $0.owner { return true }; return false }.count
           let total = game.tiles.count
           labelCaptureCount?.text = "Captured: \(captured) / \(total)"
       }

       private func animateScoreBounce() {
           UIView.animate(withDuration: 0.1, animations: {
               self.viewYou.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
           }) { _ in
               UIView.animate(withDuration: 0.1) { self.viewYou.transform = .identity }
           }
       }

       @objc private func handlePinch(_ recognizer: UIPinchGestureRecognizer) {
           let scale = Float(recognizer.scale)
           recognizer.scale = 1
           let zoomSpeed: Float = 4.0
           let delta = (1.0 - scale) * zoomSpeed
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
           let cameraPos = center + SIMD3<Float>(0, radius * 0.5, radius * 1.5)
           orbitCenter = center
           cameraRig.position = cameraPos
           cameraRig.look(at: center, from: cameraPos, relativeTo: nil)
       }
    
   }

   // MARK: - Safe Animations Extension

   extension Entity {
       func playPopAnimation() {
           let originalScale = self.scale
           let popScale = originalScale * 1.2
           
           self.move(to: Transform(scale: popScale, rotation: self.orientation, translation: self.position),
                     relativeTo: self.parent, duration: 0.1, timingFunction: .easeOut)
           
           DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
               self.move(to: Transform(scale: originalScale, rotation: self.orientation, translation: self.position),
                         relativeTo: self.parent, duration: 0.15, timingFunction: .easeInOut)
           }
       }
   }

   // MARK: - Game Classes

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
           guard let tile = tiles[tileID], canCapture(tile: tile, cost: cost) else { return }
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

   extension Entity {
       func visit(_ body: (Entity) -> Void) {
           body(self); for child in children { child.visit(body) }
       }
   }

       
