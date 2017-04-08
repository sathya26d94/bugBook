//
//  ViewController.swift
//  bugBook
//
//  Created by SaTHYa on 04/04/17.
//  Copyright © 2017 Sathya. All rights reserved.
//

import UIKit
import Foundation
import CoreData

enum TabelCellType {
    case IssueType
    case CommentType
}

class ViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var syncButton: UIButton!
    @IBOutlet weak var totalCountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var tableArray: [AnyObject] = []
    var commentArray: [Comments] = []
    var tableType: TabelCellType = TabelCellType.IssueType
    override func viewDidLoad() {
        super.viewDidLoad()
        getIssuesFromServer()
        backButton.hidden = true
        totalCountLabel.setTitleTheme()
        syncButton.setButtonTheme()
        tableView.registerNib(UINib(nibName: "IssueView", bundle: nil), forCellReuseIdentifier: "IssueView")
        tableView.registerNib(UINib(nibName: "CommentView", bundle: nil), forCellReuseIdentifier: "CommentView")
    }
    
    @IBAction func syncPressed(sender: AnyObject) {
        getIssuesFromServer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    @IBAction func backPressed(sender: AnyObject) {
        backButton.hidden = true
        syncButton.hidden = false
        getIssuesFromServer()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        totalCountLabel.attributedText("\(tableArray.count)\n", firstTextFont: UIFont(name: "Helvetica-BoldOblique" , size: 14 )!, firstTextColor: UIColor(colorLiteralRed: 130/255.0, green: 150/255.0, blue: 238/255.0, alpha: 1.0), secondText: "Total Counts", secondTextFont: UIFont(name: "HelveticaNeue" , size: 12 )!, secondTextColor: UIColor.whiteColor())
        return tableArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableType == TabelCellType.IssueType {
            let cell:IssueView = self.tableView.dequeueReusableCellWithIdentifier("IssueView", forIndexPath: indexPath) as! IssueView
            cell.tag = indexPath.row
            let issue = tableArray[indexPath.row] as! Issues
            cell.setDefaults((issue.title)!, body: (issue.body)!)
            return cell
        } else {
            let cell:CommentView = self.tableView.dequeueReusableCellWithIdentifier("CommentView", forIndexPath: indexPath) as! CommentView
            cell.tag = indexPath.row
            let comments = tableArray[indexPath.row] as! Comments
            cell.setDefaults((comments.login)!, body: (comments.body)!)
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableType == TabelCellType.IssueType {
            let issue = tableArray[indexPath.row] as! Issues
            getCommentsFromServer(issue.comments_url!)
        }
    }
    
    func getIssuesFromServer(){
        let stringFromDate = NSDate().dateByAddingTimeInterval(-24 * 60 * 60).GIT_FORMAT
        getJSON("https://api.github.com/repos/crashlytics/secureudid/issues?sincee=\(stringFromDate)") { (result: [AnyObject]) -> Void in
            self.tableType = TabelCellType.IssueType
            self.tableView.setTableDefaults(false, cellHeight: 100, headerHeight: nil)
            self.saveIssues(result)
        }
    }
    
    func getCommentsFromServer(commentUrl: String){
        if (Reachability.isConnectedToNetwork()) {
            backButton.hidden = false
            syncButton.hidden = true
            backButton.setButtonTheme()
            getJSON(commentUrl) { (result: [AnyObject]) -> Void in
                self.view.bringSubviewToFront(self.backButton)
                self.tableType = TabelCellType.CommentType
                self.tableView.setTableDefaults(false, cellHeight: 300, headerHeight: nil)
                self.saveCommentsArray(result)
            }
        } else {
            noInternetAlert()
        }
    }
}

extension NSDate {
    struct Formatter {
        static let GITFORMAT: NSDateFormatter = {
            let formatter = NSDateFormatter()
            formatter.calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierISO8601)
            formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
            formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
            return formatter
        }()
    }
    var GIT_FORMAT: String { return Formatter.GITFORMAT.stringFromDate(self) }
}

extension UITableView {
    func setTableDefaults(hasFooterView: Bool, cellHeight: CGFloat?, headerHeight: CGFloat?, cellSeparatorColor: UIColor = UIColor(colorLiteralRed:215/255, green:228/255, blue:236/255, alpha:1.0)) {
        if let cellHeight = cellHeight {
            rowHeight = cellHeight
        }
        if let headerHeight = headerHeight {
            sectionHeaderHeight = headerHeight
        }
        separatorColor = cellSeparatorColor
    }
}

extension UIButton {
    func setButtonTheme() {
        backgroundColor = UIColor(colorLiteralRed: 35/255, green: 77/255, blue: 109/255, alpha: 1.0)
        titleLabel?.textColor = UIColor.whiteColor()
        titleLabel?.textAlignment = .Center
    }
}