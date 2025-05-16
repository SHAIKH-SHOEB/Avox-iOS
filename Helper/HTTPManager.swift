//
//  HTTPManager.swift
//  Avox
//
//  Created by Shaikh Shoeb on 15/08/24.
//

import Foundation

enum APIError: Error {
    case InvalidUrl
    case RequestFailed(Error)
    case InvalidResponse
    case NoData
    case DataDecodingFailed(Error)
}

typealias ResultHandler = (Result<Data, APIError>) -> Void

final class HTTPManager {
    
    static let shared = HTTPManager()
    private init() {}
    
    // Generic GET request method
    func getRequest(urlString: String, headers: [String: String]? = nil, completion: @escaping ResultHandler) {
        request(urlString: urlString, method: "GET", headers: headers, body: Optional<Data>.none, completion: completion)
    }
    
    // Generic POST request method
    func postRequest<T: Encodable>(urlString: String, headers: [String: String]? = nil, body: T?, completion: @escaping ResultHandler) {
        request(urlString: urlString, method: "POST", headers: headers, body: body, completion: completion)
    }
    
    // Generic PUT request method
    func putRequest<T: Encodable>(urlString: String, headers: [String: String]? = nil, body: T?, completion: @escaping ResultHandler) {
        request(urlString: urlString, method: "PUT", headers: headers, body: body, completion: completion)
    }
    
    // Generic DELETE request method
    func deleteRequest(urlString: String, headers: [String: String]? = nil, completion: @escaping ResultHandler) {
        request(urlString: urlString, method: "DELETE", headers: headers, body: Optional<Data>.none, completion: completion)
    }
    
    // Private generic method to handle various HTTP methods
    private func request<T: Encodable>(urlString: String, method: String, headers: [String: String]?, body: T?, completion: @escaping (Result<Data, APIError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(APIError.InvalidUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        if let body = body {
            do {
                request.httpBody = try JSONEncoder().encode(body)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch let encodingError {
                completion(.failure(APIError.DataDecodingFailed(encodingError)))
                return
            }
        }
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(APIError.RequestFailed(error)))
                return
            }
            
            //guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
            //    completion(.failure(.invalidResponse))
            //    return
            //}
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(APIError.InvalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.NoData))
                return
            }
            
            let responseString = String(data: data, encoding: String.Encoding.utf8)
            print("responseString: \(urlString) \n \(responseString!)")
            completion(.success(data))
        }
        dataTask.resume()
    }
}

//final - final keyword used for this class not inheritance with other class
//singleton - singleton class ka object create hoga outside of class
//Singleton - if create init private this is a Singleton this class will be not create object outside of class
//URLSession - this is network calling for api, yeh server se data fetch karke hame deta ha urlSession provided by apple swift ios
//resume - this is used for return call dataTask closur
//Decodable - Yeh Data Ko Model Me Covert Karta Ha
//Encodable - Yeh Model Ko Data Me Covert Karta Ha
//Codable - Yeh Type Ki Model Class Data To Model And Model To Data Dono Ke Liye Used Hoti Ha


//    func printRequest(_ request: NSMutableURLRequest) {
//        print("🔹 URL: \(request.url?.absoluteString ?? "nil")")
//        print("🔹 HTTP Method: \(request.httpMethod ?? "nil")")
//
//        if let headers = request.allHTTPHeaderFields {
//            print("🔹 Headers:")
//            for (key, value) in headers {
//                print("   \(key): \(value)")
//            }
//        }
//
//        if let body = request.httpBody,
//           let bodyString = String(data: body, encoding: .utf8) {
//            print("🔹 Body:")
//            print(bodyString)
//        } else {
//            print("🔹 No Body")
//        }
//    }
