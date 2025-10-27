import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    lazy var rootViewController = ViewController()

//    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        guard let windowScene = (scene as? UIWindowScene) else { return }
//        window = UIWindow(frame: UIScreen.main.bounds)
//        window!.makeKeyAndVisible()
//        window!.windowScene = windowScene
//        window!.rootViewController = rootViewController
//    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
           guard let windowScene = (scene as? UIWindowScene) else { return }

           let window = UIWindow(windowScene: windowScene)
           window.rootViewController = rootViewController
           self.window = window
           window.makeKeyAndVisible()

           print("✅ SceneDelegate carregou e exibiu a rootViewController")
       }
    // For spotify authorization and authentication flow
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        
        let parameters = rootViewController.appRemote.authorizationParameters(from: url)
        
        if let code = parameters?["code"] {
            rootViewController.responseCode = code
        } else if let access_token = parameters?[SPTAppRemoteAccessTokenKey] {
            rootViewController.accessToken = access_token
        } else if let error_description = parameters?[SPTAppRemoteErrorDescriptionKey] {
            print("No access token error =", error_description)
        }
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        print("sceneDidBecomeActive called")
        if let accessToken = rootViewController.appRemote.connectionParameters.accessToken {
            print("Trying to connect with existing accessToken")
            rootViewController.appRemote.connect()
        } else if let accessToken = rootViewController.accessToken {
            print("Trying to connect with stored accessToken")
            rootViewController.appRemote.connectionParameters.accessToken = accessToken
            rootViewController.appRemote.connect()
        } else {
            print("⚠️ No access token available, skipping connect()")
        }
    }


    func sceneWillResignActive(_ scene: UIScene) {
        if rootViewController.appRemote.isConnected {
            rootViewController.appRemote.disconnect()
        }
    }
}
