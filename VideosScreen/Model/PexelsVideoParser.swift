//
//  PexelsVideoParser.swift
//  Avox
//
//  Created by Nimap on 26/02/24.
//

import UIKit

protocol PexelsVideoParserDelegate: NSObjectProtocol {
    func didRecievedPexelsVideoSuccess(model: [Videos], nextUrl: String)
    func didRecievedPexelsVideoFailure(message: String)
}

class PexelsVideoParser: NSObject {
    
    weak var delegate    : PexelsVideoParserDelegate?
    private let apiKey   = "eN3xDz2ZGvMVEQGZq9cgEjtPf5NxaNswgzeC3MsuIS3MwbOZ6DV76g34"
    private let baseURL  = "https://api.pexels.com/videos/"
    
    func getVideoData() {
        let url = URL(string: "\(baseURL)popular?per_page=\(20)")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue(apiKey, forHTTPHeaderField: "Authorization")
        processData(request: request)
    }
    
    func getNextUrlData(nextUrl: String) {
        let url = URL(string: nextUrl)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue(apiKey, forHTTPHeaderField: "Authorization")
        processData(request: request)
    }
    
    func processData(request: URLRequest) {
        let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
            do {
                if error == nil{
                    let httpResponse = response as! HTTPURLResponse
                    if(httpResponse.statusCode == 200){
                        
                        let responseString = String(data: data!, encoding: String.Encoding.utf8)
                        print("responseString PexelsParser \(responseString!)")
                        
                        let models : PexelsVideoModel?
                        models = try JSONDecoder().decode(PexelsVideoModel.self, from: data!)
                        DispatchQueue.main.async {
                            if self.delegate != nil {
                                self.delegate!.didRecievedPexelsVideoSuccess(model: models!.videos!, nextUrl: models!.next_page!)
                            }
                        }
                    }else {
                        DispatchQueue.main.async {
                            if self.delegate != nil {
                                self.delegate!.didRecievedPexelsVideoFailure(message: "Error decoding JSON: \(error!)")
                            }
                        }
                    }
                }else {
                    DispatchQueue.main.async {
                        if self.delegate != nil {
                            self.delegate!.didRecievedPexelsVideoFailure(message: "Error decoding JSON: \(error!)")
                        }
                    }
                }
            }catch {
                print("Error decoding JSON: \(error)")
                self.delegate!.didRecievedPexelsVideoFailure(message: "Error decoding JSON: \(error)")
            }
        }
        task.resume()
    }
    
//    func processDatas(request: URLRequest) {
//        let task = URLSession.shared.dataTask(with: request) { data, response, Error in
//            if Error == nil{
//                let httpResponse = response as! HTTPURLResponse
//                if(httpResponse.statusCode == 200){
//                    
//                    let responseString = String(data: data!, encoding: String.Encoding.utf8)
//                    print("responseString PexelsParser \(responseString!)")
//                    
//                    let jsonConvert = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : Any]
//                }
//            }
//        }
//        task.resume()
//    }
}
