//
//  ProfileViewModel.swift
//  GitHubDemo
//
//  Created by 朱彥睿 on 2024/8/29.
//

import ComposableArchitecture
import Combine


struct ProfileReducer: Reducer {

    enum Action {
        case fetch(String)
        case newProfile(Result<Profile, Error>)
        case closeMsg
    }
    
    struct State: Equatable {
        var profile: Profile = Profile(avatarPath: "", login: "", siteAdmin: false, bio: nil, name: "", location: "", blog: "")
        var errMsg: String = ""
        var shouldShowErrorMsg: Bool = false
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .newProfile(.success(profile)):
                state.profile = profile
                return .none
            case let .newProfile(.failure(error)):
                state.errMsg = error.localizedDescription
                state.shouldShowErrorMsg = true
                return .none
            case let .fetch(login):
                return .run{ await $0(.newProfile(Result{ try await Service().getProfile(login: login) })) }
            case .closeMsg:
                state.shouldShowErrorMsg = false
                return .none
            }
        }
    }
}



