//
//  Utility.swift
//  FightClub
//
//  Created by Anagha Wadkar on 24/04/21.
//

import Foundation
import UIKit

extension UIImageView {
    func load(urlString: String, scaleFactor: CGFloat = 1.0) {
        self.image = UIImage(named: "defaultImage")
        if let posterImage = DataManager.shared.cache.object(forKey: urlString as NSString) {
            DispatchQueue.main.async {
                self.image = posterImage
            }
        } else {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                if let url = URL(string: "https://image.tmdb.org/t/p/w500" + urlString) {
                    var urlRequest = URLRequest(url: url)
                    urlRequest.httpMethod = "GET"
                    let task = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
                        if error == nil {
                            if let data = data {
                                if let image = UIImage(data: data) {
                                    DataManager.shared.cache.setObject(image, forKey: urlString as NSString)
                                    DispatchQueue.main.async {
                                        self?.image = image
                                    }
                                }
                            }
                        }
                    }
                    task.resume()
                }
            }
            
        }
        
    }
}
