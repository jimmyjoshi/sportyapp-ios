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
import CoreLocation


@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    var tabbar: KpTabBarController!
        
    var strStreamName = String("")!
    var strUsername = String("")!
    var strPassword = String("")!
    var arrGameList = Array<GameClass>()
    
    var locationManager:CLLocationManager!
    var userLocation = CLLocation()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        IQKeyboardManager.sharedManager().enable = true
        
        GMSPlacesClient.provideAPIKey("AIzaSyA1QzteBViMZnOIHORGMMaCTYXrnOSbblo")
        
        //Location code
        self.determineCurrentLocation()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {}
    func applicationDidEnterBackground(_ application: UIApplication) {}
    func applicationWillEnterForeground(_ application: UIApplication) {}
    
    func applicationDidBecomeActive(_ application: UIApplication)
    {
        UserDefaults.standard.register(defaults: [kkeyLocationDateTime : Date()])
    }
    func applicationWillTerminate(_ application: UIApplication) {}
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool
    {
        if(url.scheme == "fb285090435024233") { //Facebook
            return SDKApplicationDelegate.shared.application(app, open: url, options: options)
        }

        return true
    }
    
    //MARK: Location Methods
    func determineCurrentLocation()
    {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            //locationManager.startUpdatingHeading()
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        self.userLocation = locations[0] as CLLocation
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        //manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
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

