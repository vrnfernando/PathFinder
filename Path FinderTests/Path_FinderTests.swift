//
//  Path_FinderTests.swift
//  Path FinderTests
//
//  Created by Vishwa Fernando on 2024-04-20.
//

import XCTest
import CoreData
@testable import Path_Finder

final class Path_FinderTests: XCTestCase {
    
    var viewController: GameGridViewController!
    
    let persistentContainer = CoreDataManager().persistentContainer
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = storyboard.instantiateViewController(withIdentifier: "GameGridViewController") as? GameGridViewController
        
        _ = viewController.view
    }
    
    // MARK: Save Data TestCase
    func testSaveData(){
        
        let context = persistentContainer.viewContext
        
        viewController.startTime = Date().addingTimeInterval(7200)
        viewController.endTime = Date()
        viewController.numRows = 5
        viewController.numColumns = 5
        viewController.moveCount = 3
        
        viewController.saveResults() // call save data method
        
        //fetch saved data
        let fetchReuqest = NSFetchRequest<NSFetchRequestResult>(entityName:"Results")
        
        do {
            let testResults = try context.fetch(fetchReuqest)
            XCTAssertGreaterThan(testResults.count, 0, "Data saved")
        } catch {
            XCTFail("Failed to Fetch \(error)")
        }
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
