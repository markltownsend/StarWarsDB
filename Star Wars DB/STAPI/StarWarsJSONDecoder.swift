//
//  StarWarsJSONDecoder.swift
//  Star Wars DB
//
//  Created by Mark Townsend on 4/24/19.
//  Copyright © 2019 Mark Townsend. All rights reserved.
//

import Foundation

class StarWarsJSONDecoder: JSONDecoder {
    override required init() {
        super.init()
        guard let codingUserInfoKeyMOC = CodingUserInfoKey.managedObjectContext else {
            fatalError("Could not get codingUserInfoKeyMOD")
        }
        let moc = DataManager.shared.persistentContainer.viewContext
        userInfo[codingUserInfoKeyMOC] = moc
        dateDecodingStrategy = .formatted(StarWarsAPI.dateFormatter)
    }
}
