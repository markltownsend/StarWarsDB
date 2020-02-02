//
//  ViewController.swift
//  Star Wars DB
//
//  Created by Mark Townsend on 3/27/19.
//  Copyright © 2019 Mark Townsend. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {
    let api = StarWarsAPI()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
    }
}

// MARK: UITableViewDelegate
extension MainViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let row = StarWarsAPI.RootElements(rawValue: indexPath.row) else { return }
        let nameViewController = NameViewController()
        switch row {
        case .people:
            api.allPeople { (people) in
                DispatchQueue.main.async {
                    nameViewController.objects = people
                    nameViewController.title = "People"
                    self.navigationController?.pushViewController(nameViewController, animated: true)
                }
            }
        case .films:
            api.allFilms { (films) in
                DispatchQueue.main.async {
                    nameViewController.objects = films
                    nameViewController.title = "Films"
                    self.navigationController?.pushViewController(nameViewController, animated: true)
                }
            }
        case .starships:
            api.allStarships { (starships) in
                DispatchQueue.main.async {
                    nameViewController.objects = starships
                    nameViewController.title = "Starships"
                    self.navigationController?.pushViewController(nameViewController, animated: true)
                }
            }
        case .vehicles:
            api.allVehicles { (vehicles) in
                DispatchQueue.main.async {
                    nameViewController.objects = vehicles
                    nameViewController.title = "Vehicles"
                    self.navigationController?.pushViewController(nameViewController, animated: true)
                }
            }
        case .species:
            api.allSpecies { (species) in
                DispatchQueue.main.async {
                    nameViewController.objects = species
                    nameViewController.title = "Species"
                    self.navigationController?.pushViewController(nameViewController, animated: true)
                }
            }
        case .planets:
            api.allPlanets { (planets) in
                DispatchQueue.main.async {
                    nameViewController.objects = planets
                    nameViewController.title = "Planets"
                    self.navigationController?.pushViewController(nameViewController, animated: true)
                }
            }
        }
    }
}

