import UIKit

class MyTableViewController: UITableViewController {
    
    let newsReuseIdentifier = "newsCell"
    //请求参数
    let rootCode = "<username>wulei1</username>"
        +      "<password>Mx0bg+sqQhBe4Aclig77yA==</password>"
        +      "<device>android</device>"
    //命名空间
    let kNameSpace = "http://service.spf.sinorail.com/"
    //url前缀
    let WS = "http://office.sinorail.com:8888/"
    //url后缀
    let approveWS = "approveWS.asmx?WSDL"
    //actionName
    let action = "http://service.spf.sinorail.com/getApproveInfo"

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
            let approveInfoList = try! doc.nodes(forXPath: "//ApproveInfo", namespaces:nil) as! [GDataXMLElement]
            //            print(responseXml)
            for approveInfo in approveInfoList {
                //User节点的id属性
                let approveTypeName = (approveInfo.elements(forName: "approveTypeName")[0] as AnyObject).stringValue()
                //获取name节点元素
                let SiteId = (approveInfo.elements(forName: "SiteId")[0] as AnyObject).stringValue()
                
                let count = (approveInfo.elements(forName: "count")[0] as AnyObject).stringValue()
                //输出调试信息
                print("ApproveInfo: approveTypeName:\(approveTypeName!),SiteId:\(SiteId!),count:\(count)")
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
    //定义数组存储数据模型news对象
    var newsArray:[News] = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //调用制造数据的方法（放在最前面）
        self.creatData()
        //self.getData(methodName: "getApproveInfo", paramValues: rootCode, action: action)
        self.title = "消息"
//        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
//        self.navigationController?.navigationBar.titleTextAttributes = [kCTFontAttributeName:UIFont.systemFont(ofSize:30.0),kCTForegroundColorAttributeName:#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)] as [NSAttributedStringKey : Any]
        
        //注册newsCell
        self.tableView.register(NewsCell.self, forCellReuseIdentifier: newsReuseIdentifier)
        let footView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        footView.backgroundColor = UIColor.white
        tableView.tableFooterView = footView
    }
    //制造数据
    func creatData(){
        
        for i in 0...6{
            
            let new = News(newsPicName: "newsPic", newsTitle: "下午在会议室开会\(i)", newsContent: "会议主题：学习十九大精神，社会主义核心价值观", newsFollowUp: "27万人跟帖")
            
            //添加到数组
            newsArray.append(new)
        }
        //print(newsArray)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: newsReuseIdentifier, for: indexPath) as! NewsCell
        //取出数组中对应位置的news对象
        let news = newsArray[indexPath.row]
        cell.newsPic.image = UIImage(named:news.newsPicName)
        cell.newsTitleLabel.text = news.newsTitle
        cell.newsContentLabel.text = news.newsContent
//        cell.followUpLabel.text = news.newsFollowUp
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


