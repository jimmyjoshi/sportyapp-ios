//
//  TeamClass.swift
//  SportsYap!
//
//  Created by Ketan Patel on 20/05/17.
//  Copyright © 2017 Ketan Patel. All rights reserved.
//

import UIKit

class TeamClass: NSObject {
    
    var strName = ""
    var strCity = ""
    var strTeamId = ""
    var isSelected: Bool!
    var urlProfile:URL!
    
    
    func getTeamList(showLoader:(Bool!), success:@escaping (Array<Array<TeamClass>>) -> Void, failed:@escaping (String!) -> Void) {
        
//        if(isInternetConnection() == true) {
//            
//            let params:[String:String] = ["username": UserClass.sharedInstance.strUserName,
//                                          "password": UserClass.sharedInstance.strPassword,
//                                          "device_token": "",
//                                          "device_type": "ios"]
//            
//            MainReqeustClass.BaseRequestSharedInstance.PostRequset(showLoader: showLoader, url: LOGIN, parameter: params as [String : AnyObject]?, success: { (response:Dictionary<String, AnyObject>) in
//                
//                self.parsingLoginData(responseReq: response as NSDictionary)
//                success(response)
//                
//            }) { (response:String!) in
//                failed(response)
//            }
//            
//        }
//        else {
//            failed("no internet connection")
//        }
        
        
        
        var arrList = Array<Array<TeamClass>>()
        
        var arrHocky = Array<TeamClass>()
        var arrGolf = Array<TeamClass>()
        var arrFootball = Array<TeamClass>()
        var arrBsketball = Array<TeamClass>()
        var arrBasball = Array<TeamClass>()
        
        for _ in 0..<20 {
            
            let teamHockey = TeamClass()
            
            teamHockey.strName = "Rams"
            teamHockey.strCity = "Los Angeles"
            teamHockey.strTeamId = ""
            teamHockey.isSelected = false
            teamHockey.urlProfile = URL(string: "http://image.cdnllnwnl.xosnetwork.com/pics33/0/ZD/ZDSTIWUAKRNZTRF.20140918151907.jpg")
            
            arrHocky.append(teamHockey)
            
            
            
            let teamGolf = TeamClass()
            
            teamGolf.strName = "Rams"
            teamGolf.strCity = "Los Angeles"
            teamGolf.strTeamId = ""
            teamGolf.isSelected = false
            teamGolf.urlProfile = URL(string: "http://image.cdnllnwnl.xosnetwork.com/pics33/0/ZD/ZDSTIWUAKRNZTRF.20140918151907.jpg")
            
            arrGolf.append(teamGolf)
            
            
            
            let teamFootball = TeamClass()
            
            teamFootball.strName = "Rams"
            teamFootball.strCity = "Los Angeles"
            teamFootball.strTeamId = ""
            teamFootball.isSelected = false
            teamFootball.urlProfile = URL(string: "http://image.cdnllnwnl.xosnetwork.com/pics33/0/ZD/ZDSTIWUAKRNZTRF.20140918151907.jpg")
            
            arrFootball.append(teamFootball)
            
            
            
            
            let teamBasketball = TeamClass()
            
            teamBasketball.strName = "Rams"
            teamBasketball.strCity = "Los Angeles"
            teamBasketball.strTeamId = ""
            teamBasketball.isSelected = false
            teamBasketball.urlProfile = URL(string: "http://image.cdnllnwnl.xosnetwork.com/pics33/0/ZD/ZDSTIWUAKRNZTRF.20140918151907.jpg")
            
            arrBsketball.append(teamBasketball)

            
            
            
            
            let teamBasball = TeamClass()
            
            teamBasball.strName = "Rams"
            teamBasball.strCity = "Los Angeles"
            teamBasball.strTeamId = ""
            teamBasball.isSelected = false
            teamBasball.urlProfile = URL(string: "http://image.cdnllnwnl.xosnetwork.com/pics33/0/ZD/ZDSTIWUAKRNZTRF.20140918151907.jpg")
            
            arrBasball.append(teamBasball)
            
            
        }
        
        arrList.append(arrHocky)
        arrList.append(arrGolf)
        arrList.append(arrFootball)
        arrList.append(arrBsketball)
        arrList.append(arrBasball)
        
        success(arrList)
        
    }
    
}
