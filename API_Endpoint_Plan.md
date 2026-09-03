API ENDPOINT PLAN
=================

BASE URL:
/api


1. AUTHENTICATION
=================

POST   /api/auth/register
       Register a new user.

POST   /api/auth/login
       Login an existing user and return authentication token.


2. USERS
========

GET    /api/users
       Get all users.

GET    /api/users/{id}
       Get a single user by User_ID.

POST   /api/users
       Create a new user.

PUT    /api/users/{id}
       Update an existing user's details.

DELETE /api/users/{id}
       Delete a user.

GET    /api/users/{id}/enrolments
       Get all enrolments belonging to a user.


3. ROLES
========

GET    /api/roles
       Get all roles.

GET    /api/roles/{id}
       Get a specific role.

POST   /api/roles
       Create a new role.

PUT    /api/roles/{id}
       Update an existing role.

DELETE /api/roles/{id}
       Delete a role.

GET    /api/roles/{id}/users
       Get all users assigned to a role.


4. EVENTS
=========

GET    /api/events
       Get all events.

GET    /api/events/{id}
       Get a specific event.

POST   /api/events
       Create a new event.

PUT    /api/events/{id}
       Update an existing event.

DELETE /api/events/{id}
       Delete an event.

GET    /api/events/{id}/categories
       Get all categories belonging to an event.

GET    /api/events/{id}/enrolments
       Get all participants enrolled in an event.

GET    /api/events/{id}/results
       Get results for participants in an event.


5. CATEGORIES
=============

GET    /api/categories
       Get all event categories.

GET    /api/categories/{id}
       Get a specific category.

POST   /api/categories
       Create a new category.

PUT    /api/categories/{id}
       Update an existing category.

DELETE /api/categories/{id}
       Delete a category.

GET    /api/categories/{id}/enrolments
       Get all participants enrolled in a category.


6. ENROLMENTS
=============

GET    /api/enrolments
       Get all enrolments.

GET    /api/enrolments/{id}
       Get a specific enrolment.

POST   /api/enrolments
       Register a participant for a category.

PUT    /api/enrolments/{id}
       Update an enrolment.

DELETE /api/enrolments/{id}
       Cancel/delete an enrolment.

GET    /api/enrolments/{id}/result
       Get the race result for an enrolment.


7. RESULTS
==========

GET    /api/results
       Get all race results.

GET    /api/results/{id}
       Get a specific result.

POST   /api/results
       Record a new race result.

PUT    /api/results/{id}
       Update an existing race result.

DELETE /api/results/{id}
       Delete a race result.


DATABASE RELATIONSHIPS
======================

ROLES
  |
  | 1
  |
  | *
USERS
  |
  | 1
  |
  | *
ENROLMENTS
  |
  | 1
  |
  | 1
RESULTS


EVENTS
  |
  | 1
  |
  | *
CATEGORIES
  |
  | 1
  |
  | *
ENROLMENTS


MAIN API FLOW
=============

User
  ↓
Authentication
  ↓
Events
  ↓
Categories
  ↓
Enrolment
  ↓
Results


HTTP METHODS
============

GET
    Retrieve data.

POST
    Create new data.

PUT
    Update existing data.

DELETE
    Remove existing data.


EXAMPLE REQUESTS
================

POST /api/auth/register

{
    "email": "user@email.com",
    "password": "Password123",
    "firstName": "John",
    "lastName": "Doe",
    "phone": "0712345678",
    "roleId": 2
}


POST /api/events

{
    "organiser": "Race Organiser",
    "eventName": "Durban Marathon",
    "description": "Annual marathon event",
    "eventType": "Marathon",
    "startDate": "2026-10-10",
    "endDate": "2026-10-10",
    "location": "Durban"
}


POST /api/categories

{
    "eventId": 1,
    "catName": "10 KM Race",
    "distanceKm": 10,
    "entryFee": 150.00
}


POST /api/enrolments

{
    "partId": 5,
    "catId": 2,
    "regDate": "2026-09-03",
    "status": "Confirmed",
    "raceNumber": 105
}


POST /api/results

{
    "enrolId": 10,
    "finishTime": "01:25:32",
    "position": 15,
    "chipTime": "01:25:10"
}
