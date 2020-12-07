//
//  ImageLoaderService.swift
//  TelstraProficiency
//
//  Created by Navamani, Samuel on 7/12/20.
//

import Foundation
import UIKit

protocol ImageLoaderServiceProtocol {
    func loadImage(_ url: URL, _ completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID?
    func cancelLoad(_ uuid: UUID)
}

class ImageLoaderService {
    
    private let session: FactsSessionProtocol
    private var loadedImages = [URL: UIImage]()
    private var runningRequests = [UUID: URLSessionDataTask]()
    
    init(with session: FactsSessionProtocol = FactsSession.shared) {
        self.session = session
    }
}

extension ImageLoaderService: ImageLoaderServiceProtocol {
    func loadImage(_ url: URL, _ completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {
        
        if let image = loadedImages[url] {
            completion(.success(image))
            return nil
        }
        
        let uuid = UUID()
        
        let task = session.executeRequest(with: url) { result in
            switch result {
            case .success(let data):
                defer {self.runningRequests.removeValue(forKey: uuid) }
                
                if let data = data, let image = UIImage(data: data) {
                    self.loadedImages[url] = image
                    DispatchQueue.main.async {
                        completion(.success(image))
                    }
                    return
                }
            case .failure(let error):
                print("Image Loader service failed with error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        runningRequests[uuid] = task
        return uuid
    }
    
    func cancelLoad(_ uuid: UUID) {
        runningRequests[uuid]?.cancel()
        runningRequests.removeValue(forKey: uuid)
    }
}
