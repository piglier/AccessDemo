//
//  View+.swift
//  GitHubDemo
//
//  Created by 朱彥睿 on 2024/9/4.
//

import UIKit


extension UIView {
    func addSubViews(_ views: UIView...) {
        views.forEach { addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    
    func centerX(_ view: UIView) {
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func setDimension(width: CGFloat, height: CGFloat) {
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
        self.widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat, enableInsets: Bool) {
        
        var topInset = CGFloat(0)
        var bottomInset = CGFloat(0)
        if #available(iOS 11, *), enableInsets {
            let insets = self.safeAreaInsets
            topInset = insets.top
            bottomInset = insets.bottom
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop + topInset).isActive = true
        }
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom - bottomInset).isActive = true
        }
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
    }
    
    func createStaffLabel(width: CGFloat, height: CGFloat) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: width).isActive = true
        label.heightAnchor.constraint(equalToConstant: height).isActive = true
        label.textAlignment = .center
        label.font = UIFont(name: "Helvetica", size: 20)
        label.text = "STAFF"
        label.clipsToBounds = true
        label.layer.cornerRadius = height / 2
        label.textColor = .white
        label.backgroundColor = .systemBlue
        return label
    }
}

struct GithubLabel {
    static func createStaffLabel(width: CGFloat, height: CGFloat) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: width).isActive = true
        label.heightAnchor.constraint(equalToConstant: height).isActive = true
        label.textAlignment = .center
        label.font = UIFont(name: "Helvetica", size: 20)
        label.text = "STAFF"
        label.clipsToBounds = true
        label.layer.cornerRadius = height / 2
        label.textColor = .white
        label.backgroundColor = .systemBlue
        return label
    }
}

struct GitHubLabelFactory {
    enum GithubLabelType {
        case smallStaff, mediumStaff, largeStaff
    }
    static func createLabel(type: GithubLabelType) ->  UILabel{
        switch type {
        case .smallStaff:
            return GithubLabel.createStaffLabel(width: 30, height: 10)
        case .mediumStaff:
            return GithubLabel.createStaffLabel(width: 60, height: 20)
        case .largeStaff:
            return GithubLabel.createStaffLabel(width: 90, height: 30)
        }
    }
}
