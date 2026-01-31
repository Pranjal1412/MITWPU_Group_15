import UIKit
import Supabase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let supabase = SupabaseManager.shared.client
    
    
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

    }

    // THIS IS CRITICAL: This handles the redirect back from Google to your app
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }

//        if url.scheme == "DevTeamRunnr" {
//            Task {
//                do {
//                    // Use .session(from: url) instead of getSessionFromUrl
//                    let session = try await supabase.auth.session(from: url)
//                    
//                    print("Login Successful! User: \(session.user.email ?? "Unknown")")
//                    
//                    await MainActor.run {
//                        self.proceedAfterLogin()
//                    }
//                } catch {
//                    print("Auth error: \(error.localizedDescription)")
//                }
//            }
//        }
    }
    
//    func proceedAfterLogin() {
//        // 1. Get the current window's root view controller
//        guard let rootVC = self.window?.rootViewController else { return }
//        
//        // 2. Setup your destination
//        let destinationVC = SetProfileViewController()
//        destinationVC.modalPresentationStyle = .fullScreen
//        
//        // 3. Call present on the rootVC instead of self
//        rootVC.present(destinationVC, animated: true)
//    }
}
