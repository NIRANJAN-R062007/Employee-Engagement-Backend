-- Company
INSERT INTO public.companies (id, company_name)
VALUES ('11111111-1111-1111-1111-111111111111', 'TechCorp Solutions');

-- Employees
INSERT INTO public.employees (id, company_id, employee_name, employee_email, employee_code, designation, department)
VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '11111111-1111-1111-1111-111111111111', 'John Doe',       'john@techcorp.com',    'EMP001', 'Software Engineer', 'Engineering'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', '11111111-1111-1111-1111-111111111111', 'Jane Smith',     'jane@techcorp.com',    'EMP002', 'Product Manager',   'Product'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', '11111111-1111-1111-1111-111111111111', 'Bob Johnson',    'bob@techcorp.com',     'EMP003', 'UI Designer',       'Design'),
  ('dddddddd-dddd-dddd-dddd-dddddddddddd', '11111111-1111-1111-1111-111111111111', 'Alice Brown',    'alice@techcorp.com',   'EMP004', 'QA Engineer',       'Quality'),
  ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', '11111111-1111-1111-1111-111111111111', 'Charlie Wilson', 'charlie@techcorp.com', 'EMP005', 'DevOps Engineer',   'Operations');
