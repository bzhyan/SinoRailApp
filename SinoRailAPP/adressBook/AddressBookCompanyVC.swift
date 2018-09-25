import UIKit

class AddressBookCompanyVC: UITableViewController {
    let ContactHeaderH: CGFloat = 11.0
    let addressBookCompanyCell = "addressBookCompanyCell"
    //请求参数
    let rootCode = "<username>wulei1</username>"
        +      "<password>Mx0bg+sqQhBe4Aclig77yA==</password>"
        +      "<device>android</device>"
    //命名空间
    let kNameSpace = "http://service.spf.sinorail.com/"
    //url前缀
    let WS = "http://office.sinorail.com:8888/"
    //url后缀
    let approveWS = "addressBookWS.asmx?WSDL"
    //actionName
    let action = "http://service.spf.sinorail.com/getCompanyList"

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
            let companyList = try! doc.nodes(forXPath: "//Companylist", namespaces:nil) as! [GDataXMLElement]
            //            print(responseXml)
            var company : AddressBookCompany
            var nodes:[GDataXMLNode] = NSArray() as! [GDataXMLNode]
            var keys : [String] = Array()
            for com in companyList {
                nodes = com.children() as! [GDataXMLNode]
                for i in 0...nodes.count-1{
                    var obj : String = nodes[i].name()
                    keys.append(obj)
                }
                
                //User节点的id属性
                let name = (com.elements(forName: "name")[0] as AnyObject).stringValue()
                //获取name节点元素
                let shortName = (com.elements(forName: "shortName")[0] as AnyObject).stringValue()
                
                let address = (com.elements(forName: "address")[0] as AnyObject).stringValue()
 
//              let phone = (com.elements(forName: "phone")[0] as AnyObject).stringValue()
                var phone = ""
                if(keys.contains("phone")){
                    phone = (com.elements(forName: "phone")[0] as AnyObject).stringValue()
                }
                var fax = ""
                if(keys.contains("fax")){
                    fax = (com.elements(forName: "fax")[0] as AnyObject).stringValue()
                }
                let ItemId = (com.elements(forName: "ItemId")[0] as AnyObject).stringValue()
                
                let zipCode = (com.elements(forName: "zipCode")[0] as AnyObject).stringValue()
                
                let flag = (com.elements(forName: "flag")[0] as AnyObject).stringValue()
                //输出调试信息
                company = AddressBookCompany(itemId: ItemId!, shortName: shortName!, name: name!, address:address!, phone: phone, fax: fax, zipCode: zipCode!, flag: flag!)
                CompanyArray.append(company)
                keys = []
            }

 
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
    //定义数组存储数据模型company对象
    var CompanyArray:[AddressBookCompany] = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(AddressBookCompanyCell.self, forCellReuseIdentifier: addressBookCompanyCell)
        let footView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        footView.backgroundColor = UIColor.white
        tableView.tableFooterView = footView
        self.getData(methodName: "getCompanyList", paramValues: rootCode, action: action)

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
        return CompanyArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: addressBookCompanyCell, for: indexPath) as! AddressBookCompanyCell
        //取出数组中对应位置的company对象
        let company = CompanyArray[indexPath.row]
        cell.name.text = company.name
        cell.shortName.text = company.shortName
        cell.telephone.text = "电话：\(company.phone!)"
        cell.fax.text = "传真：\(company.fax!)"
        cell.address.text = "地址：\(company.address!)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        hidesBottomBarWhenPushed = true
        let addressBookController = AddressBookViewController()
        addressBookController.shortName = CompanyArray[indexPath.row].shortName
        navigationController?.pushViewController(addressBookController, animated: true)
    }
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //如果数据源中没有当前section的数据，直接return nil，防止header占位
//        if(section==0){
//            return nil
//        }
//        let header = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
//
//        header.backgroundColor = sectionColor
        
//        let titleL = UILabel(frame: header.bounds)
//        titleL.text = self.tableView(tableView, titleForHeaderInSection: section)
//
//        titleL.font = UIFont.systemFont(ofSize: 14.0)
//        titleL.x = 10
//        header.addSubview(titleL)
//        return header
//    }
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

