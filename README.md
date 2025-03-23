# Hayati

**Hayati** is a SwiftUI-based iOS app that delivers an Instagram-style infinite scroll feed, showcasing images and videos fetched from the Imgur API. With a focus on performance and user experience, it features media caching, optimized video playback, and a clean modular architecture.

## Minimum Requirements

- **iOS Version**: iOS 16.0 or later
- **Xcode Version**: Xcode 16.2 (released late 2024)
- **Swift**: Swift 5.9 or higher

## Architecture

Hayati follows a **Clean Architecture** approach with a modular, layered design to ensure separation of concerns, testability, and maintainability. The app is built using **SwiftUI** for the UI and **Combine** for reactive programming. Key architectural components include:

- **Presentation Layer**: SwiftUI views (`FeedView`, `ImageCellView`, `VideoCellView`, `PostCellView`) and view models (`FeedViewModel`) handle UI and state management.
- **Domain Layer**: Use cases (`FetchPostsUseCase`) define business logic, abstracting data operations.
- **Data Layer**: Repositories (`ImgurPostRepository`) fetch data, with a network layer (`NetworkService`) and caching (`CacheService`, `MediaCacheService`).
- **Services**: `VideoPlaybackService` manages AVPlayer-based video playback, and `MediaCacheService` handles image/video caching.
- **App Coordinator**: `AppCoordinator` bootstraps the app, wiring dependencies.

This structure supports scalability and allows easy swapping of data sources or UI components.

## Features
- **Infinite Scroll**: Instagram-style feed with gray spacers between posts. 
- **Media Caching**: Images and videos cached locally for instant playback (500 MB video cache limit). 
- **Video Playback**: Full-width videos at 70% screen height, playing only when fully visible. 
- **Dynamic Images**: Photos scale naturally with aspect ratio preservation. 
- **Pagination**: Loads more posts mid-scroll with a bottom loader, full-screen loader on first fetch.

## Room for Improvement

1. **UI Enhancements**: 
**Error Handling**: Add retry UI for failed fetches or media loads. **Refreshing**: Allow users to pull to scroll to get fresh feed.
**Interaction**: Allow users to interact with feed via Like, Comment or Share. 
2. **Testing**: 
**Unit Tests**: Add tests for `NetworkService`, `CacheService`, and `FetchPostsUseCase`. 
**UI Tests**: Simulate scrolling and playback scenarios. 
3. **Flexibility**: 
**API Source**: Add support to show multiple post in one cell. 
4. **Analytics**: Integrate analytics (e.g., Firebase) to track scroll behavior and video playtime.