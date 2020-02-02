//
//  StarWarsManagedObject.swift
//  Star Wars DB
//
//  Created by Mark Townsend on 4/25/19.
//  Copyright © 2019 Mark Townsend. All rights reserved.
//

import Foundation
import CoreData

public protocol StarWarsManagedObject:Decodable where Self:NSManagedObject {
    var name: String? {get set}
}

extension StarWarsManagedObject where Self:NSManagedObject {
    static func get<T:NSManagedObject>(url: URL) -> T? {
        guard let name = Self.entity().name else { return nil }
        let fetchRequest = NSFetchRequest<Self>(entityName: name)
        let predicate = NSPredicate(format: "url == %@", argumentArray: [url])
        fetchRequest.predicate = predicate
        let moc = DataManager.shared.persistentContainer.viewContext
        do {
            return try moc.fetch(fetchRequest).first as? T
        } catch let error as NSError {
            print(error)
            return nil
        }
    }
}
