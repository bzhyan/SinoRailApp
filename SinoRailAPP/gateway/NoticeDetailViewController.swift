//
//  NoticeDetaildViewController.swift
//  SinoRailAPP
//
//  Created by ybz on 2018/9/5.
//  Copyright © 2018年 SinoRailAPP. All rights reserved.
//新闻明细页面

import UIKit

class NoticeDetailViewController: UIViewController {
    
    let webView=UIWebView(frame: CGRect(x: 10, y: 10, width: KScreenWidth, height:KScreenHeight))
    let filesButton=UIButton(frame: CGRect(x: 50, y: 80, width: 60, height:30))
    var SiteId=""
    var WebId=""
    var ListId=""
    var ItemId=""
    var files=""
    var fileSize=""
    //定义数组存储数据模型news对象
    var newsArray:[MyNewsOther] = Array()
    //*********************
    
    //命名空间
    let kNameSpace = "http://service.spf.sinorail.com/"
    //url前缀
    let WS = "http://office.sinorail.com:8888/"
    //url后缀
    let approveWS = "noticeWS.asmx?WSDL"
    //actionName
    let action = "http://service.spf.sinorail.com/getNoticeDetail"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="正文"
        self.view.addSubview(webView)
        //pageTableView.tableHeaderView=filesButton
        //pageTableView.tableFooterView=webView
        //webView.addSubview(filesButton)
        //filesButton.backgroundColor=UIColor.blue
        filesButton.setTitleColor(UIColor.blue, for: .normal)
        self.view.backgroundColor=UIColor.white
        //navigationItem.titleView=filesButton
        //rightBarButtonItems
        let offlineItem = UIBarButtonItem(customView: filesButton)
        navigationItem.rightBarButtonItem=offlineItem
        
        webView.frame = CGRect(x:self.view.frame.origin.x,
                               y:self.view.frame.origin.y,
                               width:self.view.frame.size.width,
                               height:self.view.frame.size.height);
        //注册事件
        filesButton.addTarget(self,action:#selector(filesClick),for:.touchUpInside)
        
        //请求参数
        let rootCode = "    <username>wulei1</username>"
            + "<password>Mx0bg+sqQhBe4Aclig77yA==</password>"
            + "<SiteId>\(SiteId)</SiteId>"
            + "<WebId>\(WebId)</WebId>"
            + "<ListId>\(ListId)</ListId>"
            + "<ItemId>\(ItemId)</ItemId>"
        
        self.getData(methodName: "getNoticeDetail", paramValues: rootCode, action: action)
        //self.view.backgroundColor=UIColor.white
        // Do any additional setup after loading the view.
        //onScrollChanged  scalesPageToFit=YES  contentOffset
        // CGPointMake((scrollView.contentSize.width - screenWidth) / 2, scrollView.contentOffset.y);
        // webView.scrollView.isScrollEnabled=false
        //webView.scalesPageToFit=false
        
        // webView.scrollView.contentOffset=CGPoint((webView.scrollView.contentSize.width) / 2, webView.scrollView.contentOffset.y)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    
    //点击事件
    func checkItemListCallback(response:URLResponse?,data:Data?,error:Error?) -> Void{
        if error != nil{
            print(error ?? "出错了")
        }
            
        else {
            //这里的语法已经把OC的初始化函数直接转换过来了
            let doc:GDataXMLDocument = try! GDataXMLDocument(data:data, options : 0)
            print("获得响应数据：")
            let approveInfoList = try! doc.nodes(forXPath: "//noticeDetail", namespaces:nil) as! [GDataXMLElement]
            //            print(responseXml)
            //print(approveInfoList)
            for approveInfo in approveInfoList {
                //content
                let content = (approveInfo.elements(forName: "content")[0] as AnyObject).stringValue()
                files=(approveInfo.elements(forName: "files")[0] as AnyObject).stringValue()
                fileSize=(approveInfo.elements(forName: "fileSize")[0] as AnyObject).stringValue()
                webView.loadHTMLString(content!, baseURL: nil)
                //判断是否有文件
                if(files != "" && fileSize != ""){
                    //filesButton.setTitle(files,for: .normal)
                    filesButton.setTitle("附件",for: .normal)
                    print(files)
                    print(fileSize)
                }
                else{
                    filesButton.isHidden=true
                }
                
            }
            // 方法需要在主线程中调用，这样表格数据就能及时更新
            //self.tableView.reloadData()
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
    
    //登录
    @objc func filesClick(){
        print("点击附件")
        //实例化一个界面
        let MyView = NoticeFilesTableViewController()
        MyView.SiteId=SiteId
        MyView.WebId=WebId
        MyView.ListId=ListId
        MyView.ItemId=ItemId
        MyView.fileSize=fileSize
        MyView.files=files
        //跳转
        self.navigationController?.pushViewController(MyView, animated: true)
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
