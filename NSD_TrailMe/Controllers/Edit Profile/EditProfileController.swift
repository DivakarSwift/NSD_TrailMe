//
//  EditProfileController.swift
//  TrailMe
//
//  Created by Nathaniel Coleman on 9/25/18.
//  Copyright © 2018 November 7th design. All rights reserved.
//

import UIKit
import Firebase

class EditProfileController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, EditProfileHeaderDelegate {
    
    

    var isPublic: Bool?
    var user: User? {
        didSet{
             isPublic = user?.isPublic
        }
    }
    var profileImageUrl = ""

    let cellId = "cell"
    let headerId = "header"
    let labels = ["First Name","Last Name", "Username", "Email", "Public"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationController?.navigationBar.prefersLargeTitles = false
        view.backgroundColor = backColor
        navigationItem.title = "Edit Profile"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(handleDone))
        tableView = UITableView(frame: self.tableView.frame, style: .grouped)
        tableView.keyboardDismissMode = .interactive
        tableView.register(EditProfileTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.register(EditProfileTableViewHeader.self, forCellReuseIdentifier: headerId)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EditProfileTableViewCell
        cell.cellLabel.text = labels[indexPath.row]
        cell.separatorInset = UIEdgeInsets(top: 0, left: 120, bottom: 0, right: 16)
        cell.selectionStyle = .none
        switch indexPath.row {
        case 0:
            cell.valueTextField.autocapitalizationType = .words
            cell.valueTextField.placeholder = "First Name"
            cell.valueTextField.text = self.user?.firstName
            cell.valueTextField.clearButtonMode = .always

        case 1:
            cell.valueTextField.autocapitalizationType = .words
            cell.valueTextField.placeholder = "Last Name"
            cell.valueTextField.text = self.user?.lastName
            cell.valueTextField.clearButtonMode = .always
            
        case 2:
            cell.valueTextField.autocapitalizationType = .none
            cell.valueTextField.placeholder = "Username"
            cell.valueTextField.text = self.user?.username
            cell.valueTextField.clearButtonMode = .always
            
        case 3:
            cell.valueTextField.autocapitalizationType = .none
            cell.valueTextField.keyboardType = .emailAddress
            cell.valueTextField.placeholder = "Email"
            cell.valueTextField.text = Auth.auth().currentUser?.email ?? self.user?.email
            cell.valueTextField.clearButtonMode = .never
            cell.valueTextField.isUserInteractionEnabled = false
            cell.accessoryType = .disclosureIndicator
        case 4:
            let switchView = UISwitch()
            switchView.setOn(self.user!.isPublic, animated: true)
            switchView.tag = indexPath.row
            switchView.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
            cell.accessoryView = switchView
        default:
            break
        }
        return cell
    }
    
    @objc func switchChanged(_ sender: UISwitch){
        self.isPublic = sender.isOn ? true : false
        if self.isPublic! {
            let alert = UIAlertController(title: nil, message: "Account can be seen by other users, who can also follow you in the app", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: nil, message: "Account will not be seen by other users, they cannot follow you in the app", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 3:
            let emailCell = tableView.cellForRow(at: indexPath) as! EditProfileTableViewCell
            let email = emailCell.valueTextField.text
            let destination = EditEmailController()
            destination.email = email
            self.navigationController?.pushViewController(destination, animated: true)
            break
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: headerId) as! EditProfileTableViewHeader
        header.backgroundColor = .white
        header.user = self.user
        header.delegate = self
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return view.frame.height / 4
    }
    
    @objc func handleCancel() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleDone() {
        let firstNameIndex = IndexPath(row: 0, section: 0)
        let lastNameIndex = IndexPath(row: 1, section: 0)
        let userNameIndex = IndexPath(row: 2, section: 0)
        let emailIndex = IndexPath(row: 3, section: 0)
        //let isPublicIndex = IndexPath(row: 4, section: 0)
        let firstNameCell = tableView.cellForRow(at: firstNameIndex) as! EditProfileTableViewCell
        let lastNameCell = tableView.cellForRow(at: lastNameIndex) as! EditProfileTableViewCell
        let userNameCell = tableView.cellForRow(at: userNameIndex) as! EditProfileTableViewCell
        let emailCell = tableView.cellForRow(at: emailIndex) as! EditProfileTableViewCell
        //let isPublicCell = tableView.cellForRow(at: isPublicIndex) as! EditProfileTableViewCell
        if let firstName = firstNameCell.valueTextField.text ,let lastName = lastNameCell.valueTextField.text, let username = userNameCell.valueTextField.text, let email = emailCell.valueTextField.text {
            if username.count > 0 && firstName.count > 0 && lastName.count > 0 && email.count > 0 {
                guard let uid = Auth.auth().currentUser?.uid else { return }
                guard let profileImageUrl = self.user?.profileImageUrl else { return }
                guard let fcmToken = Messaging.messaging().fcmToken else { return }
                let dictionaryValues:[String:Any] = ["firstName": firstName, "lastName" : lastName, "userName": username, "email" : email, "isPublic": self.isPublic!, "profileImageUrl": profileImageUrl,"fcmToken":fcmToken]
                let values = [uid:dictionaryValues]
                
                Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (error, ref) in
                    if let err = error {
                        print(err.localizedDescription)
                    }
                })
                navigationController?.popViewController(animated: true)
            } else {
                let alert = UIAlertController(title: nil, message: "All fields must be filled in", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func didEditProfile() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage  = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.saveProfileImage(image: editedImage)
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.saveProfileImage(image: originalImage)
        }
        dismiss(animated: true, completion: nil)
        self.tableView.reloadData()
    }
    
    fileprivate func saveProfileImage(image: UIImage) {
        guard let uploadData = image.jpegData(compressionQuality: 0.3) else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let filename = uid + "_profile_image"
        
        Storage.storage().reference().child("profile_images").child(filename).putData(uploadData, metadata: nil) { (metadata, error) in
            if let err = error {
                print(err.localizedDescription)
            }
            Storage.storage().reference().child("profile_images").child(filename).downloadURL(completion: { (url, error) in
                if let err = error {
                    print(err.localizedDescription)
                } else {
                    guard let profileImageUrl = url?.absoluteString else { return }
                    guard let firstName = self.user?.firstName else { return }
                    guard let lastName = self.user?.lastName else { return }
                    guard let userName = self.user?.username else { return }
                    guard let email = self.user?.email else { return }
                    guard let isPublic = self.user?.isPublic else { return }
                    self.profileImageUrl = profileImageUrl
                    let dictionaryValues = ["firstName": firstName, "lastName" : lastName, "userName": userName, "email" : email, "isPublic": isPublic, "profileImageUrl": profileImageUrl] as [String : Any]
                    let values = [uid:dictionaryValues]
                    Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (error, ref) in
                        if let err = error {
                            print(err.localizedDescription)
                        }
                        self.fetchUser()
                    })
                }
            })
        }
    }
    
    fileprivate func fetchUser()  {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String:Any] else { return }
            self.user = User(uid: uid, dictionary: dictionary)
            self.tableView.reloadData()
        }) { (error) in
            print("Failed to fetch user. \(error.localizedDescription)")
        }
    }
}
