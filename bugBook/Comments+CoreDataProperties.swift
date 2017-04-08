//
//  Comments+CoreDataProperties.swift
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

extension Comments {

    @NSManaged var login: String?
    @NSManaged var body: String?

}
