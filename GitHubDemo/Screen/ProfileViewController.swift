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
    
    init(store: StoreOf<ProfileReducer>) {
        super.init(nibName: nil, bundle: nil)
        self.store = store
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        bindingStyle()
        bindingUI()
        binding()
    }

    /// private function
    private func bindingStyle() {
        view.backgroundColor = .white
    }
    
    private func bindingUI() {
        let padding:            CGFloat = 15
        let imageViewLength:    CGFloat = 30
        let largeTopSpacing:    CGFloat = 50
        let smallTopSpacing:    CGFloat = 20
        let stackHeight:        CGFloat = 80
        
        view.addSubView(avatarStack, constraints:[
            avatarStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            avatarStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            avatarStack.topAnchor.constraint(equalTo: view.topAnchor, constant: largeTopSpacing)
        ])
        
        avatarStack.addArrangedSubviews([avatarImageView, userNameLabel])
        
        
        avatarStack.addSubView(userNameLabel, constraints: [
            userNameLabel.heightAnchor.constraint(equalToConstant: imageViewLength)
        ])
        
        view.addSubView(linearView, constraints: [
            linearView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            linearView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            linearView.topAnchor.constraint(equalTo: avatarStack.bottomAnchor, constant: smallTopSpacing),
            linearView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        view.addSubView(staffHStackView, constraints: [
            staffHStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            staffHStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            staffHStackView.topAnchor.constraint(equalTo: linearView.bottomAnchor, constant: smallTopSpacing),
            staffHStackView.heightAnchor.constraint(equalToConstant: stackHeight)
        ])
        
        staffHStackView.addArrangedSubviews([staffImageView, staffVStackView])
        
        staffHStackView.addSubView(staffImageView, constraints: [
            staffImageView.leadingAnchor.constraint(equalTo: staffHStackView.leadingAnchor, constant: 0),
            staffImageView.heightAnchor.constraint(equalToConstant: imageViewLength),
            staffImageView.widthAnchor.constraint(equalToConstant: imageViewLength)
        ])
        
        staffVStackView.addArrangedSubview(loginLabel)
    
        view.addSubView(locationStackView, constraints: [
            locationStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            locationStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            locationStackView.topAnchor.constraint(equalTo: self.staffHStackView.bottomAnchor, constant: padding),
            locationStackView.heightAnchor.constraint(equalToConstant: stackHeight)
        ])
        
        locationStackView.addArrangedSubviews([locationImageView, locationLabel])
        
        locationStackView.addSubView(locationImageView, constraints: [
            locationImageView.leadingAnchor.constraint(equalTo: locationStackView.leadingAnchor, constant: 0),
            locationImageView.heightAnchor.constraint(equalToConstant: imageViewLength),
            locationImageView.widthAnchor.constraint(equalToConstant: imageViewLength)
        ])


        view.addSubView(linkStackView, constraints: [
            linkStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            linkStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            linkStackView.topAnchor.constraint(equalTo: locationStackView.bottomAnchor, constant: padding),
            linkStackView.heightAnchor.constraint(equalToConstant: stackHeight)
        ])
        
        linkStackView.addArrangedSubviews([linkImageView, linkLabel])
        
        linkStackView.addSubView(linkImageView, constraints: [
            linkImageView.leadingAnchor.constraint(equalTo: self.linkStackView.leadingAnchor, constant: 0),
            linkImageView.heightAnchor.constraint(equalToConstant: imageViewLength),
            linkImageView.widthAnchor.constraint(equalToConstant: imageViewLength)
        ])
        view.accessibilityIdentifier = "ProfileView"
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
                bioLabel.numberOfLines = 0
                bioLabel.lineBreakMode = .byWordWrapping
                self?.avatarStack.addArrangedSubview(bioLabel)
            }
            
            if profile.siteAdmin {
                let siteAdmibLabel = GitHubLabelFactory.createLabel(type: .smallStaff)
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
    
    private let avatarStack = UIStackView {
        $0.spacing = 20
        $0.axis = .vertical
        $0.alignment = .center
    }
    
    private let avatarImageView = GitHubLabelFactory.createImageView(type: .largeAvatar)
    
    private let userNameLabel = UILabel {
        $0.font = UIFont(name: "Helvetica", size: 25)
    }
    
    
    private let linearView = UIView {
        $0.backgroundColor = .lightGray
    }
    
    private let staffHStackView = UIStackView {
        $0.spacing = 20
        $0.axis = .horizontal
        $0.alignment = .center
    }
    
    private let staffVStackView = UIStackView {
        $0.spacing = 8
        $0.axis = .vertical
        $0.alignment = .leading
    }
    
    private let staffImageView = UIImageView {
        $0.image = UIImage(systemName: "person.fill")
        $0.tintColor = .black
    }
    
    private let loginLabel = UILabel {
        $0.font = UIFont(name: "Helvetica", size: 16)
    }
    // 顯示是否為員工
    private var staffLabel: UILabel?
    
    private let locationStackView = UIStackView {
        $0.spacing = 20
        $0.axis = .horizontal
        $0.alignment = .center
    }
    
    private let locationImageView = UIImageView {
        $0.image = UIImage(systemName: "location.north.circle.fill")
        $0.tintColor = .black
    }
    

    private let locationLabel = UILabel {
        $0.font = UIFont(name: "Helvetica", size: 16)
    }
    
    private let linkStackView = UIStackView {
        $0.spacing = 20
        $0.axis = .horizontal
        $0.alignment = .center
    }
    
    private let linkImageView = UIImageView {
        $0.image = UIImage(systemName: "link")
        $0.tintColor = .black
    }
    
    private let linkLabel = UILabel {
        $0.font = UIFont(name: "Helvetica", size: 16)
    }
    
    private var cancelables: [AnyCancellable] = []
    
    
    private lazy var userViewStore = ViewStoreOf<UserReducer>(userStore, observe: { $0 })
    private var userStore = Store(initialState: UserReducer.State(), reducer: { UserReducer() })
}


struct UserReducer: Reducer {
    enum Action {
        case modify(String), grow, remove
    }
    struct State: Equatable {
        var id: UUID = UUID()
        var name: String = ""
        var age: Int = 1
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .grow:
                state.age += 1
                return .none
            case let .modify(name):
                state.name = name
                return .none
            case .remove:
                state.name = ""
                return .none
            }
        }
    }

}
