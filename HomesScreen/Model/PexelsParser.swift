//
//  PexelsParser.swift
//  Avox
//
//  Created by Nimap on 26/01/24.
//

import UIKit

protocol PexelsParserDelegate: NSObjectProtocol {
    func didRecievedSuccess(model: [PexelsModel], next: String)
    func didRecievedFailure(message: String)
}

class PexelsParser: NSObject {

    //https://picsum.photos/v2/list?page=2&limit=100
    weak var delegate   : PexelsParserDelegate?
    private let apiKey  = "eN3xDz2ZGvMVEQGZq9cgEjtPf5NxaNswgzeC3MsuIS3MwbOZ6DV76g34"
    private let baseURL = "https://api.pexels.com/v1/"

    
    func getImageData() {
        let url = URL(string: "\(baseURL)curated/?per_page=50&page=\(1)")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue(apiKey, forHTTPHeaderField: "Authorization")
        processData(request: request)
    }
    
    func getQueryData(query: String) {
        let url = URL(string: "\(baseURL)search?query=\(query)&per_page=50&page=\(1)")
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
        URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                if error != nil {
                    DispatchQueue.main.async {
                        self.delegate?.didRecievedFailure(message: "Error decoding JSON: \(String(describing: error))")
                    }
                }else if data != nil {
                    let responseString = String(data: data!, encoding: String.Encoding.utf8)
                    print("responseString PexelsParser \(responseString!)")
                    let jsonConvert = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String : Any]
                    if let status = jsonConvert["status"] as? Int {
                        if status == 400 {
                            let message = jsonConvert["code"] as? String
                            DispatchQueue.main.async {
                                self.delegate!.didRecievedFailure(message: message!)
                            }
                        }
                    }else {
                        let nextPage = jsonConvert["next_page"] as? String
                        let data = jsonConvert["photos"] as? [[String : Any]]
                        var imageModel : [PexelsModel] = []
                        for i in 0..<data!.count {
                            let models = PexelsModel(dictionary: data![i])
                            imageModel.append(models)
                        }
                        DispatchQueue.main.async {
                            self.delegate?.didRecievedSuccess(model: imageModel, next: nextPage ?? "")
                        }
                    }
                }
            }catch {
                print("Error decoding JSON: \(error)")
                DispatchQueue.main.async {
                    self.delegate!.didRecievedFailure(message: "Error decoding JSON: \(error)")
                }
            }
        }.resume()
    }
}
