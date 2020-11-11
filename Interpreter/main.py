from elements import Lexer
from elements import Parser
from elements import Interpreter


def main():

    text = """
        a 👉 [👻 1, 100]

        b 👉 [🔢]

🪐 [ a = b ] [ 📝  start a loop condition until baby chick is equal to cow

    🤔 [ a < b ] [[📱  🟦 ]] [ [📱  🟥]] 📝  display red if baby chick is less than cow, blue vice versa

    b 👉 [🔢]  📝 get another user input

]

[ 📱  🟩 ]

    """
    
    lexer = Lexer(text)
    lexer.lex()
    parser = Parser(lexer.lexed_text)
    tree = parser.parse()

    interpreter = Interpreter(tree)
    result = interpreter.interpret()

    print('Run-time GLOBAL_MEMORY contents:')
    for k, v in sorted(interpreter.GLOBAL_MEMORY.items()):
        print('{} = {}'.format(k, v))

main()
