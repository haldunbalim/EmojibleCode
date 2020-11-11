from elements import TokenType
from elements import NodeVisitor
import random

class Interpreter(NodeVisitor):
    def __init__(self, tree):
        self.tree = tree
        self.GLOBAL_MEMORY = {}

    def visit_Program(self, node):
        self.visit(node.block)

    def visit_Block(self, node):
        self.visit(node.compound_statement)

    def visit_BinOp(self, node):
        if node.op.type == TokenType.PLUS:
            return self.visit(node.left) + self.visit(node.right)
        elif node.op.type == TokenType.MINUS:
            return self.visit(node.left) - self.visit(node.right)
        elif node.op.type == TokenType.MUL:
            return self.visit(node.left) * self.visit(node.right)
        elif node.op.type == TokenType.FLOAT_DIV:
            return float(self.visit(node.left)) / float(self.visit(node.right))
        elif node.op.type == TokenType.EQUALS:
            return self.visit(node.left) == self.visit(node.right)
        elif node.op.type == TokenType.LESSER_EQ:
            return self.visit(node.left) <= self.visit(node.right)
        elif node.op.type == TokenType.GREATER_EQ:
            return self.visit(node.left) >= self.visit(node.right)
        elif node.op.type == TokenType.LESSER:
            return self.visit(node.left) < self.visit(node.right)
        elif node.op.type == TokenType.GREATER:
            return self.visit(node.left) > self.visit(node.right)

    def visit_Num(self, node):
        return node.value

    def visit_GetRandomNumber(self, node):
        lower_bound = self.visit(node.lower_bound)
        upper_bound = self.visit(node.upper_bound)
        if not isinstance(lower_bound,int) and not((isinstance(lower_bound,float) and int(lower_bound) == lower_bound)):
          raise Exception("Random number cannot be called with non integer lower bound")
        if not isinstance(upper_bound,int) and not((isinstance(upper_bound,float) and int(upper_bound) == upper_bound)):
          raise Exception("Random number cannot be called with non integer upper bound")
        return random.randint(lower_bound,upper_bound)

    def visit_GetNumericUserInput(self, node):
      inp = input()
      return int(inp)

    def visit_Color(self, node):
        return node.value

    def visit_SetScreenColor(self, node):
        print("Screen color is set to {}".format(node.color))

    def visit_UnaryOp(self, node):
        op = node.op.type
        if op == TokenType.PLUS:
            return +self.visit(node.expr)
        elif op == TokenType.MINUS:
            return -self.visit(node.expr)

    def visit_Compound(self, node):
        for child in node.children:
            self.visit(child)

    def visit_Assign(self, node):
        var_name = node.left.value
        var_value = self.visit(node.right)
        self.GLOBAL_MEMORY[var_name] = var_value

    def visit_If(self, node):
      if self.visit(node.bool_statement):
        self.visit(node.true_statement)
      else:
        self.visit(node.false_statement)

    def visit_For(self, node):
      times = self.visit(node.times)
      if not isinstance(times, int) or (isinstance(times,float) and times == int(times)):
        raise Exception("{} is not an integer".format(times))
      for i in range(times):
        self.visit(node.body)
      

    def visit_While(self, node):
      while True:
        bool_cond = self.visit(node.bool_statement)
        if not isinstance(bool_cond, bool):
          raise Exception("{} is not a boolean".format(bool_cond))
        if bool_cond == True:
          break
        self.visit(node.body)
        

      
    def visit_Var(self, node):
        var_name = node.value
        var_value = self.GLOBAL_MEMORY.get(var_name)
        return var_value

    def visit_NoOp(self, node):
        pass

    def interpret(self):
        tree = self.tree
        if tree is None:
            return ''
        return self.visit(tree)
