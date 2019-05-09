//
//  PlanetMO+CoreDataClass.swift
//  Star Wars DB
//
//  Created by Mark Townsend on 4/11/19.
//  Copyright © 2019 Mark Townsend. All rights reserved.
//
//

import Foundation
import CoreData

@objc(PlanetMO)
public class PlanetMO: NSManagedObject, StarWarsManagedObject {
    enum CodingKeys: String, CodingKey {
        case name
        case diameter
        case rotationPeriod = "rotation_period"
        case orbitalPeriod = "orbital_period"
        case gravity
        case population
        case climate
        case terrain
        case surfaceWater = "surface_water"
        case residents
        case films
        case url
        case created
        case edited
    }

    // MARK: - Decodable
    public required convenience init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Planet", in: managedObjectContext) else {
                fatalError("Couldn't decode Planet")
        }

        let api = StarWarsAPI()
        
        self.init(entity: entity, insertInto: managedObjectContext)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.diameter = try container.decodeIfPresent(String.self, forKey: .diameter)
        self.rotationPeriod = try container.decodeIfPresent(String.self, forKey: .rotationPeriod)
        self.orbitalPeriod = try container.decodeIfPresent(String.self, forKey: .orbitalPeriod)
        self.gravity = try container.decodeIfPresent(String.self, forKey: .gravity)
        self.population = try container.decodeIfPresent(String.self, forKey: .population)
        self.climate = try container.decodeIfPresent(String.self, forKey: .climate)
        self.terrain = try container.decodeIfPresent(String.self, forKey: .terrain)
        self.surfaceWater = try container.decodeIfPresent(String.self, forKey: .surfaceWater)
        self.url = try container.decodeIfPresent(URL.self, forKey: .url)

        if let urls = try container.decodeIfPresent([URL].self, forKey: .films) {
            for url in urls {
                api.getFilm(url: url) { (film) in
                    guard let film = film else { return }
                    self.addToFilms(film)
                }
            }
        }
        if let urls = try container.decodeIfPresent([URL].self, forKey: .residents) {
            for url in urls {
                api.getPerson(url: url) { (person) in
                    guard let person = person else { return }
                    self.addToResidents(person)
                }
            }
        }
    }
}
