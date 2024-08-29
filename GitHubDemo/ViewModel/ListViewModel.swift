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
        // 已載入的頁面(viewDidLoad載入1-20筆後會變成1, 代表有載入一個頁面)
        var loadedPage: Int = 0
        var isFetching: Bool = false
    }
    
    var body: some ReducerOf<ListViewModel> {
        Reduce { state, action in
            switch action {
            case .viewDidLoad:
                return .run { await $0(.paginated(since: 1)) }
            case let .paginated(since):
                state.isFetching = true
                return .run { await $0(.userList(Result { try await Service().getUserList(since: since)} )) }
            case let .userList(.success(users)):
                state.users = state.users + users
                state.loadedPage += 1
                state.isFetching = false
                return .none
             case let .userList(.failure(error)):
                state.errorMsg = error.localizedDescription
                state.isFetching = false
                return .none
            }
        }
    }

}
