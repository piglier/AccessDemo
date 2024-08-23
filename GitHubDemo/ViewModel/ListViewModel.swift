//
//  ListViewModel.swift
//  GitHubDemo
//
//  Created by 朱彥睿 on 2024/8/17.
//

import Foundation
import ComposableArchitecture

class ListViewModel: Reducer {

    
    init() {}
    
    enum Action {
        case viewDidLoad, paginated(since: Int), userList(Result<[User], Error>)
    }
    
    struct State: Equatable {
        var users: [User] = []
        var needReload: Bool = false
        var errorMsg: String? = nil
    }
    
    var body: some ReducerOf<ListViewModel> {
        Reduce { state, action in
            switch action {
            case .viewDidLoad:
                return .run { await $0(.paginated(since: 1)) }
            case let .paginated(since):
                return .run { await $0(.userList(Result { try await Service().getUserList(since: since)} )) }
            case let .userList(.success(users)):
                state.users = users
                return .none
             case let .userList(.failure(error)):
                state.errorMsg = error.localizedDescription
                return .none
            }
        }
    }

}
