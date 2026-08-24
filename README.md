# Trip Splitter

Trip Splitter is a full-stack web application built with Ruby on Rails for managing and splitting expenses between people travelling together.

Users can create trips, add participants, record shared expenses, and automatically calculate how much each participant owes or should receive.

## Features

- User registration and authentication
- Create and manage trips
- Add and remove trip participants
- Create, edit, and delete expenses
- Select the payer and participants for each expense
- Split expenses equally between selected participants
- Calculate how much each user owes
- Calculate how much each user should receive
- Calculate net balances for each participant
- Support expenses in multiple currencies
- Calculate balances separately for each currency
- Display the correct currency for expenses and balances
- Automatically recalculate splits when an expense or its participants are updated
- Validation for expense and split data

## Expense Splitting

Each expense has a payer and one or more selected participants.

For an equal split, the total expense amount is divided between the selected participants and each participant's share is stored individually.

The application then calculates, for the current user:

- the amount they owe for an expense;
- the amount they should receive if they paid;
- their final balance for the trip.

Balances are calculated separately for each currency, so amounts in EUR, RON, USD, or other currencies are not combined.

For example:

```text
Dinner
300 RON
Paid by Cristina

You owe 100.00 RON to Cristina

Net balance: -100.00 RON
```

## Tech Stack

- Ruby
- Ruby on Rails
- PostgreSQL
- Active Record
- HTML / ERB
- Bootstrap
- JavaScript
- Minitest
- Git / GitHub

## Testing

The project includes automated tests for core application functionality, including:

- Expense creation
- Equal expense splitting
- Participant handling
- Payer and participant scenarios
- Balance calculations
- Multi-currency balance calculations
- Invalid expense data

Run the test suite with:

```bash
bin/rails test
```

## What I Learned

While building Trip Splitter, I practiced:

- Building a full-stack application with Ruby on Rails
- Designing Rails models and Active Record associations
- Implementing CRUD functionality
- Working with join tables and model relationships
- Implementing business logic for shared expense calculations
- Handling multiple currencies without combining balances
- Building user-specific balance calculations
- Implementing authentication and authorization
- Handling form data and nested participant selections
- Writing automated tests with Minitest
- Debugging database and Active Record issues
- Using Git branches, commits, and GitHub Issues to manage development

## Installation

Clone the repository:

```bash
git clone https://github.com/CristinaLazar12/Trip-Splitter.git
cd Trip-Splitter
```

Install dependencies:

```bash
bundle install
```

Set up the database:

```bash
bin/rails db:prepare
```

Start the Rails server:

```bash
bin/rails server
```

Then open `localhost:3000` in your browser.

## Screenshots

### Trip Overview

<!-- Add screenshot here -->

### Expense Splitting

<!-- Add screenshot here -->

### Balance Summary

<!-- Add screenshot here -->

## Development

I used GitHub Issues to track features and bugs during development, including expense splitting, participant updates, and multi-currency balance handling.

## Author

Cristina Lazar
