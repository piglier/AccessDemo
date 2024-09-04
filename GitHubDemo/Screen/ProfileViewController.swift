//
//  ProfileViewController.swift
//  GitHubDemo
//
//  Created by 朱彥睿 on 2024/8/17.
//

import UIKit
import Combine
import ComposableArchitecture


class ProfileViewController: UIViewController {
    lazy var profileVS: ViewStoreOf<ProfileReducer> = ViewStoreOf<ProfileReducer>(store, observe: { $0 })
    var store: StoreOf<ProfileReducer> = Store(initialState: ProfileReducer.State(), reducer: { ProfileReducer() })
    
    override func viewDidLoad() {
        bindingStyle()
        bindingUI()
        binding()
    }
    
    
    // private function
    
    private func bindingStyle() {
        view.backgroundColor = .white
    }
    
    private func bindingUI() {
        view.addSubview(avatarStack)
        avatarStack.translatesAutoresizingMaskIntoConstraints = false
        avatarStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        avatarStack.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        avatarStack.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        avatarStack.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        avatarStack.addArrangedSubview(avatarImageView)
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.topAnchor.constraint(equalTo: self.avatarStack.topAnchor, constant: 50).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 75
        
        avatarStack.addArrangedSubview(userNameLabel)
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        userNameLabel.font = UIFont(name: "Helvetica", size: 25)
        
//        view.addSubview(avatarImageView)
//        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
//        avatarImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        avatarImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
//        avatarImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
//        avatarImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
//        avatarImageView.clipsToBounds = true
//        avatarImageView.layer.cornerRadius = 75
        
//        view.addSubview(userNameLabel)
//        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
//        userNameLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        userNameLabel.topAnchor.constraint(equalTo: self.avatarImageView.bottomAnchor, constant: 10).isActive = true
//        userNameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        userNameLabel.font = UIFont(name: "Helvetica", size: 25)
        
        view.addSubview(linearView)
        linearView.translatesAutoresizingMaskIntoConstraints = false
        linearView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15).isActive = true
        linearView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15).isActive = true
        linearView.topAnchor.constraint(equalTo: self.avatarStack.bottomAnchor, constant: 20).isActive = true
        linearView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        view.addSubview(staffHStackView)
        staffHStackView.translatesAutoresizingMaskIntoConstraints = false
        staffHStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15).isActive = true
        staffHStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15).isActive = true
        staffHStackView.topAnchor.constraint(equalTo: self.linearView.bottomAnchor, constant: 20).isActive = true
        staffHStackView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        staffHStackView.addArrangedSubview(staffImageView)
        staffImageView.translatesAutoresizingMaskIntoConstraints = false
        staffImageView.leadingAnchor.constraint(equalTo: staffHStackView.leadingAnchor, constant: 0).isActive = true
        staffImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        staffImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        staffImageView.tintColor = .black
        
        staffHStackView.addArrangedSubview(staffVStackView)
        staffVStackView.addArrangedSubview(loginLabel)
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        loginLabel.leadingAnchor.constraint(equalTo: staffVStackView.leadingAnchor, constant: 0).isActive = true
        loginLabel.font = UIFont(name: "Helvetica", size: 16)
        
        view.addSubview(locationStackView)
        locationStackView.translatesAutoresizingMaskIntoConstraints = false
        locationStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15).isActive = true
        locationStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15).isActive = true
        locationStackView.topAnchor.constraint(equalTo: self.staffHStackView.bottomAnchor, constant: 15).isActive = true
        locationStackView.heightAnchor.constraint(equalToConstant: 80).isActive = true
     
        locationStackView.addArrangedSubview(locationImageView)
        locationImageView.translatesAutoresizingMaskIntoConstraints = false
        locationImageView.leadingAnchor.constraint(equalTo: locationStackView.leadingAnchor, constant: 0).isActive = true
        locationImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        locationImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        locationImageView.tintColor = .black
        
        locationStackView.addArrangedSubview(locationLabel)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        locationLabel.font = UIFont(name: "Helvetica", size: 16)

        view.addSubview(linkStackView)
        linkStackView.translatesAutoresizingMaskIntoConstraints = false
        linkStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15).isActive = true
        linkStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15).isActive = true
        linkStackView.topAnchor.constraint(equalTo: self.locationStackView.bottomAnchor, constant: 15).isActive = true
        linkStackView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        linkStackView.addArrangedSubview(linkImageView)
        linkImageView.translatesAutoresizingMaskIntoConstraints = false
        linkImageView.leadingAnchor.constraint(equalTo: linkStackView.leadingAnchor, constant: 0).isActive = true
        linkImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        linkImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        linkImageView.tintColor = .black
        
        linkStackView.addArrangedSubview(linkLabel)
        linkLabel.translatesAutoresizingMaskIntoConstraints = false
        linkLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        linkLabel.font = UIFont(name: "Helvetica", size: 16)
    }
    
    private func binding() {
        profileVS.publisher.profile.removeDuplicates().sink { [weak self] profile in
            let avaPath = profile.avatarPath
            Task {
                do {
                    let image = try await URLLoader.loadImage(from: avaPath)
                    DispatchQueue.main.async {
                        self?.avatarImageView.image = image
                    }
                } catch {
                    print("avaImage load error: \(error.localizedDescription)")
                }
            }
            self?.userNameLabel.text = profile.name
            self?.loginLabel.text = profile.login
            self?.locationLabel.text = profile.location ?? "UnKnow"
            
            if let bio = profile.bio {
                let bioLabel = UILabel()
                bioLabel.text = bio
                self?.avatarStack.addArrangedSubview(bioLabel)
            }
            
            if profile.siteAdmin {
                let siteAdmibLabel = GitHubLabelFactory.createLabel(type: .mediumStaff)
                self?.staffVStackView.addArrangedSubview(siteAdmibLabel)
            }
            guard !profile.blog.isEmpty else {
                self?.linkLabel.text = "NA"
                return
            }
            let attributedString = NSMutableAttributedString(string: profile.blog)
            attributedString.addAttribute(.underlineStyle, value: 1, range: NSMakeRange(0, attributedString.length))
            attributedString.addAttribute(.underlineColor, value: UIColor.systemBlue, range: NSMakeRange(0, attributedString.length))
            self?.linkLabel.textColor = .systemBlue
            self?.linkLabel.attributedText = attributedString
        }.store(in: &cancelables)
    }
    
    
    // private property
    private let avatarStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .center
       return stack
    }()
    
    private let avatarImageView: UIImageView = {
        return UIImageView()
    }()
    private let userNameLabel = UILabel()
    private let linearView: UIView = {
        let v = UIView()
        v.backgroundColor = .lightGray
        return v
    }()
    
    private let staffHStackView: UIStackView =
    {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 20
        stack.alignment = .center
        return stack
    }()
    
    private let staffVStackView: UIStackView =
    {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 8
        return stack
    }()
    
    private let staffImageView: UIImageView = {
        return UIImageView(image: UIImage(systemName: "person.fill"))
    }()
    private let loginLabel = UILabel()
    // 顯示是否為員工
    private var staffLabel: UILabel?
    
    private let locationStackView: UIStackView =
    {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 20
        return stack
    }()
    private let locationImageView: UIImageView = {
        return UIImageView(image: UIImage(systemName: "location.north.circle.fill"))
    }()
    private let locationLabel = UILabel()
    
    private let linkStackView: UIStackView =
    {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 20
        return stack
    }()
    private let linkImageView: UIImageView = {
        return UIImageView(image: UIImage(systemName: "link"))
    }()
    private let linkLabel = UILabel()
    
    private var cancelables: [AnyCancellable] = []
}
