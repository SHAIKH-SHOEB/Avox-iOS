//
//  AvoxViewController.swift
//  Avox
//
//  Created by Shaikh Shoeb on 11/08/24.
//

import UIKit
import Network
import CoreTelephony

class AvoxViewController: UIViewController {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var shoeb : Kaif = ""
    var networkStatus : Kaif = ""
    
    private let monitor = NWPathMonitor()
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadNavigationBar()
//        let main = AvoxHelper()
//        main.log("Hello World")
//        Foundation.NSLog("Hello World")
//        NSLog("MOYE")
//        NSLog(1)
    
//        if #available(iOS 16, *) {
//            log("")
//        } else {
//            // Fallback on earlier versions
//            print("")
            
//        }
//        performAction()
//        let store = performAction()
//        NSLog(store)
        
//        var name = 1.0
//        var type = type(of: name)
//        NSLog(type)
        
        var number = 1
        
        repeat {
            print(number)
            number += 1
        }while number <= 5
        
        while number <= 5 {
            print(number)
            number += 1
        }
        
        for i in 1...5 {
            print(i)
        }
    }
    
    func loadNavigationBar() {
        let navigationItem = UINavigationItem()
        navigationItem.title = "Avox"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .done, target: self, action: #selector(backButtonPressed))
        navigationBar.items = [navigationItem]
        navigationBar.barTintColor = Helper.Color.bgPrimary
        navigationBar.tintColor = Helper.Color.appPrimary
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Helper.Color.textPrimary as Any]
        navigationBar.prefersLargeTitles = true
        let largeTitleAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.appFontBold(ofSize: 24) as Any, .foregroundColor: Helper.Color.textPrimary as Any]
        navigationBar!.largeTitleTextAttributes = largeTitleAttributes
    }
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @available(iOS 16, *)
    func log(_ message: String) {
        print(message)
    }
    
    func NSLog<T>(_ message: T){
        print(message)
    }
    
    @discardableResult
    func performAction() -> Bool {
        // Perform some action
        return true
    }
    
    @IBAction func planButton(_ sender: Any) {
        
    }
    
    @IBAction func grayButton(_ sender: Any) {
        
    }
    
    @IBAction func tintedButton(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Choose an Option", message: nil, preferredStyle: .actionSheet)
            
        // Add actions (buttons) to the action sheet
        let option1 = UIAlertAction(title: "Option 1", style: .default) { _ in
            print("Option 1 selected")
        }
        let option2 = UIAlertAction(title: "Option 2", style: .default) { _ in
            print("Option 2 selected")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel button tapped")
        }
        actionSheet.addAction(option1)
        actionSheet.addAction(option2)
        actionSheet.addAction(cancelAction)
        
        // Present the action sheet
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func filledButton(_ sender: Any) {
        openWiFiSettings()
    }
    
    func getCarrierInfo() {
        let networkInfo = CTTelephonyNetworkInfo()
        
        // Access the carrier info
        if let carrier = networkInfo.serviceSubscriberCellularProviders {
            for (_, carrierInfo) in carrier {
                if let carrierName = carrierInfo.carrierName {
                    print("Carrier Name: \(carrierName)")
                }
                if let mobileCountryCode = carrierInfo.mobileCountryCode {
                    print("Mobile Country Code: \(mobileCountryCode)")
                }
                if let mobileNetworkCode = carrierInfo.mobileNetworkCode {
                    print("Mobile Network Code: \(mobileNetworkCode)")
                }
            }
        } else {
            print("No carrier information available")
        }
    }
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("Network is satisfied")
            }else if path.status == .unsatisfied {
                print("Network is unsatisfied")
            }else if path.status == .requiresConnection {
                print("Network is requiresConnection")
            }else {
                print("Network not found")
            }
        }
        
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
        titleLabel.text = networkStatus
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
    
    func openAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func openWiFiSettings() {
        if let url = URL(string: "App-Prefs:root=General") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    func loadDefer() {
        print("First")
        defer {
            print("Second")
        }
        print("Three")
    }
}

class AvoxHelper: NSObject {
    
    @available(iOS 15, *)
    func newFeature() {
        // Code for iOS 15 and later
    }
    
    
    @discardableResult
    func performAction() -> Bool {
        // Perform some action
        return true
    }
    
    
    @propertyWrapper
    struct Uppercased {
        private var value: String

        var wrappedValue: String {
            get { value.uppercased() }
            set { value = newValue }
        }

        init(wrappedValue: String) {
            self.value = wrappedValue
        }
    }

    
    struct User {
        @Uppercased var name: String
    }
    
    
    @inlinable func multiply(_ a: Int, _ b: Int) -> Int {
        return a * b
    }

    
    @inline(__always) func computeValue() -> Int {
        return 42
    }
    
    
    func log(_ message: @autoclosure () -> String) {
        print(message())
    }
    //log("This is a log message.")

    
    @dynamicCallable
    struct Calculator {
        func dynamicallyCall(withArguments args: [Int]) -> Int {
            return args.reduce(0, +)
        }
    }
    //let calc = Calculator()
    //let result = calc(1, 2, 3, 4)  // result is 10
    
    
//    @frozen enum Status {
//        case success
//        case failure
//    }
    
    
    @propertyWrapper
    struct Clamped {
        private var value: Int
        private let range: ClosedRange<Int>

        var wrappedValue: Int {
            get { value }
            set { value = min(max(newValue, range.lowerBound), range.upperBound) }
        }

        init(wrappedValue: Int, _ range: ClosedRange<Int>) {
            self.range = range
            self.value = min(max(wrappedValue, range.lowerBound), range.upperBound)
        }
    }
    struct Configuration {
        @Clamped(wrappedValue: 100,0...100) var percentage: Int
    }
    
    
    @dynamicMemberLookup
    struct DynamicStruct {
        private var storage: [String: Any] = [:]

        subscript(dynamicMember member: String) -> Any? {
            get { storage[member] }
            set { storage[member] = newValue }
        }
    }
    //let obj = DynamicStruct()
    //obj.someProperty = 42
    
    
    @resultBuilder
    struct HTMLBuilder {
        static func buildBlock(_ components: String...) -> String {
            return components.joined()
        }
    }

    func html(@HTMLBuilder content: () -> String) -> String {
        return "<html>\(content())</html>"
    }
//    let page = html {
//        "<body>Hello, world!</body>"
//    }
    
    
    @dynamicCallable
    struct Adder {
        func dynamicallyCall(withArguments args: [Int]) -> Int {
            return args.reduce(0, +)
        }
    }

    //let adder = Adder()
    //let sum = adder(1, 2, 3, 4) // sum is 10

    
    @globalActor
    actor MainActor {
        static let shared = MainActor()
    }

    @MainActor
    func updateUI() {
        // UI update code
    }
    
    
    @IBDesignable class CustomView: UIView {
        @IBInspectable var borderColor: UIColor = .black
        // Custom view implementation
    }
    

    let cFunction: @convention(c) (Int32) -> Void = { value in
        print("Value: \(value)")
    }

    
    func readFile(at path: String) throws -> String {
         //Implementation that can throw an error
        return ""
    }
    
    
    func fetchData() async -> Data {
        // Async function implementation
        return Data()
    }
    
    
    @usableFromInline
    func internalFunction() {
        // Implementation
    }
    

    @nonobjc func swiftOnlyMethod() {
        // Swift-only implementation
    }

}
@testable import AdSupport


class SWiftReferences {
    
    func StringMethods() {
        var msg1 = "Swift"
        let msg2 = "Programming"
        // append str1 and str2
        msg1.append(msg2)
        print(msg1)
        // Output: SwiftProgramming
        
       
        var greet = "Hello, "
        // append new string to greet
        greet.append("Good Morning")
        // append "!" to greet
        greet.append("!")
        print(greet)
        // Output: Hello, Good Morning!
        
        
        let greet1 = "Hello, "
        let greet2 = "Good Morning"
        // use + operator to append
        print(greet1 + greet2)
        // Output: Hello, Good Morning
        
        
        // insert ! to greet
        greet.insert("!", at: greet.endIndex)
        print(greet)
        // Output: Good Morning!
        
        
        var distance = "X,Y"
        // insert character at start and end index of distance
        distance.insert("(", at: distance.startIndex)
        distance.insert(")", at: distance.endIndex)
        print(distance)
        // Output: (X,Y)
        
        
        var message = "Swift "
        // use contentsOf property to insert multiple characters
        message.insert(contentsOf: "Programming", at: message.endIndex)
        print(message)
        // Output: Swift Programming
    }
}

class swiftBasics {
    
    //what is variables and constants
    //Variables are declared using the var keyword. The values of variables can be changed after they are set.
    //Constants are declared using the let keyword. Once a constant is assigned a value, it cannot be changed.
    //Example:
    var name = "Shoeb"
    var age = 10
    var temperature: Float = 36.6 //~6–7 decimal digits, Faster, less precise
    var pi: Double = 3.14159 //~15–16 decimal digits, Slower, more precise
    var isSwiftAwesome: Bool = true
    var grade: Character = "A"
    var optionalName: String? = nil
    
    let subject = "Maths"
    let marks = 50
    
    func SyntaxFundamentals() {
        name = "Kaif"
        age = 20
        
        //Getting Error Message
        //subject = "-"
        // marks = 0
    }
    
    //whats is optionals and unwrapping
    
    
    
}
