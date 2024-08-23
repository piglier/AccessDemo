//
//  Route.swift
//  GitHubDemo
//
//  Created by 朱彥睿 on 2024/8/17.
//


enum Route {
    case list(since: Int)
    case profile(login: String)
    
    internal var requestProperties: (method: HttpMethod, path: String) {
        switch self {
        case let .list(since):
            return (.GET, "?since=\(since)&per_page=20")
        case let .profile(login):
                return (.GET, "/\(login)")
        }
    }
}
