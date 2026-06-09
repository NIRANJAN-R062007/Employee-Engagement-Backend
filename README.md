# 🧑‍💼 Employee Engagement Backend

A backend system for managing employee engagement forms — built with **Node.js**, **Supabase**, and **Google Sheets**.

---

## 🚀 Tech Stack

| Layer | Technology |
|-------|-----------|
| Runtime | Node.js |
| Framework | Express.js |
| Database | Supabase (PostgreSQL) |
| Auth | Supabase Auth |
| Security | Row Level Security (RLS) |
| Integration | Google Sheets API |

---

## 📁 Project Structure

```
employee-engagement-backend/
├── src/
│   ├── config/
│   │   └── supabase.js        # Supabase client setup
│   ├── routes/
│   │   ├── responses.js       # GET employee responses
│   │   └── submit.js          # POST form submission
│   └── services/
│       └── googleSheets.js    # Google Sheets integration
├── sql/
│   ├── schema.sql             # Database schema
│   ├── seed.sql               # Sample data
│   └── rls_policies.sql       # Row Level Security policies
├── postman/
│   └── Employee-Engagement-API.postman_collection.json
├── .env.example
└── README.md
```

---

## ⚙️ Setup

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

Fill in your `.env`:
```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
GOOGLE_SHEET_ID=your-google-sheet-id
GOOGLE_SERVICE_ACCOUNT_EMAIL=your-service-account@project.iam.gserviceaccount.com
GOOGLE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n"
PORT=3000
```

### 4. Set up Supabase
- Run `sql/schema.sql` in the Supabase SQL Editor
- Run `sql/seed.sql` to insert sample data
- Run `sql/rls_policies.sql` to enable Row Level Security

### 5. Start the server
```bash
node src/index.js
```

Server runs at: `http://localhost:3000`

---

## 📡 API Endpoints

### ✅ Health Check
```
GET /
```
**Response:**
```json
{ "status": "Employee Engagement API is running" }
```

---

### 📋 Get Employee Responses
```
GET /employee/:employeeId/responses
```

**Example:**
```
GET /employee/aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa/responses
```

**Response:**
```json
{
  "employee": {
    "name": "John Doe",
    "email": "john@techcorp.com"
  },
  "forms": [
    {
      "form_name": "Monthly Feedback",
      "status": "Submitted",
      "submitted_at": "2026-06-09T08:10:40.776+00:00",
      "responses": [
        { "question": "Rate your overall satisfaction", "answer": "5" },
        { "question": "Manager Support", "answer": "4" },
        { "question": "Work-Life Balance", "answer": "5" },
        { "question": "Feedback", "answer": "Great work environment!" },
        { "question": "Suggestions for Improvement", "answer": "More team events please" }
      ]
    }
  ]
}
```

---

### 📝 Submit Form Response
```
POST /form-response
Content-Type: application/json
```

**Payload:**
```json
{
  "assignment_id": "uuid",
  "responses": [
    { "field_id": "uuid", "value": "5" },
    { "field_id": "uuid", "value": "Great work environment!" }
  ]
}
```

**Success Response:**
```json
{
  "success": true,
  "message": "Responses submitted successfully"
}
```

**Process:**
1. Validates assignment exists
2. Validates ownership
3. Inserts responses into Supabase
4. Updates assignment status to `Submitted`
5. Sets `submitted_at` timestamp
6. Creates submission log
7. Appends data to Google Sheets

---

## 🗄️ Database Schema

| Table | Description |
|-------|-------------|
| `companies` | Company records |
| `employees` | Employee records linked to companies |
| `engagement_forms` | Form templates per company |
| `form_fields` | Questions/fields for each form |
| `form_assignments` | Forms assigned to employees |
| `form_responses` | Employee answers |
| `form_submission_logs` | Audit log with Google Sheets sync status |

---

## 🔐 Row Level Security

| Role | Permissions |
|------|------------|
| Employee | View own assignments, submit own responses, view own responses |
| Admin | Full read/write access on all tables |

---

## 📊 Google Sheets Integration

Every form submission automatically appends rows to Google Sheets:

| Timestamp | Company | Employee Name | Employee Email | Form Name | Question | Response | Assignment ID |
|-----------|---------|---------------|----------------|-----------|----------|----------|---------------|

One row is created per question-response pair.

---

## 🧪 Testing

Import the Postman collection from:
```
postman/Employee-Engagement-API.postman_collection.json
```

Includes:
- `GET /` — Health Check
- `GET /employee/:id/responses` — Get Employee Responses
- `POST /form-response` — Submit Form Response

---

## 🌐 Supabase Project

- **URL:** https://winelbrvnazonwerulrc.supabase.co
- **Auth:** Supabase Email/Password
- **Admin Email:** admin@company.com
