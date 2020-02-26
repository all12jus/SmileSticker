//
//  ColorPickerViewController.swift
//  SmileSticker
//
//  Created by Justin Allen on 2/26/20.
//  Copyright © 2020 Justin Allen. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return (red, green, blue, alpha)
    }
}

class ColorPickerViewController : UIViewController, ColorSelectorDelegate {
    func changeColor(color: UIColor) {
        updateColorSliders(color)
    }
    
    
    public var colorDelegate: ColorSelectorDelegate?
    private var color: UIColor = .clear
    
    @objc func updateColor(){
        // Update color
        color = .init(red: CGFloat(redSlider.value), green: CGFloat(greenSlider.value), blue: CGFloat(blueSlider.value), alpha: 1)
        colorDelegate?.changeColor(color: color)
    }
    
    let redSlider: UISlider = {
        let slider = UISlider()
        slider.maximumValue = 1
        slider.minimumValue = 0
        slider.addTarget(self, action: #selector(updateColor), for: UIControl.Event.valueChanged)
        slider.value = 1
        // could i add snap points?
        return slider
    }()
    
    let greenSlider: UISlider = {
        let slider = UISlider()
        slider.maximumValue = 1
        slider.minimumValue = 0
        slider.addTarget(self, action: #selector(updateColor), for: UIControl.Event.valueChanged)
        slider.value = 1
        // could i add snap points?
        return slider
    }()
    
    let blueSlider: UISlider = {
        let slider = UISlider()
        slider.maximumValue = 1
        slider.minimumValue = 0
        slider.addTarget(self, action: #selector(updateColor), for: UIControl.Event.valueChanged)
        slider.value = 1
        // could i add snap points?
        return slider
    }()
    
    public func updateColorSliders(_ col : UIColor){
        color = col
//        color.
        let (r, g, b, _ /*a*/) = color.rgba
        redSlider.value = Float(r)
        greenSlider.value = Float(g)
        blueSlider.value = Float(b)
    }
    
    func getSliderView(slider: UISlider, colorText: String, color: UIColor) -> UIView {
        let l = UILabel()
        l.text = colorText
        let vw = UIView()
        vw.addSubview(slider)
        vw.addSubview(l)
        
        let _ = Utils.SetupContraints(child: l, parent: vw, addToParent: false, top: true, topConstant: 8, leading: true, leadingConstant: 8, trailing: true, trailingConstant: 4, trailingTarget: slider.leadingAnchor, bottom: true, bottomConstant: 8)
        let _ = Utils.SetupContraints(child: slider, parent: vw, addToParent: false, top: true, topConstant: 8, leading: true, leadingConstant: 4, leadingTarget: l.trailingAnchor, trailing: true, trailingConstant: 8, bottom: true, bottomConstant: 8)
        vw.backgroundColor = color
        return vw
    }
    
    // MARK: View Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let redView: UIView = getSliderView(slider: redSlider, colorText: "R", color: .red)
        let greenView: UIView = getSliderView(slider: greenSlider, colorText: "G", color: .green)
        let blueView: UIView = getSliderView(slider: blueSlider, colorText: "B", color: .blue)
        
        let stackView = UIStackView(arrangedSubviews: [redView, greenView, blueView])
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        let _ = Utils.SetupContraints(child: stackView, parent: view)
    }
    
}
