//
//  MyNewsOther.swift
//  SinoRailAPP
//
//  Created by ybz on 2018/8/30.
//  Copyright © 2018年 SinoRailAPP. All rights reserved.
//

import UIKit

class MyNewsOther: NSObject {
    var newsPicName:String!
    var newsTitle:String!
    var newsContent:String!
    var newsFollowUp:String!
    var newsSiteId:String!
    var newsWebId:String!
    var newsListId:String!
    var newsItemId:String!
    
    init(newsPicName:String,newsTitle:String,newsContent:String,newsFollowUp:String,newsSiteId:String,newsWebId:String,newsListId:String,newsItemId:String ) {
        self.newsPicName = newsPicName
        self.newsTitle = newsTitle
        self.newsContent = newsContent
        self.newsFollowUp = newsFollowUp
        self.newsSiteId = newsSiteId
        self.newsWebId = newsWebId
        self.newsListId = newsListId
        self.newsItemId = newsItemId
    }
}

