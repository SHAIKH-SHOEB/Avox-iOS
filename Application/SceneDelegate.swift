//
//  SceneDelegate.swift
//  Avox
//
//  Created by Nimap on 26/01/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var baseController: UINavigationController?
    var viewController: UIViewController?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        //if UserDefaults.standard.string(forKey: "appTheme")!.elementsEqual("dark") {
        if Helper.isAppMode == "dark" {
            window!.overrideUserInterfaceStyle = .dark
        } else {
            window!.overrideUserInterfaceStyle = .light
        }
        
//        if scene is UIWindowScene {
//            viewController = SplashViewController()
//            baseController = UINavigationController(rootViewController: viewController!)
//            baseController!.setNavigationBarHidden(true, animated: false)
//            self.window?.backgroundColor = Helper.Color.bgPrimary
//            self.window?.makeKeyAndVisible()
//            window?.rootViewController = baseController
//        }
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        print("App will terminate")
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        print("App became active")
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        print("App will resign active")
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        print("App will enter foreground")
        DatabaseManager.share.saveContext()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        print("App entered background")

        // Save changes in the application's managed object context when the application transitions to the background.
        DatabaseManager.share.saveContext()
    }
    
    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        // Ensure the window scene has a window with a root view controller
        guard let navigationController = windowScene.windows.first?.rootViewController as? UINavigationController else {
            // Handle the case where the root view controller is not a UINavigationController
            completionHandler(false)
            return
        }
        
        switch shortcutItem.type {
        case "QuickActionSearch":
            let searchViewController = SearchViewController()
            navigationController.pushViewController(searchViewController, animated: true)
            completionHandler(true)
        default:
            completionHandler(false)
        }
    }
}

