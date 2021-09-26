//
//  Locatable.swift
//  AcmeMap
//
//  Created by Glenn Howes on 9/26/21.
//

import Foundation
import CoreLocation

public protocol Locatable
{
    var coordinate : CLLocationCoordinate2D {get}
}

extension Locatable
{
    /// compute the havsine value for an angle
    /// - Parameter angle: an angle in radians, not the normal degrees found in latitudes and longittues
    /// - Returns: a havasine value for the input value
    private func hav(_ angleInRadians: CLLocationDegrees) -> Double
    {
        let sin = sin(angleInRadians / 2.0)
        return sin * sin
    }
    /// Returns the distance (in meters) from one MapFeature struct to another
    /// - Parameter otherLocation: the feature to compute the distance from
    /// - Returns: CLLocationDistance in meters
    /// - Note:  https://en.wikipedia.org/wiki/Haversine_formula
    public func distance(from otherLocation: Locatable) -> CLLocationDistance
    {
        let approximateEarthRadius = 6_367.0 // kilometers varies a bit so this calculation will be off in absolute terms
        
        let φ₁ = self.coordinate.latitude * CLLocationDegrees.pi / 180.0 // in radians
        let φ₂ = otherLocation.coordinate.latitude * CLLocationDegrees.pi / 180.0
        let λ₁ = self.coordinate.longitude * CLLocationDegrees.pi / 180.0
        let λ₂ = otherLocation.coordinate.longitude * CLLocationDegrees.pi / 180.0
        
        let result : CLLocationDistance = asin(sqrt(hav(φ₂-φ₁) + Double(cos(φ₁) * cos(φ₂)) * hav(λ₂-λ₁))) * 2.0 * approximateEarthRadius
        
        return result * 1000.0 // convert to meters
    }
}

public extension Sequence where Element : Locatable
{
    /// Sort a list of locations in terms of distance from an item
    /// - Parameter listOfFeatures:
    /// - Returns: a sorted array in ascending order of distance from self
    func sort(byDistanceFrom location: Locatable) -> [Element]
    {
        return self.sorted(by:{
            feature0, feature1 in
            return feature0.distance(from: location) < feature1.distance(from: location)
        })
    }
}

// Not used in this app, but a demonstration of why the Protocol Locatable would be useful
extension CLLocation : Locatable
{
}

// Not used in this app, but a demonstration of why the Protocol Locatable would be useful
extension CLLocationCoordinate2D : Locatable
{
    public var coordinate: CLLocationCoordinate2D {
        return self
    }
}
