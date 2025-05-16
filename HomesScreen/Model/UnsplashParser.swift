//
//  UnsplashParser.swift
//  Avox
//
//  Created by Nimap on 26/01/24.
//

import UIKit

class UnsplashParser: NSObject {

}

//protocol UnsplashParserDelegate: NSObjectProtocol {
//    
//}
//
//class UnsplashParser: NSObject, URLSessionDelegate, URLSessionDownloadDelegate {
//
//    var webData : Data?
//    weak var delegate : UnsplashParserDelegate?
//    
//    var session : URLSession{
//        let defualtConfig = URLSessionConfiguration.default
//        defualtConfig.requestCachePolicy =  NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
//        let session1 = URLSession(configuration: defualtConfig, delegate: self, delegateQueue: nil)
//        return session1
//    }
//    
//    
//    func getUnsplashImage(apiKey: String){
//        let url = URL(string: "https://api.pexels.com/v1/")
//        let task = session.downloadTask(with: url!)
//        task.resume()
//    }
//    
//    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
//        do{
//            webData = try Data(contentsOf: location)
//            
//            let responseString = String(data: webData!, encoding: String.Encoding.utf8)
//            print("responseString \(responseString!)")
//            
////            let jsonConvert = try JSONSerialization.jsonObject(with: webData!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String : Any]
////            let data = jsonConvert["products"] as? [[String : Any]]
////            var products : [ProductsModel] = []
////            for i in 0..<data!.count {
////                let product = ProductsModel(ditionary: data![i])
////                products.append(product)
////            }
////            DispatchQueue.main.async {
////
////            }
//        }catch{
//            
//            print("Product Parser Error")
//            
//        }
//    }
//    
//    func fetchImageFromUnsplash(apiKey: String, completion: @escaping (Data?, Error?) -> Void) {
//        // Set up the URL for the Unsplash API endpoint
//        let urlString = "https://api.unsplash.com/photos/random?client_id=\(apiKey)"
//        guard let url = URL(string: urlString) else {
//            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
//            return
//        }
//
//        // Create a URLSession task for the API request
//        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//            // Handle errors
//            if let error = error {
//                completion(nil, error)
//                return
//            }
//
//            // Ensure there is data
//            guard let data = data else {
//                completion(nil, NSError(domain: "No data received", code: 0, userInfo: nil))
//                return
//            }
//
//            // Call the completion handler with the data
//            completion(data, nil)
//        }
//
//        // Start the URLSession task
//        task.resume()
//    }
//}
