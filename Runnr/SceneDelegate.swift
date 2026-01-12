import UIKit
import GoogleSignIn

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Since you are using a Storyboard (Main), iOS handles the window setup.
        // You only need to verify the scene exists.
        guard let _ = (scene as? UIWindowScene) else { return }
        
        // Log to confirm GIDClientID is being read correctly from Info.plist
        if let clientID = Bundle.main.infoDictionary?["GIDClientID"] as? String {
            print("✅ Google Sign-In Client ID found: \(clientID)")
        } else {
            print("❌ Error: GIDClientID not found in Info.plist. Button will not work.")
        }
    }

    // THIS IS CRITICAL: This handles the redirect back from Google to your app
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }

        // Pass the URL to the Google SDK to process the sign-in result
        let handled = GIDSignIn.sharedInstance.handle(url)
        
        if handled {
            print("🔗 Google Sign-In handled the URL successfully.")
        }
    }
}
