//
//  MRTSItem.swift
//  Progress Claim
//
//  Created by Quang Le Nguyen on 14/3/17.
//  Copyright © 2017 Quang Le Nguyen. All rights reserved.
//

import Foundation
import Firebase


struct workItem {
    let itemNumber: Double
    let itemDescription: String
    let itemDetailDescription: String
    let itemQuantity: Double
    let unitRate: String
}

struct detailClaimed {
    let date: String
    let previousClaimedAmount: Double
    let photoReference: String?
}
class Firebase {
    var UID = FIRAuth.auth()?.currentUser?.uid
    func ref(child: String) -> FIRDatabaseReference{
        let reference = FIRDatabase.database().reference().child(child)
        return reference
    }
    func getKeyValue(ref: FIRDatabaseReference, completion: @escaping (inout (String)) -> ()) {
        ref.queryOrderedByKey().observe(.value, with: { (snapshot) in
            for snap in snapshot.children.allObjects{
                let childSnap = snap as! FIRDataSnapshot
                var keys = childSnap.key
                print(childSnap.key)
                completion(&keys)
            }
        })
    }
}

class customTextField: UITextField {
    
    
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration  = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 4, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 4, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
}

extension FIRDataSnapshot {
    var json: JSON {
        return JSON(self.value)
    }
}
protocol _StringType { }
extension String: _StringType {}
extension Array where Element: _StringType {
     mutating func appendFireBase(snapshoot: FIRDataSnapshot!, key: String) {
        var a = [_StringType]()
        let b = snapshoot.json[key].stringValue as _StringType
        for c in self {
            a.append(c)
        }
        a.append(b)
        self = a as! Array<Element>
    }
}

