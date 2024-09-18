# Project Name
This project is a Ruby on Rails application that integrates with Google Calendar to sync and display events. It includes user authentication, a synced calendar view, and OAuth 2.0 integration with Google.

# Prerequisites
Before you begin, ensure you have met the following requirements:

Ruby version: 3.2.2 (You can check the .ruby-version file to confirm the exact version)
Rails version: 7.x
Node.js and Yarn: Required for managing JavaScript dependencies
Database: PostgreSQL
System Dependencies
Ensure the following system dependencies are installed:

Ruby: Follow instructions to install the correct Ruby version using a version manager like rbenv or rvm.
Bundler: gem install bundler
Node.js and Yarn: Install Node.js using nvm and Yarn globally via npm install -g yarn.
PostgreSQL: Make sure PostgreSQL is running on your local machine.

# Configuration

# Clone the repository:

git clone https://github.com/Ahsan1447/google_calendar_events.git
cd google_calendar_events

# Install the required gems and dependencies:

bundle install
yarn install

# Set up environment variables:
Create an .env file at the root of the project and add your Google API credentials and other sensitive information:

GOOGLE_CLIENT_ID=your_google_client_id
GOOGLE_CLIENT_SECRET=your_google_client_secret
GOOGLE_REDIRECT_URI = http://localhost:3000/auth/callback

# Database Setup

Create the database:
rails db:create

Run the migrations:
rails db:migrate

# Running the Application

rails server