//
//  GameClass.swift
//  SportsYap!
//
//  Created by Ketan Patel on 20/06/17.
//  Copyright © 2017 Ketan Patel. All rights reserved.
//

import UIKit
import SwiftyJSON

class GameClass: NSObject {
    
    var strTeam1FirstName = ""
    var strTeam2FirstName = ""
    var strTeam1LastName = ""
    var strTeam2LastName = ""
    var strTeam1Score = ""
    var strTeam2Score = ""
    var strTime = ""
    var strMatchTpe = ""
    
    var strMatchId = ""
    var strHomeMatchId = ""
    var strAwayMatchId = ""
    func getGameListFor(showLoader:(Bool!), strFullURL:String ,strMatchType:String, strDate:String, success:@escaping (Array<GameClass>) -> Void, failed:@escaping (String!) -> Void) {
        
        if(isInternetConnection() == true) {
            
            MainReqeustClass.BaseRequestSharedInstance.GetRequsetForGame(showLoader: showLoader, url: strFullURL, parameter: nil, success: { (response:Dictionary<String, AnyObject>) in
                self.strMatchTpe = strMatchType
                let arrList = self.parsingGameList(responseReq: response as NSDictionary)
                success(arrList)
                
            }) { (response:String!) in
                failed(response)
            }
            
        }
        else {
            failed("no internet connection")
        }
    }
    
    
    //MARK: - INternal Methods
    func parsingGameList(responseReq: NSDictionary) -> Array<GameClass> {
        
        var arrList = Array<GameClass>()
        
        var dict = JSON(responseReq).dictionaryValue
        
        var tempDict = dict["scores"]?.dictionaryValue
        tempDict = tempDict?["category"]?.dictionaryValue
        
//        if(tempDict?["match"]?.arrayValue == nil) {
//            
//            let tempArray = tempDict?["matches"]?.arrayValue
//            
//            for dict in tempArray! {
//                
//                let gameDetail = GameClass()
//                
//                let tempD1 = dict["awayteam"].dictionaryValue
//                gameDetail.strTeam1Score = (tempD1["totalscore"]?.stringValue)!
//                gameDetail.strTeam1FirstName = (tempD1["name"]?.stringValue)!
//                gameDetail.strTeam2LastName = (tempD1["name"]?.stringValue)!
//                
//                
//                let tempD2 = dict["hometeam"].dictionaryValue
//                gameDetail.strTeam1Score = (tempD2["totalscore"]?.stringValue)!
//                gameDetail.strTeam1FirstName = (tempD2["name"]?.stringValue)!
//                gameDetail.strTeam2LastName = (tempD2["name"]?.stringValue)!
//                
//                gameDetail.strTime = (dict["time"].stringValue)
//                
//                arrList.append(gameDetail)
//            }
//            
//            return arrList
//            
//        }
//        else {
        
        
            if let temp1Array = tempDict?["match"]?.arrayValue
        
            {
                let tempArray = tempDict?["match"]?.arrayValue
        
                for dict in tempArray! {
                let gameDetail = GameClass()
                
                let tempD1 = dict["awayteam"].dictionaryValue
                gameDetail.strMatchId = dict["id"].stringValue
                gameDetail.strTeam1Score = (tempD1["totalscore"]?.stringValue)!
                gameDetail.strAwayMatchId = (tempD1["id"]?.stringValue)!
                let strTemp1 = tempD1["name"]?.stringValue
                gameDetail.strTeam1LastName = (strTemp1?.components(separatedBy: " ").last)!
                let strMain1 = (tempD1["name"]?.stringValue)!.components(separatedBy: " ").dropLast().joined(separator: " ")
                gameDetail.strTeam1FirstName = strMain1
                let tempD2 = dict["hometeam"].dictionaryValue
                gameDetail.strTeam2Score = (tempD2["totalscore"]?.stringValue)!
                gameDetail.strHomeMatchId = (tempD2["id"]?.stringValue)!
                let strTemp2 = tempD2["name"]?.stringValue
                gameDetail.strTeam2LastName = (strTemp2?.components(separatedBy: " ").last)!
                let strMain2 = (tempD2["name"]?.stringValue)!.components(separatedBy: " ").dropLast().joined(separator: " ")
                gameDetail.strTeam2FirstName = strMain2
                gameDetail.strTime = (dict["time"].stringValue)
                gameDetail.strMatchTpe = strMatchTpe
                arrList.append(gameDetail)
            }
            
                
            }
            return arrList
//        }
        
    }
    
}


