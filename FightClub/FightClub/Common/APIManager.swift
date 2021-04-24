//
//  APIManager.swift
//  FightClub
//
//  Created by Anagha Wadkar on 24/04/21.
//

import Foundation

// MARK: - API endpoints enum for different APIs used in App
enum APIEndPoint: String {
    case  movieList
    
    /// Fetching path for base URL from info.plist
    var baseURL: String {
        get {
            if let infoDictionary = Bundle.main.infoDictionary, let baseURL = infoDictionary["DataSourceHost"] as? String {
                return baseURL
            }
            return ""
        }
    }
    
    var method: String {
        switch self {
        case .movieList:
            return "GET"
        }
    }
    
    var pathForResource: String {
        return baseURL + pathforResource(with: self.rawValue)
    }
    
    /// Fetching path for API endpoint from info.plist
    private func pathforResource(with name: String) -> String {
        if let infoDictionary = Bundle.main.infoDictionary, let pathsDictionary = infoDictionary["DataSourcePaths"] as? [String: AnyObject], let pathForResource = pathsDictionary[name] as? String {
            return pathForResource
        }
        return ""
    }
}

// MARK: - Making API calls and decoding data received
class APIManager {
    
    /// Shared instance
    static let shared = APIManager()
    
    /// Initiating API request and decoding data into codable models
    func initiateRequest<Type>(for endPoint: APIEndPoint, completion: @escaping (Type?, Error?) -> Void) where Type: Codable {
        if let url =  URL(string: endPoint.pathForResource) {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = endPoint.method
            
            let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                if error == nil {
                    do {
                        let decoder = JSONDecoder()
                        if let data = data {
                            let model = try decoder.decode(Type.self, from: data)
                            completion(model,error)
                        } else {
                            completion(nil, nil)
                        }
                    } catch {
                        completion(nil, error)
                    }
                } else {
                    completion(nil, error)
                }
            }
            task.resume()
            
        } else {
            completion(nil, nil)
        }
    }
    
}

// MARK: - To support making API calls and decoding data received for test cases
class MockAPIManager: APIManager {
    
    var bundle: Bundle
    
    init(with bundle: Bundle) {
        self.bundle = bundle
        super.init()
    }
    
    override func initiateRequest<Type>(for endPoint: APIEndPoint, completion: @escaping (Type?, Error?) -> Void) where Type: Codable {
        
        switch endPoint {
        case .movieList:
            if let path = bundle.path(forResource: "Movie", ofType: "json"), let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: []) {
                do {
                    let decoder = JSONDecoder()
                    let model = try decoder.decode(Type.self, from: data)
                    completion(model,nil)
                } catch {
                    completion(nil, error)
                }
            }
        }
        completion(nil,nil)
    }
}

