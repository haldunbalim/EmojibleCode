from elements import Lexer
from elements import Parser
from elements import SymbolTableBuilder
from elements import Interpreter


def main():

    text = """
    VAR
       number : INTEGER;
       a, b   : INTEGER;
       y      : REAL;
    
    BEGIN
       number = 2;
       a = number ;
       b = 10 * a + 10 * number DIV 4;
       y = 20 / 7 + 3.14
    """

    lexer = Lexer(text)
    lexer.lex()
    parser = Parser(lexer.lexed_text)
    tree = parser.parse()
    symtab_builder = SymbolTableBuilder()
    symtab_builder.visit(tree)
    print('')
    print('Symbol Table contents:')
    print(symtab_builder.symtab)

    interpreter = Interpreter(tree)
    result = interpreter.interpret()

    print('')
    print('Run-time GLOBAL_MEMORY contents:')
    for k, v in sorted(interpreter.GLOBAL_MEMORY.items()):
        print('{} = {}'.format(k, v))


main()
