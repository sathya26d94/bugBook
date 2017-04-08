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
    func getJSON(urlString: String, success: ([AnyObject]) -> Void) {
        if (Reachability.isConnectedToNetwork()){
            JHProgressHUD.sharedHUD.showInView(view)
            let requestURL: NSURL = NSURL(string: urlString  )!
            let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(urlRequest) {
                (data, response, error) -> Void in
                let httpResponse = response as! NSHTTPURLResponse
                let statusCode = httpResponse.statusCode
                if (statusCode == 200) {
                    do{
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                        success(json as! [AnyObject])
                    }catch {
                        print("Error with Json: \(error)")
                    }
                }
            }
            task.resume()
        } else {
            noInternetAlert()
        }
    }
    
    func noInternetAlert() {
        let alert = UIAlertController(title: "Alert", message: "Network Not Available", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: { action in
            
        }))
        dispatch_async(dispatch_get_main_queue(), {
            self.presentViewController(alert, animated: true, completion: nil)
        })
    }
    func saveIssues(dataArray : [AnyObject]) {
        deleteAllData("Issues") { (success) -> Void in
            for data in dataArray {
                let issue = NSEntityDescription.insertNewObjectForEntityForName("Issues",inManagedObjectContext:MOC.sharedInstance.managedObjectContext) as? Issues
                issue?.body = data["body"] as? String
                issue?.comments_url = data["comments_url"] as? String
                issue?.title = data["title"] as? String
                issue?.updated_at = data["updated_at"] as? String
                MOC.sharedInstance.saveContext()
            }
            self.fetch("Issues",sortKeyPath: "updated_at")
        }
    }
    
    func saveCommentsArray(dataArray : [AnyObject]) {
        deleteAllData("Comments") { (success) -> Void in
            for data in dataArray {
                let comments = NSEntityDescription.insertNewObjectForEntityForName("Comments",inManagedObjectContext:MOC.sharedInstance.managedObjectContext) as? Comments
                comments?.body = data["body"] as? String
                let userInfo = data["user"] as? [String: AnyObject]
                comments?.login = userInfo!["login"] as? String
                MOC.sharedInstance.saveContext()
            }
            self.fetch("Comments",sortKeyPath: "login")
        }
    }
    
    func deleteAllData(entity: String, success: (AnyObject) -> Void) {
        let fetchRequest = NSFetchRequest(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try MOC.sharedInstance.managedObjectContext.executeFetchRequest(fetchRequest)
            for managedObject in results {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                MOC.sharedInstance.managedObjectContext.deleteObject(managedObjectData)
            }
            MOC.sharedInstance.saveContext()
            success("Success")
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
    
    func fetch(entityName: String, sortKeyPath: String) {
        MOC.sharedInstance.fetchedResultsController(entityName,keyPath: sortKeyPath)
        MOC.sharedInstance.executeFetch { (Success) -> Void in
            if let tableArray = MOC.sharedInstance.fetchedResultsController.fetchedObjects {
                self.tableArray = tableArray
                self.tableView.reloadData()
                JHProgressHUD.sharedHUD.hide()
            } else {
                
            }
        }
    }

}