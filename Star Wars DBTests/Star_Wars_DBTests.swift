//
//  Star_Wars_DBTests.swift
//  Star Wars DBTests
//
//  Created by Mark Townsend on 3/27/19.
//  Copyright © 2019 Mark Townsend. All rights reserved.
//

import XCTest
@testable import Star_Wars_DB

class Star_Wars_DBTests: XCTestCase {
    let api = StarWarsAPI()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAllPeople() {
        let doneExpectation = expectation(description: "allPeopleCompleted")

        api.allPeople { (objects) in
            guard let objects = objects else {
                return
            }
            XCTAssertGreaterThan(objects.count, 0)
            doneExpectation.fulfill()
        }
        waitForExpectations(timeout: 600) { (error) in
            if let error = error {
                print("\(error)")
            }
        }
    }

    func testAllVehicles() {
        let doneExpectation = expectation(description: "allVehiclesCompleted")

        api.allVehicles { (objects) in
            guard let objects = objects else {
                return
            }
            XCTAssertGreaterThan(objects.count, 0)
            doneExpectation.fulfill()
        }
        waitForExpectations(timeout: 600) { (error) in
            if let error = error {
                print("\(error)")
            }
        }
    }

    func testAllFilms() {
        let doneExpectation = expectation(description: "allFilmsCompleted")

        api.allFilms { (objects) in
            guard let objects = objects else {
                return
            }
            XCTAssertGreaterThan(objects.count, 0)
            doneExpectation.fulfill()
        }
        waitForExpectations(timeout: 600) { (error) in
            if let error = error {
                print("\(error)")
            }
        }

    }

    func testAllSpecies() {
        let doneExpectation = expectation(description: "allSpeciesCompleted")

        api.allSpecies { (objects) in
            guard let objects = objects else {
                return
            }
            XCTAssertGreaterThan(objects.count, 0)
            doneExpectation.fulfill()
        }
        waitForExpectations(timeout: 600) { (error) in
            if let error = error {
                print("\(error)")
            }
        }

    }

    func testAllPlanets() {
        let doneExpectation = expectation(description: "allPlanetsCompleted")

        api.allPlanets { (objects) in
            guard let objects = objects else {
                return
            }
            XCTAssertGreaterThan(objects.count, 0)
            doneExpectation.fulfill()
        }
        waitForExpectations(timeout: 600) { (error) in
            if let error = error {
                print("\(error)")
            }
        }

    }

    func testAllStarships() {
        let doneExpectation = expectation(description: "allStarshipsCompleted")

        api.allStarships { (objects) in
            guard let objects = objects else {
                return
            }
            XCTAssertGreaterThan(objects.count, 0)
            doneExpectation.fulfill()
        }
        waitForExpectations(timeout: 600) { (error) in
            if let error = error {
                print("\(error)")
            }
        }

    }

//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
