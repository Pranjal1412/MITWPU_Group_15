//
//  CommonFunctions.swift
//  Runnr
//
//  Created by Pranjal Shinde on 03/01/26.
//

import UIKit

var isSignUpComplete: Bool {
    get {
        return UserDefaults.standard.object(forKey: "isSignUpComplete") as? Bool ?? false
    }

    set(value) {
        UserDefaults.standard.set(value, forKey: "isSignUpComplete")
        UserDefaults.standard.synchronize()
    }
}

func isValidEmail(_ email: UITextField?) -> Bool {
    if email != nil {
        let email = email!
        let emailString = email.text!
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)

        if emailPred.evaluate(with: emailString) {
            email.textColor = .accent
            return true
        }
        else {
            email.textColor = .red
            return false
        }
    }
    else {
        return false
    }

}

func addTopGradient(to view: UIView) {
    let gradient = CAGradientLayer()
    gradient.frame = view.bounds

    gradient.colors = [
        UIColor.black.cgColor,
        UIColor.black.cgColor,
        UIColor.black.cgColor,
        UIColor.black.withAlphaComponent(0.8).cgColor,
        UIColor.black.withAlphaComponent(0.7).cgColor,
        UIColor.black.withAlphaComponent(0.6).cgColor,
        UIColor.black.withAlphaComponent(0.5).cgColor,
        UIColor.black.withAlphaComponent(0.4).cgColor,
        UIColor.black.withAlphaComponent(0.3).cgColor,
        UIColor.black.withAlphaComponent(0.2).cgColor,
        UIColor.black.withAlphaComponent(0.1).cgColor,
        UIColor.clear.cgColor,
        UIColor.clear.cgColor
    ]

    gradient.startPoint = CGPoint(x: 0.5, y: 0)
    gradient.endPoint = CGPoint(x: 0.5, y: 1)

    view.layer.insertSublayer(gradient, at: 0)
}

func clubProfileTopGradient(to view: UIView) {
    let gradient = CAGradientLayer()
    gradient.frame = view.bounds

    gradient.colors = [
        UIColor.black.cgColor,
        UIColor.black.cgColor,
        UIColor.black.cgColor,
        UIColor.black.withAlphaComponent(0.7).cgColor,
        UIColor.black.withAlphaComponent(0.5).cgColor,
        UIColor.black.withAlphaComponent(0.3).cgColor,
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
        UIColor.black.cgColor,
        UIColor.black.cgColor,
        UIColor.black.withAlphaComponent(0.8).cgColor,
        UIColor.black.withAlphaComponent(0.7).cgColor,
        UIColor.black.withAlphaComponent(0.6).cgColor,
        UIColor.black.withAlphaComponent(0.5).cgColor,
        UIColor.black.withAlphaComponent(0.4).cgColor,
        UIColor.black.withAlphaComponent(0.3).cgColor,
        UIColor.black.withAlphaComponent(0.2).cgColor,
        UIColor.black.withAlphaComponent(0.1).cgColor,
        UIColor.clear.cgColor,
        UIColor.clear.cgColor
    ]

    gradient.startPoint = CGPoint(x: 0.5, y: 1)
    gradient.endPoint = CGPoint(x: 0.5, y: 0)

    view.layer.insertSublayer(gradient, at: 0)
}

func addLeadingToTrailingGradient(to view: UIView) {
    let gradient = CAGradientLayer()
    gradient.frame = view.bounds

    gradient.colors = [
        UIColor.black.cgColor,
        UIColor.black.withAlphaComponent(0.8).cgColor,
        UIColor.black.withAlphaComponent(0.7).cgColor,
        UIColor.black.withAlphaComponent(0.6).cgColor,
        UIColor.black.withAlphaComponent(0.5).cgColor,
        UIColor.black.withAlphaComponent(0.4).cgColor,
        UIColor.black.withAlphaComponent(0.3).cgColor,
        UIColor.black.withAlphaComponent(0.2).cgColor,
        UIColor.black.withAlphaComponent(0.1).cgColor,
        UIColor.clear.cgColor,
        UIColor.clear.cgColor
    ]

    // Left → Right
    gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
    gradient.endPoint   = CGPoint(x: 1.0, y: 0.5)

    view.layer.insertSublayer(gradient, at: 0)
}

func addTrailingToLeadingGradient(to view: UIView) {
    let gradient = CAGradientLayer()
    gradient.frame = view.bounds

    gradient.colors = [
        UIColor.clear.cgColor,
        UIColor.clear.cgColor,
        UIColor.black.withAlphaComponent(0.1).cgColor,
        UIColor.black.withAlphaComponent(0.2).cgColor,
        UIColor.black.withAlphaComponent(0.3).cgColor,
        UIColor.black.withAlphaComponent(0.4).cgColor,
        UIColor.black.withAlphaComponent(0.5).cgColor,
        UIColor.black.withAlphaComponent(0.6).cgColor,
        UIColor.black.withAlphaComponent(0.7).cgColor,
        UIColor.black.withAlphaComponent(0.8).cgColor,
        UIColor.black.cgColor
    ]

    gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
    gradient.endPoint   = CGPoint(x: 1.0, y: 0.5)

    view.layer.insertSublayer(gradient, at: 0)
}

func addBlurAndGradient(to view: UIView) {
    // Blur
    let blurEffect = UIBlurEffect(style: .systemThinMaterialDark)
    let blurView = UIVisualEffectView(effect: blurEffect)
    blurView.frame = view.bounds
    blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.insertSubview(blurView, at: 0)
}

func addHorizontalCardGradient(to view: UIView) {
    let gradient = CAGradientLayer()
    gradient.frame = view.bounds

    gradient.colors = [
        UIColor.black.withAlphaComponent(0.75).cgColor,
        UIColor.black.withAlphaComponent(0.55).cgColor,
        UIColor.black.withAlphaComponent(0.45).cgColor,
        UIColor.black.withAlphaComponent(0.45).cgColor,
        UIColor.black.withAlphaComponent(0.45).cgColor,
        UIColor.black.withAlphaComponent(0.55).cgColor,
        UIColor.black.withAlphaComponent(0.75).cgColor

    ]

    gradient.locations = [0.0, 0.15, 0.35, 0.5, 0.65, 0.85, 1.0]

    gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
    gradient.endPoint   = CGPoint(x: 1.0, y: 0.5)

    view.layer.insertSublayer(gradient, at: 0)
}

func formatDate(with date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .short
    return formatter.string(from: date)
}

func setGlassEffect(for button: UIButton, withImage image: String) {
    if #available(iOS 26.0, *) {
        button.configuration = .glass()
    }
    else {
        button.layer.cornerRadius = button.frame.height / 2
        button.layer.backgroundColor = UIColor.darkGray.withAlphaComponent(0.6).cgColor
    }
    button.setImage(UIImage(systemName: image), for: .normal)
    button.tintColor = .white
}

func loadUIImage(from urlString: String) async -> UIImage? {
    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        return nil
    }

    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        return UIImage(data: data)
    } catch {
        print("Failed to load image:", error)
        return nil
    }
}

func formatTime(_ interval: Int) -> FormatTime {
    let seconds = interval % 60
    let minutes = (interval % 3600) / 60
    let hours = interval / 3600

    return FormatTime(hour: hours, minute: minutes, second: seconds)
}

func formatMemberCount(_ count: Int) -> String {
    if count >= 1_000_000 {
        let formatted = Double(count) / 1_000_000
        return String(format: "%.1fM", formatted)
            .replacingOccurrences(of: ".0", with: "")
    } else if count >= 1_000 {
        let formatted = Double(count) / 1_000
        return String(format: "%.1fk", formatted)
            .replacingOccurrences(of: ".0", with: "")
    } else {
        return "\(count)"
    }
}

func setSportImage(for activity: String) -> String {
    switch activity {
    case "Hiking":
        return "figure.hiking"
    case "Running":
        return "figure.run"
    case "Walking":
        return "figure.walk"
    case "Marathon":
        return "figure.highintensity.intervaltraining"
    default:
        return activity
    }
}

func resizeImageIfNeeded(_ image: UIImage, maxDimension: CGFloat) -> UIImage {

    let size = image.size

    if max(size.width, size.height) <= maxDimension {
        return image
    }

    let scale = maxDimension / max(size.width, size.height)

    let newSize = CGSize(
        width: size.width * scale,
        height: size.height * scale
    )

    let renderer = UIGraphicsImageRenderer(size: newSize)
    return renderer.image { _ in
        image.draw(in: CGRect(origin: .zero, size: newSize))
    }
}

func getCurrentWeekStart() -> String {
    var calendar = Calendar(identifier: .iso8601)
    calendar.timeZone = TimeZone.current

    let now = Date()
    let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)
    let startOfWeek = calendar.date(from: components)!

    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.timeZone = TimeZone.current

    return formatter.string(from: startOfWeek)
}
