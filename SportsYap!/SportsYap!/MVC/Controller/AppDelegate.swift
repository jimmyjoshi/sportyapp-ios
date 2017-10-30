//  4.8.2-Tag-Game@2x


//  AppDelegate.swift
//  EventApp
//
//  Created by Ketan Patel on 04/04/17.
//  Copyright © 2017 Ketan Patel. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import GooglePlaces


@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var tabbar: KpTabBarController!
        
    var strStreamName = String("")!
    var strUsername = String("")!
    var strPassword = String("")!
    var arrGameList = Array<GameClass>()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.sharedManager().enable = true
        
        GMSPlacesClient.provideAPIKey("AIzaSyA1QzteBViMZnOIHORGMMaCTYXrnOSbblo")
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {}
    func applicationDidEnterBackground(_ application: UIApplication) {}
    func applicationWillEnterForeground(_ application: UIApplication) {}
    func applicationDidBecomeActive(_ application: UIApplication) {}
    func applicationWillTerminate(_ application: UIApplication) {}
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if(url.scheme == "fb285090435024233") { //Facebook
            return SDKApplicationDelegate.shared.application(app, open: url, options: options)
        }

        return true
    }
    
}
extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat
        {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
}

