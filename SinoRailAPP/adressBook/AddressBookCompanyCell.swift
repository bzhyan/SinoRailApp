import UIKit



class AddressBookCompanyCell: UITableViewCell {
    
    //全称
    var name:UILabel!
    //简称
    var shortName : UILabel!
    //电话
    var telephone : UILabel!
    //传真
    var fax : UILabel!
    //地址
    var address : UILabel!

    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //调用布局的方法
        self.setupViews()
    }
    
    func setupViews(){
        //全称
        name = UILabel(frame: CGRect(x: 5, y: 5, width: KScreenWidth, height:15))
        name.backgroundColor = UIColor.white
        name.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(rawValue: 0.1))
        name.textColor = UIColor.gray
        self.contentView.addSubview(name)
	
        //简称
        shortName = UILabel(frame: CGRect(x: 5, y: 25, width: KScreenWidth, height: 25))
        shortName.backgroundColor = UIColor.white
        shortName.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight(rawValue: 0.3))
        self.contentView.addSubview(shortName)
        
        //电话
        telephone = UILabel(frame: CGRect(x: 5, y: 55, width: KScreenWidth, height: 15))
        telephone.backgroundColor = UIColor.white
        telephone.font = UIFont.systemFont(ofSize: 12)
        telephone.textColor = UIColor.gray
        self.contentView.addSubview(telephone)
        //传真
        fax = UILabel(frame: CGRect(x: 5, y: 75, width: KScreenWidth, height: 15))
        fax.backgroundColor = UIColor.white
        fax.font = UIFont.systemFont(ofSize: 12)
        fax.textColor = UIColor.gray
        self.contentView.addSubview(fax)
        //地址
        address = UILabel(frame: CGRect(x: 5, y: 95, width: KScreenWidth, height: 15))
        address.backgroundColor = UIColor.white
        address.font = UIFont.systemFont(ofSize: 12)
        address.textColor = UIColor.gray
        self.contentView.addSubview(address)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

