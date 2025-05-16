//
//  OnBoardingViewController.swift
//  Avox
//
//  Created by Shaikh Shoeb on 03/08/24.
//

import UIKit

class OnBoardingViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var onBoardingModel      : [AppProvider]?
    var currentPage = 0 {
        didSet {updateButton()}
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        onBoardingModel = AppProvider.getOnboardingProvider()
        collectionView.delegate = self
        collectionView.dataSource = self
        nextButton.setAttributedTitle(NSAttributedString(string: "Next", attributes: [.font: UIFont.appFontBold(ofSize: 17.0)!]), for: .normal)
        previousButton.setAttributedTitle(NSAttributedString(string: "Skip", attributes: [.font: UIFont.appFontBold(ofSize: 17.0)!]), for: .normal)
        pageControl.isUserInteractionEnabled = false
    }
    
    @IBAction func previousButtonPressed(_ sender: Any) {
        if currentPage > 0 {
            currentPage -= 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
        }else {
            print("Skip")
            navitageToHomeScreen()
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        if currentPage == onBoardingModel!.count - 1 {
            print("Finish")
            navitageToHomeScreen()
        }else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
        }
    }
    
    func updateButton() {
        pageControl.currentPage = currentPage
        if let count = onBoardingModel?.count {
            if currentPage == count - 1 {
                nextButton.setAttributedTitle(NSAttributedString(string: "Finish", attributes: [.font: UIFont.appFontBold(ofSize: 17.0)!]), for: .normal)
                previousButton.setAttributedTitle(NSAttributedString(string: "Previous", attributes: [.font: UIFont.appFontBold(ofSize: 17.0)!]), for: .normal)
            } else if currentPage == 0 {
                nextButton.setAttributedTitle(NSAttributedString(string: "Next", attributes: [.font: UIFont.appFontBold(ofSize: 17.0)!]), for: .normal)
                previousButton.setAttributedTitle(NSAttributedString(string: "Skip", attributes: [.font: UIFont.appFontBold(ofSize: 17.0)!]), for: .normal)
            } else {
                nextButton.setAttributedTitle(NSAttributedString(string: "Next", attributes: [.font: UIFont.appFontBold(ofSize: 17.0)!]), for: .normal)
                previousButton.setAttributedTitle(NSAttributedString(string: "Previous", attributes: [.font: UIFont.appFontBold(ofSize: 17.0)!]), for: .normal)
            }
        }
    }
    
    func navitageToHomeScreen() {
        UserDefaults.standard.set("", forKey: "nickName")
        UserDefaults.standard.set("", forKey: "email")
        UserDefaults.standard.set(true, forKey: "onBoarding")
        UserDefaults.standard.set(2, forKey: "language")
        UserDefaults.standard.set(1, forKey: "appIconId")
        if UIApplication.isConnectedToNetwork() {
            let vc = HomeViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            let vc = NoConnectionViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension OnBoardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onBoardingModel?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnBoardingCollectionViewCell.identifier, for: indexPath) as! OnBoardingCollectionViewCell
        cell.updateCollectionViewCellForOnBoarding(onBoardingModel![indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
}
