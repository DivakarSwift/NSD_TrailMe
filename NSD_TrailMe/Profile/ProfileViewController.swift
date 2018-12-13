//
//  ProfileViewController.swift
//  TrailMe
//
//  Created by Nathaniel Coleman on 11/5/18.
//  Copyright © 2018 November 7th design. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK:- Properties
    @IBOutlet var followCollectionView: UICollectionView!
    @IBOutlet var activityCollectionView: UICollectionView!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var overflowLabel: UILabel!
    @IBOutlet var moreActivityLabel: UILabel!
    @IBOutlet var editProfileButton: UIButton!{
        didSet {
            editProfileButton.layer.cornerRadius = 5
            editProfileButton.layer.borderWidth = 0.5
            editProfileButton.layer.borderColor = UIColor.black.cgColor
            editProfileButton.addTarget(self, action: #selector(handleEditFollow), for: .touchUpInside)
        }
    }
    @IBOutlet var activitiesLabel: UILabel!
    @IBOutlet var followersLabel: UILabel!
    @IBOutlet var followingLabel: UILabel!

    let followCellId = "cell"
    let activityCellId = "activityCell"
    var id: String?
    var user:User?
    var users = [User]()
    var posts = [Post]()
    // MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView.layer.cornerRadius = 80 / 2
        profileImageView.layer.borderColor = backColor.cgColor
        profileImageView.layer.borderWidth = 0.5
        overflowLabel.isHidden = true
        moreActivityLabel.isHidden = true
        followCollectionView.register(UINib.init(nibName: "FollowCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: followCellId)
        activityCollectionView.register(UINib.init(nibName: "ActivityCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: activityCellId)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUser()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0
        if collectionView == self.followCollectionView {
            if users.count > 13 {
                let overCount = users.count - 13
                overflowLabel.text = "+\(overCount) more"
                overflowLabel.isHidden = false
                count = 13
            } else {
                overflowLabel.isHidden = true
                count = users.count
            }
        } else if collectionView == self.activityCollectionView {
            if posts.count > 6 {
                let moreCount = posts.count - 6
                moreActivityLabel.text = "+\(moreCount) more"
                moreActivityLabel.isHidden = false
                count =  6
            } else {
                moreActivityLabel.isHidden = true
                count = posts.count
            }
        }
        return count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView == followCollectionView {
            let followCell = collectionView.dequeueReusableCell(withReuseIdentifier: followCellId, for: indexPath) as! FollowCollectionViewCell
            followCell.profileImageView.layer.cornerRadius = 50 / 2
            followCell.profileImageView.layer.masksToBounds = true
            followCell.user = users[indexPath.row]
            return followCell
        } else if collectionView == activityCollectionView {
        let activityCell = collectionView.dequeueReusableCell(withReuseIdentifier: activityCellId, for: indexPath) as! ActivityCollectionViewCell
        activityCell.post = posts[indexPath.row]
        return activityCell
        }
        return UICollectionViewCell(frame: .zero)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Alternate", bundle: nil)
        if collectionView == followCollectionView {
            if let profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as?
                ProfileViewController
            {
                guard let loggedInUserId = Auth.auth().currentUser?.uid else { return }
                if users[indexPath.row].uid == loggedInUserId {
                    return
                }
                profileViewController.id = users[indexPath.row].uid
                navigationController?.pushViewController(profileViewController, animated: true)
            }
        } else if collectionView == activityCollectionView{
            if let activityViewController = storyboard.instantiateViewController(withIdentifier: "ActivityViewController") as? ActivityViewController {
                activityViewController.post = posts[indexPath.row]
                navigationController?.pushViewController(activityViewController, animated: true)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize(width: 0, height: 0)
        if collectionView == followCollectionView {
            size = CGSize(width: 50, height: 50)
        } else if collectionView == activityCollectionView {
            size = CGSize(width: 90, height: 60)
        }
        return size
    }

    @IBAction func editProfile(_ sender: UIButton) {
        
    }
    fileprivate func configureEditFollowButton() {
        guard let loggedInUserId = Auth.auth().currentUser?.uid else { return }
        guard let userId = user?.uid  else { return }

        if loggedInUserId == userId {
            self.setEditStyle()
        }else if(user?.isPublic == false){
            self.setPrivateStyle()
        } else {
                Database.database().reference().child("follows").child(loggedInUserId).child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
                        if let isFollowed = snapshot.value as? Int, isFollowed == 1 {
                            self.setFollowStyle()
                        } else {
                            self.setUnfollowStyle()
                        }
                    }) { (error) in
                        print(error.localizedDescription)
                    }
        }
    }

    @objc func handleEditFollow() {
        guard let loggedInUserId = Auth.auth().currentUser?.uid else { return }
        guard let userId = user?.uid else { return }
        let uid = id ?? Auth.auth().currentUser?.uid ?? ""
        switch editProfileButton.titleLabel?.text {
        case "Follow":
            self.configureEditFollowButton()
            let ref = Database.database().reference().child("follows").child(loggedInUserId)
            let followsValues = [userId: 1]
            ref.updateChildValues(followsValues) { (err, reference) in
                if let error = err {
                    print("Failed to follow user: ",error.localizedDescription)
                    return
                }

               let reference = Database.database().reference().child("follower").child(userId)
                let followerValues = [loggedInUserId:2]
                reference.updateChildValues(followerValues, withCompletionBlock: { (err, _) in
                    if let error = err {
                        print("Failed to store follower: ", error.localizedDescription)
                        return
                    }
                    self.getFollowerCount(id: uid)
                    self.getFollowingCount(id: uid)
                })
            }
        case "Unfollow":
             self.configureEditFollowButton()
            Database.database().reference().child("follows").child(loggedInUserId).child(userId).removeValue { (err, ref) in
                if let error = err {
                    print("Failed to unfollow user:", error.localizedDescription)
                    return
                }
                self.configureEditFollowButton()

                Database.database().reference().child("follower").child(userId).child(loggedInUserId).removeValue(completionBlock: { (err, _) in
                    if let error = err {
                        print("Failed to remove follower of user:", error.localizedDescription)
                        return
                    }
                    self.getFollowerCount(id: uid)
                    self.getFollowingCount(id: uid)
                })
            }
        case "Account is Private":
            let alert = UIAlertController(title: "Account is private", message: "This is a private account. Once account user makes account public, you will be able to follow them.", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        default:
            editProfile()
        }
    }

    fileprivate func editProfile() {
        let epc = EditProfileController()
        epc.user = self.user
        self.navigationController?.pushViewController(epc, animated: true)
    }

    fileprivate func setFollowStyle() {
        editProfileButton.setTitle("Unfollow", for: .normal)
        editProfileButton.layer.borderColor = mainColor.cgColor
        editProfileButton.backgroundColor = .white
        editProfileButton.setTitleColor(mainColor, for: .normal)
    }

    fileprivate func setUnfollowStyle() {
        editProfileButton.setTitle("Follow", for: .normal)
        editProfileButton.layer.borderColor = mainColor.cgColor
        editProfileButton.backgroundColor = mainColor
        editProfileButton.setTitleColor(.white, for: .normal)
    }

    fileprivate func setEditStyle() {
        editProfileButton.setTitle("Edit Profile", for: .normal)
        editProfileButton.layer.borderColor = mainColor.cgColor
        editProfileButton.backgroundColor = .white
        editProfileButton.setTitleColor(mainColor, for: .normal)
    }
    
    fileprivate func setPrivateStyle() {
        editProfileButton.setTitle("Account is Private", for: .normal)
        editProfileButton.layer.borderColor = UIColor.red.cgColor
        editProfileButton.backgroundColor = .white
        editProfileButton.setTitleColor(.red, for: .normal)
    }

    fileprivate func fetchUser()  {
        let uid = id ?? Auth.auth().currentUser?.uid ?? ""
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String:Any] else { return }
            self.user = User(uid: uid, dictionary: dictionary)
            self.configureEditFollowButton()
            self.getUsername()
            self.getProfileImage()
            self.getFollowedUsers()
            self.getActivityCount(id: uid)
            self.getFollowerCount(id: uid)
            self.getFollowingCount(id: uid)
            Database.fetchUserWithUID(uid: uid) { (user) in
                if user.isPublic == true{
                self.fetchPostsWith(user: user)
                }
            }
             self.followCollectionView.reloadData()
        }) { (error) in
            print("Failed to fetch user. \(error.localizedDescription)")
        }

    }

    fileprivate func getFollowedUsers() {
        self.users.removeAll()
        let uid = id ?? Auth.auth().currentUser?.uid ?? ""
        Database.database().reference().child("follows").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String:Any] else {return}
            dictionaries.forEach({ (key, value) in
                Database.database().reference().child("users").child(key).observeSingleEvent(of: .value, with: { (snapshot) in
                    guard let userDict = snapshot.value as? [String:Any] else { return}
                    let user = User(uid: key, dictionary: userDict)
                    self.users.append(user)
                    self.followCollectionView.reloadData()
                }, withCancel: { (err) in
                    print(err.localizedDescription)
                })
            })
        }) { (error) in
            print(error.localizedDescription)
        }

    }

    fileprivate func getUsername() {
        guard let username = user?.username else {return}
        self.nameLabel.text = "\(username)"
    }

    fileprivate func getProfileImage() {
        guard let profileImageUrl = user?.profileImageUrl else { return }
        guard let url = URL(string: profileImageUrl) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            guard let data = data else {
                self.profileImageView.image = UIImage(named: "no_image")
                return }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self.profileImageView.image = image
            }
            }.resume()
    }

    fileprivate func getActivityCount(id: String) {
        guard let username = user?.username else { return }
        Database.database().reference().child("posts").child(id + "-" + username).observeSingleEvent(of: .value, with: { (snapshot) in
            let count = snapshot.childrenCount
            self.activitiesLabel.text = "\(count)"
        }) { (error) in
            print(error.localizedDescription)
        }
    }


    fileprivate func fetchPostsWith(user: User) {
        self.posts.removeAll()
        let reference = Database.database().reference().child("posts").child(user.uid + "-" + user.username)
        reference.observeSingleEvent(of:.value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String:Any] else { return }
            dictionaries.forEach({ (key, value) in
                guard let postsDictionary = value as? [String:Any] else { return }
                let post = Post(postId: key,user: user, dictionary: postsDictionary)
                self.posts.append(post)
                self.posts.sort(by: { (p1, p2) -> Bool in
                    return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                })
                self.activityCollectionView.reloadData()
            })
        }) { (error) in
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        }
    }

    fileprivate func getFollowingCount(id: String){
        Database.database().reference().child("follows").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
            let count = snapshot.childrenCount
            self.followingLabel.text = "\(count)"
        }) { (err) in
            print(err.localizedDescription)
        }
    }

    fileprivate func getFollowerCount(id:String){
        Database.database().reference().child("follower").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
            let count = snapshot.childrenCount
            self.followersLabel.text = "\(count)"
        }) { (err) in
            print(err.localizedDescription)
        }
    }

}
