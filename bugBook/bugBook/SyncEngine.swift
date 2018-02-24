//
//  SyncEngine.swift
//  bugBook
//
//  Created by SaTHYa on 08/04/17.
//  Copyright © 2017 Sathya. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension ViewController {
    func getJSON(_ urlString: String, success: @escaping ([AnyObject]) -> Void) {
        if (Reachability.isConnectedToNetwork()){
            self.showActivityIndicator()
            let session = URLSession.shared
            guard let requestUrl = URL(string:urlString) else { return }
            let request = URLRequest(url:requestUrl)
            let task = session.dataTask(with: request) {
                (data, response, error) in
                self.hideActivityIndicator()
                if error == nil {
                    let httpResponse = response as! HTTPURLResponse
                    let statusCode = httpResponse.statusCode
                    if (statusCode == 200) {
                        do{
                            let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments)
                            success(json as! [AnyObject])
                        }catch {
                            print("Error with Json: \(error)")
                        }
                    }
                }
            }
            task.resume()
        } else {
            noInternetAlert()
        }
    }

    
    func noInternetAlert() {
        let alert = UIAlertController(title: "Alert", message: "Network Not Available", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { action in
            
        }))
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true, completion: nil)
        })
    }
    func saveIssues(_ dataArray : [AnyObject]) {
        deleteAllData("Issues") { (success) -> Void in
            for data in dataArray {
                let issue = NSEntityDescription.insertNewObject(forEntityName: "Issues",into:MOC.sharedInstance.managedObjectContext) as? Issues
                issue?.body = data["body"] as? String
                issue?.comments_url = data["comments_url"] as? String
                issue?.title = data["title"] as? String
                issue?.updated_at = data["updated_at"] as? String

            }
            MOC.sharedInstance.saveContext()
            self.fetch("Issues",sortKeyPath: "updated_at")
        }
    }
    
    func saveCommentsArray(_ dataArray : [AnyObject]) {
        deleteAllData("Comments") { (success) -> Void in
            for data in dataArray {
                let comments = NSEntityDescription.insertNewObject(forEntityName: "Comments",into:MOC.sharedInstance.managedObjectContext) as? Comments
                comments?.body = data["body"] as? String
                let userInfo = data["user"] as? [String: AnyObject]
                comments?.login = userInfo!["login"] as? String
                MOC.sharedInstance.saveContext()
            }
            self.fetch("Comments",sortKeyPath: "login")
        }
    }
    
    func deleteAllData(_ entity: String, success: (AnyObject) -> Void) {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try MOC.sharedInstance.managedObjectContext.execute(deleteRequest)
            try MOC.sharedInstance.managedObjectContext.save()
            success("Success" as AnyObject)
        } catch {
            print ("There was an error")
        }
    }
    
    func fetch(_ entityName: String, sortKeyPath: String) {
        MOC.sharedInstance.fetchedResultsController(entityName,keyPath: sortKeyPath)
        MOC.sharedInstance.executeFetch { (Success) -> Void in
            if let tableArray = MOC.sharedInstance.fetchedResultsController.fetchedObjects {
                self.tableArray = tableArray
                self.tableView.reloadData()
            } else {
                
            }
        }
    }

    func showActivityIndicator()  {
        let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        myActivityIndicator.center = view.center
        myActivityIndicator.hidesWhenStopped = true
        myActivityIndicator.startAnimating()
        myActivityIndicator.tag = 97942609
        myActivityIndicator.isHidden = false
        view.addSubview(myActivityIndicator)
    }

    func hideActivityIndicator()  {
        DispatchQueue.main.async(execute: {
            let myActivityIndicator = self.view.viewWithTag(97942609) as! UIActivityIndicatorView
            myActivityIndicator.isHidden = true
            myActivityIndicator.stopAnimating()
            myActivityIndicator.removeFromSuperview()
        })
    }

}
