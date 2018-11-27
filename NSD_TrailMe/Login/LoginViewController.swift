//
//  ViewController.swift
//  NSD_TrailMe
//
//  Created by Nathaniel Coleman on 11/19/18.
//  Copyright © 2018 Nathaniel Coleman. All rights reserved.
//

import UIKit
import MaterialComponents
import Firebase

class LoginViewController: UIViewController {
    
    // MARK:- Properties
    var blurEffectView: UIVisualEffectView?
    var validEmail = false
    var validPassword = false
    
    // Text Fields Controllers
    let emailTextFieldController: MDCTextInputControllerOutlined
    let passwordTextFieldController: MDCTextInputControllerOutlined
    
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
        label.text = "Welcome back!"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let ctaLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .white
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "Log in and let's get moving!"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign In", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor(red: 0/255, green: 71/255, blue: 255/255, alpha: 0.5)
        button.setTitleColor(UIColor.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
        return button
    }()
    
    let fogotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Forgot my password", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleForgotPassword), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let noAccountLabel: UIButton = {
        let button = UIButton(type: .system)
        let attributedText = NSMutableAttributedString(string: "Don't have an account? ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: "Sign Up",
                                                 attributes: [ NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 14)]))
        
        button.setAttributedTitle(attributedText, for: .normal)
        button.addTarget(self, action: #selector(handleDontHaveAccount), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
    
    
   
    
    
    // Light statusbar on dark background
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        // Setup text field controllers
        emailTextFieldController = MDCTextInputControllerOutlined(textInput: emailTextField)
        passwordTextFieldController = MDCTextInputControllerOutlined(textInput: passwordTextField)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        heroImage.image = UIImage(named: "frame_bg")
        let blurEffect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView?.frame = view.bounds
        heroImage.addSubview(blurEffectView!)
        
        emailTextField.delegate = self
        emailTextField.placeholder = "Email"
        passwordTextField.placeholder = "Password"
        passwordTextField.delegate = self
        scrollView.backgroundColor = .clear
        validEmail = false
        validPassword = false
        setupViews()
    }
    
    fileprivate func setupViews() {
        var constraints = [NSLayoutConstraint]()
        
        view.addSubview(heroImage)
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
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapTouch))
        scrollView.addGestureRecognizer(tapGestureRecognizer)
        
        
        scrollView.addSubview(headerLabel)
        scrollView.addSubview(ctaLabel)
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(passwordTextField)
        scrollView.addSubview(signInButton)
        scrollView.addSubview(noAccountLabel)
        scrollView.addSubview(fogotPasswordButton)
        
        constraints.append(NSLayoutConstraint(item: headerLabel,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: scrollView.contentLayoutGuide,
                                              attribute: .top,
                                              multiplier: 1,
                                              constant: 120))
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
        constraints.append(NSLayoutConstraint(item: emailTextField,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: ctaLabel,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: 22))
        constraints.append(NSLayoutConstraint(item: emailTextField,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: scrollView,
                                              attribute: .centerX,
                                              multiplier: 1,
                                              constant: 0))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|-[email]-|",
                                                                      options: [], metrics: nil, views: ["email": emailTextField]))
        constraints.append(NSLayoutConstraint(item: passwordTextField,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: emailTextField,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: 8))
        constraints.append(NSLayoutConstraint(item: passwordTextField,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: scrollView,
                                              attribute: .centerX,
                                              multiplier: 1,
                                              constant: 0))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|-[password]-|",
                                                                      options: [], metrics: nil, views: ["password": passwordTextField]))
        
        constraints.append(NSLayoutConstraint(item: signInButton,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: passwordTextField,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: 8))
        constraints.append(NSLayoutConstraint(item: signInButton,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: scrollView,
                                              attribute: .centerX,
                                              multiplier: 1,
                                              constant: 0))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|-[sign]-|",
                                                                      options: [], metrics: nil, views: ["sign": signInButton]))
         signInButton.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 58)
        
        
        constraints.append(NSLayoutConstraint(item: fogotPasswordButton,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: signInButton,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: 24))
        constraints.append(NSLayoutConstraint(item: fogotPasswordButton,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: scrollView,
                                              attribute: .centerX,
                                              multiplier: 1,
                                              constant: 0))
        constraints.append(NSLayoutConstraint(item: noAccountLabel,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: fogotPasswordButton,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: 12))
        constraints.append(NSLayoutConstraint(item: noAccountLabel,
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
    
    @objc func handleForgotPassword() {
        let resetPasswordController = ResetPasswordController()
        navigationController?.pushViewController(resetPasswordController, animated: true)
    }
    
    @objc func handleSignIn() {
        if (validEmail == true && validPassword == true){
            //print("All fields valid...signing in")
            guard let email = emailTextField.text else { return }
            guard let password = passwordTextField.text else { return }
            
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if let err = error {
                    let alert = UIAlertController(title: nil, message: err.localizedDescription, preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                guard let uid = result?.user.uid else { return }
                print("Successfully logged in user with \(uid)")
                // loads test data for test user
                if uid == "Y1MzcwjsbNPuH23a04AZeWXtxw62"{
                    if UserDefaults.standard.bool(forKey: "firstTimeRun") == false {
                        self.loadTestDataIntoCoreDataAndFirebase(testData)
                        print("Loaded test data")
                    } else {
                        print("Data already loaded")
                    }
                }
                
                guard let tabBarController = UIApplication.shared.keyWindow?.rootViewController as? TabBarController else { return }
                tabBarController.setupViewControllers()
                self.dismiss(animated: true, completion: nil)
            }
            
        } else {
            let alert = UIAlertController(title: "Form Error", message: "Form has errors, please correct to continue", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func handleDontHaveAccount() {
        let signUpController = SignUpViewController()
        navigationController?.pushViewController(signUpController, animated: true)
    }
    
    func loadTestDataIntoCoreDataAndFirebase(_ values: [[String: Any]]) {
        UserDefaults.standard.set(true, forKey: "firstTimeRun")
        values.forEach { (dictionary) in
            let newActivity = Activity(context: CoreDataStack.context)
            if let distance = dictionary["distance"] as? Double,
                let duration = dictionary["duration"] as? Int16,
                let category = dictionary["category"] as? String,
                let date = dictionary["date"] as? Date,
                let shared = dictionary["shared"] as? Bool{
                newActivity.distance = distance
                newActivity.duration = duration
                newActivity.category = category
                newActivity.timestamp = date
                newActivity.shared = shared
                newActivity.userid = "Y1MzcwjsbNPuH23a04AZeWXtxw62"
                
                
                CoreDataStack.saveContext()
                
                let frmtDate = FormatDisplay.date(date)
                let frmtDistance = FormatDisplay.distance(distance)
                let frmtTime = FormatDisplay.time(Int(duration))
                let inputDistance = Measurement(value: distance, unit: UnitLength.meters)
                let frmtPace = FormatDisplay.pace(distance: inputDistance, seconds: Int(duration), outputUnit: .minutesPerMile)
                
                let userPostReference = Database.database().reference().child("posts").child("Y1MzcwjsbNPuH23a04AZeWXtxw62")
                let reference = userPostReference.childByAutoId()
                let values = ["imageUrl" : "https://firebasestorage.googleapis.com/v0/b/my-final-project-fa8d5.appspot.com/o/map_images%2FEC0BBFAA-0AC4-41FA-A6B5-91A49418F4FC?alt=media&token=a566ccf7-309c-485a-a30f-a63ea050248a",
                              "category":category,
                              "date":frmtDate,
                              "duration":frmtTime,
                              "distance":frmtDistance,
                              "pace":frmtPace,
                              "creationDate":ServerValue.timestamp()] as [String : Any]
                reference.updateChildValues(values) { (error, ref) in
                    if let err = error {
                        print(err.localizedDescription)
                        return
                    }
                }
            }
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

}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    
    // Add basic password field validation in the textFieldShouldReturn delegate function
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if (textField == passwordTextField && passwordTextField.text != nil && passwordTextField.text!.count < 6) {
            passwordTextFieldController.setErrorText("Must enter your password", errorAccessibilityValue: nil)
            validPassword = false
        } else {
            passwordTextFieldController.setErrorText(nil, errorAccessibilityValue: nil)
            validPassword = true
        }
        
        if (textField == emailTextField && emailTextField.text != nil && !isEmailValid(email: emailTextField.text!)) {
            emailTextFieldController.setErrorText("Must enter a valid email", errorAccessibilityValue: nil)
        } else {
            emailTextFieldController.setErrorText(nil, errorAccessibilityValue: nil)
        }
        return false
    }
}
