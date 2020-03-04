//
//  AdView.swift
//  pdfsRebooks
//
//  Created by Justin Allen on 1/17/20.
//  Copyright © 2020 Justin Allen. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds

extension UIResponder {
    var viewController: UIViewController? {
        if let vc = self as? UIViewController {
            return vc
        }

        return next?.viewController
    }
}

extension UIView: GADBannerViewDelegate /*, SKPaymentTransactionObserver*/ {
    
    
    private static var _myComputedProperty = [String:Double]()
    var hideAfterTime: Double {
        get {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            return UIView._myComputedProperty[tmpAddress] ?? -1
        }
        set(newValue) {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            UIView._myComputedProperty[tmpAddress] = newValue
        }
    }
    
    private static var _myViewProperty = [String:GADBannerView]()
    var adBannerView: GADBannerView? {
        get {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            return UIView._myViewProperty[tmpAddress] ?? nil
        }
        set(newValue) {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            UIView._myViewProperty[tmpAddress] = newValue
        }
    }
    
    private static var _vwProperty = [String:UIView]()
    var adView: UIView? {
        get {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            return UIView._vwProperty[tmpAddress] ?? nil
        }
        set(newValue) {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            UIView._vwProperty[tmpAddress] = newValue
        }
    }
    
    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
    func injectAds(duration: Double? = nil) {
        if !UserDefaults.standard.bool(forKey: "ad-free") {
//            SKPaymentQueue.default().add(self)
//            let removeBTN = UIButton(type: .system)
//            removeBTN.setTitle("X", for: .normal)
//            removeBTN.addTarget(self, action: #selector(removeAdsBTNClicked), for: .touchDown)
//            removeBTN.alpha = 0
            let bannerView = GADBannerView(adSize: kGADAdSizeBanner)
            addSubview(bannerView)
//            addSubview(removeBTN)
            let _ = Utils.SetupContraints(
                child: bannerView, parent: self, addToParent: false,
                top: false,
                leading: false,
                trailing: false,
                bottom: true, bottomConstant: 10,
                //centerX: true, centerXConstant: -10
                centerX: true
            )
            
//            let _ = Utils.SetupContraints(
//                child: removeBTN, parent: self, addToParent: false,
//                top: false,
//                leading: true, leadingConstant: 2, leadingTarget: bannerView.trailingAnchor,
//                trailing: false,
//                bottom: false,
//                centerY: true, centerYConstant: 0, centerYTarget: bannerView.centerYAnchor
//            )
            
            #if targetEnvironment(simulator)
                bannerView.adUnitID  = "ca-app-pub-3940256099942544/2934735716"
            #else
                bannerView.adUnitID = "ca-app-pub-5055132508780990/9972248589"
            #endif
            bannerView.rootViewController = viewController
            bannerView.load(GADRequest())
            bannerView.delegate = self
            if let time = duration {
                if time > 0 {
                    hideAfterTime = time
                }
            }
            print("Showing ads.")
            adBannerView = bannerView
//            adView = removeBTN
        } else {
            print("Premium. No ads to show.")
        }
    }
    
    func removeAds() {
        UIView.animate(withDuration: 1, animations: {
            self.adBannerView?.alpha = 0
            self.adView?.alpha = 0
        }) { (b) in
            self.adBannerView?.removeFromSuperview()
            self.adBannerView = nil
            self.adView?.removeFromSuperview()
            self.adView = nil
        }
    }
    
    // MARK: Delegate Functions
    public func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.alpha = 0
        self.adView?.alpha = 0
        UIView.animate(withDuration: 1) {
            bannerView.alpha = 1
            self.adView?.alpha = 1
            if self.hideAfterTime > -1 {
                self.delayWithSeconds(self.hideAfterTime) {
                    UIView.animate(withDuration: 1, animations: {
                        bannerView.alpha = 0
                        self.adView?.alpha = 0
                    }) { (bo) in
                        bannerView.removeFromSuperview()
                        self.adView?.removeFromSuperview()
                    }
//                    UIView.animate(withDuration: 1, animations: {
//                        bannerView.alpha = 0
//                        bannerView.removeFromSuperview()
//                    })
                }
            }
        }
    }
    /*
    @objc func removeAdsBTNClicked(){
        print("Removing Ads Coming soon.")
//        TODO: handle other currency?
//        let product = AppDelegate.products
        let product = AppDelegate.products[SettingsTableViewController.RemoveAds]
//        let product = AppDelegate.products[SettingsTableViewController.RemoveAds]
        if let pro = product {
            if pro.productIdentifier == SettingsTableViewController.RemoveAds {
                if SKPaymentQueue.canMakePayments(){
                    let request = SKMutablePayment(product: pro)
                    SKPaymentQueue.default().add(request)
                }
            }
        }
//        updateSettingsTable()
    }
    
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            print(transaction)
    //            print(transaction.error)
    //            print(transaction.transactionState)
            if transaction.transactionState == .purchased {
                print("Transaction Successful")
//                removeAds(transaction: transaction)
                UserDefaults.standard.set(true, forKey: "ad-free")
                self.removeAds()
            } else if transaction.transactionState == .failed {
                print("Transaction Failed")
                SKPaymentQueue.default().finishTransaction(transaction as SKPaymentTransaction)
            } else if transaction.transactionState == .restored {
                print("restored")
//                removeAds(transaction: transaction)
                UserDefaults.standard.set(true, forKey: "ad-free")
                self.removeAds()
            } else if transaction.transactionState == .purchasing {
                print("Purchasing")
            }
        }
    }
    
 */
    public func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print(error)
//        bannerView.backgroundColor = .white
//        
//        let adText = UILabel()
//        adText.text = "Please Support This App"
//        adText.textColor = .black
//        adText.textAlignment = .center
//        let _ = Utils.SetupContraints(child: adText, parent: bannerView)
    }
}
/*
extension AppDelegate: SKProductsRequestDelegate {
//    static var test = [String: Any]()
    static var products: [String:SKProduct] = [String: SKProduct]()
//    private static var _myProductsProperty = [String:[String:SKProduct]]()
//    var products: [String:SKProduct] {
//        get {
//            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
//            return AppDelegate._myProductsProperty[tmpAddress] ?? [String:SKProduct]()
//        }
//        set(newValue) {
//            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
//            AppDelegate._myProductsProperty[tmpAddress] = newValue
//        }
//    }
    // MARK: IN-APP-PURCHASE
    
    func LoadProducts(){
        let products: Set = [SettingsTableViewController.RemoveAds]
        let request = SKProductsRequest(productIdentifiers: products)
        request.delegate = self
        request.start()
    }
    
//    var products: [String:SKProduct] = [String: SKProduct]()
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print(response)
        for pro in response.products {
            print(pro.productIdentifier)
            AppDelegate.products[pro.productIdentifier] = pro
        }
    }
}
*/
