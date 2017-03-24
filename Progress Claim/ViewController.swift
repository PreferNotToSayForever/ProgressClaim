//
//  ViewController.swift
//  Progress Claim
//
//  Created by Quang Le Nguyen on 14/3/17.
//  Copyright © 2017 Quang Le Nguyen. All rights reserved.
//

import LBTAComponents
import Firebase


class ViewController: DatasourceController {
    
    var itemNUmber: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let MRTSNumber = TenderScheduleDataSource()
        self.datasource = MRTSNumber
        title = "FTZD - 482"
        collectionView?.backgroundColor = UIColor(r: 40, g: 100, b: 101)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkIfUserIsLoggedIn()
    }
    func checkIfUserIsLoggedIn(){
        if Firebase().UID == nil {
            perform(#selector(self.handleLogout), with: nil, afterDelay: 0)
        } else {
            if Firebase().UID != nil {
                
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let MRTS = self.datasource?.item(indexPath) as? workItem
        let approximateWidthofCell = view.frame.width - 8 - 200
        let size = CGSize(width: approximateWidthofCell, height: 1000)
        let attribute = [NSFontAttributeName: UIFont.systemFont(ofSize: 14)]
        let estimatedFrame = NSString(string: (MRTS?.itemDetailDescription)!).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attribute, context: nil)
        return CGSize(width: view.frame.width, height: estimatedFrame.height + 75)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func calicuateDaysBetweenTwoDates(start: Date, end: Date) -> Int {
        let currentCalendar = Calendar.current
        guard let start = currentCalendar.ordinality(of: .day, in: .era, for: start) else {
            return 0
        }
        guard let end = currentCalendar.ordinality(of: .day, in: .era, for: end) else {
            return 0
        }
        return end - start
    }
    
    func handleLogout() {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        let loginController = LoginViewController()
        self.present(loginController, animated: true) {
           
        }
    }

}

