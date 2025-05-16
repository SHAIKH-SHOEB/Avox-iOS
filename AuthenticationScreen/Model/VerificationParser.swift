//
//  VerificationParser.swift
//  Avox
//
//  Created by Shaikh Shoeb on 23/03/24.
//

import UIKit

protocol VerificationParserDelegate: NSObjectProtocol {
    func didRecievedOTP(status: Int, message: String)
}

class VerificationParser: NSObject {
    
    weak var delegate : VerificationParserDelegate?
   
    func getOTPVerification(otp: Int, name: String, email: String) {
        var jsonDictionary : [String : Any] = [:]
        
        jsonDictionary["ishtml"] = "false"
        jsonDictionary["sendto"] = email
        jsonDictionary["name"] = AppConstants.NAME
        jsonDictionary["replyTo"] = "avox@gmail.com"
        jsonDictionary["title"] = "Your Verification Code"
        jsonDictionary["body"] = """
        Dear \(name),

        Thank you for registration with \(AppConstants.NAME). To complete your registration, please use the following verification code:

        Verification Code: \(otp)

        Please enter this code in the app to verify your email address.
        If you did not request this verification code, please ignore this email.

        Best regards,
        \(AppConstants.NAME)
        """
        
        var jsonData: Data?
        do{
            jsonData = try JSONSerialization.data(withJSONObject: jsonDictionary, options:JSONSerialization.WritingOptions.prettyPrinted)
        }catch{
            jsonData = nil
        }
        
        let requestString = NSString(data: jsonData!, encoding: String.Encoding.utf8.rawValue)
        print("VerificationParser request \n\(requestString!)\n")
        var url : URL?
        url = URL(string: "https://rapidmail.p.rapidapi.com/")
        let request = NSMutableURLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("b885e21920msh2a9a4b2e5e161c4p176d09jsn7ccdd722668e", forHTTPHeaderField: "X-RapidAPI-Key")
        request.addValue("rapidmail.p.rapidapi.com", forHTTPHeaderField: "X-RapidAPI-Host")
        request.httpBody = jsonData
        processData(request: request)
        
    }
    
    func processData(request: NSMutableURLRequest) {
        URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            do {
                if error != nil {
                    DispatchQueue.main.async {
                        self.delegate!.didRecievedOTP(status: 111, message: "Error decoding JSON: \(error!)")
                    }
                }else if data != nil {
                    let responseString = String(data: data!, encoding: String.Encoding.utf8)
                    print("responseString VarificationParser \(responseString!)")
                    let jsonConvert = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String : Any]
                    if let status = jsonConvert["error"] as? Bool {
                        if !status {
                            let message = jsonConvert["message"] as? String
                            DispatchQueue.main.async {
                                self.delegate!.didRecievedOTP(status: 000, message: message!)
                            }
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.delegate!.didRecievedOTP(status: 111, message: "Error")
                        }
                    }
                }
            }catch {
                print("Error decoding JSON: \(error)")
                DispatchQueue.main.async {
                    self.delegate!.didRecievedOTP(status: 111, message: "Error decoding JSON: \(error)")
                }
            }
        }.resume()
    }
    
    //let headers = [
    //    "content-type": "application/json",
    //    "X-RapidAPI-Key": "b885e21920msh2a9a4b2e5e161c4p176d09jsn7ccdd722668e",
    //    "X-RapidAPI-Host": "rapidmail.p.rapidapi.com"
    //]
}
