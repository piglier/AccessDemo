//
//  UserListCell.swift
//  GitHubDemo
//
//  Created by 朱彥睿 on 2024/8/19.
//

import UIKit
import ComposableArchitecture

struct UserListCellViewModel: Reducer {
    
    init() {}
    
    enum Action { case populate(User) }
    
    struct State: Equatable {
        var avatarPath: String? = nil
        var loginName: String = ""
        var isAdmin: Bool = false
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .populate(user):
                state.avatarPath = user.avatarPath
                state.loginName = user.login
                state.isAdmin = user.siteAdmin
                return .none
            }
        }
    }
}
