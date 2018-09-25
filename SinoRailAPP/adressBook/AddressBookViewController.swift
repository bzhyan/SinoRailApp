//
//  AddressBookViewController.swift
//  SinoRailAPP
//
//  Created by ybz on 2018/8/22.
//  Copyright © 2018年 SinoRailAPP. All rights reserved.
//

import UIKit
fileprivate let ContactCellID = "ContactCellID"
fileprivate let ContactFooterH: CGFloat = 49.0
fileprivate let ContactHeaderH: CGFloat = 22.0
class AddressBookViewController: BaseViewController {

    var shortName : String = ""
    let addressBookCell = "addressBookCell"

    //命名空间
    let kNameSpace = "http://service.spf.sinorail.com/"
    //url前缀
    let WS = "http://office.sinorail.com:8888/"
    //url后缀
    let approveWS = "addressBookWS.asmx?WSDL"
    //actionName
    let action = "http://service.spf.sinorail.com/getAddressBook"
    
    //去webservice请求数据
    func getData(methodName:String,action:String){
        //请求参数
        let rootCode = "<username>wulei1</username>"
            +      "<password>Mx0bg+sqQhBe4Aclig77yA==</password>"
            +      "<device>android</device>"
            +      "<companyName>"+Base64Encode(string: shortName)+"</companyName>"
        
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
    func checkItemListCallback(response:URLResponse?,data:Data?,error:Error?) -> Void{
        if error != nil{
            print(error ?? "出错了")
        }
            
        else {
            //这里的语法已经把OC的初始化函数直接转换过来了
            let doc:GDataXMLDocument = try! GDataXMLDocument(data:data, options : 0)
            print("获得响应数据：")
            let addressBookList = try! doc.nodes(forXPath: "//AddressBooklist", namespaces:nil) as! [GDataXMLElement]
            //            print(responseXml)
            var addressBook : AddressBook
            var nodes:[GDataXMLNode] = NSArray() as! [GDataXMLNode]
            var keys : [String] = Array()
            for abl in addressBookList {
                nodes = abl.children() as! [GDataXMLNode]
                for i in 0...nodes.count-1{
                    var obj : String = nodes[i].name()
                    keys.append(obj)
                }
                let name = (abl.elements(forName: "name")[0] as AnyObject).stringValue()
                let department = (abl.elements(forName: "department")[0] as AnyObject).stringValue()
                var ItemId = (abl.elements(forName: "ItemId")[0] as AnyObject).stringValue()
                var position = ""
                if(keys.contains("position")){
                    position = (abl.elements(forName: "position")[0] as AnyObject).stringValue()
                }
                var mobile = ""
                if(keys.contains("mobile")){
                    mobile = (abl.elements(forName: "mobile")[0] as AnyObject).stringValue()
                }
                var phone = ""
                if(keys.contains("phone")){
                    phone = (abl.elements(forName: "phone")[0] as AnyObject).stringValue()
                }
                var ext = ""
                if(keys.contains("ext")){
                    ext = (abl.elements(forName: "ext")[0] as AnyObject).stringValue()
                }
                //print("name:\(name) department:\(department)")
                addressBook = AddressBook(name: name!, image: UIImage(named:"头像")!, company: shortName, department: department!, phone: "", duty: position,ItemId:ItemId!, mobile: mobile, ext: ext)
                keys = []
                addressBookArr.append(addressBook)
            }
            configureSection()
            setup()
  
            
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

    let sortArray = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    //搜索控制器
    
    var searchController: BaseSearchController?

    // tableView
    lazy var tableView: UITableView = { [unowned self] in
        
//        let table = UITableView(frame: self.view.bounds, style: .plain)
        let table = UITableView(frame:CGRect(x: 0, y: 0, width: KScreenWidth, height:KScreenHeight),style: .plain)
        //设置代理
        table.dataSource = self
        table.delegate = self
        table.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        table.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 44, 0)
        table.rowHeight = 65.0
        let footView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: ContactFooterH + 0.4))
        footView.backgroundColor = UIColor.white
        footView.addSubview(footerL)
        table.tableFooterView = footView
        // 改变索引的颜色
        table.sectionIndexColor = UIColor.black
        // 改变索引背景颜色
        table.sectionIndexBackgroundColor = UIColor.clear
        // 改变索引被选中的背景颜色
         table.sectionIndexTrackingBackgroundColor = UIColor.clear

        return table
        }()
     var collation: UILocalizedIndexedCollation? = nil
    // MARK: footerView
    lazy var footerL: UILabel = {
        let footer = UILabel(frame: CGRect(x: 0, y: 0.45, width: UIScreen.main.bounds.width, height: ContactFooterH))
        footer.text = "\(addressBookArr.count)位联系人"
        footer.font = UIFont.systemFont(ofSize: 15)
        footer.backgroundColor = UIColor.white
        footer.textColor = UIColor.gray
        footer.textAlignment = .center
        return footer
    }()
    
    // MARK: 处理过的联系人数组
    lazy var dataArr: [[AddressBook]] = {
        return [[AddressBook]]()
    }()
    //创建实体类数组
    var addressBookArr:[AddressBook] = []
    
    // MARK: 索引数组
    lazy var sectionArr: [String] = {
        return [String]()
    }()
     var sectionsArray: [[AddressBook]] = [[AddressBook]]()
    //生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = shortName
        self.view.backgroundColor = UIColor.white
        getData(methodName: "getAddressBook",action:action)
        

    }
    func Base64Encode(string:String)  ->String {
        let utf8EncodeData = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        // 将NSData进行Base64编码
        let base64String = utf8EncodeData?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: UInt(0)))
        return base64String!
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        hidesBottomBarWhenPushed = false
    }
    
}


///初始化
extension AddressBookViewController {
    
    private func setup() {
        
        

        
        createRightBarBtnItem(icon: UIImage(named:"addressBook")!, method: #selector(addMenu))
        
        //搜索控制器
        let searchController = BaseSearchController(searchResultsController: UITableViewController())
        self.searchController = searchController
        tableView.tableHeaderView = searchController.searchBar
        
        tableView.register(BaseTableviewCell.self, forCellReuseIdentifier: ContactCellID)
        
        view.addSubview(tableView)
    }
}

// 事件处理
extension AddressBookViewController {
    
    //添加按钮
    @objc private func addMenu() {
        FCBLog("添加朋友")
        hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(PersonalViewController(), animated: true)
    }
}
func FCBLog<T>(_ message : T, file : String = #file, funcName : String = #function, lineNum : Int = #line) {
    
    #if DEBUG
    
    let fileName = (file as NSString).lastPathComponent
    
    print("\(fileName):(\(lineNum))-\(message)")
    
    #endif
}
// 代理设置
extension AddressBookViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr[section].count
    }	

    
    func configureSection() {
        //获得当前UILocalizedIndexedCollation对象并且引用赋给collation,A-Z的数据
        collation = UILocalizedIndexedCollation.current()
        //获得索引数和section标题数
        let sectionTitlesCount = collation!.sectionTitles.count
        
        //临时数据，存放section对应的userObjs数组数据
        var newSectionsArray = [[AddressBook]]()
        
        //设置sections数组初始化：元素包含userObjs数据的空数据
        for _ in 0..<sectionTitlesCount {
            let array = [AddressBook]()
            newSectionsArray.append(array)
        }
        
        //将用户数据进行分类，存储到对应的sesion数组中
        
        for bean in addressBookArr {
            //根据timezone的localename，获得对应的的section number
//            let sectionNumber = collation?.section(for: bean, collationStringSelector: #selector( getter: AddressBook.name))
            let sectionNumber = collation?.section(for: bean, collationStringSelector: #selector( getter: AddressBook.name))
            //获得section的数组
            var sectionBeans = newSectionsArray[sectionNumber!]
            
            //添加内容到section中
            sectionBeans.append(bean)
            
            // swift 数组是值类型，要重新赋值
            newSectionsArray[sectionNumber!] = sectionBeans
        }
        
        //排序，对每个已经分类的数组中的数据进行排序，如果仅仅只是分类的话可以不用这步
        for i in 0..<sectionTitlesCount {
            let beansArrayForSection = newSectionsArray[i]
            //获得排序结果
            let sortedBeansArrayForSection = collation?.sortedArray(from: beansArrayForSection, collationStringSelector:  #selector(getter: AddressBook.name))
            //替换原来数组
            newSectionsArray[i] = sortedBeansArrayForSection as! [AddressBook]

        }
        
        dataArr = newSectionsArray
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var data: AddressBook?
            data = dataArr[indexPath.section][indexPath.row]
        

        let cell = tableView.dequeueReusableCell(withIdentifier: ContactCellID) as? BaseTableviewCell
        
        cell?.model = data
        
        cell?.iconView.backgroundColor = UIColor.blue
        cell?.iconView.textColor = UIColor.white
        cell?.iconView.textAlignment = NSTextAlignment .center
        cell?.iconView.font = UIFont.boldSystemFont(ofSize: 25)
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        hidesBottomBarWhenPushed = true
        let addressBookController = AddressBookTableViewController()
        if(indexPath.section==0){
            return
        }
        addressBookController.title = dataArr[indexPath.section][indexPath.row].name
        addressBookController.name = dataArr[indexPath.section][indexPath.row].name
        addressBookController.duty = dataArr[indexPath.section][indexPath.row].duty
        addressBookController.department = dataArr[indexPath.section][indexPath.row].department
        addressBookController.company = dataArr[indexPath.section][indexPath.row].company
        addressBookController.mobile = dataArr[indexPath.section][indexPath.row].mobile
        addressBookController.phone = dataArr[indexPath.section][indexPath.row].phone
        addressBookController.ext = dataArr[indexPath.section][indexPath.row].ext
        navigationController?.pushViewController(addressBookController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //如果数据源中没有当前section的数据，直接return nil，防止header占位
        if(dataArr[section].count==0){
            return nil
        }
        let header = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: ContactHeaderH))
        
        header.backgroundColor = sectionColor
        
        let titleL = UILabel(frame: header.bounds)
        titleL.text = self.tableView(tableView, titleForHeaderInSection: section)

        titleL.font = UIFont.systemFont(ofSize: 14.0)
        titleL.x = 10
        header.addSubview(titleL)
        return header
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(dataArr[section].count==0){
            return 0
        }
        return ContactHeaderH
    }
    
    
    // 返回索引数组
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {

        return sortArray
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
    
        return self.sectionArr
    }
    
    // 返回每个索引的内容
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
                if section == 0 {
                    return nil
                }


        let beansInSection = dataArr[section]
        if (beansInSection as AnyObject).count <= 0 {
            return nil
        }
       
        if let headserString = collation?.sectionTitles[section] {
 
            if !sectionArr.contains(headserString) {
                sectionArr.append(headserString)
         
            }
            return headserString
        }
        return nil

    }
    // 跳至对应的section
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }

    
    // 搜索代理UISearchBarDelegate方法，点击虚拟键盘上的Search按钮时触发
    /**func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
     searchBar.resignFirstResponder()
     }**/
    // 刷新表格
    @objc func reloadTableView() {
        FCBLog("刷新表格")
        tableView.reloadData()
    }

}
