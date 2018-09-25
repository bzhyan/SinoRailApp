//
//  NoticeFilesViewController.swift
//  SinoRailAPP
//
//  Created by ybz on 2018/9/11.
//  Copyright © 2018年 SinoRailAPP. All rights reserved.
//

import UIKit

class NoticeFilesTableViewController: UITableViewController {
    
    let newsReuseIdentifier = "MynewsCell"
    
    //定义数组存储数据模型news对象
    var newsArray:[MyNewsOther] = Array()
    var SiteId=""
    var WebId=""
    var ListId=""
    var ItemId=""
    var files=""
    var fileSize=""
    //命名空间
    let kNameSpace = "http://service.spf.sinorail.com/"
    //url前缀
    let WS = "http://office.sinorail.com:8888/"
    //url后缀
    let approveWS = "noticeWS.asmx?WSDL"
    //actionName
    let action = "http://service.spf.sinorail.com/getNoticeFile"
    //*********************
    override func viewDidLoad() {
        super.viewDidLoad()
        creatData()
        self.title = "附件"
        
        //注册MynewsCell
        self.tableView.register(MyNewsOtherCell.self, forCellReuseIdentifier: newsReuseIdentifier)
        let footView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        footView.backgroundColor = UIColor.white
        tableView.tableFooterView = footView
        
        //初始化下拉刷新
        //        self.refreshControl = UIRefreshControl()
        //        self.refreshControl!.addTarget(self, action: #selector(MygetData),
        //                                       for: .valueChanged)
        //        self.refreshControl!.attributedTitle = NSAttributedString(string: "下拉刷新数据")
        
        //下拉刷新
        self.tableView?.gtm_addRefreshHeaderView {
            [weak self] in
            print("下拉刷新")
            self?.refresh()
        }
        //上拉刷新
        self.tableView?.gtm_addLoadMoreFooterView {
            [weak self] in
            print("上拉刷新")
            self?.loadMore()
        }
    }
    
    @objc func creatData(){
        if(files != "" && fileSize != ""){
            var MyFiles = files.split(separator: "|")
            var MyfileSize = fileSize.split(separator: "|")
            var MyfileSizes=[String]()//创建一个初始化数据为空的数据
            for var item in MyfileSize{
                MyfileSize.append(item)
            }
            var i=0
            for var item in MyFiles{
                print(item)
                
                let new = MyNewsOther(newsPicName: "news101", newsTitle: String(item), newsContent: "文件大小："+MyfileSize[i]+"      点击下载", newsFollowUp: "2万人跟帖",newsSiteId: "",newsWebId: "",newsListId: "",newsItemId: "")
                //添加到数组
                newsArray.append(new)
                i+=1
            }
        }
        self.tableView?.reloadData()
        
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
            
            //
            //            let doc = try! GDataXMLDocument(data: data!, options: 0)
            //            // 获取文档的根节点
            //
            //            let root = doc.rootElement()
            //            // 获得根节点里面所有的video元素
            //            let elements = root?.elements(forName: "soap:Body") as! [GDataXMLElement]
            //
            //
            //这里的语法已经把OC的初始化函数直接转换过来了
            let doc:GDataXMLDocument = try! GDataXMLDocument(data:data, options : 0)
            print("获得响应数据：")
            let approveInfoList = try! doc.nodes(forXPath: "//getNoticeFileResponse", namespaces:nil) as! [GDataXMLElement]
            //            print(responseXml)
            //print(approveInfoList)
            for approveInfo in approveInfoList {
                //content
                let content = (approveInfo.elements(forName: "getNoticeFileResult")[0] as AnyObject).stringValue()
                print(content)
                
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
    
    
    // MARK: Test
    func refresh() {
        perform(#selector(endRefresing), with: nil, afterDelay: 3)
    }
    
    @objc func endRefresing() {
        self.tableView?.endRefreshing(isSuccess: true)
    }
    func loadMore() {
        perform(#selector(endLoadMore), with: nil, afterDelay: 3)
    }
    
    @objc func endLoadMore() {
        creatData()
        self.tableView?.endLoadMore(isNoMoreData: newsArray.count > 50)
        self.tableView?.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return newsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: newsReuseIdentifier, for: indexPath) as! MyNewsOtherCell
        //print(indexPath)
        //取出数组中对应位置的news对象
        let news = newsArray[indexPath.row]
        cell.newsPic.image = UIImage(named:news.newsPicName)
        cell.newsTitleLabel.text = news.newsTitle
        cell.newsContentLabel.text = news.newsContent
        
        //var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        //        if cell == nil {
        //            cell = UITableViewCell(style: .default, reuseIdentifier: "cell") as! MyNewsOtherCell
        //        }
        //cell.textLabel?.text = "\(newsArray[(indexPath as NSIndexPath).row])"
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    //点击事件
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var myFileName=self.Base64Encode(string: newsArray[indexPath.row].newsTitle)
        print(myFileName)
        //请求参数
        let rootCode = "<username>wulei1</username>"
            + "<password>Mx0bg+sqQhBe4Aclig77yA==</password>"
            + "<filename>\(myFileName)</filename>"
            + "<SiteId>\(SiteId)</SiteId>"
            + "<WebId>\(WebId)</WebId>"
            + "<ListId>\(ListId)</ListId>"
            + "<ItemId>\(ItemId)</ItemId>"
        
        self.getData(methodName: "getNoticeFile", paramValues: rootCode, action: action)
        
    }
    
    //格式转换
    func Base64Encode(string:String)  ->String {
        let utf8EncodeData = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        // 将NSData进行Base64编码
        let base64String = utf8EncodeData?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: UInt(0)))
        return base64String!
    }
    
}
