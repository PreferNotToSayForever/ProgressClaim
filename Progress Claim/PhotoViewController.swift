//
//  PhotoViewController.swift
//  Progress Claim
//
//  Created by Quang Le Nguyen on 17/3/17.
//  Copyright © 2017 Quang Le Nguyen. All rights reserved.
//

import LBTAComponents
import Firebase

class tableViewCell: UITableViewCell,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var tableView = PhotoViewController()
    var photoController: PhotoViewController?
    
    static var PhotoReference: String!
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.lable.textColor = .darkText
        setupView()
    }
     let picker = UIImagePickerController()
    var beforeOrAfter: Bool = true
    var lable: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    var lable2: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    var fireBasekey: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.font = UIFont.systemFont(ofSize: CGFloat(5))
        return lable
    }()
    var beforeFireBaseReference: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.font = UIFont.systemFont(ofSize: CGFloat(5))
        lable.text = "Firebase ref"
        return lable
    }()
    var beforePhotoFireBaseDownloadURL: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.font = UIFont.systemFont(ofSize: CGFloat(5))
        lable.text = "DownloadURL"
        return lable
    }()
    var afterPhotoFireBaseDownloadURL: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.font = UIFont.systemFont(ofSize: CGFloat(5))
        lable.text = "DownloadURL"
        return lable
    }()
    var afterFireBaseReference: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.font = UIFont.systemFont(ofSize: CGFloat(5))
        lable.text = "Firebase ref"
        return lable
    }()
    lazy var photoBefore: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.isUserInteractionEnabled = true
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(addImage1))
        image.addGestureRecognizer(tap1)
        image.layer.cornerRadius = 15
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        image.backgroundColor = UIColor(r: 39, g: 101, b: 149)
       return image
    }()
   lazy var photoAfter: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(addImage))
        image.addGestureRecognizer(tap)
        image.layer.cornerRadius = 15
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        image.backgroundColor = UIColor(r: 39, g: 101, b: 149)
        return image
    }()
    func addImage(tapGesture: UITapGestureRecognizer) {
        if photoAfter.image != nil {
            if let imageView = tapGesture.view as? UIImageView {
                self.photoController?.performZoomInforStartingImageView(startingImageView: imageView)
            }
            return
        }
        beforeOrAfter =  false
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.window?.rootViewController?.presentedViewController?.presentedViewController?.present(picker, animated: true, completion: nil)
    }
    func addImage1(tapGesture2: UITapGestureRecognizer) {
        if photoBefore.image != nil {
            if let imageView = tapGesture2.view as? UIImageView {
                self.photoController?.performZoomInforStartingImageView(startingImageView: imageView)
            }
            return
        }
        beforeOrAfter = true
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.window?.rootViewController?.presentedViewController?.presentedViewController?.present(picker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else { return }
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        if let jpegData = UIImageJPEGRepresentation(image, 80) {
            try? jpegData.write(to: imagePath)
        }
        let path = getDocumentsDirectory().appendingPathComponent(imageName)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let PhotochildID = appDelegate.photoReference
        let storage = FIRStorage.storage().reference()
        let ref = FIRDatabase.database().reference().child("Photo Reference").child(PhotochildID!).child(fireBasekey.text!)
        if beforeOrAfter{
            let storageRef = storage.child("Before").child(imageName)
            photoBefore.image = UIImage(contentsOfFile: path.path)
            if let uploadData = UIImageJPEGRepresentation(self.photoBefore.image!, 80) {
                storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error ?? "UploadImage to Before Treatment Folder Error")
                        return
                    }
                    if let photoURL = metadata?.downloadURL()?.absoluteString {
                      ref.updateChildValues(["Before Treatment Photo": photoURL,
                                             "Before Treatment Photo Name": imageName
                                             ])
                    }
                })
            }
        } else {
            photoAfter.image = UIImage(contentsOfFile: path.path)
            let storageRef = storage.child("After").child(imageName)
            if let uploadData = UIImageJPEGRepresentation(self.photoAfter.image!, 80) {
                storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error ?? "UploadImage to After Treatment Folder Error")
                        return
                    }
                    if let photoURL = metadata?.downloadURL()?.absoluteString {
                        ref.updateChildValues(["After Treatment Photo": photoURL,
                                               "After Treatment Photo Name": imageName
                                               ])
                    }
                })
            }
        }
        tableView.tableView.reloadData()
        picker.dismiss(animated: true)
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    func setupView() {
        addSubview(photoBefore)
        addSubview(photoAfter)
        addSubview(lable)
        addSubview(lable2)
        addSubview(fireBasekey)
        addSubview(beforeFireBaseReference)
        addSubview(afterFireBaseReference)
        addSubview(beforePhotoFireBaseDownloadURL)
        addSubview(afterPhotoFireBaseDownloadURL)
        
    
        
        photoBefore.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 20, bottomConstant: 0, rightConstant: frame.width/2 + 4, widthConstant: 0 , heightConstant: 0)
        
        lable.anchor(photoBefore.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 8, leftConstant: 40, bottomConstant: 8, rightConstant: 8, widthConstant: self.frame.width/2 , heightConstant: 32)
        photoAfter.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: frame.width/2 + 4, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        
        lable2.anchor(photoAfter.bottomAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 8, rightConstant: 8, widthConstant: self.frame.width/2 , heightConstant: 32)
        fireBasekey.anchor(nil, left: nil, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        beforeFireBaseReference.anchor(nil, left: photoBefore.leftAnchor, bottom: photoBefore.bottomAnchor, right: nil, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        afterFireBaseReference.anchor(nil, left: photoAfter.leftAnchor, bottom: photoAfter.bottomAnchor, right: nil, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        beforePhotoFireBaseDownloadURL.anchor(photoAfter.bottomAnchor, left: photoBefore.leftAnchor, bottom: nil, right: nil, topConstant: 8, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        afterPhotoFireBaseDownloadURL.anchor(photoAfter.bottomAnchor, left: nil, bottom: nil, right: photoAfter.rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 8, widthConstant: 0, heightConstant: 0)
    }
}




class PhotoViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var photoString = [String]()
    var key: String!
    var autoIDKey = [String]()
    var beforeTreatmentImageName = [String]()
    var afterTreatmentImageName = [String]()
    var beforeTreatmentDownloadURL = [String]()
    var afterTreatmentDownloadURL = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.backgroundColor = UIColor(r: 251, g: 222, b: 75)
        tableView.register(tableViewCell.self, forCellReuseIdentifier: "MyCustomCell")
        navigationController?.title = "Photo"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addRow))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(goBack))
        firebaseSwiftJSON()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        title = appDelegate.transferingData
        
       
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autoIDKey.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCustomCell") as! tableViewCell
        cell.photoController = self
        cell.lable.text = "Before Treatment"
        cell.lable2.text = "After Treatment"
        if autoIDKey.count != 0 {
         cell.fireBasekey.text = autoIDKey[indexPath.item]
        }
        let beforeTreatmentImageName = self.beforeTreatmentImageName[indexPath.item]
        let afterTreatmentImageName = self.afterTreatmentImageName[indexPath.item]
        let downloadURLforeBeforeTreatentImage = self.beforeTreatmentDownloadURL[indexPath.item]
        let downloadURLforeAfterTreatmentImage = self.afterTreatmentDownloadURL[indexPath.item]
        cell.beforeFireBaseReference.text = beforeTreatmentImageName
        cell.afterFireBaseReference.text = afterTreatmentImageName
        cell.afterPhotoFireBaseDownloadURL.text = afterTreatmentDownloadURL [indexPath.item]
        cell.beforePhotoFireBaseDownloadURL.text = afterTreatmentDownloadURL [indexPath.item]
        if beforeTreatmentImageName != "Photo Has Not Taken" {
            if isFileNameExist(fileName: beforeTreatmentImageName) {
                let pathBefore = getDocumentsDirectory().appendingPathComponent(beforeTreatmentImageName)
                cell.photoBefore.image = UIImage(contentsOfFile: pathBefore.path)
            } else {
              fetchAndDownloadImage(downloadURl: downloadURLforeBeforeTreatentImage, imageName: beforeTreatmentImageName, image: cell.photoBefore)
            }
        } else {
            cell.photoBefore.image = nil
        }
        if afterTreatmentImageName != "Photo Has Not Taken"{
            if isFileNameExist(fileName: afterTreatmentImageName) {
                let pathAfter = getDocumentsDirectory().appendingPathComponent(afterTreatmentImageName)
                cell.photoAfter.image = UIImage(contentsOfFile: pathAfter.path)
            } else {
                fetchAndDownloadImage(downloadURl: downloadURLforeAfterTreatmentImage, imageName: afterTreatmentImageName, image: cell.photoAfter)
            }
        } else {
            cell.photoAfter.image = nil
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (view.frame.width/2 - 28) + 40
        
    }
    
    func addRow() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let ref = FIRDatabase.database().reference().child("Photo Reference").child(appDelegate.photoReference!)
        let timeStamp = Int(NSDate().timeIntervalSince1970) as NSNumber
        key = ref.childByAutoId().key
        ref.child(key).updateChildValues([
                                          "After Treatment Photo": "Photo Has Not Taken",
                                          "After Treatment Photo Name": "Photo Has Not Taken",
                                          "Before Treatment Photo": "Photo Has Not Taken",
                                          "Before Treatment Photo Name": "Photo Has Not Taken",
                                          "Time Stamp": timeStamp
                                          ])
        tableView.reloadData()
    }
    func goBack() {
        dismiss(animated: true, completion: nil)
    }

    func firebaseSwiftJSON(){
        deinnitialiseAllValue()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let key = appDelegate.photoReference
        guard key != nil else { return }
        let ref = FIRDatabase.database().reference().child("Photo Reference").child(key!)
        ref.queryOrdered(byChild: "Time Stamp").observe(.childAdded, with: { (snapshoot: FIRDataSnapshot!) in
            self.autoIDKey.append(snapshoot.key)
            self.beforeTreatmentImageName.appendFireBase(snapshoot: snapshoot, key: "Before Treatment Photo Name")
            self.beforeTreatmentDownloadURL.appendFireBase(snapshoot: snapshoot, key: "Before Treatment Photo")
            self.afterTreatmentDownloadURL.appendFireBase(snapshoot: snapshoot, key: "After Treatment Photo")
            self.afterTreatmentImageName.appendFireBase(snapshoot: snapshoot, key: "After Treatment Photo Name")
            self.tableView.reloadData()
            return
        })
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    func isFileNameExist(fileName: String) -> Bool {
        let path = getDocumentsDirectory().appendingPathComponent(fileName)
        let pathString = path.path
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: pathString) {
            return true
        } else {
            return false
        }
    }
    func fetchAndDownloadImage(downloadURl: String, imageName: String, image: UIImageView){
        let url = URL(string: downloadURl)
        guard url != nil else { return }
        let task =  URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil { print("error")}
            DispatchQueue.main.async {
                image.image = UIImage(data: data!)
                let imagePath = self.getDocumentsDirectory().appendingPathComponent(imageName)
                if let jpegData = UIImageJPEGRepresentation(image.image!, 80) {
                    try? jpegData.write(to: imagePath)
                }
            }
        }
        task.resume()
    }
    var startingFrame: CGRect?
    var blackBackgroundView: UIView?
    var startingImageView: UIImageView?
    func performZoomInforStartingImageView(startingImageView: UIImageView) {
        self.startingImageView = startingImageView
        self.startingImageView?.isHidden = true
        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.layer.cornerRadius = 15
        zoomingImageView.layer.masksToBounds = true
        if startingImageView.image != nil {
            zoomingImageView.image = startingImageView.image
            }
        zoomingImageView.isUserInteractionEnabled = true
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
        if let keyWindow = UIApplication.shared.keyWindow {
            blackBackgroundView = UIView(frame: keyWindow.frame)
            blackBackgroundView?.backgroundColor = .black
            blackBackgroundView?.alpha = 0
            keyWindow.addSubview(blackBackgroundView!)
            keyWindow.addSubview(zoomingImageView)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .
            curveEaseOut, animations: {
                self.blackBackgroundView?.alpha = 1
                let height = (self.startingFrame?.height)! / (self.startingFrame?.width)! * keyWindow.frame.width
                zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                zoomingImageView.center = keyWindow.center
            }, completion: { (completed: Bool) in
        })
        }
    }
    func handleZoomOut(tapGesture: UITapGestureRecognizer) {
        if let zoomOutImageView = tapGesture.view {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                zoomOutImageView.frame = self.startingFrame!
                self.blackBackgroundView?.alpha = 0
            }, completion: { (completed: Bool) in
                zoomOutImageView.removeFromSuperview()
                self.startingImageView?.isHidden = false
            })
        }
    }
    func deinnitialiseAllValue(){
        self.autoIDKey.removeAll()
        self.beforeTreatmentImageName.removeAll()
        self.beforeTreatmentDownloadURL.removeAll()
        self.afterTreatmentImageName.removeAll()
        self.afterTreatmentDownloadURL.removeAll()
    }
}
