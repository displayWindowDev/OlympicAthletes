//
//  Olympic_AthletesTests.swift
//  Olympic AthletesTests
//
//  Created by Mario Matrone on 21/08/23.
//

import XCTest
@testable import Olympic_Athletes

final class Olympic_AthletesTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testRequest() throws {
        let apiClient = APIClient()
        let request = GamesRequest()
        
        let endpoint = apiClient.endpoint(for: request)

        XCTAssertTrue(endpoint.scheme == "https")
        XCTAssertTrue(endpoint.path == "/\(request.resource)")
        XCTAssertTrue(endpoint.host == "ocs-test-backend.onrender.com")
    }
    
    func testParsinaResponse() throws {
        let apiClient = APIClient()
        let request = AthleteRequest(athleteId: "17")

        let json: String = "{\"athlete_id\": \"17\", \"name\": \"Michael\", \"surname\": \"Phelps\", \"bio\": \"Michael Phelps\", \"dateOfBirth\": \"30/06/1985\", \"weight\": 91, \"height\": 193, \"photo_id\": 17}"
        let jsonData: Data = json.data(using: .utf8)!
        let response = try apiClient.parseResponse(request, data: jsonData)
        
        XCTAssertTrue (response.name == "Michael")
    }
    
    func testApiRequestMethod() {
        let apiClient = APIClient()
        let request = AthleteRequest(athleteId: "17")
        
        let expectation = self.expectation(description: "Proper Response come")

        var apiResponse: Athlete?
        
        apiClient.send(request) { response in
            _ = response.map { athlete in
                apiResponse = athlete
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 60, handler: nil)
        XCTAssertNotNil(apiResponse?.name)
    }

    func testPerformanceAthletesPerGame() throws {
        let homePresenter = HomePresenter(view: HomeViewController())
        
        self.measure {
            _ = homePresenter.evaluateAthletes(in: Game(gameId: 2, city: "Rio de Janeiro", year: 2016))
        }
    }

}
