//
//  CustomCell.swift
//  Progress Claim
//
//  Created by Quang Le Nguyen on 14/3/17.
//  Copyright © 2017 Quang Le Nguyen. All rights reserved.
//

import LBTAComponents
import Firebase

// Mark: Header Setup

class tenderHeader: DatasourceCell {
    var contractNumber: String = ContractDescription.contractNumber
    var contractName: String = ContractDescription.contracName
    
    
    override func setupViews() {
        super.setupViews()
        setupAdditionalView()
        backgroundColor = UIColor(r: 39, g: 101, b: 149)
        
    }
    func setupAdditionalView(){
        addSubview(headerSubTitle)
        addSubview(line)
        
        
        headerSubTitle.anchor(topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 8, leftConstant: (self.frame.width/2 - headerSubTitle.intrinsicContentSize.width/2), bottomConstant: 0, rightConstant: 0, widthConstant: headerSubTitle.intrinsicContentSize.width, heightConstant: headerSubTitle.intrinsicContentSize.height)
        
        line.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: frame.width, heightConstant: 1)
        
    }
    lazy var headerSubTitle: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = self.contractName
        title.font = UIFont.boldSystemFont(ofSize: 14)
        title.textColor = UIColor(r: 0, g: 6, b: 98)
        return title
    }()
    let line: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = .black
        return line
    }()
    
}

// Mark: Footer Setup

class tenderFooter: DatasourceCell {
    override func setupViews() {
        super.setupViews()
    backgroundColor = UIColor(r: 39, g: 101, b: 149)
        setupAdditionalView()
    }
    let line: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = .black
        return line
    }()
    func setupAdditionalView(){
        addSubview(line)
        
        line.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: frame.width, heightConstant: 1)
        
    }

}

// Mark: Custom Cell Setup

class customCell: DatasourceCell {
    override func setupViews() {
        super.setupViews()
        setupAdditionalView()
        backgroundColor = UIColor(r: 251, g: 222, b: 75)
    }
    let MRTSName: UILabel = {
        let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.text = "1201.01         "
        return name
    }()
    
    let MRTSDescription: UILabel = {
        let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.text = "Technical Specification Number"
        name.font = UIFont.systemFont(ofSize: 14)
        return name
    }()
    
    let MRTSDetailDescription: UITextView = {
        let name = UITextView()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.text = "Technical Specification Number"
        name.font = UIFont.systemFont(ofSize: 16)
        name.textAlignment = .left
        name.backgroundColor = UIColor(r: 251, g: 222, b: 75)
        return name
    }()

    lazy var claimButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(navigation), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    let line: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = .black
        return line
    }()
    
    func navigation(){
        let viewController =  ClaimedDetailViewController()
        viewController.title = MRTSName.text
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.transferingData = MRTSName.text
        let navController = UINavigationController(rootViewController: viewController)
        self.window?.rootViewController?.present(navController, animated: true, completion: nil)
        let ref = FIRDatabase.database().reference()
        guard let MrtsNumber = MRTSName.text else { return }
        let number = MrtsNumber.replacingOccurrences(of: ".", with: "")
        ref.child(number).child("Item Description").setValue(MRTSDetailDescription.text)
        ref.child(number).child("Original Quantity").setValue(claimButton.titleLabel?.text)
    }
    
    func setupAdditionalView(){
        //        Add additional "view" to customCell
        addSubview(MRTSName)
        addSubview(MRTSDescription)
        addSubview(MRTSDetailDescription)
        addSubview(claimButton)
        addSubview(line)
        
        //        configurate viewlayout
        MRTSName.anchor(topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 8, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: MRTSName.intrinsicContentSize.width, heightConstant: MRTSName.intrinsicContentSize.height)
        
        MRTSDescription.anchor(MRTSName.topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: MRTSName.intrinsicContentSize.width, bottomConstant: 0, rightConstant: 8, widthConstant: 0, heightConstant: 0)
        
        MRTSDetailDescription.anchor(MRTSName.bottomAnchor, left: MRTSName.leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 120, widthConstant: 0, heightConstant: 0)
        
        claimButton.anchor(MRTSDetailDescription.topAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 8, widthConstant: 100, heightConstant: 50)
        
        line.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: frame.width, heightConstant: 1)
        
    }
    
    override var datasourceItem: Any? {
        didSet {
            guard let item = datasourceItem as? workItem else { return }
            MRTSName.text =  String(item.itemNumber)
            MRTSDescription.text = item.itemDescription
            MRTSDetailDescription.text = item.itemDetailDescription
            claimButton.setTitle(String(item.itemQuantity), for: .normal)
            
            
            
        }
    }
}


