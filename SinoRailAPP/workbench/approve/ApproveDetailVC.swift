//
//  ApproveDetailVC.swift
//  SinoRailAPP
//
//  Created by ybz on 2018/9/9.
//  Copyright © 2018年 SinoRailAPP. All rights reserved.
//

import UIKit

class ApproveDetailVC: UIViewController,UIScrollViewDelegate {
    var stepSelected : String = ""
    var objectSelected : String = ""
    var content = ""
    var SiteId : String = ""
    var WebId : String = ""
    var ListId : String = ""
    var ItemId : String = ""
    var approveType : String = ""
    var approveTitle : String = ""
    var rootCode : String = ""
    var desc : String = ""
    var titleLabel = UILabel()
    var nextStep :UILabel = UILabel()
    var object : UILabel = UILabel()
    let webView=UIWebView()
    let webView1 = UIWebView()

//    let statusbarHeight = UIApplication.shared.statusBarFrame.height //获取statusBar的高度
//    let height = self.navigationController?.navigationBar.frame.size.height
    var pc: UIPageControl = UIPageControl(frame: CGRect(x:KScreenWidth/2-50,y:585,width:100,height:40))
    var sv: UIScrollView = UIScrollView()

    var approveDataList : [ApproveData] = []
    var approveDetail : String = ""
    
    var approveLc : String = ""
    
    var approveHistory : String = ""
    
    var jump : [String] = []
    
    var steps : [Step] = []
    
    var objects : [String:String] = [:]
    //命名空间
    let kNameSpace = "http://service.spf.sinorail.com/"
    //url前缀
    let WS = "http://office.sinorail.com:8888/"
    //url后缀
    let approveWS = "approveWS.asmx?WSDL"
    //actionName
    let action = "http://service.spf.sinorail.com/getExpenseApproveInfo"
    
    let action2 = "http://service.spf.sinorail.com/getApproveData"
    
    let bmApproveAction = "http://service.spf.sinorail.com/ExpenseApprove"
    let appCenterApproveAction = "http://service.spf.sinorail.com/AppCenterApprove"
    //去webservice请求数据
    func getApproveData(methodName:String,action:String){
        let rootCode = "<username>wulei1</username>"
            +      "<password>Mx0bg+sqQhBe4Aclig77yA==</password>"
            +       "<device>android</device>"
            +      "<SiteId>"+SiteId+"</SiteId>"
            +      "<WebId>"+WebId+"</WebId>"
            +      "<ListId>"+ListId+"</ListId>"
            +      "<ItemId>"+ItemId+"</ItemId>"
        
        let url = WS+approveWS
        
        let request = NSMutableURLRequest(url:NSURL(string:url) as URL! )
        
        let soapMsg: String = toSoapMessage(methodName: methodName, paramValues: rootCode)//methodName是请求的方法名
        
        let msgLength = String(soapMsg.characters.count)
        
        request.httpMethod = "POST"
        
        request.httpBody = soapMsg.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        request.addValue(msgLength, forHTTPHeaderField:"Content-Length")
        
        request.addValue(action, forHTTPHeaderField: "SOAPAction")
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main, completionHandler:checkItemListCallback)
        
    }
    func proveOrRefuse(type:String,methodName:String,action:String,operation:String,comment:String){
        if(approveType == "Approvercenter"){
            print("rootCode是这样的")
            rootCode =    "<username>wulei1</username>"
                +      "<password>Mx0bg+sqQhBe4Aclig77yA==</password>"
                +      "<device>android</device>"
                +       "<operation>"+operation+"</operation>"
                +       "<step>"+stepSelected+"</step>"
                +       "<person>"+objectSelected+"</person>"
                +       "<comments>"+Base64Encode(string: comment)+"</comments>"
                +      "<SiteId>"+SiteId+"</SiteId>"
                +      "<WebId>"+WebId+"</WebId>"
                +      "<ListId>"+ListId+"</ListId>"
                +      "<ItemId>"+ItemId+"</ItemId>"
        }else if(approveType == "kqweb"){
            
        }else if(approveType == "bm"){
          rootCode =    "<username>wulei1</username>"
                +      "<password>Mx0bg+sqQhBe4Aclig77yA==</password>"
                +      "<device>android</device>"
                +       "<operation>"+operation+"</operation>"
                +       "<step>"+stepSelected+"</step>"
                +       "<person>"+objectSelected+"</person>"
            +       "<comments>"+Base64Encode(string: comment)+"</comments>"
                +      "<SiteId>"+SiteId+"</SiteId>"
                +      "<WebId>"+WebId+"</WebId>"
                +      "<ListId>"+ListId+"</ListId>"
                +      "<ItemId>"+ItemId+"</ItemId>"

        }else if(approveType == "hr"){
            
        }

        
        let url = WS+approveWS
        
        let request = NSMutableURLRequest(url:NSURL(string:url) as URL! )
        
        let soapMsg: String = toSoapMessage(methodName: methodName, paramValues: rootCode)//methodName是请求的方法名
        
        let msgLength = String(soapMsg.characters.count)
        
        request.httpMethod = "POST"
        
        request.httpBody = soapMsg.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        request.addValue(msgLength, forHTTPHeaderField:"Content-Length")
        
        request.addValue(action, forHTTPHeaderField: "SOAPAction")
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main, completionHandler:checkItemListCallbackApprove)
        
    }
    func checkItemListCallbackApprove(response:URLResponse?,data:Data?,error:Error?) -> Void{
        if error != nil{
            print(error ?? "出错了")
        }else {
            let alertController = UIAlertController(title: "成功!",message: nil, preferredStyle: .alert)
            //显示提示框
            self.present(alertController, animated: true, completion: nil)
            //两秒钟后自动消失
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                self.presentedViewController?.dismiss(animated: false, completion: nil)
            }
        }
    }
    func getApproveDetail(methodName:String,action:String){
        if(approveType == "Approvercenter"){
            var html = "<center style=\"position:absolute;top:0\">"
                + "<table bgcolor=#FFFFFF width=\"100%\" border=0 cellspacing=0>"
                + "<td align=center><font size=2px>审批详情</font></td></tr>"
                + "<tr bgcolor=#DDDDDD align=right><td>"
                + "<table width=\"99%\" border=0 cellpadding=0 cellspacin=1>"
            html += "<td>"
            html += "<font size=2px>"
            html += desc
            html += "</font>"
            html += "</td>"
            //            html += "</tr>"
            html += "</table>"
            html += "</td></tr>"
            html += "</table>"
            html += "</center>"
            content = html
            webView.loadHTMLString(content, baseURL: nil)
        }else if(approveType == "kqweb"){
            
        }else if(approveType == "bm"){

        let rootCode = "<username>wulei1</username>"
            +      "<password>Mx0bg+sqQhBe4Aclig77yA==</password>"
            +       "<device>android</device>"
            +      "<SiteId>"+SiteId+"</SiteId>"
            +      "<WebId>"+WebId+"</WebId>"
            +      "<ListId>"+ListId+"</ListId>"
            +      "<ItemId>"+ItemId+"</ItemId>"
        
        let url = WS+approveWS
        
        let request = NSMutableURLRequest(url:NSURL(string:url) as URL! )
        
        let soapMsg: String = toSoapMessage(methodName: methodName, paramValues: rootCode)//methodName是请求的方法名

        let msgLength = String(soapMsg.characters.count)
        
        request.httpMethod = "POST"
        
        request.httpBody = soapMsg.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        request.addValue(msgLength, forHTTPHeaderField:"Content-Length")
        
        request.addValue(action, forHTTPHeaderField: "SOAPAction")
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main, completionHandler:checkItemListCallback1)
        }
    }
    //查询审批详情回调，解析xml拼接html代码
    func checkItemListCallback1(response:URLResponse?,data:Data?,error:Error?) -> Void{
        if error != nil{
            print(error ?? "出错了")
        }else {
            // 加载整个XML数据
            let doc = try! GDataXMLDocument(data: data!, options: 0)
            // 获取文档的根节点
            
            let root = doc.rootElement()
            // 获得根节点里面所有的元素
            let elements = root?.elements(forName: "soap:Body") as! [GDataXMLElement]
            var html = "<center style=\"position:absolute;top:0\">"
                   + "<table bgcolor=#FFFFFF width=\"100%\" border=0 cellspacing=0>"
                   + "<td align=center><font size=2px>审批详情</font></td></tr>"
                    + "<tr bgcolor=#DDDDDD align=right><td>"
                    + "<table width=\"99%\" border=0 cellpadding=0 cellspacin=1>"
            for element in elements {
                //ApproveList节点的title属性
//                let main = (element.elements(forName: "getExpenseApproveInfoResponse")[0] as AnyObject).stringValue()!
                let response = (element.elements(forName: "getExpenseApproveInfoResponse")) as! [GDataXMLElement]
                for results in response{
                    let result = (results.elements(forName: "getExpenseApproveInfoResult")) as! [GDataXMLElement]
                    for main in result{
                        let mainXML = main.elements(forName :"Main") as! [GDataXMLElement]
                        for str in mainXML{
                            let info = (str.elements(forName: "string") as! [GDataXMLElement])
                            for stringValue in info{
//                                html += "<tr bgcolor=#FFFFFF>"
                                html += "<td>"
                                html += "<font size=2px>"
                                html += stringValue.stringValue()
                                html += "</font>"
                                html += "</td>"
                                html += "</tr>"
                            }
                        }
                    }
                    html += "</table>"
                    for detail in result{
                        let detailXML = detail.elements(forName :"Detail") as! [GDataXMLElement]
                        
                        var j = 0
                        for str in detailXML{
                            let info = (str.elements(forName: "string") as! [GDataXMLElement])
                            for stringValue in info{
                                html += "<table width=\"99%\" border=0 cellpadding=0 cellspacin=1>"
                                let str = stringValue.stringValue()
                                 let strArray = str?.components(separatedBy: "|")
                                let index = j+1
                                var rowspan = strArray?.count
                        html += "<tr bgcolor=#FFFFFF><td rowspan=\(rowspan!) align=center width=20><font size=2px>\(index)</font></td>"
                                var i=0
                                for subDetail in strArray!{
                                    if(i != 0){
                                        html += "<tr bgcolor=#FFFFFF>"
                                    }
                                    
                                    html += "<td>"
                                    html += "<font size=2px>"
                                    html += subDetail
                                    html += "</font>"
                                    html += "</td>"
                                    html += "</tr>"
                                    i+=1
                                }
                                i=0
                                j+=1
                            }
                            html += "</table>"
                            j=0
                        }
                    }
                    html += "</table>"
                    html += "</td></tr>"
                    html += "</table>"
                    html += "</center>"
                
                    content = html
                            webView.loadHTMLString(content, baseURL: nil)
                }
               

            }
        }
    }
    func checkItemListCallback(response:URLResponse?,data:Data?,error:Error?) -> Void{
        if error != nil{
            print(error ?? "出错了")
        }
            
        else {
            //这里的语法已经把OC的初始化函数直接转换过来了
            let doc:GDataXMLDocument = try! GDataXMLDocument(data:data, options : 0)
            let approveDatasource = try! doc.nodes(forXPath: "//ApproveData", namespaces:nil) as! [GDataXMLElement]
            var html = "<center>"
                        + "<table bgcolor=#FFFFFF width=\"100%\" border=0 cellspacing=0>"
                        + "<tr><td align=center><font size=2px>审批流程</font></td></tr>"
                        + "<tr bgcolor=#CCCCCC align=right><td>"
            var approveData : ApproveData?
            var defaultObject:[String:String] = [:]
            var changeObject:[String:String] = [:]
            for approveInfo in approveDatasource {
                //ApproveList节点的title属性
                let Index = (approveInfo.elements(forName: "Index")[0] as AnyObject).stringValue()!
                approveData?.index = Index
                //获取name节点元素
                let Name = (approveInfo.elements(forName: "Name")[0] as AnyObject).stringValue()!
                approveData?.name = Name
                let DefaultObject = (approveInfo.elements(forName: "Default")[0] as AnyObject).stringValue()!
                
                let defaultObj = DefaultObject.components(separatedBy: "|")
                if(defaultObj[0] != ""){
                    for obj in defaultObj{
                        defaultObject.updateValue(obj.components(separatedBy: ";")[0], forKey: obj.components(separatedBy: ";")[1])
                    }
                }else {
                    defaultObject = [:]
                }

                
                let Current = (approveInfo.elements(forName: "Current")[0] as AnyObject).stringValue()!
                approveData?.current = Current
                
                let Qty = (approveInfo.elements(forName: "Qty")[0] as AnyObject).stringValue()!
                approveData?.objectQty = Qty
                let Change = (approveInfo.elements(forName: "Change")[0] as AnyObject).stringValue()!
                let change = Change.components(separatedBy: "|")
                if(change[0] != ""){
                    for changeObj in change{
                        changeObject.updateValue(changeObj.components(separatedBy: ";")[0], forKey: changeObj.components(separatedBy: ";")[1])
                    }
                }else{
                    changeObject = [:]
                }

                let Step = (approveInfo.elements(forName: "Steps")[0] as AnyObject).stringValue()!
                
                let jump = Step.components(separatedBy: "|")
        
                
                approveData = ApproveData(index: Index, current: Current, name: Name, defaultObject: defaultObject, changeObject: changeObject, objectQty: Qty, jumpStep: jump)
                defaultObject = [:]
                changeObject = [:]
                if(Current=="1"){
                    html += "<table width=\"99%\" border=0 cellpadding=0 cellspacin=1>"
                    html += "<tr bgcolor=#FFFFCC><td width = 20 rowspan=2 align=center width=\"20\"><font size=2px>"
                    html += Index
                    html += "</font></td><td><font size=2px>审批步骤："
                    html += Name
                    html += "</font></td></tr>"
                    html += "<tr bgcolor=#FFFFCC><td><font size=2px>分配对象："
                    html += DefaultObject.components(separatedBy: ";")[1]
                    html += "</font></td></tr>"
                    html += "</table>"
                }else{
                    html += "<table width=\"99%\" border=0 cellpadding=0 cellspacin=1>"
                    html += "<tr bgcolor=#FFFFFF><td width = 20 rowspan=2 align=center width=\"20\"><font size=2px>"
                    html += Index
                    html += "</font></td><td><font size=2px>审批步骤："
                    html += Name
                    html += "</font></td></tr>"
                    html += "<tr bgcolor=#FFFFFF><td><font size=2px>分配对象："
                    if(DefaultObject == ""){
                        html+=""
                    }else{
                        html += DefaultObject.components(separatedBy: ";")[1]
                    }
                    html += "</font></td></tr>"
                    html += "</table>"
                }
                html += "</td></tr>"
                html += "</table"
                html += "</center>"
                approveDataList.append(approveData!)
                approveData = nil
            }
            webView1.loadHTMLString(html, baseURL: nil)
            //下一步骤的index
            var nextIndex = ""
            for approve in approveDataList{
                if(approve.current == "1"){
                    jump = approve.jumpStep
                    nextIndex = approve.jumpStep[0]
                }

                if(jump.count>0){
                    for i in 0...jump.count-1{
                        if(jump[i] == approve.index){
                            let step = Step(name:approve.name,value:approve.index, isSelected: i==0 )
                            steps.append(step)
                            
                        }
                    }
                }
                
                if(approve.index == nextIndex){
                    nextStep.text = "下一步骤：\(approve.name)"
                    if(approve.defaultObject.keys.count == 0){
                        object.text = "分配对象：请选择"
                    }else{
                        object.text = "分配对象：\(approve.defaultObject.keys.first!)"
                        objectSelected = approve.defaultObject.values.first!
                    }
                    stepSelected = approve.index
                    
                    objects = approve.changeObject
                }
            }


        }
    }
    //拼接请求体
    func toSoapMessage(methodName: String, paramValues: String) -> String {
        var message: String = String()
        message += "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
        message += "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://schemas.xmlsoap.org/soap/envelope/\">"
        message += "<soap12:Body>"
        message += "<\(methodName) xmlns=\"http://service.spf.sinorail.com/\">"//http://xxx/webservices/ 是Webservice的namespace
        message += "\(paramValues)"
        message += "</\(methodName)>"
        message += "</soap12:Body>"
        message += "</soap12:Envelope>"
        return message
        }
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(acceptData), name: NSNotification.Name(rawValue:"acceptData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(objectData), name: NSNotification.Name(rawValue:"objectData"), object: nil)
        self.view.backgroundColor = UIColor.white
        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        let navHeight = self.navigationController?.navigationBar.frame.size.height
        let height = navHeight!+statusBarHeight
        self.view.backgroundColor = UIColor.white
        titleLabel = UILabel(frame: CGRect(x: 5, y:15+height, width: KScreenWidth-5, height: 25))
        titleLabel.backgroundColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight(rawValue: 0.1))
        titleLabel.text = approveTitle
        titleLabel.textColor = UIColor.gray
        
        self.view.addSubview(titleLabel)
        
        let seperator1 = UILabel(frame: CGRect(x: 5, y: 55+height, width: KScreenWidth-10, height: 0.5))
        seperator1.layer.backgroundColor = UIColor.black.cgColor
        self.view.addSubview(seperator1)
        
        let line1 = UIView(frame: CGRect(x: 5, y: 50+height, width: KScreenWidth-10, height: 50))
        self.view.addSubview(line1)
        let tap1: UITapGestureRecognizer = UITapGestureRecognizer(target:self,action: #selector(stepClick))
        line1.addGestureRecognizer(tap1)
        nextStep = UILabel(frame: CGRect(x: 5, y: 15, width: KScreenWidth-60, height: 40))
        
    
        
        line1.addSubview(nextStep)
        
        let arrow1 = UIImageView(frame:CGRect(x: KScreenWidth-55, y: 20, width: 30, height: 30))
        
        arrow1.image = UIImage(named:"arrow")
        line1.addSubview(arrow1)
        
        let seperator2 = UILabel(frame: CGRect(x: 15, y: 107+height, width: KScreenWidth-30, height: 0.2))
        
        seperator2.layer.backgroundColor = UIColor.gray.cgColor
        self.view.addSubview(seperator2)
        
        let line2 = UIView(frame: CGRect(x: 5, y: 101+height, width: KScreenWidth-10, height: 50))
        self.view.addSubview(line2)
        let tap2: UITapGestureRecognizer = UITapGestureRecognizer(target:self,action: #selector(objectClick))
        line2.addGestureRecognizer(tap2)
        object = UILabel(frame: CGRect(x: 5, y: 15, width: KScreenWidth-60, height: 40))
    
        
        line2.addSubview(object)
        
        let arrow2 = UIImageView(frame:CGRect(x: KScreenWidth-55, y:20, width: 30, height: 30))
        
        arrow2.image = UIImage(named:"arrow")
        
        line2.addSubview(arrow2)
        
        let seperator3 = UILabel(frame: CGRect(x: 5, y: 158+height, width: KScreenWidth-10, height: 0.5))
        
        seperator3.layer.backgroundColor = UIColor.gray.cgColor
        self.view.addSubview(seperator3)
        sv.frame = CGRect(x:0,y:160+height,width:KScreenWidth,height:KScreenHeight-height-300)
        sv.backgroundColor = UIColor.white
        //创建webView
            let x =  self.view.frame.width
            webView.backgroundColor = UIColor.white
            webView1.backgroundColor = UIColor.white
            //设置自适应
            webView.frame = CGRect(x:0,
                                   y:10,
                                   width:KScreenWidth,
                                   height:KScreenHeight-height-300);
            //加载数据，content：是富文本
            webView.loadHTMLString(content, baseURL: nil)
            webView.backgroundColor = UIColor.gray
        webView1.frame = CGRect(x:x,
                               y:10,
                               width:KScreenWidth,
                               height:KScreenHeight-height-300);
        //加载数据，content：是富文本

        webView1.backgroundColor = UIColor.clear
            sv.isPagingEnabled = true
            sv.showsHorizontalScrollIndicator = false
            sv.addSubview(webView1)
            sv.addSubview(webView)
            sv.delegate = self
            sv.backgroundColor = UIColor.clear
            self.view.addSubview(sv)
        
        sv.contentSize = CGSize(width:(self.view.frame.width * 2), height:KScreenHeight-height-300)
        pc.numberOfPages = 2
        pc.currentPageIndicatorTintColor = UIColor.blue
        pc.pageIndicatorTintColor = UIColor.gray
        
    
        self.view.addSubview(pc)
        let refuseButton:UIButton = UIButton(type:.custom)
        //设置按钮位置和大小
        refuseButton.frame = CGRect(x:KScreenWidth/10, y:KScreenHeight-height-30, width:KScreenWidth*0.3, height:40)
        //设置按钮文字
        refuseButton.setTitle("拒绝", for:.normal)
        refuseButton.backgroundColor = UIColor.red
        refuseButton.setTitleColor(UIColor.white, for: .normal)
        refuseButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        refuseButton.addTarget(self, action: #selector(refuse), for: .touchUpInside)
        self.view.addSubview(refuseButton)
        let approveButton:UIButton = UIButton(type:.custom)
        //设置按钮位置和大小
        approveButton.frame = CGRect(x:6*KScreenWidth/10, y:KScreenHeight-height-30, width:KScreenWidth*0.3, height:40)
        //设置按钮文字
        approveButton.setTitle("批准", for:.normal)
        approveButton.backgroundColor = UIColor.green
        approveButton.setTitleColor(UIColor.white, for: .normal)
        approveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        approveButton.addTarget(self, action: #selector(approve), for: .touchUpInside)
        self.view.addSubview(approveButton)
        getApproveDetail(methodName: "getExpenseApproveInfo", action: action)
        getApproveData(methodName:"getApproveData",action:action2)
    }
    @objc  func stepClick(){
        let nextStepVC =   NextStepVC()
        if(steps.count>0){
            nextStepVC.title = "选择步骤"
            nextStepVC.stepArr = steps
            
            navigationController?.pushViewController(nextStepVC, animated: true)
        }else{
            return
        }

    }
    @objc func objectClick(){
        let objectVC = ObjectSelectVC()
        if(objects.count==0){
            return
        }else{
            objectVC.objects = objects
            objectVC.selectedObject = objectSelected
            self.navigationController?.pushViewController(objectVC, animated: true)
        }
    }
    @objc func acceptData(nofi:Notification){
        let name = nofi.userInfo!["name"]
        let val = nofi.userInfo!["value"]
        self.nextStep.text = "下一步骤：\(String(describing:name!))"
        self.stepSelected = String(describing:val!)
        for approve in approveDataList{
            if(approve.index == stepSelected){
                object.text = "分配对象：\(String(describing: approve.defaultObject.keys.first!))"
                objects = approve.changeObject
                objectSelected = approve.defaultObject.values.first!
            }
        }

    }
    @objc func objectData(nofi:Notification){
        let name = nofi.userInfo!["name"]
        let val = nofi.userInfo!["value"]
        self.objectSelected = val as! String
        self.object.text = "分配对象：\(String(describing: name!))"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func approve(){
        let alertController = UIAlertController(title: "同意",
                                                message: "请输入审批意见", preferredStyle: .alert)
        alertController.addTextField {
            (textField: UITextField!) -> Void in
            textField.placeholder = "审批意见"
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "好的", style: .default, handler: {
            action in
            //也可以用下标的形式获取textField let login = alertController.textFields![0]
            let comment = alertController.textFields!.first!
            if(self.approveType == "bm"){
                self.proveOrRefuse(type:self.approveType, methodName: "ExpenseApprove", action: self.bmApproveAction, operation: "1",comment:comment.text!)
            }else if(self.approveType == "Approvercenter"){
                print("走的流程审批")
                self.proveOrRefuse(type:self.approveType, methodName: "AppCenterApprove", action: self.appCenterApproveAction, operation: "1",comment:comment.text!)
            }
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    @objc func refuse(){
        let alertController = UIAlertController(title: "拒绝",
                                                message: "请输入审批意见", preferredStyle: .alert)
        alertController.addTextField {
            (textField: UITextField!) -> Void in
            textField.placeholder = "审批意见"
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "好的", style: .default, handler: {
            action in
            //也可以用下标的形式获取textField let login = alertController.textFields![0]
            let comment = alertController.textFields!.first!
            self.proveOrRefuse(type:self.approveType, methodName: "ExpenseApprove", action: self.bmApproveAction, operation: "0",comment:comment.text!)
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = self.view.frame.width
        
        let offsetX = scrollView.contentOffset.x
        
        let index = (offsetX + width / 2) / width
        pc.currentPage = Int(index)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //        removeTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //        addTimer()
    }
    

    
    @objc func nextImage() {
        var pageIndex = pc.currentPage
        if pageIndex == 2 {
            pageIndex = 0
        } else {
            pageIndex+=1
        }
        
        let offsetX = CGFloat(pageIndex) * self.view.frame.width
        sv.setContentOffset(CGPoint(x:offsetX, y:185), animated: true)
    }
    func Base64Encode(string:String)  ->String {
        let utf8EncodeData = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        // 将NSData进行Base64编码
        let base64String = utf8EncodeData?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: UInt(0)))
        return base64String!
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

