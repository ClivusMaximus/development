const express = require('express');
const router = express.Router();
const fs = require('fs');
let all_questions = JSON.parse(fs.readFileSync('../az-900.json', 'utf8'));
const questions = shuffle(all_questions, 1000);

let currentQuestionIndex = 0;
let totalWrongAnswers = 0;
let totalCorrectAnswers = 0;

function shuffle(array, totalQuestions) {
  for (let i = array.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [array[i], array[j]] = [array[j], array[i]]; // ES6 destructuring assignment syntax for swapping elements
  }
  questionsInSession = array.slice(0, totalQuestions);
  return questionsInSession;
};

router.get('/', (req, res) => {
  res.render('index', {
    question: questions[currentQuestionIndex],
    message: questions[currentQuestionIndex].message,
    lastAnswer: questions[currentQuestionIndex].userAnswer,
    currentQuestionIndex: currentQuestionIndex,
    totalQuestions: questions.length,
    totalCorrectAnswers: totalCorrectAnswers,
    totalWrongAnswers: totalWrongAnswers
  });
});

router.post('/answer', (req, res) => {
  const userAnswer = req.body.answer;
  const correctAnswer = questions[currentQuestionIndex].answer;
  const isCorrect = userAnswer === correctAnswer;
  const message = isCorrect ? "Punk, you are correct!" : "Punk, you are wrong!";

  if (isCorrect) {
    totalCorrectAnswers++;
  }
  else {
    totalWrongAnswers++;
  }

  questions[currentQuestionIndex].userAnswer = userAnswer;
  questions[currentQuestionIndex].message = message;

  res.render('index', {
    question: questions[currentQuestionIndex],
    message: message,
    lastAnswer: userAnswer,
    currentQuestionIndex: currentQuestionIndex,
    totalQuestions: questions.length,
    totalCorrectAnswers: totalCorrectAnswers,
    totalWrongAnswers: totalWrongAnswers
  });
});

router.post('/navigate', (req, res) => {
  const direction = req.body.direction;
  if (direction === 'next' && currentQuestionIndex < questions.length - 1) {
    currentQuestionIndex++;
  } else if (direction === 'back' && currentQuestionIndex > 0) {
    currentQuestionIndex--;
  }
  res.redirect('/');
});

module.exports = router;
