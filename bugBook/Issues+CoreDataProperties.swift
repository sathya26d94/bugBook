//
//  Issues+CoreDataProperties.swift
//  bugBook
//
//  Created by SaTHYa on 05/04/17.
//  Copyright © 2017 Sathya. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Issues {

    @NSManaged var comments_url: String?
    @NSManaged var title: String?
    @NSManaged var body: String?
    @NSManaged var updated_at: String?
}
