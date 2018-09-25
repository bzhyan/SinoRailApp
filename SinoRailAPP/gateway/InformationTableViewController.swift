//
//  InformationTableViewController.swift
//  SinoRailAPP
//
//  Created by ybz on 2018/8/30.
//  Copyright © 2018年 SinoRailAPP. All rights reserved.
//信息简报

import UIKit

class InformationTableViewController: UITableViewController {
    let newsReuseIdentifier = "MynewsCell"
    
    //定义数组存储数据模型news对象
    var newsArray:[MyNewsOther] = Array()
    var Mystart=1
    var Myend=15
    //*********************
    
    //命名空间
    let kNameSpace = "http://service.spf.sinorail.com/"
    //url前缀
    let WS = "http://office.sinorail.com:8888/"
    //url后缀
    let approveWS = "noticeWS.asmx?WSDL"
    //actionName
    let action = "http://service.spf.sinorail.com/getNoticeListByCategory"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //请求参数
        let rootCode = "    <username>wulei1</username>"
            + "<password>Mx0bg+sqQhBe4Aclig77yA==</password>"
            + "<start>\(Mystart)</start>"
            + "<end>\(Myend)</end>"
            + "<Category>cd93f2c6-7664-41c3-9a36-e54e1c7b01e9</Category>"
        
        self.getData(methodName: "getNoticeListByCategory", paramValues: rootCode, action: action)
        //注册MynewsCell
        self.tableView.register(MyNewsOtherCell.self, forCellReuseIdentifier: newsReuseIdentifier)
        let footView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        footView.backgroundColor = UIColor.white
        tableView.tableFooterView = footView
        
        //下拉刷新
        self.tableView?.gtm_addRefreshHeaderView {
            [weak self] in
            print("excute refreshBlock")
            self?.refresh()
        }
        //上拉刷新
        self.tableView?.gtm_addLoadMoreFooterView {
            [weak self] in
            print("excute loadMoreBlock")
            self?.loadMore()
        }
        
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
        //self.models += [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18]
        // self.tableView?.endLoadMore(isNoMoreData: models.count > 50)
        //请求参数
        Mystart+=15
        Myend+=15
        let rootCode = "    <username>wulei1</username>"
            + "<password>Mx0bg+sqQhBe4Aclig77yA==</password>"
            + "<start>\(Mystart)</start>"
            + "<end>\(Myend)</end>"
            + "<Category>cd93f2c6-7664-41c3-9a36-e54e1c7b01e9</Category>"
        
        self.getData(methodName: "getNoticeListByCategory", paramValues: rootCode, action: action)
        self.tableView?.endLoadMore(isNoMoreData: newsArray.count > 50)
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
                //                print("ItemId:"+ItemId!+"title:"+title!+"date:"+date!+"user:"+user!+"SiteId:"+SiteId!+"WebId:"+WebId!+"ListId:"+ListId!+"type"+type!)
                //日期截取前10位：2018-08-18
                let sub1 = date?.prefix(10)
                let sub2 = (date as! NSString).substring(with: NSMakeRange(11, 8));
                //var dformatter = NSDate()
                //let mydate=NoticeViewController.dateConvertString(date: dformatter as Date,dateFormat: "yyyy-MM-dd")
                //str.prefix(10)
                let new = MyNewsOther(newsPicName: "news101", newsTitle: title!, newsContent: "发布人："+user!+"   "+sub1!+" "+sub2, newsFollowUp: "2万人跟帖",newsSiteId: SiteId!,newsWebId: WebId!,newsListId: ListId!,newsItemId: ItemId!)
                //添加到数组
                newsArray.append(new)
            }
            // 方法需要在主线程中调用，这样表格数据就能及时更新
            self.tableView.reloadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: newsReuseIdentifier, for: indexPath) as! MyNewsOtherCell
        print(indexPath)
        //取出数组中对应位置的news对象
        let news = newsArray[indexPath.row]
        cell.newsPic.image = UIImage(named:news.newsPicName)
        cell.newsTitleLabel.text = news.newsTitle
        cell.newsContentLabel.text = news.newsContent
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    //点击事件
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //实例化一个界面
        let MyView = NoticeDetailViewController()
        //MyNewsDetailedViewController.title=newsArray[indexPath.section][1][indexPath.indexr
        //MyView.lable.text = newsArray[indexPath.row].newsTitle
        MyView.SiteId=newsArray[indexPath.row].newsSiteId
        MyView.WebId=newsArray[indexPath.row].newsWebId
        MyView.ListId=newsArray[indexPath.row].newsListId
        MyView.ItemId=newsArray[indexPath.row].newsItemId
        //        print(indexPath)
        //        print(indexPath.section)
        //跳转
        self.navigationController?.pushViewController(MyView, animated: true)
    }
    
}
