# -*- coding: utf-8 -*-
'''
    Takes all the selected text.
    Splits it into lines.
    Reads all the lines up to ##
    Converts those to a question on a single line.
    
    Then reads the remaining lines
    Then write the selected lines as a singlke line at the end of the document

    Usage:
    Make a selection
    Run the script
'''
from Npp import editor

def get_question():
    selectedText = editor.getSelText()
    lines = selectedText.splitlines()
    lines_with_newline = []
    for line in lines:
        if line == '##':
            continue
        lines_with_newline.append(line + '\\n')
    text_with_newline = ''.join(lines_with_newline)
    return text_with_newline

def get_options_and_answer():
    selectedText = editor.getSelText()
    lines = selectedText.splitlines()
    lines_with_option = []
    answer = ''
    found_options = 0
    for line in lines:
        if line == '##':
            found_options = 1
            continue
        if found_options == 1:
            if line.startswith('*'):
                line = line.replace('*', '')
                answer = line
            lines_with_option.append(line)
    return lines_with_option, answer

def append_to_end_of_file(question, options, answer):
    editor.appendText('\n\n\n')
    editor.appendText('{\n')
    editor.appendText(f'\t"question":"{question}",\n')
    editor.appendText('"options": [\n')
    for option in options:
        editor.appendText(f'\t\t"{option}",\n')
    editor.appendText('],\n')
    editor.appendText(f'\t"anwser":"{answer}",\n')
    editor.appendText('},\n')

question = get_question()
options, answer = get_options_and_answer()
append_to_end_of_file(question, options, answer)
