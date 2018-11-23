//
//  NoteController.swift
//  NSD_TrailMe
//
//  Created by Nathaniel Coleman on 11/22/18.
//  Copyright © 2018 Nathaniel Coleman. All rights reserved.
//

import UIKit

class NoteController: UIViewController {
    let noteForm: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        return tv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backColor
        navigationItem.title = "Note"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(handleDone))
        
        view.addSubview(noteForm)
        noteForm.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 80, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 400)
        noteForm.becomeFirstResponder()
    }
    
    @objc func handleCancel(){
        navigationController?.popViewController(animated: true)
    }
    @objc func handleDone(){
        ActivityDetailViewController.note = noteForm.text
        navigationController?.popViewController(animated: true)
    }
}

