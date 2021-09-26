//
//  MapFeatureModel.swift
//  AcmeMap
//
//  Created by Glenn Howes on 9/25/21.
//

import Foundation
import MapKit

/// A viewModel that will be driving the MainViewController
class MapFeatureModel : NSObject, ObservableObject
{
    enum MapFeatureErrors : LocalizedError
    {
        case noData
        var errorDescription: String?
        {
            switch self
            {
                case .noData:
                    return NSLocalizedString("Server returned no data", comment: "")
            }
        }
    }
    
    @Published var lastError : Error?
    @Published var annotations : [MapFeatureAnnotation]?
    @Published var features : [MapFeature]?
    {
        didSet
        {
            self.annotations = features?.map{MapFeatureAnnotation(feature: $0)}
        }
    }
    
    private var activeTask : URLSessionDataTask?
    {
        willSet
        {
            self.activeTask?.cancel()
        }
    }
    
    private func downloadData(completion: @escaping (Result<MapFeatureCollection, Error>)->Void)
    {
        let url = URL(string:"https://assets.acmeaom.com/interview-project/locations.json")!
        // using a URLRequest so I can ignore the cache and test the error handling code.
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 20.0)
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard error == nil else
            {
                completion(.failure(error!))
                return
            }
            
            guard let data = data, !data.isEmpty else
            {
                completion(.failure(MapFeatureErrors.noData))
                return
            }
            
            do
            {
                let collection = try JSONDecoder().decode(MapFeatureCollection.self, from: data)
                completion(.success(collection))
            }
            catch
            {
                completion(.failure(error))
            }
        }
        self.activeTask = dataTask
        dataTask.resume()
    }
    
    public func refresh()
    {
        self.downloadData
        {
            fetchResult in
            OperationQueue.main.addOperation {
                [weak self] in
                guard let strongSelf = self else
                {
                    return
                }
                strongSelf.activeTask = nil
                switch fetchResult
                {
                    case .failure(let anError):
                        strongSelf.lastError = anError
                    case .success(let newCollection):
                        strongSelf.lastError = nil
                        strongSelf.features = newCollection.features
                }
            }
        }
    }
}
