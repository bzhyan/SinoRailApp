//
//  FBMeUser.swift
//  SinoRailAPP
//
//  Created by ybz on 2018/8/27.
//  Copyright © 2018年 SinoRailAPP. All rights reserved.
//

import UIKit

class FBMeUser {
    var name: String
    var avatarName: String
    var education: String
    //个人头像
    init(name: String, avatarName: String = "头像", education: String) {
        self.name = name
        self.avatarName = avatarName
        self.education = education
    }
}
