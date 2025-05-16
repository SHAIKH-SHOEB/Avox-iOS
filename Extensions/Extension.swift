//
//  Extension.swift
//  Avox
//
//  Created by Nimap on 28/01/24.
//

import UIKit
import Foundation
import SystemConfiguration
import ImageIO

extension UIImageView {
    func downloadImage(from url: URL, placeholder: UIImage? = nil, completion: (() -> Void)? = nil) {
        if let cachedImage = ImageCache.shared.getImage(url: url) {
            self.image = cachedImage
            completion?()
            return
        }

        self.image = placeholder

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion?()
                }
                return
            }

            if let image = UIImage(data: data) {
                ImageCache.shared.cacheImage(image, for: url)
                DispatchQueue.main.async {
                    self.image = image
                    completion?()
                }
            }
        }.resume()
    }
}

class ImageCache {
    static let shared = ImageCache()

    private var cache = NSCache<NSURL, UIImage>()

    func getImage(url: URL) -> UIImage? {
        return cache.object(forKey: url as NSURL)
    }

    func cacheImage(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url as NSURL)
    }
}

extension UIViewController {
    func downloadImage(from imageUrlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let imageUrl = URL(string: imageUrlString) else {
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: imageUrl) { data, response, error in
            guard let data = data, error == nil else {
                print("Error downloading image: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            if let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }.resume()
    }
}

extension UIColor {
    convenience init?(hexString: String) {
        var formattedString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        formattedString = formattedString.replacingOccurrences(of: "#", with: "")
        
        var rgbValue: UInt64 = 0
        Scanner(string: formattedString).scanHexInt64(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

extension UIApplication {
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }

        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }

        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)

        return (isReachable && !needsConnection)
    }
}

extension String {
    func isValidateEmailId() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        return applyPredicateOnRegex(regexStr: emailRegEx)
        
    }
    func applyPredicateOnRegex(regexStr: String) -> Bool{
        let trimmedString = self.trimmingCharacters(in: .whitespaces)
        let validateOtherString = NSPredicate(format: "SELF MATCHES %@", regexStr)
        let isValidateOtherString = validateOtherString.evaluate(with: trimmedString)
        return isValidateOtherString
    }
}

extension UIViewController {
    var isNotch: Bool {
        if #available(iOS 13.0, *) {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                return false
            }
            return windowScene.windows.first?.safeAreaInsets.bottom ?? 0 > 0
        } else {
            return false
        }
    }
}

extension UILabel {
    func setAttributedIdText(title: String, value: String, titleColor: UIColor, valueColor: UIColor, titleFont: UIFont, valueFont: UIFont, divider: String? = nil) {
        let attributedString = NSMutableAttributedString(string: "\(title)\(divider ?? ":") \(value)")
        
        // Define ranges for the different parts of the text
        let idLabelRange = (attributedString.string as NSString).range(of: "\(title)\(divider ?? ":") ")
        attributedString.addAttribute(.foregroundColor, value: titleColor, range: idLabelRange)
        attributedString.addAttribute(.font, value: titleFont, range: idLabelRange)
        
        let idValueRange = (attributedString.string as NSString).range(of: "\(value)")
        attributedString.addAttribute(.foregroundColor, value: valueColor, range: idValueRange)
        attributedString.addAttribute(.font, value: valueFont, range: idValueRange)
        
        // Set the attributed text to the label
        self.attributedText = attributedString
    }
}

extension UIImage {
    static func setAnimatedGif(forResource: String, ofType: String) -> UIImage? {
        let assetURL = URL(fileURLWithPath: Bundle.main.path(forResource: forResource, ofType: ofType)!)
        let gifData = try? Data(contentsOf: assetURL)
        
        let source = CGImageSourceCreateWithData(gifData! as CFData, nil)
        let count = CGImageSourceGetCount(source!)
        
        var images = [UIImage]()
        var duration: TimeInterval = 0.0

        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source!, i, nil) {
                images.append(UIImage(cgImage: image))
                
                // Get delay for this frame
                let properties = CGImageSourceCopyPropertiesAtIndex(source!, i, nil) as Dictionary?
                if let gifProperties = properties?[kCGImagePropertyGIFDictionary as String as NSObject] as? [String: Any],
                   let delay = gifProperties[kCGImagePropertyGIFDelayTime as String] as? TimeInterval {
                    duration += delay
                } else {
                    duration += 0.1 // Default delay
                }
            }
        }
        return UIImage.animatedImage(with: images, duration: duration)
    }
}

//Typealias Type All Variable Here
typealias Kaif = String
