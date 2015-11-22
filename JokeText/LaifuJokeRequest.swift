//
//  LaifuJokeRequest.swift
//  JokeText
//
//  Created by tutujiaw on 15/11/18.
//  Copyright © 2015年 tujiaw. All rights reserved.
//

import Foundation


class LaifuJokeRequest : Request {
    var url: String {
        let sign = super.sign([(String, String)](), secret: "c7288cbf5a0941598e3ab326c27f9668")
        return super.url("http://route.showapi.com/107-32", sign: sign)
    }
    
    init() {
        super.init(appId: 12078)
    }
}
