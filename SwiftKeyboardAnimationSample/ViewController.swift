//
//  ViewController.swift
//  SwiftKeyboardAnimationSample
//
//  Created by Vitaly Ivanov on 1/27/15.
//  Copyright (c) 2015 Ivanov Vitaly. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    var rows = [String]()
    
    @IBOutlet weak var tableView: UITableView!   
    @IBOutlet weak var messageTextFeild: UITextField!
    @IBOutlet weak var messageContainerBottonConstraint: NSLayoutConstraint!
    
    var tapGesture:UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0..<30 {
            rows.append("row \(i)")
        }
        
        self.tapGesture = UITapGestureRecognizer(target: self, action: "tableViewDidTap:")
        self.tapGesture.numberOfTouchesRequired = 1
        self.tapGesture.numberOfTapsRequired = 1
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShowNotification:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHideNotification:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func tableViewDidTap(gesture:UITapGestureRecognizer) {
        self.messageTextFeild.resignFirstResponder()
    }
    
    // MARK: - Keyboard Notifications
    
    func keyboardWillShowNotification(notification:NSNotification){
        let userInfo = notification.userInfo!
        
        let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        let animationOptions = UIViewAnimationOptions(UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as NSNumber).integerValue << 16))
        let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as Double
        
        UIView.animateWithDuration(animationDuration,
            delay: 0,
            options: animationOptions,
            animations: {
                self.messageContainerBottonConstraint.constant = keyboardFrame.size.height
                self.view.layoutIfNeeded()
            },
            completion: { completed in
                self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: self.rows.count - 1, inSection: 0), atScrollPosition: UITableViewScrollPosition.None, animated: true)
                
                self.tableView.addGestureRecognizer(self.tapGesture)
            })
    }
    
    func keyboardWillHideNotification(notification:NSNotification){
        self.messageContainerBottonConstraint.constant = 0
        self.view.layoutIfNeeded()
        
        self.tableView.removeGestureRecognizer(self.tapGesture)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "cell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
        }
        
        cell?.textLabel?.text = rows[indexPath.row]
        return cell!
    }
}

