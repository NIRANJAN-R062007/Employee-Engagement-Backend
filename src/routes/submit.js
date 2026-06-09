const express = require('express');
const router = express.Router();
const supabase = require('../config/supabase');
const { appendToGoogleSheet } = require('../services/googleSheets');

// POST /form-response
router.post('/', async (req, res) => {
  const { assignment_id, responses } = req.body;

  if (!assignment_id || !responses || !Array.isArray(responses)) {
    return res.status(400).json({ error: 'Invalid payload' });
  }

  try {
    // Step 1: Validate assignment exists
    const { data: assignment, error: assignError } = await supabase
      .from('form_assignments')
      .select(`
        id, status, employee_id,
        employees (
          id, employee_name, employee_email,
          companies ( company_name )
        ),
        engagement_forms ( id, name )
      `)
      .eq('id', assignment_id)
      .single();

    if (assignError || !assignment) {
      return res.status(404).json({ error: 'Assignment not found' });
    }

    // Step 2: Validate ownership (not already submitted)
    if (assignment.status === 'Submitted') {
      return res.status(400).json({ error: 'Form already submitted' });
    }

    // Step 3: Insert responses
    const responseRows = responses.map((r) => ({
      assignment_id,
      field_id: r.field_id,
      response_value: r.value,
    }));

    const { error: insertError } = await supabase
      .from('form_responses')
      .insert(responseRows);

    if (insertError) {
      return res.status(500).json({ error: insertError.message });
    }

    // Step 4 & 5: Update assignment status and submitted_at
    const { error: updateError } = await supabase
      .from('form_assignments')
      .update({ status: 'Submitted', submitted_at: new Date().toISOString() })
      .eq('id', assignment_id);

    if (updateError) {
      return res.status(500).json({ error: updateError.message });
    }

    // Step 6: Create submission log
    const { error: logError } = await supabase
      .from('form_submission_logs')
      .insert({
        assignment_id,
        employee_id: assignment.employee_id,
        form_id: assignment.engagement_forms.id,
        google_sheet_synced: false,
      });

    if (logError) {
      console.error('Log error:', logError.message);
    }

    // Step 7: Push to Google Sheets
    try {
      // Get field labels for responses
      const fieldIds = responses.map((r) => r.field_id);
      const { data: fields } = await supabase
        .from('form_fields')
        .select('id, label')
        .in('id', fieldIds);

      const fieldMap = {};
      fields.forEach((f) => (fieldMap[f.id] = f.label));

      const employee = assignment.employees;
      const companyName = employee.companies.company_name;
      const formName = assignment.engagement_forms.name;
      const timestamp = new Date().toISOString();

      const rows = responses.map((r) => [
        timestamp,
        companyName,
        employee.employee_name,
        employee.employee_email,
        formName,
        fieldMap[r.field_id] || r.field_id,
        r.value,
        assignment_id,
      ]);

      await appendToGoogleSheet(rows);

      // Update log as synced
      await supabase
        .from('form_submission_logs')
        .update({ google_sheet_synced: true })
        .eq('assignment_id', assignment_id);

    } catch (sheetErr) {
      console.error('Google Sheets error:', sheetErr.message);
    }

    return res.json({
      success: true,
      message: 'Responses submitted successfully',
    });

  } catch (err) {
    return res.status(500).json({ error: err.message });
  }
});

module.exports = router;
