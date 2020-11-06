from elements import Lexer
from elements import Parser
from elements import Interpreter


def main():

    text = """
    📝 This is a program for arithmetics
       number 👉 3.14
       a 👉 number
       b 👉 10 ✖️ a ➕ 10 ✖️ number ➗ 4
       y 👉 20 ➗ 7 ➕ 3.14
    """

    lexer = Lexer(text)
    lexer.lex()
    parser = Parser(lexer.lexed_text)
    tree = parser.parse()

    interpreter = Interpreter(tree)
    result = interpreter.interpret()

    print('')
    print('Run-time GLOBAL_MEMORY contents:')
    for k, v in sorted(interpreter.GLOBAL_MEMORY.items()):
        print('{} = {}'.format(k, v))


main()
