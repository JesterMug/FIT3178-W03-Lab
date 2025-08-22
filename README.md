# Hero Party Builder

**Hero Party Builder** is an iOS app that lets you build a party of superheroes. You can create a party from a pre-defined list of heroes, add your own custom heroes, and search through the entire hero database.

The app was developed as a lab exercise for the unit **FIT3178** and covers fundamental concepts in iOS development, including:

- **Working with UITableView**: Displaying dynamic lists of data, handling different cell types, and managing sections.
- **Navigation**: Using `UINavigationController` to move between different screens.
- **Data Models**: Creating custom classes and using enumerations to structure app data.
- **Delegation**: Implementing a custom protocol to pass data and communication between view controllers.
- **Search Functionality**: Implementing `UISearchController` and the `UISearchResultsUpdating` protocol to filter a list of heroes.
- **Core UI Concepts**: Connecting UI elements from the storyboard to code using `@IBOutlet` and configuring views programmatically.

---

## Features

### Current Party Screen
- View your current party of heroes (up to 6 members).
- The number of heroes in your party is displayed below the list.
- Swipe to delete a hero from your party.
- An **Add** button navigates to the "All Heroes" screen to add more heroes.
- If your party is empty, a different cell is displayed to prompt you to add heroes.

### All Heroes Screen
- Displays a list of all heroes, including hard-coded and user-created ones.
- Tap a hero to add them to your party (as long as the party isn't full).
- A **Create** button lets you go to the "Create Hero" screen.
- A swipe-down gesture reveals a search bar to filter the list of heroes by name.

### Create Hero Screen
- A simple form to create your own custom heroes.
- Requires a name and a description of their abilities.
- Tapping **Add** creates the hero and adds them to the main hero database.

---

## Learning Objectives

This lab project is designed to help students master several core concepts:

- **Model-View-Controller (MVC) Pattern**: Understanding how to separate data, presentation, and logic.
- **Table Views**: Deep dive into `UITableViewDataSource` and `UITableViewDelegate` methods, including:
  - `tableView(_:numberOfRowsInSection:)`
  - `tableView(_:cellForRowAt:)`
- **Protocols and Delegation**: Learning how to use custom protocols to establish a communication channel between different parts of the app—a powerful and common design pattern in iOS.
- **UISearchController**: Implementing a key UI component for filtering data—a common requirement in many apps.

