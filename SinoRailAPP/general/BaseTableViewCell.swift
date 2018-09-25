import UIKit

class BaseTableviewCell: UITableViewCell {
    
  
    
    // moxing
    

    let lable=UILabel(frame: CGRect(x: 60, y: 7.5, width: KScreenWidth-60, height:50))
    let iconView = UILabel(frame: CGRect(x: 5, y: 12.5, width: 40, height:40))
    
    var model: AddressBook? {	
        
        
        didSet {
            
//            nickName.text = model?.name ?? "小明"
//            iconView.image = model?.image ?? UIImage(named:"newsPic")
            self.addSubview(lable)
            self.addSubview(iconView)
            let headImage = String((model?.name.suffix(1))!)
            lable.text = model?.name ?? ""
            iconView.text = headImage
            
            //nickName.text="333"
            //iconView.image =  UIImage(named:"newsPic")
        }
    }
    
    
}
