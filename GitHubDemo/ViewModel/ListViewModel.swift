//
//  ListViewModel.swift
//  GitHubDemo
//
//  Created by 朱彥睿 on 2024/8/17.
//

import Foundation
import ComposableArchitecture

enum UserError: Error, Equatable {
    case networkError(String)
    case decodingError
}

extension UserError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .networkError(let msg):
            return msg
        case .decodingError:
            return "解析異常"
        }
    }
}

class ListViewModel: Reducer {
    
    @Dependency(\.serviceClient) var serviceClient
    
    init() {}
    
    enum Action: Equatable {
        case viewDidLoad, paginated(since: Int), userList(Result<[User], UserError>)
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
                guard !state.isFetching else { return .none }
                state.isFetching = true
                state.errorMsg = nil
                return .run{ send in
                    do {
                        let users = try await self.serviceClient.getUserList(since)
                        await send(.userList(.success(users)))
                    } catch {
                        await send(.userList(.failure(.decodingError)))
                    }
                }
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
