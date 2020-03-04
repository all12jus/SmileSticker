//
//  MessagesViewController.swift
//  smartStickers MessagesExtension
//
//  Created by Justin Allen on 2/16/20.
//  Copyright © 2020 Justin Allen. All rights reserved.
//

import UIKit
import Messages
import GoogleMobileAds

extension MSSticker {
    convenience init(called description: String, from filename: String) {
        let path = Bundle.main.path(forResource: filename, ofType: "png")! // Make sure the specified file exists; otherwise, you’ll get a runtime error.
        let url = URL(fileURLWithPath: path)
        try! self.init(contentsOfFileURL: url, localizedDescription: description) // Unsafe
    }
}

class CollectionColorCell: UICollectionViewCell {
    
    public var color: UIColor{
        didSet{
            self.colorView.backgroundColor = color
        }
    }
    
    let colorView: UIView = {
        let vw = UIView()
        vw.layer.borderColor = UIColor.label.cgColor
        vw.layer.borderWidth = 1
        vw.layer.cornerRadius = 21 // was 25
        return vw
    }()
        
    override init(frame: CGRect){
        self.color = .clear
        super.init(frame: .zero)
        let _ = Utils.SetupContraints(child: colorView, parent: self)
        print(colorView.layer.cornerRadius)
        colorView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class TableController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    public let cellId = "Cell"
    public var colorDelegate: ColorSelectorDelegate?
    let colors:[UIColor] = [
//        UIColor.black,
//        UIColor.white,
        UIColor.red,
        UIColor.blue,
        UIColor.green,
        UIColor.yellow,
        UIColor.purple,
        UIColor.cyan,
        UIColor.magenta,
        UIColor.orange
    ]
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CollectionColorCell
        cell.color = colors[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        colorDelegate!.changeColor(color: colors[indexPath.row])
    }
}

protocol ColorSelectorDelegate {
    func changeColor(color: UIColor)
}

class MessagesViewController: MSMessagesAppViewController, ColorSelectorDelegate {
    
    func applicationVersion() -> String {

        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }

    func applicationBuild() -> String {

        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
    }

    func versionBuild() -> String {

        let version = self.applicationVersion()
        let build = self.applicationBuild()

//        return "\(version) (\(build)) \(gitHash)"
        return "\(version) (\(build))"
    }
    
    func version() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        return "\(version) build \(build)"
    }
    
    func buildDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        if let infoPath = Bundle.main.path(forResource: "Info", ofType: "plist"), let infoAttr = try? FileManager.default.attributesOfItem(atPath: infoPath), let infoDate = infoAttr[.modificationDate] as? Date {
            return dateFormatter.string(from: infoDate)
        }
        return dateFormatter.string(from: Date())
    }
    
    func changeColor(color: UIColor) {
        selectedColor = color
        changeFace()
        colorPickerViewController.changeColor(color: color)
    }
    
    
    static func lerp(from a: CGFloat, to b: CGFloat, val: CGFloat) -> CGFloat {
        return (1 - val) * a + val * b
    }
    
    let sideView: UIView = {
        let vw = UIView()
        vw.layer.borderWidth = 1
        vw.layer.borderColor = UIColor.blue.cgColor
        return vw
    }()
    
    var stickerImageView: UIImageView = UIImageView()
    let stickerView: MSStickerView = {
        let stickerView = MSStickerView()
        return stickerView
    }()
    
    let slider: UISlider = {
        let slider = UISlider()
        slider.maximumValue = 1
        slider.minimumValue = -1
        slider.addTarget(self, action: #selector(changeFace), for: UIControl.Event.valueChanged)
        slider.value = 0.65
        // could i add snap points?
        return slider
    }()
    
    var selectedColor: UIColor = .green
    
    @objc public func changeFace(){
        do {
            let image = FaceDrawing.drawFace(smileNumber: slider.value, backgroundColor: selectedColor)
            stickerImageView.image = image
            stickerView.sticker = nil
            let path = NSTemporaryDirectory().appending(UUID().uuidString).appending(".png")
            let url = URL(fileURLWithPath: path)
            let data = image.pngData()
            try data?.write(to: url)
            let sticker = try MSSticker.init(contentsOfFileURL: url, localizedDescription: "Test")
            stickerView.sticker = sticker
        } catch  {
            print(error)
        }
    }
    
    var stickerViewConstaints: Utils.Contraints? = nil
    var settingsViewContstraints:Utils.Contraints? = nil
    var controller = TableController() // <------ wtf
    
    
    let colorPickerViewController = ColorPickerViewController()
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
//        let emptyView = UIView()
        // Do any additional setup after loading the view.
        view.addSubview(slider)
        view.addSubview(stickerView)
        view.addSubview(colorPickerViewController.view)
        colorPickerViewController.view.isHidden = true
        
        colorPickerViewController.colorDelegate = self
        controller.colorDelegate = self
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 1, left: 2, bottom: 1, right: 2)
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 42, height: 42) // was 50x50
        print(layout)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.delegate = controller
        collectionView.dataSource = controller
        collectionView.register(CollectionColorCell.self, forCellWithReuseIdentifier: controller.cellId)
        view.addSubview(collectionView)
        stickerView.addSubview(stickerImageView)
        changeFace()
        
//            stickerView.addSubview(stickerImageView)
        
        stickerViewConstaints = Utils.SetupContraints(child: stickerView, parent: view, addToParent: false, top: true, topConstant: 4, leading: false, trailing: false, bottom: false, centerX: true, width: true, widthConstant: 100, height: true, heightConstant: 100)

        let padding = view.bounds.width/4
        let _ = Utils.SetupContraints(child: slider, parent: view, addToParent: false, topConstant: 5, topTarget: stickerView.bottomAnchor, leading: true, leadingConstant: padding, trailing: true, trailingConstant: padding, bottom: false, centerX: true
            , height: true, heightConstant: 15
        )
        
        let _ = Utils.SetupContraints(child: collectionView, parent: view, addToParent: false, topConstant: 5, topTarget: slider.bottomAnchor, leading: true, leadingConstant: 0, trailing: true, trailingConstant: 0, bottom: false, centerX: true, height: true, heightConstant: 45) // this shouldn't pin to bottom on expanded mode.... was 60
        
        let _ = Utils.SetupContraints(child: colorPickerViewController.view, parent: view, addToParent: false, topConstant: 5, topTarget: collectionView.bottomAnchor, leading: true, leadingConstant: 0, trailing: true, trailingConstant: 0,
                                      bottom: false,
//                                      bottom: true, bottomConstant: -150, bottomTarget: view.safeAreaLayoutGuide.bottomAnchor,
                                      centerX: true)
        
        let adView = UIView()
        
        let _ = Utils.SetupContraints(child: adView, parent: view, addToParent: true, top: true, topConstant: 5, topTarget: colorPickerViewController.view.bottomAnchor, leading: true, trailing: true, bottom: true
//            , height: true, heightConstant: 102
        )
        
        let stickerTap = UITapGestureRecognizer(target: self, action: #selector(stickerViewSelected))
        stickerView.addGestureRecognizer(stickerTap)
        
        let stickerLong = UILongPressGestureRecognizer(target: self, action: #selector(stickerViewSelected))
        stickerView.addGestureRecognizer(stickerLong) // TODO: do different for long press....
        
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ "d2edb294edfc15fbb05b34d319957267" ];
//        view.injectAds()
//        adView.injectAds()
        colorPickerViewController.changeColor(color: selectedColor)
    }
    
//    var currentConversation: MSConversation?
    
    @objc func stickerViewSelected(){
        print("Tapped")
        if let convo = activeConversation {
            if let sticker = stickerView.sticker {
                convo.insert(sticker) { (e) in
//                    print(e as Any)
                    if e == nil {
                        let usage: ApiController.UsageModel = ApiController.UsageModel(
                            BundleID: Bundle.main.bundleIdentifier!,
                            AppVersion: self.applicationVersion(),
                            BuildNumber: self.applicationBuild(),
                            color: self.selectedColor.hex(),
                            // TODO device id
                            slider: self.slider.value
//                            Data: data
                        )
                        ApiController.SubmitReport(usage)
                    }
                }
                
                
//                convo.insert(<#T##sticker: MSSticker##MSSticker#>, completionHandler: <#T##((Error?) -> Void)?##((Error?) -> Void)?##(Error?) -> Void#>)
            }
        }
//        currentConversation?.insert(stickerView.sticker!, completionHandler: { (err) in
//            print("SEnt")
//            print(err as Any)
//        })
    }
    
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        print(view.bounds.size)
//    }
    
    
    // MARK: - Conversation Handling
    
//    override func willBecomeActive(with conversation: MSConversation) {
//        // Called when the extension is about to move from the inactive to active state.
//        // This will happen when the extension is about to present UI.
//
//        // Use this method to configure the extension and restore previously stored state.
//        let stickerTap = UITapGestureRecognizer(target: self, action: #selector(stickerViewSelected))
//        stickerView.addGestureRecognizer(stickerTap)
//
//        let stickerLong = UILongPressGestureRecognizer(target: self, action: #selector(stickerViewSelected))
//        stickerView.addGestureRecognizer(stickerLong) // TODO: do different for long press....
//
//        currentConversation = conversation
//    }
    
    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dissmises the extension, changes to a different
        // conversation or quits Messages.
        
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
    }
   
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        
        // Use this method to trigger UI updates in response to the message.
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
//        print(message)
        print("Sending...")
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
        print("cancel...")
        // Use this to clean up state related to the deleted message.
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        if presentationStyle == .expanded {
            // show colorPickerView
            colorPickerViewController.view.isHidden = false
        } else {
            // hide colorPickerView
            colorPickerViewController.view.isHidden = true
//            colorPickerViewController.color = selectedColor
            colorPickerViewController.updateColorSliders(selectedColor)
            // TODO: init sliders!!!!
        }
    }
    
//    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
//        // Called before the extension transitions to a new presentation style.
//        print("Changing?!")
//        print(view.bounds.size)
//        print(presentationStyle.rawValue)
//        stickerView.alpha = 0.5
//        UIView.animate(withDuration: 0.1) {
//            switch presentationStyle {
//            case .compact:
//                self.stickerViewConstaints?.topAnchor?.isActive = false
//                self.stickerViewConstaints?.centerYAnchor?.isActive = true
//                break
//            case .expanded:
//                self.stickerViewConstaints?.centerYAnchor?.isActive = false
//                self.stickerViewConstaints?.topAnchor?.isActive = true
//                break
//            default: break
//            }
//            self.view.layoutIfNeeded()
//        }
//        // Use this method to prepare for the change in presentation style.
//    }
//
//    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
//        // Called after the extension transitions to a new presentation style.
//        print("changed")
//        stickerView.alpha = 1
//
//        // Use this method to finalize any behaviors associated with the change in presentation style.
//    }

}
