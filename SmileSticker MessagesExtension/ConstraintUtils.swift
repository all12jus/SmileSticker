//
//  ConstraintUtils.swift
//
//  Created by Justin Allen on 8/15/19.
//  Updated on 1/30/20
//  Copyright © 2019 Justin Allen. All rights reserved.
//

import UIKit

class Utils {
    public struct Contraints {
        var child: UIView? = nil
        var parent: UILayoutGuide? = nil
        var topAnchor : NSLayoutConstraint? = nil
        var leadingAnchor : NSLayoutConstraint? = nil
        var trailingAnchor : NSLayoutConstraint? = nil
        var bottomAnchor : NSLayoutConstraint? = nil
        var widthAnchor : NSLayoutConstraint? = nil
        var heightAnchor : NSLayoutConstraint? = nil
        var centerXAnchor: NSLayoutConstraint? = nil
        var centerYAnchor: NSLayoutConstraint? = nil
    }
    
    public static func SetupContraints(
        child : UIView, parent: UIView, addToParent: Bool = true,
        top: Bool = true, topConstant: CGFloat? = nil, topTarget: NSLayoutAnchor<NSLayoutYAxisAnchor>? = nil,
        leading:Bool = true, leadingConstant: CGFloat? = nil, leadingTarget: NSLayoutAnchor<NSLayoutXAxisAnchor>? = nil,
        trailing:Bool = true, trailingConstant: CGFloat? = nil, trailingTarget: NSLayoutAnchor<NSLayoutXAxisAnchor>? = nil,
        bottom:Bool = true, bottomConstant: CGFloat? = nil, bottomTarget: NSLayoutAnchor<NSLayoutYAxisAnchor>? = nil,
        centerX:Bool = false, centerXConstant: CGFloat? = nil, centerXTarget: NSLayoutAnchor<NSLayoutXAxisAnchor>? = nil,
        centerY:Bool = false, centerYConstant: CGFloat? = nil, centerYTarget: NSLayoutAnchor<NSLayoutYAxisAnchor>? = nil,
        width: Bool = false, widthConstant: CGFloat? = nil,
        height: Bool = false, heightConstant: CGFloat? = nil
    ) -> Contraints {
        child.translatesAutoresizingMaskIntoConstraints = false
//        let parent = UIView()
        parent.addSubview(child)
        let guide : UILayoutGuide = parent.safeAreaLayoutGuide
        var constraints : Contraints = Contraints()
        constraints.child = child
        constraints.parent = guide
//        constraints.parent = parent
        
        if top {
            let target = topTarget ?? guide.topAnchor
            if let constant = topConstant {
                constraints.topAnchor = child.topAnchor.constraint(equalTo: target, constant: constant)
            } else {
                constraints.topAnchor = child.topAnchor.constraint(equalTo: target)
            }
            constraints.topAnchor?.isActive = true
        }
        
        if leading {
            let target = leadingTarget ?? guide.leadingAnchor
            if let constant = leadingConstant {
                constraints.leadingAnchor = child.leadingAnchor.constraint(equalTo: target, constant: constant)
            } else {
                constraints.leadingAnchor = child.leadingAnchor.constraint(equalTo: target)
            }
            constraints.leadingAnchor?.isActive = true
        }
        
        if trailing {
            let target = trailingTarget ?? guide.trailingAnchor
            if let constant = trailingConstant {
                constraints.trailingAnchor = child.trailingAnchor.constraint(equalTo: target, constant: -1 * constant)
            } else {
                constraints.trailingAnchor = child.trailingAnchor.constraint(equalTo: target)
            }
            constraints.trailingAnchor?.isActive = true
        }
        
        if bottom {
            let target = bottomTarget ?? guide.bottomAnchor
            if let constant = bottomConstant {
                constraints.bottomAnchor = child.bottomAnchor.constraint(equalTo: target, constant: -1 * constant)
            } else {
                constraints.bottomAnchor = child.bottomAnchor.constraint(equalTo: target)
            }
            constraints.bottomAnchor?.isActive = true
        }
        
        if centerX {
            let target = centerXTarget ?? guide.centerXAnchor
            if let constant = centerXConstant {
                constraints.centerXAnchor = child.centerXAnchor.constraint(equalTo: target, constant: constant)
            } else {
                constraints.centerXAnchor = child.centerXAnchor.constraint(equalTo: target)
            }
            constraints.centerXAnchor?.isActive = true
        }
        
        if centerY {
            let target = centerYTarget ?? guide.centerYAnchor
            if let constant = centerYConstant {
                constraints.centerYAnchor = child.centerYAnchor.constraint(equalTo: target, constant: constant)
            } else {
                constraints.centerYAnchor = child.centerYAnchor.constraint(equalTo: target)
            }
            constraints.centerYAnchor?.isActive = true
        }
        
        if width {
            if let constant = widthConstant {
                constraints.widthAnchor = child.widthAnchor.constraint(equalToConstant: constant)
            } else {
                // TODO: What do you do if it gets here?!
                print("widthConstant isn't set while width is enabled")
            }
            constraints.widthAnchor?.isActive = true
        }
        
        if height {
            if let constant = heightConstant {
                constraints.heightAnchor = child.heightAnchor.constraint(equalToConstant: constant)
            } else {
                // TODO: What do you do if it gets here?!
                print("heightConstant isn't set while height is enabled")
            }
            constraints.heightAnchor?.isActive = true
        }
        
        return constraints
    }
}

