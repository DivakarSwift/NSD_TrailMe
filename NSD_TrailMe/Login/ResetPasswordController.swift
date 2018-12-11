//
//  ResetPasswordController.swift
//  NSD_TrailMe
//
//  Created by Nathaniel Coleman on 11/20/18.
//  Copyright © 2018 Nathaniel Coleman. All rights reserved.
//

import UIKit
import MaterialComponents
import Firebase

class ResetPasswordController: UIViewController {
    
    // MARK:- Properties
    var blurEffectView: UIVisualEffectView?
    let activityIndicator = UIActivityIndicatorView()
    let emailTextFieldController: MDCTextInputControllerFilled
    var validEmail = false
    
    let heroImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.text = "Recover account information"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let infoLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.text = "We can help reset your password info"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emailTextField: MDCTextField = {
        let tf = MDCTextField()
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        tf.placeholder = "Email"
        tf.clearButtonMode = .always
        tf.textColor = .black
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.addTarget(self, action: #selector(textEditingChangedEmail(_:)), for: .editingChanged)
        return tf
    }()
    
    let resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reset password", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor(red: 0/255, green: 71/255, blue: 255/255, alpha: 0.5)
        button.addTarget(self, action: #selector(handleReset), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let cancelButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.layoutMargins = UIEdgeInsets.init(top: 0, left: 16, bottom: 0, right: 16)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        // Setup text field controllers
        emailTextFieldController = MDCTextInputControllerFilled(textInput: emailTextField)
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
        //heroImage.addSubview(blurEffectView!)
        scrollView.backgroundColor = .clear
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        emailTextField.delegate = self
        validEmail = false
        
        setupUI()
    }
    
    fileprivate func setupUI() {
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
        scrollView.addSubview(infoLabel)
        scrollView.addSubview(activityIndicator)
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(resetButton)
        scrollView.addSubview(cancelButton)
        
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
        constraints.append(NSLayoutConstraint(item: infoLabel,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: headerLabel,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: 8))
        constraints.append(NSLayoutConstraint(item: infoLabel,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: scrollView,
                                              attribute: .centerX,
                                              multiplier: 1,
                                              constant: 0))
        constraints.append(NSLayoutConstraint(item: activityIndicator,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: infoLabel,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: 24))
        constraints.append(NSLayoutConstraint(item: activityIndicator,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: scrollView,
                                              attribute: .centerX,
                                              multiplier: 1,
                                              constant: 0))
        constraints.append(NSLayoutConstraint(item: emailTextField,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: activityIndicator,
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
        constraints.append(NSLayoutConstraint(item: resetButton,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: emailTextField,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: 8))
        constraints.append(NSLayoutConstraint(item: resetButton,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: scrollView,
                                              attribute: .centerX,
                                              multiplier: 1,
                                              constant: 0))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|-[reset]-|",
                                                                      options: [], metrics: nil, views: ["reset": resetButton]))
        resetButton.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 58)
        
        constraints.append(NSLayoutConstraint(item: cancelButton,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: resetButton,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: 24))
        constraints.append(NSLayoutConstraint(item: cancelButton,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: scrollView,
                                              attribute: .centerX,
                                              multiplier: 1,
                                              constant: 0))
        
        
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func didTapTouch(sender: UIGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func handleReset() {
        if validEmail == true {
            //print("Valid email... resetting")
            guard let email = emailTextField.text else { return }
            if activityIndicator.isAnimating == true {
                activityIndicator.isHidden = true
                activityIndicator.stopAnimating()
            }
            else {
                activityIndicator.isHidden = false
                activityIndicator.startAnimating()
            }
            Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                if let err = error {
                    let alert = UIAlertController(title: nil, message: err.localizedDescription, preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                        self.emailTextField.text = ""
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            let alert = UIAlertController(title: "Form Error", message: "Form has errors, please correct to continue", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func handleCancel() {
        navigationController?.popViewController(animated: true)
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
    
    
    fileprivate func isEmailValid(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let test = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        
        return test.evaluate(with:email)
    }
}

// MARK: - UITextFieldDelegate
extension ResetPasswordController: UITextFieldDelegate {
    
    // Add basic password field validation in the textFieldShouldReturn delegate function
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if (textField == emailTextField && emailTextField.text != nil && !isEmailValid(email: emailTextField.text!)) {
            emailTextFieldController.setErrorText("Must enter a valid email", errorAccessibilityValue: nil)
            validEmail = false
        } else {
            emailTextFieldController.setErrorText(nil, errorAccessibilityValue: nil)
            validEmail = true
        }
        return false
    }
}

