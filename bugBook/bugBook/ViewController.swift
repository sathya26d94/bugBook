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
    case issueType
    case commentType
}

class ViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var syncButton: UIButton!
    @IBOutlet weak var totalCountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var tableArray: [AnyObject] = []
    var commentArray: [Comments] = []
    var tableType: TabelCellType = TabelCellType.issueType
    override func viewDidLoad() {
        super.viewDidLoad()
        getIssuesFromServer()
        backButton.isHidden = true
        totalCountLabel.setTitleTheme()
        syncButton.setButtonTheme()
        tableView.register(UINib(nibName: "IssueView", bundle: nil), forCellReuseIdentifier: "IssueView")
        tableView.register(UINib(nibName: "CommentView", bundle: nil), forCellReuseIdentifier: "CommentView")
    }
    
    @IBAction func syncPressed(_ sender: AnyObject) {
        getIssuesFromServer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    @IBAction func backPressed(_ sender: AnyObject) {
        backButton.isHidden = true
        syncButton.isHidden = false
        getIssuesFromServer()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        totalCountLabel.attributedText("\(tableArray.count)\n", firstTextFont: UIFont(name: "Helvetica-BoldOblique" , size: 14 )!, firstTextColor: UIColor(red: 130/255.0, green: 150/255.0, blue: 238/255.0, alpha: 1.0), secondText: "Total Counts", secondTextFont: UIFont(name: "HelveticaNeue" , size: 12 )!, secondTextColor: UIColor.white)
        return tableArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableType == TabelCellType.issueType {
            let cell:IssueView = self.tableView.dequeueReusableCell(withIdentifier: "IssueView", for: indexPath) as! IssueView
            cell.tag = indexPath.row
            let issue = tableArray[indexPath.row] as! Issues
            cell.setDefaults((issue.title)!, body: (issue.body)!)
            return cell
        } else {
            let cell:CommentView = self.tableView.dequeueReusableCell(withIdentifier: "CommentView", for: indexPath) as! CommentView
            cell.tag = indexPath.row
            let comments = tableArray[indexPath.row] as! Comments
            cell.setDefaults((comments.login)!, body: (comments.body)!)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableType == TabelCellType.issueType {
            let issue = tableArray[indexPath.row] as! Issues
            getCommentsFromServer(issue.comments_url!)
        }
    }
    
    func getIssuesFromServer(){
        let stringFromDate = Date().addingTimeInterval(-24 * 60 * 60).GIT_FORMAT
        getJSON("https://api.github.com/repos/crashlytics/secureudid/issues?sincee=\(stringFromDate)") { (result: [AnyObject]) -> Void in
            self.tableType = TabelCellType.issueType
            self.tableView.setTableDefaults(false, cellHeight: 100, headerHeight: nil)
            self.saveIssues(result)
        }
    }
    
    func getCommentsFromServer(_ commentUrl: String){
        if (Reachability.isConnectedToNetwork()) {
            backButton.isHidden = false
            syncButton.isHidden = true
            backButton.setButtonTheme()
            getJSON(commentUrl) { (result: [AnyObject]) -> Void in
                DispatchQueue.main.async {
                 self.view.bringSubview(toFront: self.backButton)
                }
                self.tableType = TabelCellType.commentType
                self.tableView.setTableDefaults(false, cellHeight: 300, headerHeight: nil)
                self.saveCommentsArray(result)
            }
        } else {
            noInternetAlert()
        }
    }
}

extension Date {
    struct Formatter {
        static let GITFORMAT: DateFormatter = {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: Calendar.Identifier.iso8601)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
            return formatter
        }()
    }
    var GIT_FORMAT: String { return Formatter.GITFORMAT.string(from: self) }
}

extension UITableView {
    func setTableDefaults(_ hasFooterView: Bool, cellHeight: CGFloat?, headerHeight: CGFloat?, cellSeparatorColor: UIColor = UIColor(red:215/255, green:228/255, blue:236/255, alpha:1.0)) {
        if let cellHeight = cellHeight {
            DispatchQueue.main.async {
                self.rowHeight = cellHeight
            }
        }
        if let headerHeight = headerHeight {
            sectionHeaderHeight = headerHeight
        }
        separatorColor = cellSeparatorColor
    }
}

extension UIButton {
    func setButtonTheme() {
        backgroundColor = UIColor(red: 35/255, green: 77/255, blue: 109/255, alpha: 1.0)
        titleLabel?.textColor = UIColor.white
        titleLabel?.textAlignment = .center
    }
}
