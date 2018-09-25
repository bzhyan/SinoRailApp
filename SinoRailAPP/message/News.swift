import UIKit

class News: NSObject {
    
    var newsPicName:String!
    var newsTitle:String!
    var newsContent:String!
    var newsFollowUp:String!
    
    init(newsPicName:String,newsTitle:String,newsContent:String,newsFollowUp:String ) {
        self.newsPicName = newsPicName
        self.newsTitle = newsTitle
        self.newsContent = newsContent
        self.newsFollowUp = newsFollowUp
    }
    
}

//作者：风的低语
//链接：https://www.jianshu.com/p/67a2e2b4e2bf
//來源：简书
//简书著作权归作者所有，任何形式的转载都请联系作者获得授权并注明出处。
