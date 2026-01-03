//
//  CommonFunctions.swift
//  Runnr
//
//  Created by Pranjal Shinde on 03/01/26.
//

import UIKit

func addTopGradient(to view: UIView) {
    let gradient = CAGradientLayer()
    gradient.frame = view.bounds

    gradient.colors = [
        UIColor.black.cgColor,
        UIColor.black.withAlphaComponent(0.4).cgColor,
        UIColor.black.withAlphaComponent(0.4).cgColor,
        UIColor.black.withAlphaComponent(0.2).cgColor,
        UIColor.black.withAlphaComponent(0.2).cgColor,
        UIColor.black.withAlphaComponent(0.1).cgColor,
        UIColor.black.withAlphaComponent(0.1).cgColor,
        UIColor.black.withAlphaComponent(0.1).cgColor,
        UIColor.black.withAlphaComponent(0.1).cgColor,
        UIColor.black.withAlphaComponent(0.1).cgColor,
        UIColor.clear.cgColor
    ]

    gradient.startPoint = CGPoint(x: 0.5, y: 0)
    gradient.endPoint = CGPoint(x: 0.5, y: 1)

    view.layer.insertSublayer(gradient, at: 0)
}

func addBottomGradient(to view: UIView) {
    let gradient = CAGradientLayer()
    gradient.frame = view.bounds

    gradient.colors = [
        UIColor.black.cgColor,
        UIColor.black.withAlphaComponent(0.2).cgColor,
        UIColor.black.withAlphaComponent(0.2).cgColor,
        UIColor.black.withAlphaComponent(0.2).cgColor,
        UIColor.black.withAlphaComponent(0.2).cgColor,
        UIColor.black.withAlphaComponent(0.1).cgColor,
        UIColor.black.withAlphaComponent(0.1).cgColor,
        UIColor.black.withAlphaComponent(0.1).cgColor,
        UIColor.black.withAlphaComponent(0.1).cgColor,
        UIColor.black.withAlphaComponent(0.1).cgColor,
        UIColor.clear.cgColor
    ]

    gradient.startPoint = CGPoint(x: 0.5, y: 1)
    gradient.endPoint = CGPoint(x: 0.5, y: 0)

    view.layer.insertSublayer(gradient, at: 0)
}
