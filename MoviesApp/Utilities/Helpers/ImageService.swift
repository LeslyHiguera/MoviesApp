//
//  ImageService.swift
//  MoviesApp
//
//  Created by _ on 14/06/24.
//

import UIKit

final class ImageService {
    
    // MARK: - Properties
    
    private var images = NSCache<NSString, NSData>()

    // MARK: - Methods
    
    func image(for url: URL, completion: @escaping (UIImage?) -> Void) {
        if let imageData = images.object(forKey: url.absoluteString as NSString) {
            print("Using cached images")
            
            guard let image = UIImage(data: imageData as Data) else { return }
            completion(image)
            
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, _ in
            
            var image: UIImage?

            defer {
                
                DispatchQueue.main.async {
                    completion(image)
                }
            }

            if let data = data {
                self.images.setObject(data as NSData, forKey: url.absoluteString as NSString)
                image = UIImage(data: data)
            }
        }
        dataTask.resume()
    }

}

