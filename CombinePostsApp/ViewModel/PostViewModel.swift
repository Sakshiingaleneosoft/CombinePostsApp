//
//  PostViewModel.swift
//  CombinePostsApp
//
//  Created by Sakshi on 08/01/26.
//

import Combine
import Foundation

class PostViewModel: ObservableObject {

    // MARK: - Published Properties
    @Published private(set) var allPosts: [Post] = []
    @Published var posts: [Post] = []
    @Published var searchText: String = ""
    @Published var errorMessage: String?
    @Published var showError: Bool = false

    // MARK: - Pagination State
    private var currentPage = 1
    private let pageSize = 10
    private var isLoading = false

    // MARK: - Subjects
    let loadNextPage = PassthroughSubject<Void, Never>()
    let refreshSubject = PassthroughSubject<Void, Never>()

    // MARK: - Dependencies
    private let apiService = APIService()
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init
    init() {
        setupSearchBinding()
        setupPagination()
        setupRefresh()

        // Initial load
        loadNextPage.send(())
    }

    // MARK: - Search Pipeline
    private func setupSearchBinding() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .map { [weak self] text -> [Post] in
                guard let self = self else { return [] }

                if text.isEmpty {
                    return self.allPosts
                }

                return self.allPosts.filter {
                    $0.title.lowercased().contains(text.lowercased())
                }
            }
            .assign(to: &$posts)
    }

    // MARK: - Pagination Pipeline (flatMap)
    private func setupPagination() {

        loadNextPage
            .filter { [weak self] in
                guard let self = self else { return false }
                return !self.isLoading
            }
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.isLoading = true
            })
            .flatMap { [weak self] _ -> AnyPublisher<[Post], Never> in
                guard let self = self else {
                    return Just([]).eraseToAnyPublisher()
                }

                return self.apiService
                      .fetchPosts(page: self.currentPage, limit: self.pageSize)
                      .catch { [weak self] error -> Just<[Post]> in
                          self?.errorMessage = error.localizedDescription
                          self?.showError = true
                          return Just([])
                      }
                      .eraseToAnyPublisher()
            }
            .sink { [weak self] newPosts in
                guard let self = self else { return }

                self.isLoading = false

                guard !newPosts.isEmpty else { return }

                self.currentPage += 1
                self.allPosts.append(contentsOf: newPosts)
                self.posts = self.allPosts
            }
            .store(in: &cancellables)
    }

    // MARK: - Refresh Logic
    private func setupRefresh() {
        refreshSubject
            .sink { [weak self] in
                guard let self = self else { return }

                self.currentPage = 1
                self.allPosts.removeAll()
                self.posts.removeAll()

                self.loadNextPage.send(())
            }
            .store(in: &cancellables)
    }
}
