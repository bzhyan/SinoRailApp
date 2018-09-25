import UIKit

class AddressBookCompany: NSObject {

    
    var itemId:String!
    var shortName:String!
    var name:String!
    var address:String!
    var phone:String!
    var fax:String!
    var zipCode:String!
    var flag:String!
    
    init(itemId:String,shortName:String,name:String,address:String,phone:String,fax:String,zipCode:String,flag:String ) {
        self.itemId = itemId
        self.name = name
        self.shortName = shortName
        self.address = address
        self.phone = phone
        self.fax = fax
        self.zipCode = zipCode
        self.flag = flag
    }
    
}

