# CombinePostsApp

A lightweight iOS application built using **SwiftUI** and **Combine** to demonstrate reactive programming concepts such as publishers, subscribers, operators, subjects, pagination, and error handling.

---

## 📱 Features

- Fetch posts from a REST API using Combine
- Live search with debouncing
- Infinite scrolling (pagination) using `flatMap`
- Pull-to-refresh support
- Centralized error handling
- Clean MVVM architecture

---

## 🧱 Architecture

- **MVVM (Model–View–ViewModel)**
- Business logic handled in ViewModel
- SwiftUI views react automatically using `@Published`

---

## 🛠 Technologies Used

- Swift 
- SwiftUI
- Combine
- URLSession
- REST API (JSONPlaceholder)

---

## 🔄 Combine Concepts Covered

### Publishers
- `@Published`
- `URLSession.dataTaskPublisher`
- `Just`
- `PassthroughSubject`

### Subscribers
- `sink`
- `assign`

### Operators
- `map`
- `filter`
- `debounce`
- `removeDuplicates`
- `flatMap`
- `catch`
- `receive(on:)`
- `eraseToAnyPublisher`

---

## 🔁 Pagination Implementation

- Pagination implemented using `PassthroughSubject` + `flatMap`
- Scroll events trigger page-based API calls
- New data is appended to existing list reactively
- Prevents duplicate calls using loading state

---

## 🔍 Search Functionality

- Implemented using SwiftUI `searchable`
- Combine pipeline processes user input
- Debounced and filtered against a single source of truth

---

## ⚠️ Error Handling

- Errors handled using Combine `catch`
- User-friendly alerts shown in SwiftUI
- Retry logic implemented for network failures

---

## 🧠 Learning Outcome

This project demonstrates how to:
- Use Combine for asynchronous programming
- Manage data flow reactively in SwiftUI
- Implement pagination using `flatMap`
- Avoid common Combine state-management pitfalls


