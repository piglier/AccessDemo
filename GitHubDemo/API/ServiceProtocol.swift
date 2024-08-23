//
//  ServiceProtocol.swift
//  GitHubDemo
//
//  Created by 朱彥睿 on 2024/8/17.
//

import Foundation

protocol ServiceProtocol {
    var serverConfig: ServerConfigType { get }
    
    init(serverConfig: ServerConfigType)
    
    func getUserList(since: Int) async throws -> [User]
    
    func getProfile(login: String) async throws -> Profile
    
}
