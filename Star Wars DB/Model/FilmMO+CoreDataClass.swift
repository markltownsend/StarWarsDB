//
//  FilmMO+CoreDataClass.swift
//  Star Wars DB
//
//  Created by Mark Townsend on 4/11/19.
//  Copyright © 2019 Mark Townsend. All rights reserved.
//
//

import Foundation
import CoreData

@objc(FilmMO)
public class FilmMO: NSManagedObject, StarWarsManagedObject {
    static var filmDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }

    enum CodingKeys: String, CodingKey {
        case title
        case episodeId = "episode_id"
        case openingCrawl = "opening_crawl"
        case director
        case producer
        case releaseDate = "release_date"
        case species
        case starships
        case vehicles
        case characters
        case planets
        case url
        case created
        case edited
    }

    // MARK: - Decodable
    public required convenience init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Film", in: managedObjectContext) else {
                fatalError("Couldn't decode Film")
        }

        let api = StarWarsAPI()

        self.init(entity: entity, insertInto: managedObjectContext)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.episodeId = try container.decode(Int64.self, forKey: .episodeId)
        self.openingCrawl = try container.decodeIfPresent(String.self, forKey: .openingCrawl)
        self.director = try container.decodeIfPresent(String.self, forKey: .director)
        self.producer = try container.decodeIfPresent(String.self, forKey: .producer)
        self.releaseDate = try container.decodeIfPresent(Date.self, forKey: .releaseDate)
        self.url = try container.decodeIfPresent(URL.self, forKey: .url)

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
        if let urls = try container.decodeIfPresent([URL].self, forKey: .characters) {
            for url in urls {
                api.getPerson(url: url) { (person) in
                    guard let person = person else { return }
                    self.addToCharacters(person)
                }
            }
        }
        if let urls = try container.decodeIfPresent([URL].self, forKey: .planets) {
            for url in urls {
                api.getPlanet(url: url) { (planet) in
                    guard let planet = planet else { return }
                    self.addToPlanets(planet)
                }
            }
        }
    }
}
