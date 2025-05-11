//
//  ServiceClient.swift
//  GitHubDemo
//
//  Created by 朱彥睿 on 2025/4/27.
//

import ComposableArchitecture

struct ServiceClient {
    var getUserList: @Sendable (_ since: Int) async throws -> [User]
}

// 註冊到 TCA DependencyValues
extension DependencyValues {
    var serviceClient: ServiceClient {
        get { self[ServiceClientKey.self] }
        set { self[ServiceClientKey.self] = newValue }
    }
    
}

private enum ServiceClientKey: DependencyKey {
    static let liveValue = ServiceClient(
        getUserList: { since in
            try await Service().getUserList(since: since)
            
        }
    )
}

