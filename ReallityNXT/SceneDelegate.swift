//
//  SceneDelegate.swift
//  ReallityNXT
//
//  Created by Jonish Sangwan on 03/06/24.
//

import UIKit
import FBSDKCoreKit


class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
                
                /// 2. Create a new UIWindow using the windowScene constructor which takes in a window scene.
            let window = UIWindow(windowScene: windowScene)
        self.window = window
        getUserData()
    }
    
    func getUserData(){
        guard let data = UserDefaults.standard.dictionary(forKey: "userProfile") else {
            moveToLoginVC()
            return
        }
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            do {
                let jsonDecoder = JSONDecoder()
                let dic = try jsonDecoder.decode(User.self, from: jsonData)
                Utility.shared.user = dic
                moveToHomeVC()
            } catch {
                moveToLoginVC()
                print("Unexpected error: \(error).")
            }
            
        } catch {
            moveToLoginVC()
            print(error.localizedDescription)
        }
    }
    
    func moveToHomeVC(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "RootStackTabViewController") as! RootStackTabViewController
        let rootNC = UINavigationController(rootViewController: initialViewController)
        rootNC.isNavigationBarHidden = true
        self.window?.rootViewController = rootNC
        self.window?.makeKeyAndVisible()
    }
    
    func moveToLoginVC(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        let rootNC = UINavigationController(rootViewController: initialViewController)
        rootNC.isNavigationBarHidden = true
        self.window?.rootViewController = rootNC
        self.window?.makeKeyAndVisible()
    }
    
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }

        ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url,
            sourceApplication: nil,
            annotation: [UIApplication.OpenURLOptionsKey.annotation]
        )
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
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

