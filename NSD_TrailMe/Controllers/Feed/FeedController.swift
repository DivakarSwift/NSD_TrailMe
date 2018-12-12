//
//  FeedController.swift
//  TrailMe
//
//  Created by Nathaniel Coleman on 9/24/18.
//  Copyright © 2018 November 7th design. All rights reserved.
//

import UIKit
import Firebase

class FeedController: UICollectionViewController, UICollectionViewDelegateFlowLayout, FeedPostCellDelegate {


    let cellId = "cellId"
    var posts = [Post]()


    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(handleRefresh), name: ActivityDetailViewController.updateFeedNotificationName, object: nil)
        collectionView.backgroundColor = .white
        collectionView.register(FeedPostCell.self, forCellWithReuseIdentifier: cellId)
        navigationController?.navigationBar.prefersLargeTitles = false
        title = "Feed"
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFollowingPosts()
        fetchUserPosts()
    }

    fileprivate func getFollowingPosts() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("follows").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userIDsDictionary = snapshot.value as? [String:Any] else {
                return
            }
            userIDsDictionary.forEach({ (key, value) in
                Database.fetchUserWithUID(uid: key, completion: { (user) in
                    self.fetchPostsWith(user: user)
                })
            })
        }) { (err) in
            print("Failed to get ids of users being followed:", err)
        }
    }

    @objc  func handleRefresh() {
        posts.removeAll(keepingCapacity: false)
        getFollowingPosts()
        fetchUserPosts()
    }

    fileprivate func fetchUserPosts() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.fetchPostsWith(user: user)
        }
    }

    fileprivate func fetchPostsWith(user: User) {
        let reference = Database.database().reference().child("posts").child(user.uid)
        reference.observeSingleEvent(of:.value, with: { (snapshot) in
            self.collectionView.refreshControl?.endRefreshing()
            guard let dictionaries = snapshot.value as? [String:Any] else { return }
            dictionaries.forEach({ (key, value) in
                guard let postsDictionary = value as? [String:Any] else { return }
                var post = Post(postId: key,user: user, dictionary: postsDictionary)
                guard let uid = Auth.auth().currentUser?.uid else { return }
                Database.database().reference().child("likes").child(post.postId).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let value = snapshot.value as? Int , value == 1 {
                        post.hasLiked = true
                    } else {
                        post.hasLiked = false
                    }
                    self.posts.append(post)
                    self.posts.sort(by: { (p1, p2) -> Bool in
                        return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                    })
                    self.collectionView.reloadData()
                }, withCancel: { (error) in
                    print("Failed to get like info for post: ",error.localizedDescription)
                })
            })
        }) { (error) in
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if posts.count == 0 {
            self.collectionView.setEmptyDisplay("You have no posts in your feed. Share or follow to view posts.")
            return posts.count
        }
        self.collectionView.restoreView()
        return posts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FeedPostCell
        if indexPath.item < posts.count{
            cell.post = posts[indexPath.item]
        }
        cell.delegate = self
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 40 + 8 + 8
        height += view.frame.width
        height += 75
        return CGSize(width: view.frame.width, height: height)
    }

    func didCommentOn(post: Post) {
        let commentsController = CommentsController(collectionViewLayout: UICollectionViewFlowLayout())
        commentsController.postId = post.postId
        navigationController?.pushViewController(commentsController, animated: true)
    }

    func didLike(cell: FeedPostCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        var post = self.posts[indexPath.item]
        let posterId = post.user.uid
        let postID = post.postId
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let values = [uid: post.hasLiked == true ? 0 : 1] as [String:Any]
        Database.database().reference().child("likes").child(postID).child(uid).child(posterId).updateChildValues(values) { (err, _) in
            if let error = err {
                print("Failed to like post: ", error.localizedDescription)
            }
            post.hasLiked = !post.hasLiked
            self.posts[indexPath.item] = post
            self.collectionView.reloadItems(at: [indexPath])
        }
    }

    func didHighFive(cell: FeedPostCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        var post = self.posts[indexPath.item]
        let posterId = post.user.uid
        let postID = post.postId
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let values = [uid: post.hasHighFive == true ? 0 : 1] as [String:Any]
        Database.database().reference().child("highFives").child(postID).child(uid).child(posterId).updateChildValues(values) { (err, _) in
            if let error = err {
                print("Failed to give high five to post: ", error.localizedDescription)
            }
            post.hasHighFive = !post.hasHighFive
            self.posts[indexPath.item] = post
            self.collectionView.reloadItems(at: [indexPath])
        }
    }
}

extension UICollectionView {
    func setEmptyDisplay(_ text: String){
        let message = UILabel(frame: CGRect(x: 0, y: 0, width:self.bounds.size.width , height: self.bounds.size.height))
        message.text = text
        message.textColor = mainColor
        message.numberOfLines = 0
        message.textAlignment = .center
        message.sizeToFit()
        
        self.backgroundView = message
    }
    func restoreView()  {
        self.backgroundView = nil
    }
}




