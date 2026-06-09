# Employee Engagement Backend

A backend system for managing employee engagement forms using Supabase, Node.js, and Google Sheets.

## Tech Stack
- Node.js + Express
- Supabase (PostgreSQL + Auth + RLS)
- Google Sheets API

## Project Setup

### 1. Clone the repository
```bash
git clone https://github.com/NIRANJAN-R062007/Employee-Engagement-Backend.git
cd employee-engagement-backend
```

### 2. Install dependencies
```bash
npm install
```

### 3. Configure environment variables
```bash
cp .env.example .env
```
Fill in your values in `.env`

### 4. Start the server
```bash
node src/index.js
```

## API Endpoints

### GET /employee/:employeeId/responses
Returns all assigned form responses for an employee.

**Example Response:**
```json
{
  "employee": { "name": "John Doe", "email": "john@techcorp.com" },
  "forms": [
    {
      "form_name": "Monthly Feedback",
      "status": "Submitted",
      "responses": [
        { "question": "Rate your overall satisfaction", "answer": "5" }
      ]
    }
  ]
}
```

### POST /form-response
Submit responses for a form assignment.

**Payload:**
```json
{
  "assignment_id": "uuid",
  "responses": [
    { "field_id": "uuid", "value": "5" },
    { "field_id": "uuid", "value": "Very satisfied" }
  ]
}
```

**Success Response:**
```json
{ "success": true, "message": "Responses submitted successfully" }
```

## Database Schema
See `sql/schema.sql`

## RLS Policies
See `sql/rls_policies.sql`

## Supabase Project
- **URL:** https://winelbrvnazonwerulrc.supabase.co
