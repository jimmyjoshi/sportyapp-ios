//
//  AppUtiles.swift
//  DumpTruck
//
//  Created by Ketan Patel on 02/10/16.
//  Copyright © 2016 Ketan Patel. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration
import ACFloatingTextfield

func setBorder(idObject: UIView, size: CGFloat, color:UIColor) {
    idObject.layer.borderColor = color.cgColor
    idObject.layer.borderWidth = size
    idObject.layer.masksToBounds = true
}

func setCornurRedius(idObject: UIView, radius: CGFloat) {

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        idObject.layer.cornerRadius = radius
        idObject.layer.masksToBounds = true
    }
}

func showAlert(strMsg: String, vc:UIViewController) {
    let alert = UIAlertController(title: AppName, message: strMsg, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
    vc.present(alert, animated: true, completion: nil)
}

func isInternetConnection() -> Bool {
    
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
            SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
        }
    }
    
    var flags = SCNetworkReachabilityFlags()
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
        return false
    }
    let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
    let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
    return (isReachable && !needsConnection)
    
}

func setImageFromURL(imageView: UIImageView, url: URL!, placeHolderImg: UIImage) {
    //imageView.sd_setImage(with: url, placeholderImage: placeHolderImg)
}

func setTextFiled(txt: ACFloatingTextField) {
    txt.selectedLineColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    txt.lineColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    txt.selectedPlaceHolderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
}

func setTabbar() {
    
    let homeStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let homeVC = homeStoryboard.instantiateViewController(withIdentifier: "HomeVC")
    homeVC.tabBarItem.image = #imageLiteral(resourceName: "Home")
    homeVC.tabBarItem.selectedImage = #imageLiteral(resourceName: "slt_Home")
    
    //Commented as this particular screen is no more used
    let discoverVC = homeStoryboard.instantiateViewController(withIdentifier: "DiscoverVC")
    
    //let discoverVC = homeStoryboard.instantiateViewController(withIdentifier: "DiscoverUserVC")
    discoverVC.tabBarItem.image = #imageLiteral(resourceName: "search_icon")
    discoverVC.tabBarItem.selectedImage = #imageLiteral(resourceName: "slt_discover")
    
    let meVC = homeStoryboard.instantiateViewController(withIdentifier: "MeVC") as! MeVC
    meVC.isOtherProfile = false
    meVC.tabBarItem.image = #imageLiteral(resourceName: "Me")
    meVC.tabBarItem.selectedImage = #imageLiteral(resourceName: "slt_Me")
    
    
    let newsVC = homeStoryboard.instantiateViewController(withIdentifier: "NewVC")
    //let newsVC = homeStoryboard.instantiateViewController(withIdentifier: "TransparentViewController")
    //newsVC.tabBarItem.image = #imageLiteral(resourceName: "Record")
    //newsVC.tabBarItem.selectedImage = #imageLiteral(resourceName: "Record")
    
    
    //Create Custom TabBar
    appDelegate.tabbar = KpTabBarController()
    
    //Set Tabbar Properties
    appDelegate.tabbar.bgColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    appDelegate.tabbar.viewControllers = [homeVC, discoverVC, meVC, newsVC]
    //appDelegate.tabbar.viewControllers = [homeVC, discoverVC, meVC]
    let new = UINavigationController.init(rootViewController: appDelegate.tabbar)
    new.navigationBar.isHidden = true
    //Add Tabbar in Window
    appDelegate.window?.rootViewController = new
    appDelegate.window?.makeKeyAndVisible()
    
}
