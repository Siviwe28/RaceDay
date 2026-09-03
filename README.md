 Race Day System - Part 1

Overview
The Race Day System is a console application built in C# for managing race day registration and participant check-in operations. Part 1 implements the core registration and check-in functionality with in-memory data storage.

Features
- Participant registration with automatic race number generation
- Check-in management for registered participants
- Participant lookup and status verification
- Console-based interface for race day operations

Prerequisites
- .NET 6.0 SDK or later
- Visual Studio 2022 or later (recommended) or VS Code with C# extensions

Installation
Clone the repository: `git clone [repository-url]` then `cd race-day-system`. Build the solution: `dotnet build`.

Usage
Start the application: `dotnet run` from the project directory.

Available Commands:
- register [name] [age] - Register a new participant
- checkin [raceNumber]` - Check in a registered participant
- status [raceNumber]` - Check participant status
- list - Display all registered participants
- help - Show available commands
- exit - Exit the application

Example Workflow:

> register John Doe 28
Registration successful. Race Number: 1001
> checkin 1001
Participant 1001 checked in successfully
> status 1001
Race Number: 1001 | Name: Siviwe Mnyaka | Age: 28 | Status: Checked In


Data Storage
Part 1 uses in-memory storage. Participant data persists only during runtime and is lost when the application terminates.

Testing
Run the test suite: dotnet test

Future Enhancements (Part 2)
Persistent data storage with database integration, race timing and results tracking, reporting and analytics, API endpoints for external integration.

## License
This project is proprietary and confidential.
