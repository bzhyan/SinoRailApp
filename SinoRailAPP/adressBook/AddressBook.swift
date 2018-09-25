//
//  AddressBook.swift
//  SinoRailAPP
//
//  Created by ybz on 2018/8/21.
//  Copyright © 2018年 SinoRailAPP. All rights reserved.
//

import UIKit

class AddressBook: NSObject {
    @objc var name:String
    @objc var company:String
    @objc var department:String
    @objc var phone:String
    @objc var duty : String
    @objc var image :UIImage
    @objc var ItemId : String
    @objc var mobile : String
    @objc var ext : String
    
    init(name:String,image:UIImage,company:String,department:String,phone:String,duty:String,ItemId:String,mobile:String,ext:String) {
        self.name = name
        self.image = image
        self.company = company
        self.department = department
        self.duty = duty
        self.phone = phone
        self.ItemId = ItemId
        self.mobile = mobile
        self.ext = ext
    }
}
