//
//  BookSearchLibraryTests.swift
//  BookSearchLibraryTests
//
//  Created by K Y on 11/18/19.
//  Copyright © 2019 Consultant. All rights reserved.
//

import XCTest
@testable import BookSearchLibrary

class BookSearchLibraryTests: XCTestCase {
    
    let session = URLSession(configuration: .default)
    let coreData = CoreDataManager()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_parse_mock_sherlock() {
        let network = MockNetworkService(session, coreData.mainContext)
        let vm = BookViewModel(network, coreData: coreData)
        var books: [BookModel] = []
        vm.bind {
            books = vm.books
            print("There are \(vm.books.count) books about Sherlock")
        }
        vm.download(search: "test-dummy-string")
        
        XCTAssertEqual(books.count, 10, "Error: there are not 10 books")
    }
    
    func test_download_sherlock() {
        // 1. For asynchronous tests, make an Expectation
        let expectation = XCTestExpectation(description: "test downloading sherlock")
        let network = DecodableNetwork(session, coreData.mainContext)
        let vm = BookViewModel(network, coreData: coreData)
        var books: [BookModel] = []
        vm.bind {
            print("There are \(vm.books.count) books about Sherlock")
            books = vm.books
            // 3. fulfill the expectation
            expectation.fulfill()
        }
        vm.download(search: "Sherlock Holmes")
        
        // 2. wait for the download to finish.
        wait(for: [expectation], timeout: 2.0)
        
        XCTAssertEqual(books.count, 10, "Error: there are not 10 books")
    }
    
}
