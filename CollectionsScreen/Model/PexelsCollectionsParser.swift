//
//  PexelsCollectionsParser.swift
//  Avox
//
//  Created by Shaikh Shoeb on 17/09/24.
//

import UIKit

protocol PexelsCollectionsParserDelegate: NSObjectProtocol {
    func didRecievedPexelsCollectionsSuccess(model: [Collections], nextUrl: String)
    func didRecievedPexelsCollectionsFailure(message: String)
}

class PexelsCollectionsParser: NSObject {

    weak var delegate    : PexelsCollectionsParserDelegate?
    private let apiKey   = "eN3xDz2ZGvMVEQGZq9cgEjtPf5NxaNswgzeC3MsuIS3MwbOZ6DV76g34"
    private let baseURL  = "https://api.pexels.com/v1/"
    
    func getCollectionsData() {
        //let url = URL(string: "\(baseURL)collections?per_page=20")
        let url = URL(string: "\(baseURL)collections/featured?per_page=\(20)")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue(apiKey, forHTTPHeaderField: "Authorization")
        processData(request: request)
    }
    
    func getCollectionsData(nextUrl: String) {
        let url = URL(string: nextUrl)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue(apiKey, forHTTPHeaderField: "Authorization")
        processData(request: request)
    }
    
    func processData(request: URLRequest) {
        let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
            do {
                if error == nil {
                    let httpResponse = response as! HTTPURLResponse
                    if httpResponse.statusCode == 200 {
                        
                        let responseString  = String(data: data!, encoding: String.Encoding.utf8)
                        print("responseString PexelsCollectionsParser \n\n \(responseString!)")
                        
                        let models : PexelsCollectionsModel?
                        models = try JSONDecoder().decode(PexelsCollectionsModel.self, from: data!)
                        DispatchQueue.main.async {
                            if self.delegate != nil {
                                self.delegate!.didRecievedPexelsCollectionsSuccess(model: models!.collections, nextUrl: (models!.nextPage!))
                            }
                        }
                    }else {
                        DispatchQueue.main.async {
                            if self.delegate != nil {
                                self.delegate!.didRecievedPexelsCollectionsFailure(message: "Error decoding JSON: \(error!)")
                            }
                        }
                    }
                }else {
                    DispatchQueue.main.async {
                        if self.delegate != nil {
                            self.delegate!.didRecievedPexelsCollectionsFailure(message: "Error decoding JSON: \(error!)")
                        }
                    }
                }
            }catch {
                print("Error decoding JSON: \(error)")
                if delegate != nil {
                    delegate?.didRecievedPexelsCollectionsFailure(message: "Error decoding JSON: \(error)")
                }
            }
        }
        task.resume()
    }
}
