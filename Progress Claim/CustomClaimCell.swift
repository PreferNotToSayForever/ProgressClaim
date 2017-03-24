//
//  CustomClaimCell.swift
//  Progress Claim
//
//  Created by Quang Le Nguyen on 15/3/17.
//  Copyright © 2017 Quang Le Nguyen. All rights reserved.
//

import LBTAComponents

class ClaimDetailCustomCell: DatasourceCell, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var titleName: String!
    var photoRef: String!
    override func setupViews() {
        super.setupViews()
        setupAdditionalView()
        backgroundColor = UIColor(r: 251, g: 222, b: 75)
        
    }
    let date: UILabel = {
        let date = UILabel()
        date.translatesAutoresizingMaskIntoConstraints = false
        date.text = "1201.01         "
        return date
    }()
    
    let claimQuantity: UILabel = {
        let quantity = UILabel()
        quantity.translatesAutoresizingMaskIntoConstraints = false
        quantity.text = "1201.01         "
        quantity.textAlignment = .left
        return quantity
    }()
    
    lazy var photo: UIButton = {
       let photo = UIButton()
        photo.backgroundColor = UIColor.lightGray
        photo.translatesAutoresizingMaskIntoConstraints = false
        photo.layer.cornerRadius = 10
        photo.layer.masksToBounds = true
        photo.addTarget(self, action: #selector(takephoto), for: .touchUpInside)
        photo.backgroundColor = UIColor(r: 40, g: 100, b: 101)
        return photo
    }()
    
    func takephoto(_sender: UITapGestureRecognizer) {
        let photoController = PhotoViewController()
        let navigationPhotoController = UINavigationController(rootViewController: photoController)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.photoReference = photoRef
    
        self.window?.rootViewController?.presentedViewController?.present(navigationPhotoController, animated: true, completion: nil)
        
    }
    
    func setupAdditionalView(){
        addSubview(date)
        addSubview(claimQuantity)
        addSubview(photo)
        
        date.anchor(topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 8, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        claimQuantity.anchor(topAnchor, left: date.rightAnchor, bottom: nil, right: nil, topConstant: 8, leftConstant: 80, bottomConstant: 0, rightConstant: 8, widthConstant: 0, heightConstant: 0)
    
        photo.anchor(topAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 8, widthConstant: 50, heightConstant: 50)
        
    }
    
    func swipeRightToDelete(){
        
    }
    override var datasourceItem: Any? {
        didSet {
            guard let item = datasourceItem as? detailClaimed else { return }
//            date.text = item.date
            date.text = item.date
            claimQuantity.text = String(item.previousClaimedAmount)
            photoRef = item.photoReference
        }
    }
}

class ClaimedDetailHeader: DatasourceCell {
    override func setupViews() {
        super.setupViews()
       setupAdditionalView()
        backgroundColor = UIColor(r: 39, g: 101, b: 149)
    }
    func setupAdditionalView() {
        addSubview(date)
        addSubview(previousClaimed)
        addSubview(photo)
        
        date.anchor(topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: self.frame.height/2, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        previousClaimed.anchor(topAnchor, left: date.rightAnchor, bottom: nil, right: nil, topConstant: self.frame.height/2, leftConstant: 80, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        photo.anchor(topAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: self.frame.height/2, leftConstant: 0, bottomConstant: 0, rightConstant: 8, widthConstant: 0, heightConstant: 0)
        
        
  }
    let date: UILabel = {
        let date = UILabel()
        date.translatesAutoresizingMaskIntoConstraints = false
        date.text = "Date"
        date.font = UIFont.boldSystemFont(ofSize: 16)
        return date
    }()
    
    let previousClaimed: UILabel = {
        let previousClaimed = UILabel()
        previousClaimed.translatesAutoresizingMaskIntoConstraints = false
        previousClaimed.text = "Previous Claimed"
        previousClaimed.font = UIFont.boldSystemFont(ofSize: 16)
        return previousClaimed
    }()
    
    let photo: UILabel = {
        let photo = UILabel()
        photo.translatesAutoresizingMaskIntoConstraints = false
        photo.text = "Photo"
        photo.font = UIFont.boldSystemFont(ofSize: 16)
        return photo
    }()
    
    
}


class ClaimedDetailFooter: DatasourceCell {
    override func setupViews() {
        super.setupViews()
        backgroundColor = UIColor.gray
         setupAdditionalView()
    }
    let total: UILabel = {
        let total = UILabel()
        total.translatesAutoresizingMaskIntoConstraints = false
        total.text = "Total"
        total.font = UIFont.boldSystemFont(ofSize: 16)
        return total
    }()
    
    
    let amount: UILabel = {
        let amount = UILabel()
        amount.translatesAutoresizingMaskIntoConstraints = false
        let items = claimedDetailDataSource().itemClaimed
        var subtotalAmount: Double = 0.0
        for item in items {
            subtotalAmount += item.previousClaimedAmount
        }
        
        amount.text = String(subtotalAmount)
        amount.font = UIFont.boldSystemFont(ofSize: 16)
        amount.textAlignment = .right
        return amount
    }()
    
    
    func setupAdditionalView() {
        addSubview(total)
        addSubview(amount)
        
        total.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 8, leftConstant: 8, bottomConstant: 8, rightConstant: 8, widthConstant: 100, heightConstant: 0)
        
         amount.anchor(topAnchor, left: total.rightAnchor, bottom: bottomAnchor, right: nil, topConstant: 8, leftConstant: 0, bottomConstant: 8, rightConstant: 8, widthConstant: 100, heightConstant: 0)
        
        
    }
    
}

