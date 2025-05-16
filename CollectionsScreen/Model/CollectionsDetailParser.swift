//
//  CollectionsDetailParser.swift
//  Avox
//
//  Created by Shaikh Shoeb on 21/09/24.
//

import UIKit

protocol CollectionsDetailParserDelegate: NSObjectProtocol {
    func didRecievedCollectionsDetailSuccess(model: [Media], nextUrl: String)
    func didRecievedCollectionsDetailFailure(message: String)
}

class CollectionsDetailParser: NSObject {

    weak var delegate    : CollectionsDetailParserDelegate?
    private let apiKey   = "eN3xDz2ZGvMVEQGZq9cgEjtPf5NxaNswgzeC3MsuIS3MwbOZ6DV76g34"
    private let baseURL  = "https://api.pexels.com/v1/"
    
    func getCollectionsDetailData(id: String) {
        let url = URL(string: "\(baseURL)collections/\(id)?per_page=\(10)&sort=desc")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue(apiKey, forHTTPHeaderField: "Authorization")
        processData(request: request)
    }
    
    func getCollectionsDetailData(nextUrl: String) {
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
                        print("responseString CollectionsDetailParser \n\n \(responseString!)")
                        
                        let models : CollectionsDetailModel?
                        models = try JSONDecoder().decode(CollectionsDetailModel.self, from: data!)
                        DispatchQueue.main.async {
                            if self.delegate != nil {
                                self.delegate!.didRecievedCollectionsDetailSuccess(model: models!.media, nextUrl: (models!.nextPage))
                            }
                        }
                    }else {
                        DispatchQueue.main.async {
                            if self.delegate != nil {
                                self.delegate!.didRecievedCollectionsDetailFailure(message: "Error decoding JSON: \(error!)")
                            }
                        }
                    }
                }else {
                    DispatchQueue.main.async {
                        if self.delegate != nil {
                            self.delegate!.didRecievedCollectionsDetailFailure(message: "Error decoding JSON: \(error!)")
                        }
                    }
                }
            }catch {
                print("Error decoding JSON: \(error)")
                DispatchQueue.main.async {
                    if self.delegate != nil {
                        self.delegate?.didRecievedCollectionsDetailFailure(message: "Error decoding JSON: \(error)")
                    }
                }
            }
        }
        task.resume()
    }
}

//let url = URL(string: "\(baseURL)collections/c7g2wkk?per_page=20")
//let url = URL(string: "\(baseURL)collections/c7g2wkk?per_page=1&sort=desc")
