//
//  User.swift
//  GitHubDemo
//
//  Created by 朱彥睿 on 2024/8/17.
//

import Foundation


/**
 {
     "login": "pjhyett",
     "id": 3,
     "node_id": "MDQ6VXNlcjM=",
     "avatar_url": "https://avatars.githubusercontent.com/u/3?v=4",
     "gravatar_id": "",
     "url": "https://api.github.com/users/pjhyett",
     "html_url": "https://github.com/pjhyett",
     "followers_url": "https://api.github.com/users/pjhyett/followers",
     "following_url": "https://api.github.com/users/pjhyett/following{/other_user}",
     "gists_url": "https://api.github.com/users/pjhyett/gists{/gist_id}",
     "starred_url": "https://api.github.com/users/pjhyett/starred{/owner}{/repo}",
     "subscriptions_url": "https://api.github.com/users/pjhyett/subscriptions",
     "organizations_url": "https://api.github.com/users/pjhyett/orgs",
     "repos_url": "https://api.github.com/users/pjhyett/repos",
     "events_url": "https://api.github.com/users/pjhyett/events{/privacy}",
     "received_events_url": "https://api.github.com/users/pjhyett/received_events",
     "type": "User",
     "site_admin": false,
     "name": "PJ Hyett",
     "company": "GitHub, Inc.",
     "blog": "https://hyett.com",
     "location": "San Francisco",
     "email": null,
     "hireable": null,
     "bio": null,
     "twitter_username": null,
     "public_repos": 8,
     "public_gists": 21,
     "followers": 8299,
     "following": 30,
     "created_at": "2008-01-07T17:54:22Z",
     "updated_at": "2024-01-22T12:11:10Z"
 }
 */

struct User: Codable, Hashable, Equatable, Identifiable {
    let avatarPath: String
    let login: String
    let siteAdmin: Bool
    let id: UUID
    
   
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.avatarPath = try container.decode(String.self, forKey: .avatarPath)
        self.login = try container.decode(String.self, forKey: .login)
        self.siteAdmin = try container.decode(Bool.self, forKey: .siteAdmin)
        self.id = UUID()
    }
    
    private enum CodingKeys: String, CodingKey {
        case login
        case avatarPath = "avatar_url"
        case siteAdmin = "site_admin"
    }
}
