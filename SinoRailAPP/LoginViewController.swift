//
//  LoginViewController.swift
//  SinoRailAPP
//
//  Created by ybz on 2018/8/20.
//  Copyright © 2018年 SinoRailAPP. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    //初始化控件
    let imageView=UIImageView(frame: CGRect(x: 0, y: 0, width: KScreenWidth, height:KScreenHeight))
    let userNametextFiled=UITextField(frame: CGRect(x: KScreenWidth/2-150, y: KScreenHeight/2-120, width: 300, height:40))
    let userPasswordtextFiled=UITextField(frame: CGRect(x: KScreenWidth/2-150, y: KScreenHeight/2-40-20, width: 300, height:40))
    let userLoginButton=UIButton(frame: CGRect(x: KScreenWidth/2-150, y: KScreenHeight/2, width: 300, height:40))
    let forgotPasswordButton=UIButton(frame: CGRect(x: KScreenWidth/2-150, y: KScreenHeight/2+60, width: 100, height:40))
    let networkSetupButton=UIButton(frame: CGRect(x: KScreenWidth/2+60, y: KScreenHeight/2+60, width: 100, height:40))
    let termsOfServiceLabel=UILabel(frame: CGRect(x: KScreenWidth/2-120, y: KScreenHeight-60, width: 260, height:40))
    ////////////
    //命名空间
    let kNameSpace = "http://service.spf.sinorail.com/"
    //url前缀
    let WS = "http://office.sinorail.com:8888/"
    //url后缀
    let approveWS = "noticeWS.asmx?WSDL"
    //actionName
    let action = "http://service.spf.sinorail.com/getNoticeListByCategory"
    
    //去webservice请求数据
    func getData(methodName:String,paramValues:String,action:String){
        let url = WS+approveWS
        
        let request = NSMutableURLRequest(url:NSURL(string:url) as URL! )
        
        let soapMsg: String = toSoapMessage(methodName: methodName, paramValues: paramValues)//methodName是请求的方法名
        
        let msgLength = String(soapMsg.characters.count)
        
        request.httpMethod = "POST"
        
        request.httpBody = soapMsg.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        request.addValue(msgLength, forHTTPHeaderField:"Content-Length")
        
        request.addValue(action, forHTTPHeaderField: "SOAPAction")
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main, completionHandler:checkItemListCallback)
        
    }
    func checkItemListCallback(response:URLResponse?,data:Data?,error:Error?) -> Void{
        if error != nil{
            print(error ?? "出错了")
        }
            
        else {
            //这里的语法已经把OC的初始化函数直接转换过来了
            let doc:GDataXMLDocument = try! GDataXMLDocument(data:data, options : 0)
            print("获得响应数据：")
            let approveInfoList = try! doc.nodes(forXPath: "//noticelist", namespaces:nil) as! [GDataXMLElement]
            //            print(responseXml)
            //print(approveInfoList)
            for approveInfo in approveInfoList {
                //列表ID
                let ItemId = (approveInfo.elements(forName: "ItemId")[0] as AnyObject).stringValue()
                //标题
                let title = (approveInfo.elements(forName: "title")[0] as AnyObject).stringValue()
                //发布时间
                var date = (approveInfo.elements(forName: "date")[0] as AnyObject).stringValue()
                //发布人
                let user = (approveInfo.elements(forName: "user")[0] as AnyObject).stringValue()
                //SiteId
                let SiteId = (approveInfo.elements(forName: "SiteId")[0] as AnyObject).stringValue()
                //WebId
                let WebId = (approveInfo.elements(forName: "WebId")[0] as AnyObject).stringValue()
                //ListId
                let ListId = (approveInfo.elements(forName: "ListId")[0] as AnyObject).stringValue()
                //type
                let type = (approveInfo.elements(forName: "type")[0] as AnyObject).stringValue()
                
                //输出调试信息
                print(date)
                //                print("ItemId:"+ItemId!+"title:"+title!+"date:"+date!+"user:"+user!+"SiteId:"+SiteId!+"WebId:"+WebId!+"ListId:"+ListId!+"type"+type!)
                //日期截取前10位：2018-08-18
                let sub1 = date?.prefix(10)
                let sub2 = (date as! NSString).substring(with: NSMakeRange(11, 8));
                //var dformatter = NSDate()
                //let mydate=NoticeViewController.dateConvertString(date: dformatter as Date,dateFormat: "yyyy-MM-dd")
                //str.prefix(10)
                let new = MyNewsOther(newsPicName: "news101", newsTitle: title!, newsContent: "发布人："+user!+"   "+sub1!+" "+sub2, newsFollowUp: "2万人跟帖",newsSiteId: SiteId!,newsWebId: WebId!,newsListId: ListId!,newsItemId: ItemId!)
                
            }
            
        }
    } 
    
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
    //////////
    override func viewDidLoad() {
      
        super.viewDidLoad()
        //背景图片
        self.view.addSubview(imageView)
        //设置显示的图片
        let image = UIImage(named: "102")
        imageView.image = image
        //用户名
        userNametextFiled.backgroundColor=UIColor.white
        userNametextFiled.placeholder="用户名"
        //文字编辑的时候现实清除按钮。默认不显示
        userNametextFiled.clearButtonMode=UITextFieldViewMode.whileEditing
        self.view.addSubview(userNametextFiled)
        //密码
        userPasswordtextFiled.backgroundColor=UIColor.white
        userPasswordtextFiled.placeholder="密码"
        //设置为密码输入框
        userPasswordtextFiled.isSecureTextEntry=true
        //文字编辑的时候现实清除按钮。默认不显示
        userPasswordtextFiled.clearButtonMode=UITextFieldViewMode.whileEditing
        self.view.addSubview(userPasswordtextFiled)
        //登录
        userLoginButton.setTitle("登录",for: .normal)
        userLoginButton.backgroundColor=UIColor.blue
        userLoginButton.setTitleColor(UIColor.white, for: .normal)
        //注册事件
        userLoginButton.addTarget(self,action:#selector(loginClick),for:.touchUpInside)
        self.view.addSubview(userLoginButton)
        
        //忘记密码
        forgotPasswordButton.setTitle("忘记密码？", for: .normal)
        //按钮文字左对齐
        forgotPasswordButton.titleLabel?.textAlignment = .left
        forgotPasswordButton.addTarget(self,action:#selector(forgotPassword),for:.touchUpInside)
        self.view.addSubview(forgotPasswordButton)
        //网络设置
        networkSetupButton.setTitle("网络设置", for: .normal)
        //按钮文字左对齐
        networkSetupButton.titleLabel?.textAlignment = .right
        networkSetupButton.addTarget(self,action:#selector(networkSetup),for:.touchUpInside)
        self.view.addSubview(networkSetupButton)
        //服务条款
        termsOfServiceLabel.text="登录即代表阅读并同意服务条款"
        //按钮文字左对齐
        termsOfServiceLabel.textAlignment = .left
        termsOfServiceLabel.textColor=UIColor.white
        self.view.addSubview(termsOfServiceLabel)
        
        userNametextFiled.text="wulei1"
        userPasswordtextFiled.text="Mx0bg+sqQhBe4Aclig77yA=="
        let userName=userNametextFiled.text
        let userPassword=userPasswordtextFiled.text
        //请求参数
        let rootCode = "    <username>\(userName)</username>"
            + "<password>\(userPassword)</password>"
            + "<Category>b7879d8a-be68-4f3c-8152-0c6417ad4ae3</Category>"
        
        self.getData(methodName: "getNoticeListByCategory", paramValues: rootCode, action: action)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //登录
    @objc func loginClick(){
        print("点击登录")
        let userName=userNametextFiled.text
        let userPassword=userPasswordtextFiled.text
        if userName != "" && userPassword != ""{
            //登录状态写入缓存,true:登录成功，false：第一次登录或者退出APP
            UserDefaults.standard.setValue("true", forKey: "loginState")
            //读取缓存中登录状态,true:登录成功，false：第一次登录或者退出APP
            let loginState = UserDefaults.standard.value(forKey: "loginState") as! String?
            print("登录状态------"+loginState!)
            //let ntc:NetworkController = NetworkController.sharedInstance()
            //let imei:String? = ntc.IMEI
            //获取手机硬件UUIT
            let device = UIDevice.current
            let uuid = String(describing: device.identifierForVendor)
            // 获取索引（截取第十个字符串后36个字符）
            //            let stauuid = uuid.index(uuid.startIndex, offsetBy: 9)
            //            let enduuid = uuid.index(stauuid, offsetBy: 36)
            //            let uuid1 = uuid.substring(with: stauuid..<enduuid)
            //            let deUUID = "UUID：" + uuid1
            //
            
            //登录成功跳转到主页面
            self.view.window?.rootViewController=MainTabBarController()
        }
    }
    //忘记密码
    @objc func forgotPassword(_ sender: UIButton) {
        print("点击忘记密码")
    }
    
    //网络设置
    @objc func networkSetup(_ sender: UIButton) {
        print("点击网络设置")
    }
    
    //用户登录 
    @IBAction func userLogin(_ sender: UIButton) {

    }
}
