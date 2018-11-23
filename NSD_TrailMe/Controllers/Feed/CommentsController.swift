//
//  CommentsController.swift
//  TrailMe
//
//  Created by Nathaniel Coleman on 10/28/18.
//  Copyright © 2018 November 7th design. All rights reserved.
//

import UIKit
import Firebase

class CommentsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var _inputAccessoryView: UIView!
    let cellId = "cellId"
    let commentTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter comment"
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(mainColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        return button
    }()

    var postId: String?
    var comments = [Comment]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        title = "Comments"

        collectionView.register(PostCommentCell.self, forCellWithReuseIdentifier: cellId)

        fetchComments()
    }

    fileprivate func fetchComments() {
        comments.removeAll()
        guard let postID = postId else { return }
        let ref = Database.database().reference().child("comments").child(postID)
        ref.observe(.childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }

            guard let uid = dictionary["uid"] as? String else { return }
            Database.fetchUserWithUID(uid: uid, completion: { (user) in
                let comment = Comment(user: user,dictionary: dictionary)
                self.comments.append(comment)
                self.collectionView.reloadData()
            })

        }) { (error) in
            print("Failed to fetch post comments:", error.localizedDescription)
        }

    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PostCommentCell
        cell.comment = comments[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let dummyCell = PostCommentCell(frame: frame)
        dummyCell.comment = comments[indexPath.item]
        dummyCell.layoutIfNeeded()

        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        let height = max(40 + 8 + 8, estimatedSize.height)

        return CGSize(width: view.frame.width, height: height)
    }

    override var canBecomeFirstResponder: Bool{ return true }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    override var inputAccessoryView: UIView? {
        if _inputAccessoryView == nil {
            _inputAccessoryView = CustomView()
            _inputAccessoryView.backgroundColor = .groupTableViewBackground
            _inputAccessoryView.addSubview(commentTextField)
            _inputAccessoryView.addSubview(submitButton)
            _inputAccessoryView.autoresizingMask = .flexibleHeight
            commentTextField.leadingAnchor.constraint(equalTo: _inputAccessoryView.leadingAnchor, constant: 8).isActive = true
            commentTextField.trailingAnchor.constraint(equalTo: submitButton.leadingAnchor, constant: -4).isActive = true
            commentTextField.topAnchor.constraint(equalTo: _inputAccessoryView.topAnchor, constant: 8).isActive = true
            commentTextField.bottomAnchor.constraint(equalTo: _inputAccessoryView.layoutMarginsGuide.bottomAnchor, constant: -8).isActive = true
            submitButton.leadingAnchor.constraint(equalTo: commentTextField.trailingAnchor, constant: 4).isActive = true
            submitButton.trailingAnchor.constraint(equalTo: _inputAccessoryView.trailingAnchor, constant: -8).isActive = true
            submitButton.bottomAnchor.constraint(equalTo: _inputAccessoryView.layoutMarginsGuide.bottomAnchor, constant: -8).isActive = true
            submitButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        }
        return _inputAccessoryView
    }

    @objc func handleSubmit() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let postID = postId else { return }
        let values = ["text": commentTextField.text ?? "", "creationDate":ServerValue.timestamp(), "uid": uid] as [String: Any]
        Database.database().reference().child("comments").child(postID).childByAutoId().updateChildValues(values) { (err, ref) in
            if let error = err {
                print("Failed to store insert comment: ",error.localizedDescription)
            }
        }
        commentTextField.text = ""
    }

}

class CustomView: UIView {
    override var intrinsicContentSize: CGSize{
        return CGSize.zero
    }
}
