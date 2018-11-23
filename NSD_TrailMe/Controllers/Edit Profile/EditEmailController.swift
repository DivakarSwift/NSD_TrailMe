//
//  EditEmailController.swift
//  TrailMe
//
//  Created by Nathaniel Coleman on 10/2/18.
//  Copyright © 2018 November 7th design. All rights reserved.
//

import UIKit
import Firebase

class EditEmailController: UIViewController {
    var email: String?
    let emailTextField : UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layer.borderColor = UIColor.black.cgColor
        tf.autocapitalizationType = .none
        tf.keyboardType = .emailAddress
        tf.borderStyle = .roundedRect
        tf.placeholder = "Email"
        tf.clearButtonMode = .always
        return tf
    }()
    let changeEmailButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleChangeEmail), for: .touchUpInside)
        return button
    }()
    let validationLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = "Edit email"
        setupView()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    fileprivate func setupView(){
        view.addSubview(emailTextField)
        view.addSubview(changeEmailButton)
        view.addSubview(validationLabel)
        emailTextField.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 120, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 44)
        emailTextField.text = email

        changeEmailButton.anchor(top: emailTextField.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 150, height: 44)
        changeEmailButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        validationLabel.anchor(top: nil, left: emailTextField.leftAnchor, bottom: emailTextField.topAnchor, right: emailTextField.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 12, paddingRight: 0, width: 0, height: 20)
    }

    @objc func handleChangeEmail() {
        validationLabel.isHidden = true
        guard let email = emailTextField.text, email.count > 0 else {
            validationLabel.isHidden = false
            validationLabel.text = "Please enter your email"
            return }
        if isEmailValid(email: email) == false {
            validationLabel.isHidden = false
            validationLabel.text = "Please enter a valid email address"
            return
        }
        // Handle changing email
        guard let user = Auth.auth().currentUser else { return }
        user.updateEmail(to: email) { (error) in
            if let err = error {
                let alert = UIAlertController(title: nil, message:err.localizedDescription, preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    fileprivate func isEmailValid(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let test = NSPredicate(format: "SELF MATCHES %@", emailRegEx)

        return test.evaluate(with:email)
    }

}
