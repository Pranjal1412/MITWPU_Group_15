//
//  LottieLoaderView.swift
//  Runnr
//
//  Created by Aditi Bhange on 20/03/26.
//

import SwiftUI
import Lottie

struct LottieLoaderView: UIViewRepresentable {
    func makeUIView(context: Context) -> LottieAnimationView {
        let view = LottieAnimationView(name: "Run_Forrest_Run")
        view.loopMode = .loop
        view.contentMode = .scaleAspectFit
        view.play()
        return view
    }

    func updateUIView(_ uiView: LottieAnimationView, context: Context) {}
}
