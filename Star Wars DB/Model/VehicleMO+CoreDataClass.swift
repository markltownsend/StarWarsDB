//
//  VehicleMO+CoreDataClass.swift
//  Star Wars DB
//
//  Created by Mark Townsend on 4/11/19.
//  Copyright © 2019 Mark Townsend. All rights reserved.
//
//

import Foundation
import CoreData

@objc(VehicleMO)
public class VehicleMO: NSManagedObject, StarWarsManagedObject {
    enum CodingKeys: String, CodingKey {
        case name
        case model
        case vehicleClass = "vehicle_class"
        case manufacturer
        case length
        case costInCredits = "cost_in_credits"
        case crew
        case passengers
        case maxAtmospheringSpeed = "max_atmosphering_speed"
        case cargoCapacity = "cargo_capacity"
        case consumables
        case films
        case pilots
        case url
        case created
        case edited
    }

    // MARK: - Decodable
    public required convenience init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Vehicle", in: managedObjectContext) else {
                fatalError("Couldn't decode Vehicle")
        }

        let api = StarWarsAPI()
        
        self.init (entity: entity, insertInto: managedObjectContext)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.model = try container.decodeIfPresent(String.self, forKey: .model)
        self.vehicleClass = try container.decodeIfPresent(String.self, forKey: .vehicleClass)
        self.manufacturer = try container.decodeIfPresent(String.self, forKey: .manufacturer)
        self.length = try container.decodeIfPresent(String.self, forKey: .length)
        self.costInCredits = try container.decodeIfPresent(String.self, forKey: .costInCredits)
        self.crew  = try container.decodeIfPresent(String.self, forKey: .crew)
        self.passengers = try container.decodeIfPresent(String.self, forKey: .passengers)
        self.maxAtmospheringSpeed = try container.decodeIfPresent(String.self, forKey: .maxAtmospheringSpeed)
        self.cargoCapacity = try container.decodeIfPresent(String.self, forKey: .cargoCapacity)
        self.consumables = try container.decodeIfPresent(String.self, forKey: .consumables)
        self.url = try container.decode(URL.self, forKey: .url)

        if let urls = try container.decodeIfPresent([URL].self, forKey: .films) {
            for url in urls {
                api.getFilm(url: url) { (film) in
                    guard let film = film else { return }
                    self.addToFilms(film)
                }
            }
        }
        if let urls = try container.decodeIfPresent([URL].self, forKey: .pilots) {
            for url in urls {
                api.getPerson(url: url) { (person) in
                    guard let person = person else { return }
                    self.addToPilots(person)
                }
            }
        }
        
    }
}
