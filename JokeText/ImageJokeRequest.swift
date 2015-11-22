//
//  ImageJokeRequest.swift
//  JokeText
//
//  Created by tutujiaw on 15/11/22.
//  Copyright © 2015年 tujiaw. All rights reserved.
//

import Foundation

class ImageJokeRequest : Request {
    var time: String = ""
    var page: Int = 0
    var maxResult: Int = 0
    
    var url: String {
        let params = [("time", self.time), ("page", String(self.page)), ("maxResult", String(self.maxResult))]
        let sign = super.sign(params, secret: "c7288cbf5a0941598e3ab326c27f9668")
        return super.url("http://route.showapi.com/107-33", sign: sign)
    }
    
    init(time: String = NSDate.currentDate("yyyy-MM-dd"), page: Int = 1, maxResult: Int = 20) {
        super.init(appId: 12078)
        self.time = time
        self.page = page
        self.maxResult = maxResult
    }
}