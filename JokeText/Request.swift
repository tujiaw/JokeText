//: Playground - noun: a place where people can play

//
//  Request.swift
//  JokeText
//
//  Created by tutujiaw on 15/11/11.
//  Copyright © 2015年 tujiaw. All rights reserved.
//

import Foundation

class Request {
    var appId: Int
    
    var timestamp: String {
        return NSDate.currentDate("yyyyMMddHHmmss")
    }
    
    var signMethod = "md5"
    
    var resGzip = 0
    
    var allParams = [(String, String)]()
    
    init(appId: Int) {
        self.appId = appId
    }
    
    func sign(appParams: [(String, String)], secret: String) -> String {
        self.allParams = appParams
        self.allParams.append(("showapi_appid", String(self.appId)))
        self.allParams.append(("showapi_timestamp", self.timestamp))
        
        let sortedParams = allParams.sort{$0.0 < $1.0}
        var str = ""
        for item in sortedParams {
            str += (item.0 + item.1)
        }
        str += secret.lowercaseString
        return str.md5()
    }
    
    func url(mainUrl: String, sign: String) -> String {
        var url = mainUrl + "?"
        for param in self.allParams {
            url += "\(param.0)=\(param.1)&"
        }
        url += "showapi_sign=\(sign)"
        return url
    }
}


