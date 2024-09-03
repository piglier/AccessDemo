//
//  URLLoader.swift
//  GitHubDemo
//
//  Created by 朱彥睿 on 2024/8/31.
//
import UIKit

struct URLLoader {
    static func loadImage(from url: String) async throws -> UIImage? {
        guard let url = URL(string: url) else { throw URLError(.badURL) }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        return UIImage(data: data)
    }
}
