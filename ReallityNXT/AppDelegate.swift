//
//  AppDelegate.swift
//  ReallityNXT
//
//  Created by Jonish Sangwan on 03/06/24.
//

import UIKit
import GoogleSignIn
import FBSDKCoreKit
import GoogleMaps
import GooglePlaces
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navController: UINavigationController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        GMSServices.provideAPIKey(googleApiKey)
        GMSPlacesClient.provideAPIKey(googleApiKey)
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
              // Show the app's signed-out state.
            } else {
              // Show the app's signed-in state.
            }
          }
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        getUserData()
        return true
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
    
    func application(_ app: UIApplication, open url: URL,
              options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
      var handled: Bool
      handled = GIDSignIn.sharedInstance.handle(url)
      if handled {
        return true
      }
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )

      // Handle other custom URL types.

      // If not handled by this app, return false.
      return false
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

