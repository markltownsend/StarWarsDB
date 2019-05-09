//
//  SpeciesMO+CoreDataClass.swift
//  Star Wars DB
//
//  Created by Mark Townsend on 4/11/19.
//  Copyright © 2019 Mark Townsend. All rights reserved.
//
//

import Foundation
import CoreData

@objc(SpeciesMO)
public class SpeciesMO: NSManagedObject, StarWarsManagedObject {
    enum CodingKeys: String, CodingKey {
        case name
        case classification
        case designation
        case averageHeight = "average_height"
        case averageLifespan = "average_lifespan"
        case eyeColors = "eye_colors"
        case hairColors = "hair_colors"
        case skinColors = "skin_colors"
        case language
        case homeworld
        case people
        case films
        case url
        case created
        case edited
    }

    // MARK: - Decodable
    public required convenience init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Species", in: managedObjectContext) else {
                fatalError("Couldn't decode Species")
        }

        let api = StarWarsAPI()

        self.init(entity: entity, insertInto: managedObjectContext)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.classification = try container.decodeIfPresent(String.self, forKey: .classification)
        self.designation = try container.decodeIfPresent(String.self, forKey: .designation)
        self.averageHeight = try container.decodeIfPresent(String.self, forKey: .averageHeight)
        self.eyeColors = try container.decodeIfPresent(String.self, forKey: .eyeColors)
        self.hairColors = try container.decodeIfPresent(String.self, forKey: .hairColors)
        self.skinColors = try container.decodeIfPresent(String.self, forKey: .skinColors)
        self.language = try container.decodeIfPresent(String.self, forKey: .language)
        if let planetURL = try container.decodeIfPresent(URL.self, forKey: .homeworld) {
            api.getPlanet(url: planetURL) { (planet) in
                guard let planet = planet else { return }
                self.homeworld = planet
            }
        }
        self.url = try container.decode(URL.self, forKey: .url)

        if let urls = try container.decodeIfPresent([URL].self, forKey: .films) {
            for url in urls {
                api.getFilm(url: url) { (film) in
                    guard let film = film else { return }
                    self.addToFilms(film)
                }
            }
        }
        if let urls = try container.decodeIfPresent([URL].self, forKey: .people) {
            for url in urls {
                api.getPerson(url: url) { (person) in
                    guard let person = person else { return }
                    self.addToPeople(person)
                }
            }
        }
    }

}
