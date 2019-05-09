//
//  PersonMO+CoreDataClass.swift
//  Star Wars DB
//
//  Created by Mark Townsend on 4/11/19.
//  Copyright © 2019 Mark Townsend. All rights reserved.
//
//

import Foundation
import CoreData

@objc(PersonMO)
public class PersonMO: NSManagedObject, StarWarsManagedObject {
    enum CodingKeys: String, CodingKey {
        case name
        case birthYear = "birth_year"
        case eyeColor = "eye_color"
        case gender
        case hairColor = "hair_color"
        case height
        case mass
        case skinColor = "skin_color"
        case homeworld
        case films
        case species
        case starships
        case vehicles
        case url
        case created
        case edited
    }

    // MARK: - Decodable
    public required convenience init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedObjectContext) else {
                fatalError("Couldn't decode Person")
        }
        let api = StarWarsAPI()

        self.init(entity: entity, insertInto: managedObjectContext)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.birthYear = try container.decodeIfPresent(String.self, forKey: .birthYear)
        self.eyeColor = try container.decodeIfPresent(String.self, forKey: .eyeColor)
        self.gender = try container.decodeIfPresent(String.self, forKey: .gender)
        self.hairColor = try container.decodeIfPresent(String.self, forKey: .hairColor)
        self.height = try container.decodeIfPresent(String.self, forKey: .height)
        self.mass = try container.decodeIfPresent(String.self, forKey: .mass)
        self.skinColor = try container.decodeIfPresent(String.self, forKey: .skinColor)
        if let planetURL = try container.decodeIfPresent(URL.self, forKey: .homeworld) {
            api.getPlanet(url: planetURL) { (planet) in
                guard let planet = planet else { return }
                self.homeworld = planet
            }
        }
        if let urls = try container.decodeIfPresent([URL].self, forKey: .films) {
            for url in urls {
                api.getFilm(url: url) { (film) in
                    guard let film = film else { return }
                    self.addToFilms(film)
                }
            }
        }
        if let urls = try container.decodeIfPresent([URL].self, forKey: .species) {
            for url in urls {
                api.getSpecies(url: url) { (species) in
                    guard let species = species else { return }
                    self.addToSpecies(species)
                }
            }
        }
        if let urls = try container.decodeIfPresent([URL].self, forKey: .starships) {
            for url in urls {
                api.getStarship(url: url) { (starship) in
                    guard let starship = starship else { return }
                    self.addToStarships(starship)
                }
            }
        }
        if let urls = try container.decodeIfPresent([URL].self, forKey: .vehicles) {
            for url in urls {
                api.getVehicle(url: url) { (vehicle) in
                    guard let vehicle = vehicle else { return }
                    self.addToVehicles(vehicle)
                }
            }
        }
        self.url = try container.decode(URL.self, forKey: .url)
    }
}
