//
//  ApproveInfo.swift
//  SinoRailAPP
//
//  Created by ybz on 2018/9/7.
//  Copyright © 2018年 SinoRailAPP. All rights reserved.
//

import UIKit

class ApproveInfo: NSObject {
//    <ListId>3DCC088C-853A-42F3-90F7-2C210EA04DFB</ListId>
//    <WebId>8CFBFA75-776A-46DE-899E-2751ADE644F4</WebId>
//    <ItemId>155387;#{2D1F2D2C-1E9C-4892-9815-4E2B813F7C76}</ItemId>
//    <title>请审批: 差旅费报销单ZJSJ201807CL0065</title>
//    <arrive>2018-09-03</arrive>
//    <name>审批</name>
//    <owner>吴雷</owner>
//    <start>2018-09-03</start>
//    <WorkflowState>进行中</WorkflowState>
//    <SiteId>c5279f3e-ced2-41ac-a296-050bf2ca1d56</SiteId>
//    <operation>0</operation>
//    <StepIndex>1</StepIndex>
//    <StepName>报销专责</StepName>
//    <desc>项目信息: 差旅费报销单ZJSJ201807CL0065 状态:进行中</desc>
    var ListId : String = ""
    var WebId : String = ""
    var ItemId : String = ""
    var title : String = ""
    var arrive : String = ""
    var name : String = ""
    var owner : String = ""
    var start : String = ""
    var workflowState : String = ""
    var SiteId : String = ""
    var operation : String = ""
    var StepIndex : String = ""
    var StepName : String = ""
    var desc : String = ""
    init(ListId : String,WebId : String,ItemId : String,title : String,arrive : String,name : String,owner : String,start : String,workflowState : String,SiteId : String,operation : String,StepIndex : String,StepName : String,desc : String){
        self.ListId = ListId
        self.WebId = WebId
        self.ItemId = ItemId
        self.title = title
        self.arrive = arrive
        self.name = name
        self.owner = owner
        self.start = start
        self.workflowState = workflowState
        self.SiteId = SiteId
        self.operation = operation
        self.StepIndex = StepIndex
        self.StepName = StepName
        self.desc = desc
    }
}
