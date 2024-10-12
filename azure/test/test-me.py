import json

def load_questions():
    with open('/home/clivew/play/azure/test/az-900.json', 'r') as file:
        questions = json.load(file)
    return questions

def quiz(questions):
    score = 0
    for q in questions:
        print(q['question'])
        for idx, option in enumerate(q['options']):
            print(f"{idx + 1}. {option}")
        answer = input("Your answer (number): ")
        if answer == "q":
            break
        if q['options'][int(answer) - 1] == q['answer']:
            print("Feeling lucky, punk? Well, you should. That's CORRECT.\n----------------------------------------\n")
            score += 1
        else:
            print("Make my day, punk... Oh, wait, you didn’t. That's WRONG.\n----------------------------------------\n")
    print(f"Your final score: {score}/{len(questions)}")

def main():
    questions = load_questions()
    quiz(questions)

if __name__ == "__main__":
    print("\n\n#### Welcome to the Azure Fundamentals Quiz ####\n\n")
    print("Type 'q' to quit at any time.\n")
    main()
    # https://github.com/Ditectrev/Microsoft-Azure-AZ-900-Microsoft-Azure-Fundamentals-Practice-Tests-Exams-Questions-Answers    
    # https://github.com/pradeep1807/az900
    # https://www.whizlabs.com/blog/az-900-certification-exam-questions/
    # search github for az-900 and az900