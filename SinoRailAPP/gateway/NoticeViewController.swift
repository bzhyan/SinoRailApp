//
//  NoticeViewController.swift
//  SinoRailAPP
//
//  Created by ybz on 2018/8/30.
//  Copyright © 2018年 SinoRailAPP. All rights reserved.
//集团公告

import Foundation
import UIKit

class NoticeViewController: UITableViewController {

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
                //print(date)
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
    /// Date类型转化为日期字符串
    ///
    /// - Parameters:
    ///   - date: Date类型
    ///   - dateFormat: 格式化样式默认“yyyy-MM-dd”
    /// - Returns: 日期字符串
    static func dateConvertString(date:Date, dateFormat:String="yyyy-MM-dd") -> String {
        let timeZone = TimeZone.init(identifier: "UTC")
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        let date = formatter.string(from: date)
        return date.components(separatedBy: " ").first!
    }
    
    
    /// 日期字符串转化为Date类型
    ///
    /// - Parameters:
    ///   - string: 日期字符串
    ///   - dateFormat: 格式化样式，默认为“yyyy-MM-dd HH:mm:ss”
    /// - Returns: Date类型
    static func stringConvertDate(string:String, dateFormat:String="yyyy-MM-dd HH:mm:ss") -> Date {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: string)
        return date!
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
    //*********************
    override func viewDidLoad() {
        super.viewDidLoad()
        //调用制造数据的方法（放在最前面）
        //self.creatData()
        
        //请求参数
        let rootCode = "    <username>wulei1</username>"
            + "<password>Mx0bg+sqQhBe4Aclig77yA==</password>"
            + "<start>\(Mystart)</start>"
            + "<end>\(Myend)</end>"
            + "<Category>b7879d8a-be68-4f3c-8152-0c6417ad4ae3</Category>"
        
         self.getData(methodName: "getNoticeListByCategory", paramValues: rootCode, action: action)
        self.title = "消息"
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
            + "<Category>b7879d8a-be68-4f3c-8152-0c6417ad4ae3</Category>"
        
        self.getData(methodName: "getNoticeListByCategory", paramValues: rootCode, action: action)
        self.tableView?.endLoadMore(isNoMoreData: newsArray.count > 50)
        self.tableView?.reloadData()
    }
    
    
  
    
    //下拉刷新
//    @objc func MygetData() {
//        newsArray.removeAll()
//        self.tableView.reloadData()
//        self.getData(methodName: "getNoticeListByCategory", paramValues: rootCode, action: action)
//        //加载完毕
//        self.refreshControl?.endRefreshing()
//    }
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
    
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//
//        // 1. 判断是否是最后一行 indexPath.row = max  , indexPath.section = max
//        // 取出当前的行数
//        let row = indexPath.row
//        // 取出最大节数
//        let section = tableView.numberOfSections - 1
//        if row < 0 || section < 0 {
//            return
//        }
//        //取最后一节的最大行数
//        let maxRowCount = tableView.numberOfRows(inSection: section) - 1
//        print("上拉刷新")
//
//        print("11111111111")
//        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
//        if cell == nil {
//            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
//        }
//        cell?.textLabel?.text = "\(newsArray[(indexPath as NSIndexPath).row])"
//
//
//    }
    
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
    
    
    ///////////////
    //制造数据
    func creatData(){
        
        //        for i in 0...6{
        //
        //            let new = MyNews(newsPicName: "news101", newsTitle: "集团召开2018年度经营责任书签约暨经营工作座谈会\(i)", newsContent: "发布人：明霞   2018-08-18", newsFollowUp: "27万人跟帖")
        //
        //            //添加到数组
        //            newsArray.append(new)
        //        }
        //print(newsArray)
        
        //        let new1 = MyNewsOther(newsPicName: "news101", newsTitle: "关于发布《中铁信息工程集团有限公司差旅费管理办法》的通知", newsContent: "发布人：明霞   2018-08-18", newsFollowUp: "27万人跟帖")
        //        //添加到数组
        //        newsArray.append(new1)
        //
        //        let new2 = MyNewsOther(newsPicName: "news101", newsTitle: "计算机公司综合管理部商务助理（主管）内部招聘通知", newsContent: "发布人：余淼   2018-05-20", newsFollowUp: "27万人跟帖")
        //        //添加到数组
        //        newsArray.append(new2)
        //
        //        let new3 = MyNewsOther(newsPicName: "news103", newsTitle: "关于发布《中铁信息工程集团内部管理控制手册》的通知", newsContent: "发布人：余淼   2018-07-20", newsFollowUp: "27万人跟帖")
        //        //添加到数组
        //        newsArray.append(new3)
        //
        //        let new4 = MyNewsOther(newsPicName: "news104", newsTitle: "中铁信息工程集团应收账款督导函（编号20180801）", newsContent: "发布人：余淼   2018-05-10", newsFollowUp: "27万人跟帖")
        //        //添加到数组
        //        newsArray.append(new4)
        //
        //        let new5 = MyNewsOther(newsPicName: "news105", newsTitle: "关于发布《中铁信集团通讯费管理暂行规定》的通知", newsContent: "发布人：余淼   2018-05-10", newsFollowUp: "27万人跟帖")
        //        //添加到数组
        //        newsArray.append(new5)
        //
        //        let new6 = MyNewsOther(newsPicName: "news106", newsTitle: "关于2018年端午节放假安排的通知", newsContent: "发布人：余淼   2018-05-10", newsFollowUp: "27万人跟帖")
        //        //添加到数组
        //        newsArray.append(new6)
        //
        //        let new7 = MyNewsOther(newsPicName: "news105", newsTitle: "恪尽职守、任劳任怨----践行新时期铁路精神", newsContent: "发布人：余淼   2018-05-10", newsFollowUp: "27万人跟帖")
        //        //添加到数组
        //        newsArray.append(new7)
        //
        //        let new8 = MyNewsOther(newsPicName: "news105", newsTitle: "集中心团委举办读书分享会", newsContent: "发布人：余淼   2018-05-10", newsFollowUp: "27万人跟帖")
        //        //添加到数组
        //        newsArray.append(new8)
        //
        //        let new9 = MyNewsOther(newsPicName: "news105", newsTitle: "集团SAP-ERP升级实施项目顺利通过验收", newsContent: "发布人：余淼   2018-05-10", newsFollowUp: "27万人跟帖")
        //        //添加到数组
        //        newsArray.append(new9)
        //
        //        let new10 = MyNewsOther(newsPicName: "news105", newsTitle: "感受五年成就 喜迎十九大—集团第二联合党支部开展主题党日系列活动", newsContent: "发布人：余淼   2018-05-10", newsFollowUp: "27万人跟帖")
        //        //添加到数组
        //        newsArray.append(new10)
        //
        //        let new11 = MyNewsOther(newsPicName: "news105", newsTitle: "集团团总支组织青年开展“同心协力，共创未来”团建活动", newsContent: "发布人：余淼   2018-05-10", newsFollowUp: "27万人跟帖")
        //        //添加到数组
        //        newsArray.append(new11)
        //
        //        let new12 = MyNewsOther(newsPicName: "news105", newsTitle: "中心召开集团SAP-ERP升级实施试点项目总结汇报会", newsContent: "发布人：余淼   2018-05-10", newsFollowUp: "27万人跟帖")
        //        //添加到数组
        //        newsArray.append(new12)
    }
    
}
