//
//  APIManager.swift
//  FightClub
//
//  Created by Anagha Wadkar on 24/04/21.
//

import Foundation

// MARK: - API endpoints enum for different APIs used in App
enum APIEndPoint {
    case  movieList
    case synopsis(id: Int)
    case credits(id: Int)
    case similarMovies(id: Int)
    case reviews(id: Int)
    
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
        case .movieList, .synopsis, .credits, .similarMovies, .reviews:
            return "GET"
        }
    }
    
    var rawValue: String {
        switch self {
        case .movieList:
            return  "movieList"
        case .synopsis:
            return "synopsis"
        case .credits:
            return "credits"
        case .similarMovies:
            return "similarMovies"
        case .reviews:
            return "reviews"
        }
    }
    
    var pathForResource: String {
        switch self {
        case .synopsis(let id), .credits(let id), .similarMovies(let id), .reviews(let id):
            let url = baseURL + pathforResource(with: self.rawValue)
            return url.replacingOccurrences(of: "{id}", with: String(id))
        default:
            return baseURL + pathforResource(with: self.rawValue)
        }
        
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
        case .synopsis(id: let id):
            //TODO:
            completion(nil, nil)
        case .credits(id: let id):
            //TODO:
            completion(nil, nil)
        case .similarMovies(id: let id):
            //TODO:
            completion(nil, nil)
        case .reviews(id: let id):
            //TODO:
            completion(nil, nil)
        }
        completion(nil,nil)
    }
}

