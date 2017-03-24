//
//  ClaimDetailViewController.swift
//  Progress Claim
//
//  Created by Quang Le Nguyen on 14/3/17.
//  Copyright © 2017 Quang Le Nguyen. All rights reserved.
//

import LBTAComponents
import Firebase

struct TimeStampAndAutoID {
    let timeStamp: NSNumber
    let childByAutoID: String
}

class ClaimedDetailViewController: DatasourceController {
        var ref: FIRDatabaseReference!
        var timestamp: NSNumber!
        var claimedData = claimedDetailDataSource()
        var listOfTimeStamp = [TimeStampAndAutoID]()
    
        override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingValue()
        observeNewDataAdd()
        ref = FIRDatabase.database().reference()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(addItem))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(goBack))
        collectionView?.isScrollEnabled = true
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    
      override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 70)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 40)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.height, height: 50)
    }
    func goBack(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func addItem() {
        let vc = UIAlertController(title: "Add Item", message: "", preferredStyle: UIAlertControllerStyle.alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let ok = UIAlertAction(title: "Update", style: .default) { (result) in
            let input: String = (vc.textFields?[0].text)!
            
            let currentDate = self.getCurrentDate()
            var currentItemNumber = self.title
            currentItemNumber = currentItemNumber?.replacingOccurrences(of: ".", with: "")
            let timeStamp = Int(NSDate().timeIntervalSince1970) as NSNumber
            let updatingValue = ["TimeStamp" : timeStamp, "Date Claimed" : currentDate,"Claim Amount" : input ] as [String : Any]
            let childByAutoID = self.ref.childByAutoId().key
            self.ref.child(currentItemNumber!).child("Claim History").child(childByAutoID).updateChildValues(updatingValue)

           
            
        }
        vc.addAction(cancel)
        vc.addAction(ok)
        vc.addTextField { (textField: UITextField) in
            textField.placeholder = "Add Text"
        }
        self.present(vc, animated: true, completion: nil)
    }
    func getCurrentDate()->String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MMM.yyyy"
        let result = formatter.string(from: date)
        return result
    }
    func loadingValue(){
        self.claimedData = claimedDetailDataSource()
        self.listOfTimeStamp.removeAll(keepingCapacity: true)
        let currentDataBaseLocation = FIRDatabase.database().reference().child((self.title?.replacingOccurrences(of: ".", with: ""))!).child("Claim History")
        currentDataBaseLocation.queryOrdered(byChild: "TimeStamp").observeSingleEvent(of: .value, with: { (snapshoot) in
            if snapshoot.exists() {
                
                for childsnap in snapshoot.children.allObjects {
                    let snap = childsnap as! FIRDataSnapshot
                    if let snapshotValue = snapshoot.value as? NSDictionary, let snapVal = snapshotValue[snap.key] as? NSDictionary {
                        if let dateClaimed = snapVal.value(forKey: "Date Claimed") as? String, let claimAmount = snapVal.value(forKey: "Claim Amount") as? String{
                            
                            let claimItem = detailClaimed(date: dateClaimed, previousClaimedAmount: Double(claimAmount)!,photoReference: snap.key)
                            self.claimedData.itemClaimed.append(claimItem)
                            self.timestamp = snapVal.value(forKey: "TimeStamp") as! NSNumber!
                            
                            let referenceItem = TimeStampAndAutoID(timeStamp: self.timestamp, childByAutoID: snap.key)
                            self.listOfTimeStamp.append(referenceItem)
                        }
                    }
                }
                self.datasource = self.claimedData
            } else {
                self.datasource = self.claimedData
                print("Data doesnt exist")
            }
        })
    }
    func observeNewDataAdd(){
        let ref = FIRDatabase.database().reference().child((self.title?.replacingOccurrences(of: ".", with: ""))!).child("Claim History")
        ref.queryOrdered(byChild: "TimeStamp").queryLimited(toLast: 1).observe(.childAdded, with: { (snapshoot) in
            if let snapshootValue = snapshoot.value as? NSDictionary {
                if let claimAmount = snapshootValue.value(forKey: "Claim Amount") as? String, let dateClaimed = snapshootValue.value(forKey: "Date Claimed") as? String, let stamp = snapshootValue.value(forKey: "TimeStamp") as? NSNumber! {
                    guard stamp != self.timestamp && self.timestamp != nil else { return }
                    guard self.listOfTimeStamp.last?.childByAutoID != snapshoot.key && self.listOfTimeStamp.count != 0 else { return }
                    print(snapshoot.key, "this is the test data")
                    print(self.listOfTimeStamp.last?.childByAutoID)
                    let claimItem = detailClaimed(date: dateClaimed, previousClaimedAmount: Double(claimAmount)!,photoReference:snapshoot.key)
                    self.claimedData.itemClaimed.append(claimItem)
                    self.listOfTimeStamp.append(TimeStampAndAutoID(timeStamp: stamp, childByAutoID: (self.listOfTimeStamp.last?.childByAutoID)!))
                    self.collectionView?.reloadData()
                }
            }
        })
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ref = FIRDatabase.database().reference().child((self.title?.replacingOccurrences(of: ".", with: ""))!).child("Claim History")
        let childByAutoIDAtSelectedRow = listOfTimeStamp[indexPath.row].childByAutoID
       
    }
    
}
