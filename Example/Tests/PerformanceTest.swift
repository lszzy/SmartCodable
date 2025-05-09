import XCTest
import SmartCodable


class PerformanceTest: XCTestCase {
    var data: Data = Data()

    override func setUp() {
        super.setUp()
        data = airportsJSON(count: count)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    

    //【1000】 0.015。 使用JSONDecoder解析遵循Codable协议的model
    func testCodable() {
        measure {
            do {
                let decoder = JSONDecoder()
                let objects = try decoder.decode([CodableModel].self, from: data)
                XCTAssertEqual(objects.count, count)
            } catch {
                XCTAssertNil(error)
            }
        }
    }
    
    //【1000】0.026 使用SmartJSONDecoder解析遵循Codable协议的model
    func testCleanJsonDecoder() {
        measure {
            do {
                let decoder = SmartJSONDecoder()
                let objects = try decoder.decode([CodableModel].self, from: data)
                XCTAssertEqual(objects.count, count)
            } catch {
                XCTAssertNil(error)
            }
        }
    }
    
    //【1000】 0.046 使用SmartJSONDecoder解析遵循SmartCodable协议的model
    func testSmartJsonDecoder() {
        measure {
            do {
                let decoder = SmartJSONDecoder()
                let objects = try decoder.decode([SmartModel].self, from: data)
                XCTAssertEqual(objects.count, count)
            } catch {
                XCTAssertNil(error)
            }
        }
    }
}

// Codable & CleanJSON
struct CodableModel: Codable {
    let name: String
    let iata: String
    let icao: String
    let coordinates: [Double]
//    let runways: [Runway]

//    struct Runway: Codable {
//        enum Surface: String, Codable {
//            case rigid, flexible, gravel, sealed, unpaved, other
//        }
//        
//        let direction: String
//        let distance: Int
//        let surface: Surface
//    }
}




// SmartCodable
struct SmartModel: SmartCodable {
    
    var name: String?
    var iata: String?
    var icao: String?
    var coordinates: [Double]?
//    var runways: [Runway]?
//    
//    struct Runway: SmartCodable {
//        enum Surface: String, SmartCaseDefaultable {            
//            case rigid, flexible, gravel, sealed, unpaved, other
//        }
//        
//        var direction: String?
//        var distance: Int?
//        var surface: Surface?
//    }
}
