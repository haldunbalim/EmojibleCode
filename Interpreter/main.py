from elements import Lexer
from elements import Parser
from elements import Interpreter


def main():

    text = """
        🐤 👉 [👻 1, 100] 📝  assign a random number between 1 and 100 to baby chick emoji\n
        🐄 👉 [🔢] 📝  assign user input to cow emoji\n
        🪐 [ 🐄 = 🐤 ] [ 📝  start a loop condition until 🐄 is equal to 🐤\n
            🤔 [ 🐄 > 🐤 ] [[📱  🟦 ]] [ [📱  🟥]] 📝  display blue if 🐄 is greater than 🐤, red vice versa\n
            🐄 👉 [🔢]  📝 get another user input\n
        ]\n
        [ 📱  🟩 ] 📝  display green to indicate the correct answer is given\n

    """
    
    lexer = Lexer(text)
    lexer.lex()
    parser = Parser(lexer.lexed_text)
    tree = parser.parse()

    interpreter = Interpreter(tree)
    interpreter.interpret()

    print("")
    print('Run-time GLOBAL_MEMORY contents:')
    for k, v in sorted(interpreter.GLOBAL_MEMORY.items()):
        print('{} = {}'.format(k, v))

main()
