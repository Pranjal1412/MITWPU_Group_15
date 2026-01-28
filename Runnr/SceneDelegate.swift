import UIKit
import GoogleSignIn

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Since you are using a Storyboard (Main), iOS handles the window setup.
        // You only need to verify the scene exists.
        guard let _ = (scene as? UIWindowScene) else { return }
        
        window?.overrideUserInterfaceStyle = .dark
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        // Log to confirm GIDClientID is being read correctly from Info.plist
        if let clientID = Bundle.main.infoDictionary?["GIDClientID"] as? String {
            print("Google Sign-In Client ID found: \(clientID)")
        } else {
            print("Error: GIDClientID not found in Info.plist. Button will not work.")
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
