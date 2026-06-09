const express = require('express');
require('dotenv').config();

const app = express();
app.use(express.json());

// Routes
const responsesRouter = require('./routes/responses');
const submitRouter = require('./routes/submit');

app.use('/employee', responsesRouter);
app.use('/form-response', submitRouter);

// Health check
app.get('/', (req, res) => {
  res.json({ status: 'Employee Engagement API is running' });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});

module.exports = app;
