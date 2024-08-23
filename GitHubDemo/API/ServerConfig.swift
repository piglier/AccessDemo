//
//  ServerConfig.swift
//  GitHubDemo
//
//  Created by 朱彥睿 on 2024/8/17.
//

import Foundation

protocol ServerConfigType {
    var apiBaseUrl: URL { get }
}

struct ServerConfig: ServerConfigType {
    
    var apiBaseUrl: URL
    
    static let development: ServerConfigType = ServerConfig(
        apiBaseUrl: URL(string: "https://api.github.com/users")!
    )
}
