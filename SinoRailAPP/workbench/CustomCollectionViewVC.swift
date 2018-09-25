//
//  CustomCollectionViewVC.swift
//  TableViewText
//
//  Created by thinkjoy on 2017/7/11.
//  Copyright © 2017年 杜瑞胜. All rights reserved.
//

import UIKit


class CustomCollectionViewVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,CoutomeCollectionViewCellDelegate {
    //流程审批数量
    private var lcCount : String = "0"
    //费用审批数量
    private var fyCount : String = "0"
    //考勤审批数量
    private var kqCount : String = "0"
    //货款审批数量
    private var hkCount : String = "0"
    //流程siteId
    private var lcSiteId : String = ""
    //流程webid
    private var lcWebId : String = ""
    //流程Listid
    private var lcListId : String = ""
    //费用siteId
    private var fySiteId : String = ""
    //费用webid
    private var fyWebId : String = ""
    //费用Listid
    private var fyListId : String = ""
    //考勤siteId
    private var kqSiteId : String = ""
    //考勤webid
    private var kqWebId : String = ""
    //考勤Listid
    private var kqListId : String = ""
    //货款siteId
    private var hkSiteId : String = ""
    //货款webid
    private var hkWebId : String = ""
    //货款Listid
    private var hkListId : String = ""
    /// 行距
    private let hangSpace:Float = 10
    
    /// 列距
    private let lieSpace:Float = 10
    
    /// 间距
    private let marginSpace:Float = 5
    
    /// 列数
    private let lieCount = 4
    
    /// 是否是编辑状态
    private var isEdit:Bool =   false
    
    /// 所有items模型数组
    private var allItemModel:NSMutableArray =   NSMutableArray.init()
    
    private var _moveIndexP:IndexPath?
    private var _originalIndexP:IndexPath?
    private var _snapshotV:UIView?
    //let lable=UILabel(frame: CGRect(x: 40, y: 40, width: 200, height:200))
    private let sectionHeaderID = "sectionHeaderID"
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
        }else {
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
                let WebId = (approveInfo.elements(forName: "WebId")[0] as AnyObject).stringValue()
                let ListId = (approveInfo.elements(forName: "ListId")[0] as AnyObject).stringValue()
                //输出调试信息
                switch approveTypeName{
                case "流程审批" :
                    lcCount = count!
                    lcSiteId = SiteId!
                    lcWebId = WebId!
                    lcListId = ListId!
                case "考勤审批" :
                    kqCount = count!
                    kqSiteId = SiteId!
                    kqWebId = WebId!
                    kqListId = ListId!
                case "费用审批" :
                    fyCount = count!
                    fySiteId = SiteId!
                    fyWebId = WebId!
                    fyListId = ListId!
                case "货款审批" :
                    hkCount = count!
                    hkSiteId = SiteId!
                    hkWebId = WebId!
                    hkListId = ListId!
                case .none: break
                    
                case .some(_): break
                    
                }

            }
            var dataMDMuAry1 = { () -> NSMutableArray in
                var dataAry = NSMutableArray.init(array: [
                    ["type":"我的审批","items":[
                        ["imageName":"充值中心","itemTitle":"流程审批","itemCount":"\(lcCount)","SiteId":"\(lcSiteId)","WebId":"\(lcWebId)","ListId":"\(lcListId)","approveType":"Approvercenter"],
                        ["imageName":"信用卡还款","itemTitle":"费用审批","itemCount":"\(fyCount)","SiteId":"\(fySiteId)","WebId":"\(fyWebId)","ListId":"\(fyListId)","approveType":"bm"],
                        ["imageName":"生活缴费","itemTitle":"考勤审批","itemCount":"\(kqCount)","SiteId":"\(kqSiteId)","WebId":"\(kqWebId)","ListId":"\(kqListId)","approveType":"kqweb"],
                        ["imageName":"城市服务","itemTitle":"货款审批","itemCount":"\(hkCount)","SiteId":"\(hkSiteId)","WebId":"\(hkWebId)","ListId":"\(hkListId)","approveType":"pfg"]
                        ]]
                    ]
                )
                var muAry   =   NSMutableArray.init()
                let count   =   dataAry.count
                
                for i in 0..<count {
                    let dic =   dataAry[i] as! NSDictionary
                    let model:CoutomeCollectionViewCellModel    =   CoutomeCollectionViewCellModel.init(objectWith: dic as! [AnyHashable : Any])
                    let items:[Items]   =   model.items as! [Items]
                    muAry.add(model)
                }
                return muAry
            }()
            dataMDMuAry = dataMDMuAry1
            let flowLayout = UICollectionViewFlowLayout()
            let mainCollectionView = UICollectionView(frame:CGRect(x: 0, y: 250, width: KScreenWidth, height:KScreenHeight-280), collectionViewLayout: flowLayout)
            mainCollectionView.dataSource = self
            mainCollectionView.delegate = self
            mainCollectionView.backgroundColor = UIColor.white
            self.view.addSubview(mainCollectionView)
            let KWinW:Float = Float(self.view.bounds.size.width)
            
            
            
            //cell width
            let item_W:Float    =   (KWinW - marginSpace*2 - Float(lieCount-1)*lieSpace)/Float(lieCount)
            //cell height
            let item_H:Float    =   item_W*0.75
            
            flowLayout.itemSize =   CGSize.init(width: CGFloat(item_W), height: CGFloat(item_H))
            
            flowLayout.headerReferenceSize = CGSize.init(width: CGFloat(KWinW), height: 35)
            
            self.automaticallyAdjustsScrollViewInsets   =   false
            
            //注册CoutomeCollectionViewCell
            mainCollectionView.register(UINib.init(nibName: CoutomeCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: CoutomeCollectionViewCell.className)
            
            mainCollectionView.register(CollectionReusableHeaderView.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier:sectionHeaderID)
            mainCollectionView.reloadData()
            
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
    //    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
//    @IBOutlet weak var mainCollectionView: UICollectionView!
    

//    MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        var imageView : UIImageView
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: KScreenWidth, height: 250))
        imageView.image = UIImage(named:"workbenchPic")
        self.view.addSubview(imageView)
        self.view.backgroundColor = UIColor.white
        self.getData(methodName: "getApproveInfo", paramValues: rootCode, action: action)
    }
 
    
//MARK: -   UICollectionViewDataSource
    //区个数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let count = self.dataMDMuAry.count
        return count;
    }
    
    //对应区cell个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) ->
    
        Int {
        let model:CoutomeCollectionViewCellModel = self.dataMDMuAry[section] as! CoutomeCollectionViewCellModel
        let count = model.items.count
        return count;
    }
    
    //
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:CoutomeCollectionViewCell  =   CoutomeCollectionViewCell.getCoutomeCollectionViewCell(collectionView: collectionView, indexPath: indexPath);
    
        let sectionMD:CoutomeCollectionViewCellModel = self.dataMDMuAry[indexPath.section] as! CoutomeCollectionViewCellModel
        
        let itemMD = sectionMD.items[indexPath.row] as! Items
        
        if self.isEdit {
            if sectionMD.type! == "我的应用" {
                itemMD.itemStaue    =   ItemStaue_CanDelete
            }
        }else{
            itemMD.itemStaue    =   ItemStaue_None
        }
        itemMD.itemCount = ((self.dataMDMuAry[indexPath.section] as! CoutomeCollectionViewCellModel).items[indexPath.row] as! Items).itemCount
        cell.itemMD = itemMD    //赋值
        
        cell.delegate =   self  //设置代理
 
        return  cell;
    }
    
//MARK: -   UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellModel : CoutomeCollectionViewCellModel = dataMDMuAry[indexPath.section] as! CoutomeCollectionViewCellModel
        let items : NSArray = cellModel.items! as NSArray
        let item : Items = items[indexPath.row] as! Items
        let SiteId = item.siteId!
        let WebId = item.webId!
        let ListId = item.listId!
        let approveType = item.approveType!
        let approveListVC = ApproveListVC()
        approveListVC.SiteId = SiteId
        approveListVC.WebId = WebId
        approveListVC.ListId = ListId
        approveListVC.approveType = approveType
        navigationController?.pushViewController(approveListVC, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if (kind == UICollectionElementKindSectionHeader) {
            let  reusableV:CollectionReusableHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: sectionHeaderID, for: indexPath) as! CollectionReusableHeaderView
            
            let sectionMD:CoutomeCollectionViewCellModel? = self.dataMDMuAry[indexPath.section] as? CoutomeCollectionViewCellModel
            reusableV.title =   sectionMD?.type
            
            return  reusableV
        }else {
            return UICollectionReusableView()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//MARK: - Lazy
    
    /// 初始数据字典数组，转化得到的数据模型
    lazy var dataMDMuAry = { () -> NSMutableArray in
        var dataAry = NSMutableArray.init(array: [
            ["type":"我的审批","items":[
                ["imageName":"充值中心","itemTitle":"流程审批","itemCount":"\(lcCount)"],
                ["imageName":"信用卡还款","itemTitle":"费用审批","itemCount":"\(fyCount)"],
                ["imageName":"生活缴费","itemTitle":"考勤审批","itemCount":"\(kqCount)"],
                ["imageName":"城市服务","itemTitle":"货款审批","itemCount":"\(hkCount)"]
                ]]
                    ]
               )
        var muAry   =   NSMutableArray.init()
        let count   =   dataAry.count
        
        for i in 0..<count {
            let dic =   dataAry[i] as! NSDictionary
            let model:CoutomeCollectionViewCellModel    =   CoutomeCollectionViewCellModel.init(objectWith: dic as! [AnyHashable : Any])
            let items:[Items]   =   model.items as! [Items]
            muAry.add(model)
        }
        return muAry
    }()

}

