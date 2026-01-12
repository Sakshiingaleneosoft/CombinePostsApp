//
//  APIService.swift
//  CombinePostsApp
//
//  Created by Sakshi on 08/01/26.
//

import Combine
import Foundation

class APIService {
    
    func fetchPosts(page: Int, limit: Int = 10) -> AnyPublisher<[Post], Error> {
        let url = URL(
            string: "https://jsonplaceholder.typicode.com/posts?_page=\(page)&_limit=\(limit)"
        )!
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Post].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

