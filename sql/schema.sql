-- Extensions
create extension if not exists pgcrypto;

-- Updated At Function
create or replace function public.update_updated_at_column()
returns trigger language plpgsql as $$
begin new.updated_at = now(); return new; end; $$;

-- Companies
create table public.companies (
  id uuid primary key default gen_random_uuid(),
  company_name text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Employees
create table public.employees (
  id uuid primary key default gen_random_uuid(),
  company_id uuid not null references public.companies(id) on delete cascade,
  auth_user_id uuid unique references auth.users(id) on delete set null,
  employee_name text not null,
  employee_email text not null unique,
  employee_code text unique,
  designation text,
  department text,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Engagement Forms
create table public.engagement_forms (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  description text,
  is_active boolean not null default true,
  company_id uuid not null references public.companies(id) on delete cascade,
  created_by uuid not null references auth.users(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(company_id, name)
);

-- Form Fields
create table public.form_fields (
  id uuid primary key default gen_random_uuid(),
  form_id uuid not null references public.engagement_forms(id) on delete cascade,
  field_order integer not null,
  label text not null,
  field_type text not null,
  required boolean not null default false,
  placeholder text,
  options jsonb,
  validation_rules jsonb,
  created_at timestamptz not null default now(),
  unique(form_id, field_order)
);

-- Form Assignments
create table public.form_assignments (
  id uuid primary key default gen_random_uuid(),
  form_id uuid not null references public.engagement_forms(id) on delete cascade,
  employee_id uuid not null references public.employees(id) on delete cascade,
  assigned_at timestamptz not null default now(),
  due_date timestamptz,
  status text not null default 'Pending',
  submitted_at timestamptz,
  updated_at timestamptz not null default now(),
  unique(form_id, employee_id)
);

-- Form Responses
create table public.form_responses (
  id uuid primary key default gen_random_uuid(),
  assignment_id uuid not null references public.form_assignments(id) on delete cascade,
  field_id uuid not null references public.form_fields(id) on delete cascade,
  response_value text not null,
  submitted_at timestamptz not null default now(),
  unique(assignment_id, field_id)
);

-- Submission Logs
create table public.form_submission_logs (
  id uuid primary key default gen_random_uuid(),
  assignment_id uuid not null,
  employee_id uuid not null,
  form_id uuid not null,
  google_sheet_synced boolean default false,
  created_at timestamptz not null default now()
);
