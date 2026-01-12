//
//  Post.swift
//  CombinePostsApp
//
//  Created by Sakshi on 08/01/26.
//

struct Post: Codable, Identifiable {
    let id: Int
    let title: String
    let body: String
}
