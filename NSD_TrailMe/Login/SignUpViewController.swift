//
//  SignUpViewController.swift
//  NSD_TrailMe
//
//  Created by Nathaniel Coleman on 11/20/18.
//  Copyright © 2018 Nathaniel Coleman. All rights reserved.
//

import UIKit
import MaterialComponents
import Firebase

class SignUpViewController: UIViewController {
    
    // MARK:- Properties
    var blurEffectView: UIVisualEffectView?
    var isPublic = false
    var validFirstName = false
    var validLastName = false
    var validUserName = false
    var validPassword = false
    var validEmail = false
    
    // Text Fields Controllers
    let emailTextFieldController: MDCTextInputControllerOutlined
    let passwordTextFieldController: MDCTextInputControllerOutlined
    let firstnameTextFieldController: MDCTextInputControllerOutlined
    let lastnameTextFieldController: MDCTextInputControllerOutlined
    let usernameTextFieldController: MDCTextInputControllerOutlined
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.layoutMargins = UIEdgeInsets.init(top: 0, left: 16, bottom: 0, right: 16)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let heroImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 37)
        label.textColor = .white
        label.text = "Ready to Move?"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let ctaLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .white
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "Sign up for an account so you can get moving today!"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up with Email", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor(red: 0/255, green: 71/255, blue: 255/255, alpha: 0.5)
        button.setTitleColor(UIColor.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    
    let haveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedText = NSMutableAttributedString(string: "Already have an account? ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: "Log In",
                                                 attributes: [ NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 14)]))
        
        button.setAttributedTitle(attributedText, for: .normal)
        button.addTarget(self, action: #selector(handleHaveAccount), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let firstNameTextField: MDCTextField = {
        let tf = MDCTextField()
        tf.autocapitalizationType = .words
        tf.clearButtonMode = .always
        tf.textColor = .white
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.addTarget(self, action: #selector(textEditingChangedFirstname(_:)), for: .editingChanged)
        return tf
    }()
    
    let lastNameTextField: MDCTextField = {
        let tf = MDCTextField()
        tf.autocapitalizationType = .words
        tf.clearButtonMode = .always
        tf.textColor = .white
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.addTarget(self, action: #selector(textEditingChangedLastname(_:)), for: .editingChanged)
        return tf
    }()
    
    let usernameTextField: MDCTextField = {
        let tf = MDCTextField()
        tf.autocapitalizationType = .none
        tf.clearButtonMode = .always
        tf.textColor = .white
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.addTarget(self, action: #selector(textEditingChangedUsername(_:)), for: .editingChanged)
        return tf
    }()
    
    let emailTextField: MDCTextField = {
        let tf = MDCTextField()
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        tf.textColor = .white
        tf.clearButtonMode = .always
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.addTarget(self, action: #selector(textEditingChangedEmail(_:)), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: MDCTextField = {
        let tf = MDCTextField()
        tf.isSecureTextEntry = true
        tf.textColor = .white
        tf.clearButtonMode = .always
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.addTarget(self, action: #selector(textEditingChangedPassword(_:)), for: .editingChanged)
        return tf
    }()
    
    let privacyLabel : UILabel = {
        let label = UILabel()
        label.text = "Make account public"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let privacyCheckBox: CheckBox = {
        let cb = CheckBox()
        cb.addTarget(self, action: #selector(handleCheckBox), for: .touchUpInside)
        return cb
    }()
    
    
    
    
    
    // Light statusbar on dark background
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
   
    
    // MARK: - Methods
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        // Setup text field controllers
        emailTextFieldController = MDCTextInputControllerOutlined(textInput: emailTextField)
        passwordTextFieldController = MDCTextInputControllerOutlined(textInput: passwordTextField)
        firstnameTextFieldController = MDCTextInputControllerOutlined(textInput: firstNameTextField)
        lastnameTextFieldController = MDCTextInputControllerOutlined(textInput: lastNameTextField)
        usernameTextFieldController = MDCTextInputControllerOutlined(textInput: usernameTextField)
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        heroImage.image = UIImage(named: "frame_bg")
        let blurEffect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView?.frame = view.bounds
        heroImage.addSubview(blurEffectView!)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        usernameTextField.delegate = self
        
        emailTextField.placeholder = "Email"
        passwordTextField.placeholder = "Password"
        firstNameTextField.placeholder = "Firstname"
        lastNameTextField.placeholder = "Lastname"
        usernameTextField.placeholder = "Username"
        
        scrollView.backgroundColor = .clear
        
        validPassword = false
        validEmail = false
        validUserName = false
        validEmail = false
        validFirstName = false
        validLastName = false
        setupUI()
    }
    
    fileprivate func setupUI() {
        var constraints = [NSLayoutConstraint]()
        view.addSubview(heroImage)
        view.addSubview(scrollView)
        
        
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[heroImage]|",
                                           options: [],
                                           metrics: nil,
                                           views: ["heroImage" : heroImage])
        )
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[heroImage]|",
                                           options: [],
                                           metrics: nil,
                                           views: ["heroImage" : heroImage])
        )
        view.addSubview(scrollView)
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[scrollView]|",
                                           options: [],
                                           metrics: nil,
                                           views: ["scrollView" : scrollView])
        )
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[scrollView]|",
                                           options: [],
                                           metrics: nil,
                                           views: ["scrollView" : scrollView])
        )
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapTouch(sender:)))
        scrollView.addGestureRecognizer(tapGestureRecognizer)
        scrollView.addSubview(headerLabel)
        scrollView.addSubview(ctaLabel)
        scrollView.addSubview(firstNameTextField)
        scrollView.addSubview(lastNameTextField)
        scrollView.addSubview(usernameTextField)
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(passwordTextField)
        scrollView.addSubview(haveAccountButton)
        scrollView.addSubview(signUpButton)
        scrollView.addSubview(privacyLabel)
        scrollView.addSubview(privacyCheckBox)
        
        constraints.append(NSLayoutConstraint(item: headerLabel,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: scrollView.contentLayoutGuide,
                                              attribute: .top,
                                              multiplier: 1,
                                              constant: 88))
        constraints.append(NSLayoutConstraint(item: headerLabel,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: scrollView,
                                              attribute: .centerX,
                                              multiplier: 1,
                                              constant: 0))
        constraints.append(NSLayoutConstraint(item: ctaLabel,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: headerLabel,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: 8))
        constraints.append(NSLayoutConstraint(item: ctaLabel,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: scrollView,
                                              attribute: .centerX,
                                              multiplier: 1,
                                              constant: 0))
        constraints.append(NSLayoutConstraint(item: firstNameTextField,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: ctaLabel,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: 16))
        constraints.append(NSLayoutConstraint(item: firstNameTextField,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: scrollView,
                                              attribute: .centerX,
                                              multiplier: 1,
                                              constant: 0))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|-[first]-|",
                                                                      options: [], metrics: nil, views: ["first": firstNameTextField]))
        constraints.append(NSLayoutConstraint(item: lastNameTextField,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: firstNameTextField,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: 4))
        constraints.append(NSLayoutConstraint(item: lastNameTextField,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: scrollView,
                                              attribute: .centerX,
                                              multiplier: 1,
                                              constant: 0))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|-[last]-|",
                                                                      options: [], metrics: nil, views: ["last": lastNameTextField]))
        constraints.append(NSLayoutConstraint(item: usernameTextField,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: lastNameTextField,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: 4))
        constraints.append(NSLayoutConstraint(item: usernameTextField,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: scrollView,
                                              attribute: .centerX,
                                              multiplier: 1,
                                              constant: 0))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|-[user]-|",
                                                                      options: [], metrics: nil, views: ["user": usernameTextField]))
        constraints.append(NSLayoutConstraint(item: emailTextField,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: usernameTextField,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: 4))
        constraints.append(NSLayoutConstraint(item: emailTextField,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: scrollView,
                                              attribute: .centerX,
                                              multiplier: 1,
                                              constant: 0))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|-[mail]-|",
                                                                      options: [], metrics: nil, views: ["mail": emailTextField]))
        constraints.append(NSLayoutConstraint(item: passwordTextField,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: emailTextField,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: 4))
        constraints.append(NSLayoutConstraint(item: passwordTextField,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: scrollView,
                                              attribute: .centerX,
                                              multiplier: 1,
                                              constant: 0))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|-[passwd]-|",
                                                                      options: [], metrics: nil, views: ["passwd": passwordTextField]))
        constraints.append(NSLayoutConstraint(item: signUpButton,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: passwordTextField,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: 8))
        constraints.append(NSLayoutConstraint(item: signUpButton,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: scrollView,
                                              attribute: .centerX,
                                              multiplier: 1,
                                              constant: 0))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|-[sign]-|",
                                                                      options: [], metrics: nil, views: ["sign": signUpButton]))
        signUpButton.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 58)
        
        privacyLabel.anchor(top: signUpButton.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 20)
        privacyCheckBox.anchor(top: privacyLabel.topAnchor, left: privacyLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 3, paddingBottom: 0, paddingRight: 0, width: 25, height: 25)
        
    
        constraints.append(NSLayoutConstraint(item: privacyLabel,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: scrollView,
                                              attribute: .centerX,
                                              multiplier: 1,
                                              constant: 0))
        
        constraints.append(NSLayoutConstraint(item: haveAccountButton,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: privacyLabel,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: 12))
        
        constraints.append(NSLayoutConstraint(item: haveAccountButton,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: scrollView,
                                              attribute: .centerX,
                                              multiplier: 1,
                                              constant: 0))
        NSLayoutConstraint.activate(constraints)
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        blurEffectView?.frame = view.bounds
    }
    
    @objc func didTapTouch(sender: UIGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func handleCheckBox() {
        if privacyCheckBox.isSelected{
            isPublic = true
            let alert = UIAlertController(title: nil, message: "Account will be public to other users, who can also follow you in the app", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            isPublic = false
            let alert = UIAlertController(title: nil, message: "Account will be private to other users, they cannot follow you in the app", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func textEditingChangedEmail(_ textField: MDCTextField){
        if !isEmailValid(email: textField.text!){
            emailTextFieldController.setErrorText("enter valid email", errorAccessibilityValue: nil)
            validEmail = false
        } else {
            emailTextFieldController.setErrorText(nil, errorAccessibilityValue: nil)
            validEmail = true
        }
    }
    
    @objc func textEditingChangedFirstname(_ textField: MDCTextField){
        if (textField.text!.count < 3){
            firstnameTextFieldController.setErrorText("enter valid name", errorAccessibilityValue: nil)
            validFirstName = false
        } else {
            firstnameTextFieldController.setErrorText(nil, errorAccessibilityValue: nil)
            validFirstName = true
        }
    }
    
    @objc func textEditingChangedLastname(_ textField: MDCTextField){
        if (textField.text!.count < 3){
            lastnameTextFieldController.setErrorText("enter valid name", errorAccessibilityValue: nil)
            validLastName = false
        } else {
            lastnameTextFieldController.setErrorText(nil, errorAccessibilityValue: nil)
            validLastName = true
        }
    }
    
    @objc func textEditingChangedUsername(_ textField: MDCTextField){
        if (textField.text!.count < 3){
            usernameTextFieldController.setErrorText("enter valid username", errorAccessibilityValue: nil)
            validUserName = false
        } else {
            usernameTextFieldController.setErrorText(nil, errorAccessibilityValue: nil)
            validUserName = true
        }
    }
    
    @objc func textEditingChangedPassword(_ textField: MDCTextField){
        if (textField.text!.count < 6){
            passwordTextFieldController.setErrorText("enter valid password", errorAccessibilityValue: nil)
            validPassword = false
        } else {
            passwordTextFieldController.setErrorText(nil, errorAccessibilityValue: nil)
            validPassword = true
        }
    }
    
    
    
    fileprivate func isEmailValid(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let test = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        
        return test.evaluate(with:email)
    }
    
    @objc func handleHaveAccount() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSignUp() {
        if (validPassword == true && validUserName == true && validLastName == true && validFirstName == true && validEmail == true){
            //print("All fields valid... signing up")
            guard let firstName = firstNameTextField.text else { return }
            guard let lastName = lastNameTextField.text else { return }
            guard let username = usernameTextField.text else { return }
            guard let email = emailTextField.text else { return }
            guard let password = passwordTextField.text else { return }
            
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                if let err = error {
                    let alert = UIAlertController(title: nil, message: err.localizedDescription, preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                guard let image = UIImage(named: "no_image") else { return }
                guard let uploadData = image.jpegData(compressionQuality: 0.3) else { return }
                guard let user = result?.user else { return }
                let uid = user.uid
                let filename = uid + "_profile_image"
                
                Storage.storage().reference().child("profile_images").child(filename).putData(uploadData, metadata: nil, completion: { (metadata, err) in
                    if let error = err {
                        print(error.localizedDescription)
                    }
                    Storage.storage().reference().child("profile_images").child(filename).downloadURL(completion: { (url, err) in
                        if let error = err {
                            print(error.localizedDescription)
                        } else {
                            guard let profileImageUrl = url?.absoluteString else { return }
                            //guard let fcmToken = Messaging.messaging().fcmToken else { return }
                            let dictionaryValues: [String:Any] = ["firstName": firstName, "lastName": lastName, "userName": username, "email": email, "isPublic": self.isPublic,"profileImageUrl":profileImageUrl]
                            let values = [uid:dictionaryValues]
                            Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (error, ref) in
                                if let err = error {
                                    print(err.localizedDescription)
                                }
//                                guard let tabBarController = UIApplication.shared.keyWindow?.rootViewController as? TabBarController else { return }
//                                tabBarController.setupViewControllers()
//                                self.dismiss(animated: true, completion: nil)
                            })
                        }
                    })
                })
            }
            
        } else {
            let alert = UIAlertController(title: "Form Error", message: "Form has errors, please correct to continue", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        
    }
}

// MARK: - UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate {
    
    // Add basic password field validation in the textFieldShouldReturn delegate function
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if (textField == passwordTextField && passwordTextField.text != nil && passwordTextField.text!.count < 6) {
            passwordTextFieldController.setErrorText("Password must be at least 6 characters", errorAccessibilityValue: nil)
            validPassword = false
        } else {
            passwordTextFieldController.setErrorText(nil, errorAccessibilityValue: nil)
            validPassword = true
        }
        
        if (textField == emailTextField && emailTextField.text != nil && !isEmailValid(email: emailTextField.text!)) {
            emailTextFieldController.setErrorText("Must enter a valid email", errorAccessibilityValue: nil)
            validEmail = false
        } else {
            emailTextFieldController.setErrorText(nil, errorAccessibilityValue: nil)
            validEmail = true
        }
        
        if (textField == firstNameTextField && firstNameTextField.text != nil && firstNameTextField.text!.count < 3){
            firstnameTextFieldController.setErrorText("Firstname must be at least 3 characters", errorAccessibilityValue: nil)
            validFirstName = false
        } else {
            firstnameTextFieldController.setErrorText(nil, errorAccessibilityValue: nil)
            validFirstName = true
        }
        
        if (textField == lastNameTextField && lastNameTextField.text != nil && lastNameTextField.text!.count < 3){
            lastnameTextFieldController.setErrorText("Lastname must be at least 3 characters", errorAccessibilityValue: nil)
            validLastName = false
        } else {
            lastnameTextFieldController.setErrorText(nil, errorAccessibilityValue: nil)
            validLastName = true
        }
        
        if (textField == usernameTextField && usernameTextField.text != nil && usernameTextField.text!.count < 3){
            usernameTextFieldController.setErrorText("Username must be at least 3 characters", errorAccessibilityValue: nil)
            validUserName = false
        } else {
            usernameTextFieldController.setErrorText(nil, errorAccessibilityValue: nil)
            validUserName = true
        }
        return false
    }
}

