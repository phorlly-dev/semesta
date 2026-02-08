# Semesta - Indonesian Social Media App

**Semesta** is a social media application built using **Flutter** and **Firebase**, offering an experience similar to platforms like X (Twitter) and Threads.

## Technology Stack

- **Framework**: Flutter for cross-platform development
- **Backend**: Firebase for authentication, database, and storage
- **Platform**: Android & iOS

## Key Features

Based on the app interface, Semesta provides:

### 🏠 Main Feed

- **For You**: Personalized content for users
- **Following**: Posts from followed accounts
- Repost system to share others' content

### 💬 Social Interactions

- Comments on posts
- Like/heart to show appreciation
- Repost to share content
- Bookmark to save posts
- Share to other platforms

### 📱 User Interface

- Modern and clean design
- Bottom navigation bar with icons:
    - 🔍 Search
    - 📺 Media/Video
    - 🏠 Home (active)
    - 🔔 Notifications
    - ✉️ Messages
- Floating action button (+) to create new posts

### 👤 Profile Features

- User profile picture
- Username and display name
- Post timestamps
- Content visibility status

## Flutter + Firebase Advantages

**Flutter** enables:

- Write once, run on both Android and iOS
- Fast native performance
- Responsive and attractive UI
- Hot reload for rapid development

**Firebase** provides:

- Secure user authentication
- Cloud Firestore for real-time database
- Firebase Storage for media (photos/videos)
- Cloud Functions for backend logic
- Analytics for user tracking
- Push notifications

## App Architecture

Semesta App ├── Authentication (Firebase Auth) ├── Feed System │ ├── For You Algorithm │ └── Following Timeline ├── Post Management │ ├── Create Post │ ├── Repost │ └── Media Upload ├── Engagement Features │ ├── Comments │ ├── Likes │ └── Bookmarks └── User Profiles

## Setting up Flutter (For Developers)

To contribute or develop on Semesta, you'll need to set up your Flutter environment. Here's a basic guide:

1. **Install Flutter SDK:**
    - Download the latest stable Flutter SDK from the official website: [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
    - Follow the instructions for your operating system (Windows, macOS, Linux).

2. **Configure Your Environment:**
    - **Windows:** Add Flutter's `bin` directory to your `PATH` environment variable.
    - **macOS:** Add Flutter's `bin` directory to your `.bash_profile` or `.zshrc` file.
    - **Linux:** Add Flutter's `bin` directory to your `.bashrc` or `.zshrc` file.

3. **Run `flutter doctor`:**
    - Open your terminal or command prompt and run `flutter doctor`. This command checks your environment and provides a list of any missing dependencies.

4. **Install Dependencies:**
    - Address any issues reported by `flutter doctor`. Common dependencies include:
        - **Android Studio/VS Code:** Install the Flutter and Dart plugins.
        - **Android SDK:** Ensure you have the latest Android SDK installed and configured.
        - **Xcode (macOS):** Install Xcode and configure your build settings.
5. **Clone the Repository:**
    - Obtain the Semesta repository (assuming it exists on a platform like GitHub).
    - Use `git clone https://github.com/phorlly-dev/semesta.git` to download the code.

6. **Run the App:**
    - Navigate to the project directory in your terminal.
    - Run `flutter run` to build and launch the app on a connected device or emulator.

## Conclusion

Semesta is a great example of a modern social media application implementation using Flutter and Firebase technology, delivering a familiar experience for users of platforms like X/Threads with an Indonesian local touch.
