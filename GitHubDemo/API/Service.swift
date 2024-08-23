//
//  Service.swift
//  GitHubDemo
//
//  Created by 朱彥睿 on 2024/8/17.
//

import Foundation


struct Service: ServiceProtocol {
   
    let serverConfig: ServerConfigType
    let monitor: ServiceMonitorProtocol
    
    init(serverConfig: ServerConfigType = ServerConfig.development) {
        self.serverConfig = serverConfig
        self.monitor = CompositeServiceMonitor(monitors: [ServiceMonitor()])
    }
    
    func getUserList(since: Int) async throws -> [User] {
        return try await request(.list(since: since))
    }
    
    func getProfile(login: String) async throws -> Profile {
        return try await request(.profile(login: login))
    }

}

