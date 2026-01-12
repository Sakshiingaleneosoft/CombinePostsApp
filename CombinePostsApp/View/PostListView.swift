//
//  PostListView.swift
//  CombinePostsApp
//
//  Created by Sakshi on 08/01/26.
//

import SwiftUI
import Combine

struct PostListView: View {
    
    @StateObject private var viewModel = PostViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.posts.indices, id: \.self) { index in
                    let post = viewModel.posts[index]
                    
                    VStack(alignment: .leading) {
                        Text(post.title)
                            .font(.headline)
                        Text(post.body)
                            .font(.subheadline)
                    }
                    .onAppear {
                        if index == viewModel.posts.count - 1 {
                            viewModel.loadNextPage.send(())
                        }
                    }
                }
            }
            .navigationTitle("Posts")
            .searchable(text: $viewModel.searchText)
            .refreshable {
                viewModel.refreshSubject.send(())
            }
            .alert("Error",
                   isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }
}
