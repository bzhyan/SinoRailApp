//
//  ApproveListVC.swift
//  SinoRailAPP
//
//  Created by ybz on 2018/9/7.
//  Copyright © 2018年 SinoRailAPP. All rights reserved.
//

import UIKit

class ApproveListVC: UITableViewController {
    let reuseIdentifier = "approveInfoCell"
    var SiteId : String = ""
    var WebId : String = ""
    var ListId : String = ""
    var approveType : String = ""
    var approveInfoArr:[ApproveInfo] = Array()
    //请求参数
    
    //命名空间
    let kNameSpace = "http://service.spf.sinorail.com/"
    //url前缀
    let WS = "http://office.sinorail.com:8888/"
    //url后缀
    let approveWS = "approveWS.asmx?WSDL"
    //actionName
    let action = "http://service.spf.sinorail.com/getApproveList"
    
    //去webservice请求数据
    func getData(methodName:String,action:String){
        let rootCode = "<username>wulei1</username>"
            +      "<password>Mx0bg+sqQhBe4Aclig77yA==</password>"
            +       "<approveType>"+approveType+"</approveType>"
            +      "<SiteId>"+SiteId+"</SiteId>"
        +      "<WebId>"+WebId+"</WebId>"
        +      "<ListId>"+ListId+"</ListId>"
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
            let approveInfoList = try! doc.nodes(forXPath: "//ApproveList", namespaces:nil) as! [GDataXMLElement]
            var approve : ApproveInfo!
            for approveInfo in approveInfoList {
                //ApproveList节点的title属性
                let title = (approveInfo.elements(forName: "title")[0] as AnyObject).stringValue()!
                //获取name节点元素
                let SiteIdResp = (approveInfo.elements(forName: "SiteId")[0] as AnyObject).stringValue()!
                
                let WebIdResp = (approveInfo.elements(forName: "WebId")[0] as AnyObject).stringValue()!
                
                let ListIdResp = (approveInfo.elements(forName: "ListId")[0] as AnyObject).stringValue()!
                
                let ItemIdResp = (approveInfo.elements(forName: "ItemId")[0] as AnyObject).stringValue()!
                
                let name = (approveInfo.elements(forName: "name")[0] as AnyObject).stringValue()!
                
                let owner = (approveInfo.elements(forName: "owner")[0] as AnyObject).stringValue()!
                
                let arrive = (approveInfo.elements(forName: "arrive")[0] as AnyObject).stringValue()!
                
                let start = (approveInfo.elements(forName: "start")[0] as AnyObject).stringValue()!
                
                let workflowState = (approveInfo.elements(forName: "WorkflowState")[0] as AnyObject).stringValue()!
                
                let operation = (approveInfo.elements(forName: "operation")[0] as AnyObject).stringValue()!
                
                let stepIndex = (approveInfo.elements(forName: "StepIndex")[0] as AnyObject).stringValue()!
                
                let stepName = (approveInfo.elements(forName: "StepName")[0] as AnyObject).stringValue()!
                
                let desc = (approveInfo.elements(forName: "desc")[0] as AnyObject).stringValue()!
                //输出调试信息
                approve = ApproveInfo(ListId: ListIdResp, WebId: WebIdResp, ItemId: ItemIdResp, title: title, arrive: arrive, name: name, owner: owner, start: start, workflowState: workflowState, SiteId: SiteIdResp, operation: operation, StepIndex: stepIndex, StepName: stepName, desc: desc)
                approveInfoArr.append(approve)
                
            }

            self.tableView.reloadData()
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
        getData(methodName: "getApproveList", action: action)
        switch approveType {
        case "bm" :
            self.title = "费用审批"
        case "Approvercenter" :
            self.title = "流程审批"
        case "kqweb" :
            self.title = "考勤审批"
        case "pfg" :
            self.title = "货款审批"
        default:
            ""
        }
        self.tableView.register(ApproveInfoCell.self, forCellReuseIdentifier: reuseIdentifier)
        let footView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        footView.backgroundColor = UIColor.white
        tableView.tableFooterView = footView
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let approveDetailVC = ApproveDetailVC()
        approveDetailVC.SiteId = approveInfoArr[indexPath.row].SiteId
        approveDetailVC.WebId = approveInfoArr[indexPath.row].WebId
        approveDetailVC.ListId = approveInfoArr[indexPath.row].ListId
        approveDetailVC.ItemId = approveInfoArr[indexPath.row].ItemId
        approveDetailVC.approveTitle = approveInfoArr[indexPath.row].title
        approveDetailVC.approveType = approveType
        approveDetailVC.desc = approveInfoArr[indexPath.row].desc
        navigationController?.pushViewController(approveDetailVC, animated: true)
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
        return approveInfoArr.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ApproveInfoCell
        cell.titleLabel.text = approveInfoArr[indexPath.row].title
        cell.stepLabel.text = "当前步骤："+approveInfoArr[indexPath.row].StepName
        cell.ownerLabel.text = "发起人："+approveInfoArr[indexPath.row].owner
        cell.arriveLabel.text = "送达："+approveInfoArr[indexPath.row].arrive
        // Configure the cell...

        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
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
