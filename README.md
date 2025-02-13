# Simple Facebook App

This is a simple Facebook-like application built using Ruby on Rails. It allows users to sign up, create posts ("thoughts"), like posts, manage friendships, and edit their profile.

## Features

- **User Authentication** (Signup & Login)
- **Thoughts** (Post thoughts, like/unlike posts)
- **Friend Management** (Send, accept, and reject friend requests)
- **Bootstrap Styling** for UI enhancements
- **SQLite3 Database** for data storage

## Technologies Used

- **Ruby Version:** 3.x
- **Rails Version:** 7.x
- **Database:** SQLite3
- **Front-end:** Bootstrap, ERB Templates

## Installation & Setup

1. **Clone the Repository:**
   ```sh
   git clone https://github.com/yourusername/simple_facebook_app.git
   cd simple_facebook_app
   ```

2. **Install Dependencies:**
   ```sh
   bundle install
   ```

3. **Setup Database:**
   ```sh
   rails db:create db:migrate db:seed
   ```

4. **Run the Server:**
   ```sh
   rails server
   ```
   The app will be available at `http://localhost:3000`

## Folder Structure

- `app/models/` - Contains ActiveRecord models (User, Thought, Friendship, etc.)
- `app/controllers/` - Contains controllers for authentication, thoughts, friendships, etc.
- `app/views/` - Contains ERB templates for UI rendering
- `config/routes.rb` - Defines application routes
- `db/migrate/` - Contains database migration files

## Usage

- Sign up and log in.
- Add friends by searching users and sending requests.
- Accept or reject friend requests from the "Friends" page.
- Post thoughts and like/unlike them.
- View posts from accepted friends on the home page.

This project is open-source and free to use.

---
For any issues, feel free to raise an issue or contribute to the project!

