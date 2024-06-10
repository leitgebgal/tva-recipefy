# Recipefy - Share Recipes with the World

Recipefy is a Flutter application that allows users to share their favorite recipes with the world. Users can add, edit, and delete recipes, as well as rate recipes shared by others. The application includes essential user functionalities such as login, registration, and password reset. Recipefy uses Firebase Firestore for its database and Firebase Authentication for user management.

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Firebase Setup](#firebase-setup)
- [Usage](#usage)

## Features
- **Search Recipes**: Users can search recipes by title and category.
- **Add Recipes**: Users can add new recipes with details such as title, ingredients, instructions, categories, and an image.
- **Edit Recipes**: Users can edit their own recipes to update any information.
- **Delete Recipes**: Users can delete their own recipes.
- **Rate Recipes**: Users can rate recipes shared by others.
- **User Authentication**: Secure user authentication using Firebase Authentication.
  - **Login**: Users can log in with their email and password.
  - **Registration**: New users can create an account with their email and password.
  - **Reset Password**: Users can reset their password if they forget it.

## Installation

### Prerequisites

- Flutter installed on your machine. If not, follow the instructions [here](https://flutter.dev/docs/get-started/install).
- Firebase account. If not, create one [here](https://firebase.google.com/).

### Steps

1. **Clone the repository**

   ```sh
   git clone https://github.com/yourusername/recipefy.git
   cd recipefy
   ```

2. **Install dependencies**

   ```sh
   flutter pub get
   ```   

3. **Run the app**

   ```sh
   flutter run
   ```

## Firebase Setup

1. **Create a Firebase project**
   - Go to the [Firebase Console](https://console.firebase.google.com/) and create a new project.

2. **Add an Android app to your Firebase project**
   - Register your app with the package name (e.g., com.yourdomain.recipefy).
   - Download the `google-services.json` file and place it in the `android/app` directory.

3. **Add an iOS app to your Firebase project**
   - Register your app with the iOS bundle ID.
   - Download the `GoogleService-Info.plist` file and place it in the `ios/Runner` directory.
   - Open `ios/Runner.xcworkspace` in Xcode and add `GoogleService-Info.plist` to the Runner target.

4. **Enable Firebase Authentication**
   - In the Firebase Console, go to the Authentication section.
   - Enable Email/Password as a sign-in method.

5. **Enable Firestore**
   - In the Firebase Console, go to the Firestore Database section.
   - Create a Firestore database in test mode (you can change the security rules later).

## Usage

### Searching a Recipe
1. Log in to the app.
2. Navigate to the Home Screen.
3. Fill in the details such as title, ingredients, instructions, categories, and upload an image.
4. Save the recipe.

### Adding a Recipe
1. Log in to the app.
2. Navigate to the "Add Recipe" section from the Home Screen.
3. Fill in the details such as title, ingredients, instructions, categories, and upload an image.
4. Save the recipe.

### Editing a Recipe
1. Go to your profile.
2. Select a recipe you want to edit.
3. Update the necessary details.
4. Save the changes.

### Deleting a Recipe
1. Go to your profile.
2. Select a recipe you want to delete.
3. Confirm the deletion.

### Rating a Recipe
1. Browse recipes.
2. Select a recipe to view details.
3. Rate the recipe using the rating system provided.

### User Authentication
1. Register a new account using your email and password.
2. Log in to your account.

