//: Playground - noun: a place where people can play

//
//  Request.swift
//  JokeText
//
//  Created by tutujiaw on 15/11/11.
//  Copyright © 2015年 tujiaw. All rights reserved.
//

import Foundation

extension NSDate {
    static func currentDate(dateFormat: String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.locale = NSLocale.currentLocale()
        return dateFormatter.stringFromDate(NSDate())
    }
}

struct Request {
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
    
    mutating func sign(appParams: [(String, String)], secret: String) -> String {
        self.allParams = appParams
        self.allParams.append(("showapi_appid", String(self.appId)))
        self.allParams.append(("showapi_timestamp", self.timestamp))
        
        let sortedParams = allParams.sort({(left, right) -> Bool in
            return left.0 < right.0
        })
        
        var str = ""
        for item in sortedParams {
            str += (item.0 + item.1)
        }
        str += secret.lowercaseString
        str = secret
        return str
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


