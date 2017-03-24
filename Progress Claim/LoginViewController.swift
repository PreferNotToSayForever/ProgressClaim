//
//  LoginViewController.swift
//  
//
//  Created by Quang Le Nguyen on 16/3/17.
//
//

import UIKit
import Firebase
import FBSDKLoginKit



class LoginViewController: UIViewController, UITextFieldDelegate,FBSDKLoginButtonDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    var emailToResetPassword: String! = nil
    var introImage = ["IntroductionPage1","IntroductionPage2","IntroductionPage3", "IntroductionPage 4","Background2"]
    var swipeDirection: String! = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        
        //view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        setupInputsContainerView()
        setupLoginRegisterButton()
        setupProfileImageView()
        setupFaceBookLoginButton()
        setupLoginRegisterSegmentedControl()
        setupActivityIndicator()
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        setupForgetYourPassWord()
        scrollView.isPagingEnabled = true
        setupScrollViewGestureRegconiser()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        setupPageControl()
        setupSkipButton()
    }
    lazy var pageController: UIPageControl = {
        let pc = UIPageControl()
        pc.translatesAutoresizingMaskIntoConstraints = false
        pc.numberOfPages = self.introImage.count
        pc.pageIndicatorTintColor = .gray
        pc.currentPageIndicatorTintColor = .orange
        return pc
    }()
    
    func setupPageControl() {
        view.addSubview(pageController)
        
        pageController.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 8).isActive = true
        pageController.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        pageController.widthAnchor.constraint(equalToConstant: pageController.intrinsicContentSize.width).isActive = true
        pageController.heightAnchor.constraint(equalToConstant: pageController.intrinsicContentSize.height).isActive = true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["field" : "id, name, email"]).start { (connection, result, errs) in
            if errs != nil {
                return
            }
          
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.nameTextField.resignFirstResponder()
        self.emailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        return true
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if pageController.currentPage == introImage.count {
            return.lightContent
        } else {
            return .default
        }
    }
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    let nameTextField: customTextField = {
        let name = customTextField()
        name.placeholder = ""
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    let separaterView: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        separator.alpha = 0
        separator.translatesAutoresizingMaskIntoConstraints = false
        return separator
    }()
    
    let emailTextField: customTextField = {
        let email = customTextField()
        email.placeholder = "Email"
        email.alpha = 0
        email.translatesAutoresizingMaskIntoConstraints = false
        return email
    }()
    
    let separaterEmailView: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.alpha = 0
        return separator
    }()
    
    let passwordTextField: customTextField = {
        let password = customTextField()
        password.placeholder = "Password"
        password.contentVerticalAlignment = .center
        password.isSecureTextEntry = true
        password.alpha = 0
        password.translatesAutoresizingMaskIntoConstraints = false
        return password
    }()
    
    let profileImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "N37")
        image.layer.cornerRadius = 5
        image.layer.masksToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    func setupInputsContainerView(){
        view.addSubview(inputsContainerView)
        view.addSubview(nameTextField)
        view.addSubview(separaterView)
        view.addSubview(emailTextField)
        view.addSubview(separaterEmailView)
        view.addSubview(passwordTextField)
        
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYInputContainerConstraint = inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        centerYInputContainerConstraint?.isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1, constant: -24).isActive = true
        
        inputContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 0)
        inputContainerViewHeightAnchor?.isActive = true
        
        
        
        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 0)
        nameTextFieldHeightAnchor?.isActive = true
        
        
        separaterView.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        separaterView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        separaterView.widthAnchor.constraint(equalTo: nameTextField.widthAnchor).isActive = true
        separaterView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: separaterView.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: nameTextField.widthAnchor).isActive = true
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2)
        emailTextFieldHeightAnchor?.isActive = true
        
        separaterEmailView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        separaterEmailView.centerXAnchor.constraint(equalTo: separaterView.centerXAnchor).isActive = true
        separaterEmailView.widthAnchor.constraint(equalTo: separaterView.widthAnchor).isActive = true
        separaterEmailView.heightAnchor.constraint(equalTo: separaterView.heightAnchor).isActive = true
        
        passwordTextField.bottomAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 0).isActive = true
        passwordTextField.centerXAnchor.constraint(equalTo: emailTextField.centerXAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: emailTextField.widthAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor, multiplier: 1).isActive = true
    }
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = UIColor.white
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        return button
    }()
    func handleLoginRegister() {
        if loginSegnmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    func handleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            activityIndicator.isHidden = true
            
            return }
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if let error = error { print(error)
                self.self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                self.emailTextField.shake()
                self.passwordTextField.shake()
                
            } else {
                
                self.userJustVerified(user: user!)
            }
        })
    }
    
    func handleRegister() {
        guard let email = emailTextField.text, let password = passwordTextField.text, let _ = nameTextField.text else { return }
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error: Error?) in
            if error != nil {
             
                self.emailTextField.shake()
                self.passwordTextField.shake()
                self.nameTextField.shake()
                return
            }
            guard let user = FIRAuth.auth()?.currentUser else { return }
            user.sendEmailVerification(completion: { (error) in
                if let error = error {
                    print(error)
                } else {
                    self.activityIndicator.isHidden = false
                    self.activityIndicator.startAnimating()
                    DispatchQueue.global(qos: .userInteractive).async { [unowned self] in
                        let vc = UIAlertController(title: "Confirm Verification Email", message: "A verification email has been sent to your email address, please verify your account to proceed", preferredStyle: .alert)
                        vc.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        self.loginSegnmentedControl.selectedSegmentIndex = 0
                        DispatchQueue.main.async {
                            self.present(vc, animated: true, completion: {
                                self.switchingInputContainerView()
                                self.handleLoginRegisteredChange()
                                self.activityIndicator.isHidden = true
                                self.activityIndicator.stopAnimating()
                            })
                        }
                    }
                }
            })
        })
    }
    
    var inputContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var buttonLoginAnimationAnchor: NSLayoutConstraint?
    var buttonFaceBookAnimationAnchor: NSLayoutConstraint?
    var loginRegisterWidthAnimator: NSLayoutConstraint?
    var faceBookButtonTopAnchor: NSLayoutConstraint?
    var loginSegmentedBottomAnchor: NSLayoutConstraint?
    
    
    func setupLoginRegisterButton() {
        view.addSubview(loginRegisterButton)
        buttonLoginAnimationAnchor = loginRegisterButton.leftAnchor.constraint(equalTo: view.rightAnchor)
        buttonLoginAnimationAnchor?.isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    func setupProfileImageView() {
        view.addSubview(profileImageView)
        let imagelayoutguide = UILayoutGuide()
        view.addLayoutGuide(imagelayoutguide)
        
        imagelayoutguide.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imagelayoutguide.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imagelayoutguide.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        imagelayoutguide.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.33).isActive = true
        
        profileImageView.centerYAnchor.constraint(equalTo: imagelayoutguide.centerYAnchor).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: imagelayoutguide.centerXAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalTo: imagelayoutguide.heightAnchor, multiplier: 0.6).isActive = true
        profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor, multiplier: 1).isActive = true
        profileImageView.alpha = 0
    }
    lazy var loginSegnmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Login","Register"])
        control.tintColor = UIColor.white
        control.translatesAutoresizingMaskIntoConstraints = false
        control.selectedSegmentIndex = 0
        control.alpha = 0
        control.addTarget(self, action: #selector(handleLoginRegisteredChange), for: .valueChanged)
        return control
    }()
    
    func handleLoginRegisteredChange() {
        if let title = loginSegnmentedControl.titleForSegment(at: loginSegnmentedControl.selectedSegmentIndex) {
            loginRegisterButton.setTitle(title, for: .normal)
            let facebookButtonTitle = "\(title) with FaceBook"
            FaceBookLoginButton.setTitle(facebookButtonTitle, for: .normal)
        }
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
            self.switchingInputContainerView()
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    func setupLoginRegisterSegmentedControl() {
        view.addSubview(loginSegnmentedControl)
        let imageguidline = UILayoutGuide()
        view.addLayoutGuide(imageguidline)
        
        imageguidline.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageguidline.topAnchor.constraint(equalTo: profileImageView.bottomAnchor).isActive = true
        imageguidline.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        imageguidline.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        
        
        loginSegnmentedControl.centerXAnchor.constraint(equalTo: imageguidline.centerXAnchor).isActive = true
        loginSegmentedBottomAnchor = loginSegnmentedControl.centerYAnchor.constraint(equalTo: imageguidline.centerYAnchor)
        loginSegmentedBottomAnchor?.isActive = true
        loginRegisterWidthAnimator = loginSegnmentedControl.widthAnchor.constraint(equalTo: imageguidline.widthAnchor)
        loginRegisterWidthAnimator?.isActive = false
        loginSegnmentedControl.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    lazy var FaceBookLoginButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        
        button.backgroundColor = UIColor.white
        button.setTitle("Login With FaceBook", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleFacebookLogin), for: UIControlEvents.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func handleFacebookLogin(){
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, error) in
            if error != nil {

                return
            }
            
            if result?.isCancelled == true { return }
            guard let accessToken = result?.token.tokenString else { return }
            
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken)
            
            FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
                if error != nil {
                    print("sign in error", error ?? "error")
                }
                FIRDatabase.database().reference().child("users").queryEqual(toValue: nil, childKey: user?.uid).observe(.value, with: { (snapshot) in
                    if snapshot.exists(){
                        self.dismiss(animated: true, completion: {
                            self.activityIndicator.isHidden = true
                            self.activityIndicator.stopAnimating()
                        })
                        return
                    } else {
                        guard user?.displayName != nil, user?.email != nil else { return }
                        let group = DispatchGroup()
                        let queue = DispatchQueue(label: "Create User Data")
                        let queue2 = DispatchQueue(label: "Create Filter")
                        queue.async(group: group) {
                            FIRDatabase.database().reference().child("users").child((user?.uid)!).updateChildValues(["Name" : user?.displayName! ?? "user displayName is not available", "email": user?.email ?? "email is not available", "userID": user?.uid ?? "userUID is not available"])
                        }
                        
                        queue2.async(group: group) {
                            FIRDatabase.database().reference().child("FilterSearch").child((user?.uid)!).childByAutoId().setValue(user?.email)
                        }
                        
                        group.notify(queue: DispatchQueue.main, execute: {
                            self.dismiss(animated: true, completion: nil)
                        })
                    }
                }, withCancel: nil)
            })
        }
    }
    func setupFaceBookLoginButton() {
        view.addSubview(FaceBookLoginButton)
        buttonFaceBookAnimationAnchor = FaceBookLoginButton.rightAnchor.constraint(equalTo: view.leftAnchor)
        buttonFaceBookAnimationAnchor?.isActive = true
        faceBookButtonTopAnchor = FaceBookLoginButton.topAnchor.constraint(equalTo: loginRegisterButton.bottomAnchor, constant: 16)
        faceBookButtonTopAnchor?.isActive = true
        FaceBookLoginButton.widthAnchor.constraint(equalTo: loginRegisterButton.widthAnchor).isActive = true
        FaceBookLoginButton.heightAnchor.constraint(equalTo: loginRegisterButton.heightAnchor).isActive = true
    }
    func switchingInputContainerView() {
        inputContainerViewHeightAnchor?.constant = loginSegnmentedControl.selectedSegmentIndex == 1 ? 150 : 100
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginSegnmentedControl.selectedSegmentIndex == 1 ? 1/3 : 0)
        nameTextFieldHeightAnchor?.isActive = true
        nameTextField.placeholder = loginSegnmentedControl.selectedSegmentIndex == 1 ? "Name" : ""
        let currentText = nameTextField.text
        nameTextField.text = loginSegnmentedControl.selectedSegmentIndex == 1 ? currentText : ""
        
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginSegnmentedControl.selectedSegmentIndex == 1 ? 1/3 : 1/2)
        emailTextFieldHeightAnchor?.isActive = true
    }
    
    func userJustVerified(user: FIRUser) {
        guard (user.isEmailVerified) == true else {
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            return }
        let ref = FIRDatabase.database().reference(fromURL: "https://progressclaim-6c2b1.firebaseio.com/")
        let userReference = ref.child("users").child(user.uid)
        userReference.queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            switch true {
            case snapshot.exists():
                self.dismiss(animated: true, completion: nil)
            case !snapshot.exists():
                print("snapshot not exist")
                let queue = DispatchQueue(label: "Create Filter Search List")
                let queue2 = DispatchQueue(label: "Create User Data")
                let group = DispatchGroup()
                queue.async(group: group) {
                    ref.child("FilterSearch").child(user.uid).setValue(user.email!)
                }
                queue2.async(group: group) {
                    let value = ["email" : user.email, "userID" : user.uid]
                    userReference.updateChildValues(value)
                }
                group.notify(queue: DispatchQueue.main) {
                    self.dismiss(animated: true, completion: {
                        self.activityIndicator.isHidden = true
                        self.activityIndicator.stopAnimating()
                    })
                }
            default: break
            }
        })
    }
    func animatingButton(){
        UIView.animate(withDuration: 0.1, delay: -0.2, options: .curveEaseOut, animations: { [unowned self] in
            self.buttonFaceBookAnimationAnchor?.isActive = false
            self.buttonLoginAnimationAnchor?.isActive = false
            self.loginRegisterWidthAnimator?.isActive = false
            self.inputContainerViewHeightAnchor?.isActive = false
            self.loginRegisterButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            self.FaceBookLoginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            self.loginSegnmentedControl.widthAnchor.constraint(equalTo: self.inputsContainerView.widthAnchor).isActive = true
            self.loginSegnmentedControl.alpha = 1
            self.inputContainerViewHeightAnchor?.constant = 100
            self.inputContainerViewHeightAnchor?.isActive = true
            self.profileImageView.alpha = 1
            self.emailTextField.alpha = 1
            self.passwordTextField.alpha = 1
            self.separaterEmailView.alpha = 1
            self.separaterView.alpha = 1
            self.forgetYourPasswordLabel.alpha = 1
            self.view.alpha = 1
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.isHidden = true
        indicator.color = UIColor.orange
        indicator.activityIndicatorViewStyle = .gray
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    func setupActivityIndicator(){
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: inputsContainerView.centerYAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: activityIndicator.intrinsicContentSize.width * 2).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: activityIndicator.intrinsicContentSize.height * 2).isActive = true
    }
    lazy var forgetYourPasswordLabel: UILabel = {
        let text = UILabel()
        text.isUserInteractionEnabled = true
        text.alpha = 0
        text.textColor = .white
        text.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.resetPassword)))
        text.text = "Forgot Your Password?"
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    func resetPassword(sender: UITapGestureRecognizer){
        setupBlurEffect()
        setupPasswordResetContainer()
    }
    func setupForgetYourPassWord() {
        view.addSubview(forgetYourPasswordLabel)
        forgetYourPasswordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        forgetYourPasswordLabel.topAnchor.constraint(equalTo: FaceBookLoginButton.bottomAnchor, constant: 24).isActive = true
        forgetYourPasswordLabel.widthAnchor.constraint(equalToConstant: forgetYourPasswordLabel.intrinsicContentSize.width).isActive = true
        forgetYourPasswordLabel.heightAnchor.constraint(equalToConstant: forgetYourPasswordLabel.intrinsicContentSize.height).isActive = true
    }
    lazy var ResetPasswordview: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.white
        var viewTitle: UILabel = {
            let title = UILabel()
            title.lineBreakMode = NSLineBreakMode.byWordWrapping
            title.sizeToFit()
            title.textColor = UIColor(r: 61, g: 91, b: 151)
            title.numberOfLines = 0
            title.text = "Please Enter Your Email Below"
            title.translatesAutoresizingMaskIntoConstraints = false
            return title
        }()
        view.addSubview(viewTitle)
        viewTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        viewTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        viewTitle.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -16).isActive = true
        viewTitle.heightAnchor.constraint(equalToConstant: viewTitle.intrinsicContentSize.height).isActive = true
        var passwordResetButton: UIButton = {
            let button = UIButton(type: UIButtonType.system)
            button.setTitle("Reset Password", for: .normal)
            button.setTitleColor(UIColor(r: 61, g: 91, b: 151), for: UIControlState.normal)
            button.backgroundColor = UIColor.white
            button.layer.cornerRadius = 5
            button.layer.masksToBounds = true
            button.backgroundColor = UIColor.white
            button.layer.borderWidth = 1
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        passwordResetButton.addTarget(self, action: #selector(LoginViewController.resetPasswordButton), for: .touchUpInside)
        view.addSubview(passwordResetButton)
        passwordResetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordResetButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
        passwordResetButton.widthAnchor.constraint(equalToConstant: passwordResetButton.intrinsicContentSize.width + 16).isActive = true
        view.addSubview(self.passwordTextFields)
        self.passwordTextFields.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -8).isActive = true
        self.passwordTextFields.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.passwordTextFields.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -16).isActive = true
        self.passwordTextFields.heightAnchor.constraint(equalToConstant: 32).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var passwordTextFields : UITextField = {
        let text = UITextField()
        text.borderStyle = .line
        text.placeholder = "Email"
        text.delegate = self
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    func resetPasswordButton(){
        emailToResetPassword = passwordTextFields.text
        if emailToResetPassword == "" {
            ResetPasswordview.removeFromSuperview()
            blurEffect.removeFromSuperview()
        } else if let email = self.emailToResetPassword {
            FIRAuth.auth()?.sendPasswordReset(withEmail: email, completion: { (error) in
                if error != nil {
                    let vc = UIAlertController(title: "Unable to Reset Password", message: "Please Recheck Your Email", preferredStyle: .alert)
                    let done = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    vc.addAction(done)
                    self.present(vc, animated: true, completion: {
                        self.view.addSubview(self.ResetPasswordview)
                    })
                } else {
                    let vc = UIAlertController(title: "Password Reset Email Sent", message: "Please Check Your Email to Reset Your Password", preferredStyle: .alert)
                    let done = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    vc.addAction(done)
                    self.present(vc, animated: true, completion: {
                        self.ResetPasswordview.removeFromSuperview()
                        self.blurEffect.removeFromSuperview()
                    })
                }
            })
        }
    }
    lazy var blurEffect : UIVisualEffectView = {
        let visualEffect = UIBlurEffect(style: .light)
        let image = UIVisualEffectView(effect: visualEffect)
        image.frame.size = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height)
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    func setupBlurEffect(){
        view.addSubview(blurEffect)
        blurEffect.center = view.center
    }
    func setupPasswordResetContainer() {
        view.addSubview(ResetPasswordview)
        self.ResetPasswordview.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.ResetPasswordview.topAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.ResetPasswordview.widthAnchor.constraint(equalTo: self.inputsContainerView.widthAnchor).isActive = true
        self.ResetPasswordview.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1/4).isActive = true
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn, animations: {
            self.ResetPasswordview.topAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = false
            self.ResetPasswordview.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        }, completion: nil)
        
    }
    lazy var scrollView: UIScrollView = {
        var imageNames: [String] = self.introImage
        let scroll = UIScrollView()
        var totalWidth: CGFloat = 0
        for imageName in imageNames {
            let image = UIImage(named: imageName)
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(origin: CGPoint(x: totalWidth, y: 0),size: self.view.bounds.size)
            imageView.contentMode = .scaleAspectFit
            scroll.addSubview(imageView)
            totalWidth += imageView.bounds.size.width
        }
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.contentSize = CGSize(width: totalWidth, height: scroll.bounds.size.height)
        scroll.delegate = self
        return scroll
    }()
    func setupScrollViewGestureRegconiser(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.resignTextField))
        tap.numberOfTapsRequired = 1
        scrollView.addGestureRecognizer(tap)
    }
    func resignTextField(sender: UITapGestureRecognizer) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        nameTextField.resignFirstResponder()
    }
    func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        constraint = scrollView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        constraint?.isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: 0).isActive = true
    }
    var constraint: NSLayoutConstraint?
    var centerYInputContainerConstraint: NSLayoutConstraint?
    func keyboardNotification(notification: NSNotification) {
        constraint?.isActive = false
        centerYInputContainerConstraint?.isActive = false
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            UIView.animate(withDuration: duration,delay: TimeInterval(0),options: animationCurve, animations: {
                if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                    self.constraint?.isActive = false
                    self.constraint?.constant = 0
                    self.constraint?.isActive = true
                    self.centerYInputContainerConstraint?.isActive  = false
                    self.centerYInputContainerConstraint = self.inputsContainerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0)
                    self.centerYInputContainerConstraint?.isActive = true
                    self.loginSegnmentedControl.alpha = 1
                    self.profileImageView.alpha = 1
                    
                } else {
                    self.constraint = self.scrollView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0 - (endFrame?.size.height)! )
                    self.constraint?.isActive = true
                    self.loginSegnmentedControl.alpha = 0
                }
                self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        nameTextField.resignFirstResponder()
        if scrollView.contentOffset.x == scrollView.frame.size.width * CGFloat(introImage.count - 1) {
            hideEverything(bool: true)
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == scrollView.frame.size.width * CGFloat(introImage.count - 1) {
            hideEverything(bool: false)
            if loginSegnmentedControl.frame.size.width < view.frame.size.width/2 {
                animatingButton()
            }
        }
    }
    func hideEverything(bool: Bool) {
        let alpha = bool ? CGFloat(0) : CGFloat(1)
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            self.profileImageView.alpha = alpha
            self.loginRegisterButton.alpha = alpha
            self.inputsContainerView.alpha = alpha
            self.FaceBookLoginButton.alpha = alpha
            self.forgetYourPasswordLabel.alpha = alpha
            self.loginSegnmentedControl.alpha = alpha
            self.separaterView.alpha = alpha
            self.separaterEmailView.alpha = alpha
        }, completion: nil)
        self.profileImageView.isHidden = bool
        self.loginRegisterButton.isHidden = bool
        self.inputsContainerView.isHidden = bool
        self.FaceBookLoginButton.isHidden = bool
        self.forgetYourPasswordLabel.isHidden = bool
        self.loginSegnmentedControl.isHidden = bool
        self.separaterView.isHidden = bool
        self.separaterEmailView.isHidden = bool
        self.emailTextField.isHidden = bool
        self.nameTextField.isHidden = bool
        self.passwordTextField.isHidden = bool
        self.emailTextField.isEnabled = !bool
        self.nameTextField.isEnabled = !bool
        self.passwordTextField.isEnabled = !bool
        self.skipbutton.isHidden = !bool
        self.skipbutton.isEnabled = bool
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x/scrollView.frame.size.width)
        pageController.currentPage = Int(pageNumber)
    }
    
    lazy var skipbutton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("Skip", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(skipIntro), for: UIControlEvents.touchUpInside)
        return button
    }()
    func skipIntro(){
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                self.scrollView.contentOffset.x = CGFloat(self.introImage.count - 1) * self.scrollView.frame.size.width
                self.pageController.currentPage = self.introImage.count
            }, completion: nil)
        }
    }
    func setupSkipButton() {
        view.addSubview(skipbutton)
        view.addSubview(whiteheader)
        skipbutton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        skipbutton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        skipbutton.widthAnchor.constraint(equalToConstant: skipbutton.intrinsicContentSize.width + CGFloat(8)).isActive = true
        skipbutton.heightAnchor.constraint(equalToConstant: skipbutton.intrinsicContentSize.height).isActive = true
        whiteheader.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        whiteheader.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        whiteheader.widthAnchor.constraint(equalToConstant: view.frame.size.width).isActive = true
        whiteheader.heightAnchor.constraint(equalToConstant: 16).isActive = true
    }
    var whiteheader: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
}

