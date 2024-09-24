//
//  UserListCell.swift
//  GitHubDemo
//
//  Created by 朱彥睿 on 2024/8/19.
//

import UIKit
import ComposableArchitecture
import Combine

class UserListCell: UICollectionViewCell {
    
    lazy var userListCellVM: ViewStoreOf<UserListCellViewModel> = ViewStoreOf<UserListCellViewModel>(store, observe: { $0 })
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        

        addSubview(avatarView)
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        avatarView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30).isActive = true
        avatarView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        avatarView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        avatarView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        avatarView.clipsToBounds = true
        avatarView.layer.cornerRadius = 40
        
        addSubview(staffStackView)
        staffStackView.translatesAutoresizingMaskIntoConstraints = false
        staffStackView.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 15).isActive = true
        staffStackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        staffStackView.addArrangedSubview(userNameLabel)
        userNameLabel.setContentHuggingPriority(.required, for: .vertical)

        binding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func populate(user: User) {
        userListCellVM.send(.populate(user))
    }
    
    // private function

    private func loadImage(avatarPath: String) {
        guard let avatarURL = URL(string: avatarPath) else { return }
        let task = URLSession.shared.dataTask(with: avatarURL) { [weak self] data, response, error in
            if let error = error { print(error.localizedDescription); return }
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data else
            { print("[UserListCell] httpStatus error"); return }
            DispatchQueue.main.async {
                self?.avatarView.image = UIImage(data: data)
            }
        }
        task.resume()
    }
    
    private func binding() {
        userListCellVM.publisher.avatarPath.removeDuplicates().sink { [weak self] avatarPath in
            if let avatarPath = avatarPath {
                self?.loadImage(avatarPath: avatarPath)
            }
        }.store(in: &cancelable)
        
        userListCellVM.publisher.loginName.removeDuplicates().sink { [weak self] loginName in
            self?.userNameLabel.textColor = .lightGray
            self?.userNameLabel.font = UIFont(name: "Helvetica", size: 18)
            self?.userNameLabel.text = loginName
        }.store(in: &cancelable)
        
        userListCellVM.publisher.isAdmin.removeDuplicates().sink { [weak self] isAmin in
            self?.staffLabel = isAmin ? GitHubLabelFactory.createLabel(type: .mediumStaff) : nil
            guard let unwrappedLabel = self?.staffLabel else { return }
            self?.staffStackView.addArrangedSubview(unwrappedLabel)
        }.store(in: &cancelable)
    }
    
    // private property
    private var staffStackView: UIStackView =
    {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    private let avatarView: UIImageView = {
        return UIImageView(image: UIImage(named: "person"))
    }()
    private let userNameLabel = UILabel()
    // 顯示是否為員工
    private var staffLabel: UILabel?
    
    private let store: StoreOf<UserListCellViewModel> = 
    Store(initialState: UserListCellViewModel.State(), reducer: { UserListCellViewModel() })
    
    private var cancelable: [AnyCancellable] = []
}

