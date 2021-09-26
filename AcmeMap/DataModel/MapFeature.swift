//
//  MapFeature.swift
//  AcmeMap
//
//  Created by Glenn Howes on 9/24/21.
//

import Foundation
import MapKit


/// Errors that could be thrown if defects are found in the data retrieved from the server
public enum MapFeatureParseError : LocalizedError
{
    case badType
    case incomplete
    case corrupt
    
    public var errorDescription: String?
    {
        switch self
        {
            case .badType:
                return NSLocalizedString("Server returned unexpected data", comment: "")
            case .incomplete:
                return NSLocalizedString("Server returned incomplete data", comment: "")
            case .corrupt:
                return NSLocalizedString("Server returned bad data", comment: "")
        }
    }
}

/// struct that encapsulates a list of "Features" to display on the map
public struct MapFeatureCollection : Decodable
{
    let features : [MapFeature]
    private enum CodingKeys : String, CodingKey
    {
        case type, features
    }
    
    public init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        guard type == "FeatureCollection" else
        {
            throw MapFeatureParseError.badType
        }
        self.features = try container.decode([MapFeature].self, forKey: .features)
    }
}

/// struct to encapsulate the "Feature" data we are retrieving from the JSON
public struct MapFeature : Decodable
{
    public let coordinate : CLLocationCoordinate2D
    let name : String
    let id : String
    
    private enum CodingKeys : String, CodingKey
    {
        case id, type, geometry, properties
    }
    
    /// Struct to make it easy to dig into the JSON and retrieve the coordinates
    private struct MapPoint : Decodable
    {
        let coordinate : CLLocationCoordinate2D
        private enum CodingKeys : String, CodingKey{case type, coordinates}
        public init(from decoder: Decoder) throws
        {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let type = try container.decode(String.self, forKey: .type)
            guard type == "Point" else
            {
                throw MapFeatureParseError.badType
            }
            let rawCoordinates = try container.decode([Double].self, forKey: .coordinates)
            if rawCoordinates.count < 2
            {
                throw MapFeatureParseError.incomplete
            }
            else if rawCoordinates.count > 2
            {
                throw MapFeatureParseError.corrupt
            }
            self.coordinate = CLLocationCoordinate2D(latitude: rawCoordinates.last!, longitude: rawCoordinates.first!)
        }
    }
    
    public init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        guard type == "Feature" else
        {
            throw MapFeatureParseError.badType
        }
        guard let name = try container.decode(Dictionary<String,String>.self, forKey: .properties)["name"] else
        {
            throw MapFeatureParseError.incomplete
        }
        
        self.id = try container.decode(String.self, forKey: .id)
        self.coordinate = try container.decode(MapPoint.self, forKey: .geometry).coordinate
        self.name = name
    }
}

extension MapFeature : Equatable
{
    public static func == (lhs: MapFeature, rhs: MapFeature) -> Bool {
        return lhs.id == rhs.id
    }
}

extension MapFeature : Locatable
{
}

/// MapFeatureAnnotation
///  A MapViewAnnotation that wraps  a MapFeature structure
public class MapFeatureAnnotation : NSObject, MKAnnotation, Identifiable
{
    let feature : MapFeature

    public var id : String
    {
        return feature.id
    }
    
    public init(feature : MapFeature)
    {
        self.feature = feature
    }
    
    public override func isEqual(_ object: Any?) -> Bool {
        guard let itsFeature = (object as? MapFeatureAnnotation)?.feature
        else
        {
            return false
        }
        return itsFeature == feature
    }
    
    ///  Figure out the annotations which will have to be removed, and the ones that will have to be added
    /// - Parameters:
    ///   - oldAnnotations: the annotations that were already in the map view
    ///   - newAnnotations: the annotations that the map view should end up with
    /// - Returns: a tuple with the annotations to remove and the annotations to add to the map view
    static func determineActiveAnnotations(oldAnnotations: [MKAnnotation], newAnnotations : [MapFeatureAnnotation]) -> (toRemove: [MapFeatureAnnotation], toAdd: [MapFeatureAnnotation])
    {
        let newSet = Set(newAnnotations)
        let existingAnnotations = oldAnnotations.compactMap{$0 as? MapFeatureAnnotation}
        let annotationsToRemove = existingAnnotations.filter
        {
            !newSet.contains($0)
        }
        let existingSet = Set(existingAnnotations)
        let annotationsToAdd = newAnnotations.filter
        {
            
            !existingSet.contains($0)
        }
        return(toRemove: annotationsToRemove, toAdd: annotationsToAdd)
    }
    
    // MKAnnotation
    public var coordinate: CLLocationCoordinate2D
    {
        return feature.coordinate
    }
    
    // MKAnnotation
    public var title : String?
    {
        return feature.name
    }
}
