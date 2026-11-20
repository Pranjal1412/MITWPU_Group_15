//
//  GameAnimationViewController.swift
//  Runnr
//
//  Created by Pranjal Shinde on 20/11/26.
//

import UIKit
import AVKit

class GameAnimationViewController: UIViewController {

    private var player: AVPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playVideo()
        addCloseButton()
    }

    func playVideo() {
        guard let url = Bundle.main.url(forResource: "gameAnime", withExtension: "mov") else {
            print("Video not found")
            return
        }
        let player = AVPlayer(url: url)
        let layer = AVPlayerLayer(player: player)
        layer.frame = view.bounds
        layer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(layer)
        player.play()
        self.player = player
    }

    func addCloseButton() {
        let button = UIButton()
        setGlassEffect(for: button, withImage: "xmark")
        button.frame.size.width = 45
        button.frame.size.height = 45
        button.layer.frame.origin.x = 20
        button.layer.frame.origin.y = 70
        button.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        view.addSubview(button)

    }

    @objc func closeTapped() {
        player?.pause()
        dismiss(animated: true)
    }
}
