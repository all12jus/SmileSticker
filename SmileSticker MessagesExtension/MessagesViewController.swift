//
//  MessagesViewController.swift
//  smartStickers MessagesExtension
//
//  Created by Justin Allen on 2/16/20.
//  Copyright © 2020 Justin Allen. All rights reserved.
//

import UIKit
import Messages

extension MSSticker {
    convenience init(called description: String, from filename: String) {
        let path = Bundle.main.path(forResource: filename, ofType: "png")! // Make sure the specified file exists; otherwise, you’ll get a runtime error.
        let url = URL(fileURLWithPath: path)
        try! self.init(contentsOfFileURL: url, localizedDescription: description) // Unsafe
    }
}

class MessagesViewController: MSMessagesAppViewController {
    
    static func lerp(from a: CGFloat, to b: CGFloat, val: CGFloat) -> CGFloat {
        return (1 - val) * a + val * b
    }
    
    static func drawFace(size: CGSize = CGSize(width: 100, height: 100), faceNumber: Float) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        let sfMid = faceNumber * 20
        let img = renderer.image { ctx in
            // awesome drawing code

//            switch face {
//            case .sad:
//                ctx.cgContext.setFillColor(UIColor.red.cgColor)
//            case .smile:
//                ctx.cgContext.setFillColor(UIColor.green.cgColor)
//            @unknown default:
//                break
//            }
            
            let happyColor = UIColor.yellow.cgColor
            let sadColor = UIColor.blue.cgColor
            
            let redValue:CGFloat = MessagesViewController.lerp(from: sadColor.components![0], to: happyColor.components![0], val: CGFloat(faceNumber + 0.5))
            let greenValue:CGFloat = MessagesViewController.lerp(from: sadColor.components![1], to: happyColor.components![1], val: CGFloat(faceNumber + 0.5))
            let blueValue:CGFloat = MessagesViewController.lerp(from: sadColor.components![2], to: happyColor.components![2], val: CGFloat(faceNumber + 0.5))
            
            if #available(iOSApplicationExtension 13.0, *) {
                let faceColor: CGColor = CGColor.init(srgbRed: redValue, green: greenValue, blue: blueValue, alpha: 1)
                ctx.cgContext.setFillColor(faceColor)
            } else {
                // Fallback on earlier versions
                let faceColor: CGColor = UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 1).cgColor
                ctx.cgContext.setFillColor(faceColor)
            }
            
//            ctx.cgContext.setFillColor(faceColor)
//            if faceNumber > 0 {
//                ctx.cgContext.setFillColor(UIColor.green.cgColor)
//            } else {
//                ctx.cgContext.setFillColor(UIColor.red.cgColor)
//            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(0)
            
            // Background
            ctx.cgContext.addArc(center: CGPoint(x: size.width/2, y: size.height/2), radius: ((size.height*0.9)/2), startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: false)
            ctx.cgContext.drawPath(using: .fill)
            
            
            
            
            let eyeY = size.height / 2.7
            // Left Eye
            let leftEyeCenter = CGPoint(x: size.width / 3.5, y: eyeY)
            ctx.cgContext.setFillColor(UIColor.white.cgColor)
            ctx.cgContext.addArc(center: leftEyeCenter, radius: 10, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: false)
            ctx.cgContext.drawPath(using: .fill)
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            ctx.cgContext.addArc(center: leftEyeCenter, radius: 6, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: false)
            ctx.cgContext.drawPath(using: .fill)
            
            
            
            // Right Eye
            let rightEyeCenter = CGPoint(x: size.width - (size.width / 3.5), y: eyeY)
            ctx.cgContext.setFillColor(UIColor.white.cgColor)
            ctx.cgContext.addArc(center: rightEyeCenter, radius: 10, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: false)
            ctx.cgContext.drawPath(using: .fill)
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            ctx.cgContext.addArc(center: rightEyeCenter, radius: 6, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: false)
            ctx.cgContext.drawPath(using: .fill)
            
            
            // Smile/Frown
            let yPoint = (size.height / 3) * 2
            let startPoint = CGPoint(x: size.width / 4 , y: yPoint )
            let midPoint =  CGPoint(x: size.width / 2, y:
                yPoint + CGFloat(sfMid)
            )
            let endPoint = CGPoint(x: (size.width / 4) * 3, y: yPoint)
            ctx.cgContext.setLineCap(.round)
            ctx.cgContext.setLineWidth(3)
            ctx.cgContext.move(to: startPoint)
            ctx.cgContext.addQuadCurve(to: endPoint, control: midPoint)
            ctx.cgContext.drawPath(using: .stroke)
            
            
//            ctx.cgContext.setLineWidth(0)
//            ctx.cgContext.addArc(center: CGPoint(x: size.width/2, y: size.height/2), radius: size.height/3, startAngle: 0, endAngle: CGFloat.pi, clockwise: false)
//            ctx.cgContext.drawPath(using: .fillStroke)
        }

        return img
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
    
//    let toggleSwitch: UISwitch = {
//        let sw = UISwitch()
//        sw.isOn = true
//        sw.addTarget(self, action: #selector(toggleFace), for: UIControl.Event.valueChanged)
////        sw.target(forAction: #selector(toggleFace), withSender: nil)
//        return sw
//    }()
    
    let slider: UISlider = {
        let slider = UISlider()
        slider.maximumValue = 1
        slider.minimumValue = -1
        slider.addTarget(self, action: #selector(changeFace), for: UIControl.Event.valueChanged)
        slider.value = 1
        // could i add snap points?
        return slider
    }()
    
    @objc func changeFace(){
        do {
            let image = MessagesViewController.drawFace(faceNumber: slider.value)
//            let image = MessagesViewController.drawRectangle(face: currentFace)
    //        let imageView = UIImageView(image: image)
            stickerImageView.image = image
            stickerView.sticker = nil
            let path = NSTemporaryDirectory().appending(UUID().uuidString).appending(".png")
            let url = URL(fileURLWithPath: path)
            let data = image.pngData()
            try data?.write(to: url)
            let sticker = try MSSticker.init(contentsOfFileURL: url, localizedDescription: "Test")
    //            let stickerView = MSStickerView()
            stickerView.sticker = sticker
//            DispatchQueue.main.async {
//                self.stickerImageView.image = image
//                self.stickerView.sticker = sticker
//            }
            
//            print("sticker should have updated.")
        } catch  {
            print(error)
        }
    }
    
    var stickerViewConstaints: Utils.Contraints? = nil
    var settingsViewContstraints:Utils.Contraints? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(slider)
        view.addSubview(stickerView)
//        view.addSubview(toggleSwitch)
        
        do {
//            let image = MessagesViewController.drawRectangle(face: .smile)
            let image = MessagesViewController.drawFace(faceNumber: slider.value)
            stickerImageView = UIImageView(image: image)
            let path = NSTemporaryDirectory().appending(UUID().uuidString).appending(".png")
            let url = URL(fileURLWithPath: path)
            let data = image.pngData()
            try data?.write(to: url)
            let sticker = try MSSticker.init(contentsOfFileURL: url, localizedDescription: "Test")
            stickerView.sticker = sticker
            stickerView.addSubview(stickerImageView)
        } catch  {
            
        }
        
//            stickerView.addSubview(stickerImageView)
        
        stickerViewConstaints = Utils.SetupContraints(child: stickerView, parent: view, addToParent: false, top: true, topConstant: 100, leading: false, trailing: false, bottom: false, centerX: true, centerY: true, width: true, widthConstant: 100, height: true, heightConstant: 100)
        stickerViewConstaints?.topAnchor?.isActive = false
        
        let padding = view.bounds.width/4
        let _ = Utils.SetupContraints(child: slider, parent: view, addToParent: false, topConstant: 5, topTarget: stickerView.bottomAnchor, leading: true, leadingConstant: padding, trailing: true, trailingConstant: padding, centerX: true)
    
    }
    
    
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        print(view.bounds.size)
//    }
    
    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.
        
        // Use this method to configure the extension and restore previously stored state.
    }
    
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
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
    
        // Use this to clean up state related to the deleted message.
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called before the extension transitions to a new presentation style.
        print("Changing?!")
        print(view.bounds.size)
        print(presentationStyle.rawValue)
        stickerView.alpha = 0.5
        UIView.animate(withDuration: 0.1) {
            switch presentationStyle {
            case .compact:
                self.stickerViewConstaints?.topAnchor?.isActive = false
                self.stickerViewConstaints?.centerYAnchor?.isActive = true
                break
            case .expanded:
                self.stickerViewConstaints?.centerYAnchor?.isActive = false
                self.stickerViewConstaints?.topAnchor?.isActive = true
                break
            default: break
            }
            self.view.layoutIfNeeded()
        }
        // Use this method to prepare for the change in presentation style.
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called after the extension transitions to a new presentation style.
        print("changed")
        stickerView.alpha = 1
        
        // Use this method to finalize any behaviors associated with the change in presentation style.
    }

}
