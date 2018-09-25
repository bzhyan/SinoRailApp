//
//  ApproveDetail.swift
//  SinoRailAPP
//
//  Created by ybz on 2018/9/10.
//  Copyright © 2018年 SinoRailAPP. All rights reserved.
//

import UIKit

class ApproveDetail: NSObject {

//    private String index;
//    private String name;
//    private String object;
//    private boolean current;
//
//    private Map<String, String> defaultObject = new HashMap<String, String>();
//    private Map<String, String> changeObject = new HashMap<String, String>();
//    private int objectQty;
//    private List<String> jumpStep = new ArrayList<String>();
    var index : String = ""
    var name : String = ""
    var object : String = ""
    var current : Bool = false
    var defaultObject : NSDictionary = [:]
    var changeObject : NSDictionary = [:]
    var Qty  = 1
    var jumpStep : NSArray = []
    
    init(index:String,name:String,object:String,current:Bool,defaultObject:NSDictionary,changeObject:NSDictionary,jumpStep:NSArray){
        self.index = index
        self.name = name
        self.object = object
        self.current = current
        self.defaultObject = defaultObject
        self.changeObject = changeObject
        self.jumpStep = jumpStep
    }
}
