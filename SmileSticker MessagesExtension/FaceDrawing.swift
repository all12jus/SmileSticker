//
//  FaceDrawing.swift
//  SmileSticker MessagesExtension
//
//  Created by Justin Allen on 2/25/20.
//  Copyright © 2020 Justin Allen. All rights reserved.
//

import Foundation
import UIKit

class FaceDrawing {
    static func drawFace(size: CGSize = CGSize(width: 100, height: 100), smileNumber: Float, backgroundColor: UIColor) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        // 20
        let sfMid = smileNumber * 40
        // -10
        let sfLeft_Right_Y = smileNumber * -8
        let img = renderer.image { ctx in
            ctx.cgContext.setFillColor(backgroundColor.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(0)
            
            // Background
            
            ctx.cgContext.addArc(center: CGPoint(x: size.width/2, y: size.height/2), radius: ((size.height*0.9)/2), startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: false)
//            ctx.cgContext.addArc(center: CGPoint(x: size.width/2, y: size.height/2), radius: ((size.height*0.9)/2), startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: false)
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
            let yLRPoint: CGFloat = CGFloat(sfLeft_Right_Y) + (size.height / 3) * 2
            let startPoint = CGPoint(x: size.width / 4 , y: yLRPoint )
            let midPoint =  CGPoint(x: size.width / 2, y:
                yPoint + CGFloat(sfMid)
            )
            let endPoint = CGPoint(x: (size.width / 4) * 3, y: yLRPoint)
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
}
