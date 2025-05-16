//
//  TermServiceViewController.swift
//  Avox
//
//  Created by Nimap on 26/01/24.
//

import UIKit
import PDFKit

class TermServiceViewController: UIViewController {
    
    var navigationBar       : UINavigationBar?
    var pdfViewer           : PDFView?
    var isAbout             : Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = Helper.Color.bgPrimary
        UINavigationBar.appearance().isTranslucent = false
        loadNavigationBar()
        loadPDFViewer()
        loadPDFViewer()
        uploadPDFViewer()
    }
    
    init(isAbout : Bool) {
        super.init(nibName: nil, bundle: nil)
        self.isAbout = isAbout
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadNavigationBar() {
        navigationBar = UINavigationBar()
        navigationBar!.translatesAutoresizingMaskIntoConstraints = false
        let navigationItem = UINavigationItem()
        navigationItem.title = isAbout! ? AppUtils.localizableString(key: LanguageConstant.aboutUs) : AppUtils.localizableString(key: LanguageConstant.termServices)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .done, target: self, action: #selector(backButtonPressed))
        navigationBar!.items = [navigationItem]
        navigationBar!.barTintColor = Helper.Color.bgPrimary
        navigationBar!.tintColor = Helper.Color.appPrimary
        navigationBar!.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Helper.Color.textPrimary as Any]
        navigationBar!.prefersLargeTitles = true
        let largeTitleAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.appFontBold(ofSize: 27.0) as Any, .foregroundColor: Helper.Color.textPrimary as Any]
        navigationBar!.largeTitleTextAttributes = largeTitleAttributes
        self.view.addSubview(navigationBar!)
        NSLayoutConstraint.activate([
            navigationBar!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            navigationBar!.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            navigationBar!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    func loadPDFViewer() {
        pdfViewer = PDFView()
        pdfViewer!.translatesAutoresizingMaskIntoConstraints = false
        pdfViewer!.displayMode = PDFDisplayMode.singlePageContinuous
        pdfViewer!.autoScales = true
        pdfViewer!.displayDirection = .vertical
        pdfViewer!.backgroundColor = Helper.Color.bgPrimary!
        self.view.addSubview(pdfViewer!)
        NSLayoutConstraint.activate([
            pdfViewer!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            pdfViewer!.topAnchor.constraint(equalTo: navigationBar!.bottomAnchor, constant: 10),
            pdfViewer!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            pdfViewer!.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10)
        ])
    }
    
    func uploadPDFViewer() {
        if let pdfURL = Bundle.main.url(forResource: isAbout! ? "AboutUs" : "TermsOfServices" , withExtension: "pdf") {
            if let document = PDFDocument(url: pdfURL) {
                pdfViewer!.document = document
            }else{
                print("Invalid PDF Path")
            }
        }
    }
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }

}
