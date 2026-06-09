-- Enable RLS
alter table public.companies            enable row level security;
alter table public.employees            enable row level security;
alter table public.engagement_forms     enable row level security;
alter table public.form_fields          enable row level security;
alter table public.form_assignments     enable row level security;
alter table public.form_responses       enable row level security;
alter table public.form_submission_logs enable row level security;

-- Employee: view own assignments
create policy "Employee can view own assignments"
  on public.form_assignments for select
  using (exists (
    select 1 from public.employees e
    where e.id = form_assignments.employee_id
    and e.auth_user_id = auth.uid()
  ));

-- Employee: insert own responses
create policy "Employee can insert own responses"
  on public.form_responses for insert
  with check (exists (
    select 1 from public.form_assignments fa
    join public.employees e on e.id = fa.employee_id
    where fa.id = form_responses.assignment_id
    and e.auth_user_id = auth.uid()
  ));

-- Employee: view own responses
create policy "Employee can view own responses"
  on public.form_responses for select
  using (exists (
    select 1 from public.form_assignments fa
    join public.employees e on e.id = fa.employee_id
    where fa.id = form_responses.assignment_id
    and e.auth_user_id = auth.uid()
  ));

-- Admin: full access all tables
create policy "Admin full access companies"            on public.companies            for all using (auth.uid() is not null);
create policy "Admin full access employees"            on public.employees            for all using (auth.uid() is not null);
create policy "Admin full access engagement_forms"     on public.engagement_forms     for all using (auth.uid() is not null);
create policy "Admin full access form_fields"          on public.form_fields          for all using (auth.uid() is not null);
create policy "Admin full access form_assignments"     on public.form_assignments     for all using (auth.uid() is not null);
create policy "Admin full access form_responses"       on public.form_responses       for all using (auth.uid() is not null);
create policy "Admin full access form_submission_logs" on public.form_submission_logs for all using (auth.uid() is not null);
