const express = require('express');
const router = express.Router();
const supabase = require('../config/supabase');

// GET /employee/:employeeId/responses
router.get('/:employeeId/responses', async (req, res) => {
  const { employeeId } = req.params;

  try {
    // Get employee details
    const { data: employee, error: empError } = await supabase
      .from('employees')
      .select('id, employee_name, employee_email')
      .eq('id', employeeId)
      .single();

    if (empError || !employee) {
      return res.status(404).json({ error: 'Employee not found' });
    }

    // Get assignments with forms
    const { data: assignments, error: assignError } = await supabase
      .from('form_assignments')
      .select(`
        id,
        status,
        submitted_at,
        engagement_forms (
          id,
          name
        )
      `)
      .eq('employee_id', employeeId);

    if (assignError) {
      return res.status(500).json({ error: assignError.message });
    }

    // For each assignment, get responses with field labels
    const forms = await Promise.all(
      assignments.map(async (assignment) => {
        const { data: responses, error: respError } = await supabase
          .from('form_responses')
          .select(`
            response_value,
            form_fields (
              label
            )
          `)
          .eq('assignment_id', assignment.id);

        if (respError) return null;

        return {
          form_name: assignment.engagement_forms.name,
          status: assignment.status,
          submitted_at: assignment.submitted_at,
          responses: responses.map((r) => ({
            question: r.form_fields.label,
            answer: r.response_value,
          })),
        };
      })
    );

    return res.json({
      employee: {
        name: employee.employee_name,
        email: employee.employee_email,
      },
      forms: forms.filter(Boolean),
    });

  } catch (err) {
    return res.status(500).json({ error: err.message });
  }
});

module.exports = router;
