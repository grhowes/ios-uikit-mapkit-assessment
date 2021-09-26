//
//  AcmeMapTests.swift
//  AcmeMapTests
//

import XCTest
import CoreLocation
@testable import AcmeMap

class AcmeMapTests: XCTestCase {
    
    let featureCollectionJSON = """
{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "geometry": {
        "type": "Point",
        "coordinates": [
          149.98458041136354,
          -34.98520411042454
        ]
      },
      "properties": {
        "name": "Alpha"
      },
      "id": "2298eb8d-255e-4198-a20c-cc9c2eac0cf7"
    },
    {
      "type": "Feature",
      "geometry": {
        "type": "Point",
        "coordinates": [
          -67.09898354941409,
          45.042099781891125
        ]
      },
      "properties": {
        "name": "Bravo"
      },
      "id": "a3a2d144-4d0e-4bec-9773-4566f74846ba"
    },
    {
      "type": "Feature",
      "geometry": {
        "type": "Point",
        "coordinates": [
          -115.42362,
          -57.98449
        ]
      },
      "properties": {
        "name": "Charlie"
      },
      "id": "84e0c359-1e8a-434a-963a-613771dbe2c9"
    },
    {
      "type": "Feature",
      "properties": {
        "name": "Delta"
      },
      "id": "50a5f829-0955-4c66-82b0-61b0606309e9",
      "geometry": {
        "type": "Point",
        "coordinates": [
          81.9140625,
          56.75272287205736
        ]
      }
    },
    {
      "type": "Feature",
      "properties": {
        "name": "Echo"
      },
      "id": "2abca2a7-d768-4db2-95e2-09002df94362",
      "geometry": {
        "type": "Point",
        "coordinates": [
          29.179687499999996,
          -37.99616267972812
        ]
      }
    },
    {
      "type": "Feature",
      "properties": {
        "name": "Foxtrot"
      },
      "id": "6b9fdafb-4d9b-4255-aa1a-2c52a1e597b5",
      "geometry": {
        "type": "Point",
        "coordinates": [
          -130.4296875,
          -4.915832801313164
        ]
      }
    },
    {
      "type": "Feature",
      "properties": {
        "name": "Golf"
      },
      "id": "14147ae6-0852-4a46-92e4-8fcc037562b1",
      "geometry": {
        "type": "Point",
        "coordinates": [
          -108.984375,
          38.8225909761771
        ]
      }
    },
    {
      "type": "Feature",
      "properties": {
        "name": "Hotel"
      },
      "id": "d8010c95-e91b-4f53-b687-5c9e368ab582",
      "geometry": {
        "type": "Point",
        "coordinates": [
          70.6640625,
          -30.44867367928756
        ]
      }
    },
    {
      "type": "Feature",
      "properties": {
        "name": "India"
      },
      "id": "83c49015-d46b-4636-9e06-644c8e7e9c88",
      "geometry": {
        "type": "Point",
        "coordinates": [
          117.7734375,
          68.39918004344189
        ]
      }
    },
    {
      "type": "Feature",
      "properties": {
        "name": "Juliett"
      },
      "id": "1dbca7db-05fa-419f-9654-a7587eaaf5a7",
      "geometry": {
        "type": "Point",
        "coordinates": [
          -3.515625,
          30.14512718337613
        ]
      }
    },
    {
      "type": "Feature",
      "properties": {
        "name": "Kilo"
      },
      "id": "633fdb3a-f696-4227-bc33-a5cfb80f90a9",
      "geometry": {
        "type": "Point",
        "coordinates": [
          -40.078125,
          -39.368279149160124
        ]
      }
    }
  ]
}

"""
    
 let badFeatureJSONType     =  """
{
    "type": "BadType",
    "features": [{
        "type": "Feature",
        "geometry": {
            "type": "Point",
            "coordinates": [
                149.98458041136354,
                -34.98520411042454
            ]
        },
        "properties": {
            "name": "Alpha"
        },
        "id": "2298eb8d-255e-4198-a20c-cc9c2eac0cf7"

    }]
}
"""
    
    let missingNameJSONType     =  """
       {
         "type": "FeatureCollection",
         "features": [
           {
             "type": "Feature",
             "geometry": {
               "type": "Point",
               "coordinates": [
                 149.98458041136354,
                 -34.98520411042454
               ]
             },
             "properties": {
             },
             "id": "2298eb8d-255e-4198-a20c-cc9c2eac0cf7"
           
    }]
}
"""
    
    let missingCoordinateJSONType     =  """
       {
         "type": "FeatureCollection",
         "features": [
           {
             "type": "Feature",
             "properties": {
                "name": "Kilo"
             },
             "id": "2298eb8d-255e-4198-a20c-cc9c2eac0cf7"
           
    }]
}
"""
    
    let missingIDJSONType     =  """
       {
         "type": "FeatureCollection",
         "features": [
           {
             "type": "Feature",
             "geometry": {
               "type": "Point",
               "coordinates": [
                 149.98458041136354,
                 -34.98520411042454
               ]
             },
             "properties": {
               "name": "Alpha"
             }

    }]
}
"""
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    private func createFeatureCollection() throws -> MapFeatureCollection
    {
        let data = featureCollectionJSON.data(using: .utf8, allowLossyConversion: false)!
        let result = try JSONDecoder().decode(MapFeatureCollection.self, from: data)
       return result
    }

    func test_parse_feature_collection() throws {
        let collection = try createFeatureCollection()
        XCTAssert(!collection.features.isEmpty, "MapFeatureCollection: Found no Features")
        XCTAssertEqual(collection.features.count, 11, "MapFeatureCollection: Expected 11, got \(collection.features.count)")
        XCTAssertEqual(collection.features.last?.name, "Kilo", "MapFeatureCollection: expected 'Kilo', got \(collection.features.last?.name ?? "none")")
        XCTAssertEqual(collection.features.last?.id, "633fdb3a-f696-4227-bc33-a5cfb80f90a9", "MapFeatureCollection: expected '633fdb3a-f696-4227-bc33-a5cfb80f90a9', got \(collection.features.last?.id ?? "none")")
        
        for aFeature in collection.features
        {
            XCTAssertTrue(CLLocationCoordinate2DIsValid(aFeature.coordinate), "Invalid location: \(aFeature.coordinate)")
        }
    }
    

    
    func test_bad_JSON_feature_collection() throws
    {
        let badFeatureTypeData = badFeatureJSONType.data(using: .utf8, allowLossyConversion: false)!
        XCTAssertThrowsError(try JSONDecoder().decode(MapFeatureCollection.self, from: badFeatureTypeData), "MapFeatureCollection: should have thrown bad Feature type")
        {
            XCTAssert($0 as? MapFeatureParseError == .badType, "MapFeatureCollection: unexpected thrown error \($0.localizedDescription)")
        }
        
        
        let missingNameTypeData = missingNameJSONType.data(using: .utf8, allowLossyConversion: false)!
        XCTAssertThrowsError(try JSONDecoder().decode(MapFeatureCollection.self, from: missingNameTypeData), "MapFeatureCollection: should have thrown missing name")
        {
            XCTAssert($0 as? MapFeatureParseError == .incomplete, "MapFeatureCollection: unexpected thrown error \($0.localizedDescription)")
        }
        
        
        let missingCoordinateTypeData = missingCoordinateJSONType.data(using: .utf8, allowLossyConversion: false)!
        XCTAssertThrowsError(try JSONDecoder().decode(MapFeatureCollection.self, from: missingCoordinateTypeData), "MapFeatureCollection: should have thrown missing coordinates")
        
        let missingIDData = missingIDJSONType.data(using: .utf8, allowLossyConversion: false)!
        XCTAssertThrowsError(try JSONDecoder().decode(MapFeatureCollection.self, from: missingIDData), "MapFeatureCollection: should have thrown missing id")
    }
    
    func test_map_feature_distance () throws
    {
        let collection = try createFeatureCollection()
        
        let features = collection.features
        let firstFeature = features.first!
        
        let sortedFeatures = features.sort(byDistanceFrom: firstFeature)
        XCTAssertEqual(firstFeature.id, sortedFeatures.first!.id)
        
    }
    
    func test_map_diffing() throws
    {
        let collection = try createFeatureCollection()
        let model = MapFeatureModel()
        model.features = Array(collection.features.prefix(upTo: 10))
        XCTAssertEqual(model.features!.count, 10, "Did not parse enough features in test")
        let evenFeatures = model.annotations!.enumerated().compactMap{
            index, feature in
            return (index % 2) == 0 ? feature : nil
        }
        let everyThirdFeatures = model.annotations!.enumerated().compactMap{
            index, feature in
            return (index % 3) == 0 ? feature : nil
        }
        let diff = MapFeatureAnnotation.determineActiveAnnotations(oldAnnotations: everyThirdFeatures, newAnnotations: evenFeatures)
        
        XCTAssertEqual(diff.toAdd.count, 3)
        XCTAssertEqual(diff.toRemove.count, 2)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
