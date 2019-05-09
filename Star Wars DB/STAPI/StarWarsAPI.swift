//
//  StarWarsAPI.swift
//  Star Wars DB
//
//  Created by Mark Townsend on 4/11/19.
//  Copyright © 2019 Mark Townsend. All rights reserved.
//

import Foundation
import CoreData

public class StarWarsAPI {
    private let baseURL = "https://swapi.co/api/"
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    enum RootElements: String {
        case people
        case films
        case starships
        case vehicles
        case species
        case planets
    }

    func get<T:StarWarsManagedObject>(url: URL, completionHandler:@escaping (T?)->Void) {
        if let starWarsObject = T.get(url: url) {
            completionHandler(starWarsObject as? T)
            return
        }
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    print("Server error: \(String(describing: response))")
                    return
            }
            if let data = data {
                let decoder = StarWarsJSONDecoder()
                DispatchQueue.main.async {
                    do {
                        let starWarsObject = try decoder.decode(T.self, from: data) as T
                        DataManager.shared.saveContext()
                        completionHandler(starWarsObject)
                    } catch {
                        print(error)
                        completionHandler(nil)
                    }

                }
            }
        }
        task.resume()
    }

    public func getPerson(url: URL, completionHandler:@escaping (PersonMO?)->Void) {
        get(url: url, completionHandler: completionHandler)
    }

    public func getPlanet(url: URL, completionHandler:@escaping (PlanetMO?)->Void) {
        get(url: url, completionHandler: completionHandler)
    }

    public func getFilm(url: URL, completionHandler:@escaping (FilmMO?)->Void) {
        get(url: url, completionHandler: completionHandler)
    }

    public func getStarship(url: URL, completionHandler:@escaping (StarshipMO?)->Void) {
        get(url: url, completionHandler: completionHandler)
    }

    public func getVehicle(url: URL, completionHandler:@escaping (VehicleMO?)->Void) {
        get(url: url, completionHandler: completionHandler)
    }

    public func getSpecies(url: URL, completionHandler:@escaping (SpeciesMO?)->Void) {
        get(url: url, completionHandler: completionHandler)
    }

    public func allVehicles(next: URL? = nil, completionHandler:@escaping ([VehicleMO]?)->Void) {
        struct Response: Decodable {
            var results:[VehicleMO]
            var next: URL?
        }

        guard let url = URL(string: baseURL + "vehicles/") else {
            completionHandler([])
            return
        }

        let session = URLSession.shared
        let task = session.dataTask(with: next ?? url) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    print("Server error: \(String(describing: response))")
                    return
            }
            if let data = data {
                let decoder = StarWarsJSONDecoder()
                guard let codingUseInfoKeyMoc = CodingUserInfoKey.managedObjectContext,
                    let moc = decoder.userInfo[codingUseInfoKeyMoc] as? NSManagedObjectContext else {
                        completionHandler([])
                        return
                }
                DispatchQueue.main.async {
                    do {
                        let response = try decoder.decode(Response.self, from: data)
                        try moc.save()
                        if let next = response.next {
                            self.allVehicles(next: next, completionHandler: completionHandler)
                        } else {
                            let fetchRequest: NSFetchRequest<VehicleMO> = VehicleMO.fetchRequest()
                            let result = try moc.fetch(fetchRequest)
                            completionHandler(result)
                        }
                    } catch {
                        print(error)
                        completionHandler([])
                    }
                }
            }
        }
        task.resume()
    }

    public func allFilms(next: URL? = nil, completionHandler:@escaping ([FilmMO]?)->Void) {
        struct Response: Decodable {
            var results:[FilmMO]
            var next: URL?
        }

        guard let url = URL(string: baseURL + "films/") else {
            completionHandler([])
            return
        }

        let session = URLSession.shared
        let task = session.dataTask(with: next ?? url) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    print("Server error: \(String(describing: response))")
                    return
            }
            if let data = data {
                let decoder = StarWarsJSONDecoder()
                guard let codingUseInfoKeyMoc = CodingUserInfoKey.managedObjectContext,
                    let moc = decoder.userInfo[codingUseInfoKeyMoc] as? NSManagedObjectContext else {
                        completionHandler([])
                        return
                }
                DispatchQueue.main.async {
                    do {
                        let response = try decoder.decode(Response.self, from: data)
                        try moc.save()
                        if let next = response.next {
                            self.allFilms(next: next, completionHandler: completionHandler)
                        } else {
                            let fetchRequest: NSFetchRequest<FilmMO> = FilmMO.fetchRequest()
                            let result = try moc.fetch(fetchRequest)
                            completionHandler(result)
                        }
                    } catch {
                        print(error)
                        completionHandler([])
                    }
                }
            }
        }
        task.resume()
    }

    public func allSpecies(next: URL? = nil, completionHandler:@escaping ([SpeciesMO]?)->Void) {
        struct Response: Decodable {
            var results:[SpeciesMO]
            var next: URL?
        }

        guard let url = URL(string: baseURL + "species/") else {
            completionHandler([])
            return
        }

        let session = URLSession.shared
        let task = session.dataTask(with: next ?? url) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    print("Server error: \(String(describing: response))")
                    return
            }
            if let data = data {
                let decoder = StarWarsJSONDecoder()
                guard let codingUseInfoKeyMoc = CodingUserInfoKey.managedObjectContext,
                    let moc = decoder.userInfo[codingUseInfoKeyMoc] as? NSManagedObjectContext else {
                        completionHandler([])
                        return
                }
                DispatchQueue.main.async {
                    do {
                        let response = try decoder.decode(Response.self, from: data)
                        try moc.save()
                        if let next = response.next {
                            self.allSpecies(next: next, completionHandler: completionHandler)
                        } else {
                            let fetchRequest: NSFetchRequest<SpeciesMO> = SpeciesMO.fetchRequest()
                            let result = try moc.fetch(fetchRequest)
                            completionHandler(result)
                        }
                    } catch {
                        print(error)
                        completionHandler([])
                    }
                }
            }
        }
        task.resume()
    }

    public func allPlanets(next: URL? = nil, completionHandler:@escaping ([PlanetMO]?)->Void) {
        struct Response: Decodable {
            var results:[PlanetMO]
            var next: URL?
        }

        guard let url = URL(string: baseURL + "planets/") else {
            completionHandler([])
            return
        }

        let session = URLSession.shared
        let task = session.dataTask(with: next ?? url) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    print("Server error: \(String(describing: response))")
                    return
            }
            if let data = data {
                let decoder = StarWarsJSONDecoder()
                guard let codingUseInfoKeyMoc = CodingUserInfoKey.managedObjectContext,
                    let moc = decoder.userInfo[codingUseInfoKeyMoc] as? NSManagedObjectContext else {
                        completionHandler([])
                        return
                }
                DispatchQueue.main.async {
                    do {
                        let response = try decoder.decode(Response.self, from: data)
                        try moc.save()
                        if let next = response.next {
                            self.allPlanets(next: next, completionHandler: completionHandler)
                        } else {
                            let fetchRequest: NSFetchRequest<PlanetMO> = PlanetMO.fetchRequest()
                            let result = try moc.fetch(fetchRequest)
                            completionHandler(result)
                        }
                    } catch {
                        print(error)
                        completionHandler([])
                    }
                }
            }
        }
        task.resume()
    }

    public func allStarships(next: URL? = nil, completionHandler:@escaping ([StarshipMO]?)->Void) {
        struct Response: Decodable {
            var results:[StarshipMO]
            var next: URL?
        }

        guard let url = URL(string: baseURL + "starships/") else {
            completionHandler([])
            return
        }

        let session = URLSession.shared
        let task = session.dataTask(with: next ?? url) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    print("Server error: \(String(describing: response))")
                    return
            }
            if let data = data {
                let decoder = StarWarsJSONDecoder()
                guard let codingUseInfoKeyMoc = CodingUserInfoKey.managedObjectContext,
                    let moc = decoder.userInfo[codingUseInfoKeyMoc] as? NSManagedObjectContext else {
                        completionHandler([])
                        return
                }
                DispatchQueue.main.async {
                    do {
                        let response = try decoder.decode(Response.self, from: data)
                        try moc.save()
                        if let next = response.next {
                            self.allStarships(next: next, completionHandler: completionHandler)
                        } else {
                            let fetchRequest: NSFetchRequest<StarshipMO> = StarshipMO.fetchRequest()
                            let result = try moc.fetch(fetchRequest)
                            completionHandler(result)
                        }
                    } catch {
                        print(error)
                        completionHandler([])
                    }
                }
            }
        }
        task.resume()
    }

    public func allPeople(next: URL? = nil, completionHandler:@escaping ([PersonMO]?)->Void) {
        struct Response: Decodable {
            var results:[PersonMO]
            var next: URL?
        }

        guard let url = URL(string: baseURL + "people/") else {
            completionHandler([])
            return
        }

        let session = URLSession.shared
        let task = session.dataTask(with: next ?? url) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    print("Server error: \(String(describing: response))")
                    return
            }
            if let data = data {
                let decoder = StarWarsJSONDecoder()
                guard let codingUseInfoKeyMoc = CodingUserInfoKey.managedObjectContext,
                let moc = decoder.userInfo[codingUseInfoKeyMoc] as? NSManagedObjectContext else {
                    completionHandler([])
                    return
                }
                DispatchQueue.main.async {
                    do {
                        let response = try decoder.decode(Response.self, from: data)
                        try moc.save()
                        if let next = response.next {
                            self.allPeople(next: next, completionHandler: completionHandler)
                        } else {
                            let fetchRequest: NSFetchRequest<PersonMO> = PersonMO.fetchRequest()
                            let result = try moc.fetch(fetchRequest)
                            completionHandler(result)
                        }
                    } catch {
                        print(error)
                        completionHandler([])
                    }
                }
            }

        }
        task.resume()
    }
}
