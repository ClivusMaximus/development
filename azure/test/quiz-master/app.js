const express = require('express');
const app = express();
const quizRoutes = require('./routes/quizRoutes');

app.set('view engine', 'ejs');
app.use(express.static('public'));
app.use(express.urlencoded({ extended: true }));

app.use('/', quizRoutes);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server's running, make my day on port ${PORT}`));
