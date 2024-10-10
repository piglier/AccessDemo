//
//  View+.swift
//  GitHubDemo
//
//  Created by 朱彥睿 on 2024/9/4.
//

import UIKit


protocol ClosureConfigurable {}

extension ClosureConfigurable where Self: UIView {
    init(_ configure: (Self) -> Void) {
        self.init(frame: .zero)
        configure(self)
    }
}

extension UIView: ClosureConfigurable {}


extension UIView {
    func addSubView(_ view: UIView, constraints: [NSLayoutConstraint]) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints)
    }
}

struct GithubLabel {
    static func createStaffLabel(width: CGFloat, height: CGFloat, size: CGFloat) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: width).isActive = true
        label.heightAnchor.constraint(equalToConstant: height).isActive = true
        label.textAlignment = .center
        label.font = UIFont(name: "Helvetica", size: size)
        label.text = "STAFF"
        label.clipsToBounds = true
        label.layer.cornerRadius = height / 2
        label.textColor = .white
        label.backgroundColor = .systemBlue
        
        return label
    }
}

struct GithubImageView {
    static func createAvatarImagView(length: CGFloat) -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: length).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: length).isActive = true
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = length / 2
        return imageView
    }
}

struct GitHubLabelFactory {
    enum GithubLabelType {
        case smallStaff, mediumStaff, largeStaff
    }
    
    enum GithubImageViewType {
        case smallAvatar, mediumAvatar, largeAvatar
    }
    
    static func createLabel(type: GithubLabelType) ->  UILabel {
        switch type {
        case .smallStaff:
            return GithubLabel.createStaffLabel(width: 60, height: 20, size: 15)
        case .mediumStaff:
            return GithubLabel.createStaffLabel(width: 90, height: 30, size: 20)
        case .largeStaff:
            return GithubLabel.createStaffLabel(width: 120, height: 35, size: 25)
        }
    }
    
    static func createImageView(type: GithubImageViewType) -> UIImageView {
        switch type {
        case .smallAvatar:
            return GithubImageView.createAvatarImagView(length: 50)
        case .mediumAvatar:
            return GithubImageView.createAvatarImagView(length: 100)
        case .largeAvatar:
            return GithubImageView.createAvatarImagView(length: 150)
        }
    }
}


extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach({ addArrangedSubview($0) })
    }
}
