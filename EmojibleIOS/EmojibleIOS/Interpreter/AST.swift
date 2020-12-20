//
//  AST.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 3.12.2020.
//

import Foundation

fileprivate let runScreen = RunCodeCoordinator.getInstance().runScreen!
fileprivate var isCancelled: Bool { Interpreter.getInstance().isCancelled }

class AST{
    func visit() -> Any?{
        return nil
    }
    
    func safeVisit() -> Any?{
        if isCancelled{
            return nil
        }
        return self.visit()
    }
}

class BinOpNode:AST{
    var left:AST
    var op:Token
    var token:Token
    var right:AST
    
    init(left:AST, op:Token, right:AST){
        self.left = left
        self.token = op
        self.op = op
        self.right = right
        
    }
    
    override func visit() -> Any?{
        if let left_val = self.left.safeVisit() as? Int, let right_val = self.right.safeVisit() as? Int{
            return visitInt(left:left_val , right:right_val)
        }else if let left_val = self.left.safeVisit() as? NSNumber, let right_val = self.right.safeVisit() as? NSNumber{
            return visitFloat(left:Float(truncating: left_val), right:Float(truncating: right_val))
        }else{
            //error
            return nil
        }
    }
    
    func visitFloat(left:Float,right:Float) -> Any?{
        if op.type == TokenType.PLUS{
            return left + right
        }else if op.type == TokenType.MINUS{
            return left - right
        }else if op.type == TokenType.MUL{
            return left * right
        }else if op.type == TokenType.FLOAT_DIV{
            return left/right
        }else if op.type == TokenType.EQUALS{
            return left == right
        }else if op.type == TokenType.LESSER_EQ{
            return left <= right
        }else if op.type == TokenType.GREATER_EQ{
            return left >= right
        }else if op.type == TokenType.LESSER{
            return left < right
        }else if op.type == TokenType.GREATER{
            return left > right
        }
        return nil
    }
    
    func visitInt(left:Int,right:Int) -> Any?{
        let result = visitFloat(left: Float(left), right: Float(right))
        if result is Bool{
            return result
        }
        
        let resultFloat = result as! Float
        
        
        
        return resultFloat
    }
    
}

class ValueNode:AST{
    var token: Token
    var value: Any
    
    init(token:Token){
        self.token = token
        self.value = token.value
        
    }
    
    override func visit() -> Any? {
        return value
    }
}

class NumNode:ValueNode{
    
}

class BoolNode:ValueNode{
    
}


class ColorNode:ValueNode{
    
}

class GetNumericUserInputNode:AST{
    var op:TokenType
    
    init(op: TokenType){
        self.op = op
        
    }
    
    override func visit()->Any?{
        runScreen.performSelector(onMainThread: #selector(runScreen.textInputRequested), with: nil, waitUntilDone: false)
        Interpreter.getInstance().inputSemaphore.wait()
        
        if isCancelled{
            return nil
        }
        
        let input = runScreen.input!
        if let inputInt = Int(input){
            return inputInt
        }else if let inputFloat = Float(input){
            return inputFloat
        }else{
            // error
            return nil
        }
    }
    
}

class SetScreenColorNode:AST{
    var color: ColorNode
    var op: TokenType
    
    init(op:TokenType, color:ColorNode){
        self.op = op
        self.color = color
        
    }
    
    override func visit()->Any?{
        runScreen.backgroundColor = color.token.value as? String
        runScreen.performSelector(onMainThread: #selector(runScreen.changeBackgroundColor), with: nil, waitUntilDone: false)
        return nil
    }
}

class UnaryOpNode:AST{
    var token:Token
    var op:Token
    var expr:AST
    init(op:Token, expr:AST){
        self.token = op
        self.op = op
        self.expr = expr
        
    }
    
    override func visit() -> Any? {
        if let num = expr.safeVisit() as? Int {
            if op.type == TokenType.PLUS{
                return +num
            }else if op.type == TokenType.MINUS{
                return -num
            }
        }
        if let num = expr.safeVisit() as? Float {
            if op.type == TokenType.PLUS{
                return +num
            }else if op.type == TokenType.MINUS{
                return -num
            }
        }
        return nil
    }
    
}

class CompoundNode:AST{
    var children: [AST]
    init(children:[AST]?=nil){
        self.children = children == nil ? []:children!
    }
    
    override func visit() -> Any? {
        for child in children{
            _ = child.safeVisit()
            if isCancelled{
                return nil
            }
        }
        return nil
    }
}

class AssignNode:AST{
    var left: VarNode
    var op:Token
    var token:Token
    var right:AST
    var memory:Memory
    
    init(left:VarNode, op:Token, right:AST, memory:Memory){
        self.left = left
        self.token = op
        self.op = op
        self.right = right
        self.memory = memory
        
    }
    
    override func visit() -> Any? {
        let var_name = left.value
        let var_value = right.safeVisit()
        if isCancelled{
            return nil
        }
        memory.addAssignment(assignment: AssignmentModel(identifier: var_name as! String, value: var_value!))
        return nil
    }
}

class GetRandomNumberNode:AST{
    var op:Token
    var token:Token
    var lower_bound:AST
    var upper_bound:AST
    init(op:Token, lower_bound:AST, upper_bound:AST){
        self.token = op
        self.op = op
        self.lower_bound = lower_bound
        self.upper_bound = upper_bound
        
    }
    
    override func visit() -> Any? {
        
        guard let lower_bound = self.lower_bound.safeVisit() as? Int else{
            //raise Exception("Random number cannot be called with non integer lower bound")
            return nil
        }
        guard let upper_bound = self.upper_bound.safeVisit() as? Int else{
            //raise Exception("Random number cannot be called with non integer upper bound")
            return nil
        }
        if lower_bound >= upper_bound{
            //raise Exception("lower bound cannot be greater than upper bound")
        }
        return Int.random(in: lower_bound ..< upper_bound)
    }
}

class IfNode:AST{
    var op:TokenType
    var bool_statement:AST
    var true_statement:BlockNode
    var false_statement:BlockNode
    init(op:TokenType, bool_statement:AST, true_statement:BlockNode, false_statement:BlockNode?=nil){
        self.op = op
        self.bool_statement = bool_statement
        self.true_statement = true_statement
        if let false_st = false_statement{
            self.false_statement = false_st
        }else{
            let children: [AST] = [NoOpNode()]
            self.false_statement = BlockNode(compound_statement: CompoundNode(children:children))
        }
    }
    
    override func visit() -> Any? {
        guard let bool = bool_statement.safeVisit() as? Bool else {
            // Exception
            return nil
        }
        if bool{
            return true_statement.safeVisit()
        }else{
            return false_statement.safeVisit()
        }
    }
}

class ForNode:AST{
    var op:TokenType
    var times:AST
    var body:BlockNode
    init(op:TokenType, times:AST, body:BlockNode){
        self.op = op
        self.times = times
        self.body = body
        
    }
    
    override func visit() -> Any? {
        guard let times = self.times.safeVisit() as? Int else{
            return nil
        }
        for _ in 0..<times{
            _ = body.safeVisit()
            if isCancelled{
                return nil
            }
        }
        return nil
    }
}

class WhileNode:AST{
    var op:TokenType
    var bool_statement:AST
    var body:BlockNode
    init(op:TokenType, bool_statement:AST, body:BlockNode){
        self.op = op
        self.bool_statement = bool_statement
        self.body = body
        
    }
    
    override func visit() -> Any? {
        while true{
            guard let bool_cond = bool_statement.safeVisit() as? Bool else{
                // exception: raise Exception("{} is not a boolean".format(bool_cond))
                return nil
            }
            if bool_cond{
                break
            }
            if isCancelled{
                return nil
            }
            _ = body.safeVisit()
        }
        return nil
    }
}

class VarNode:AST{
    var token:Token
    var value:Any
    var memory:Memory
    init(token:Token, memory:Memory){
        self.token = token
        self.value = token.value
        self.memory = memory
    }
    
    override func visit() -> Any? {
        let var_name = value as! String
        
        for assignment in memory.getAssignments(){
            if assignment.identifier == var_name{
                return assignment.getValue()
            }
        }
        //raise Exception("{} is an undefined variable".format(var_name))
        return nil
    }
}

class NoOpNode:AST{
}

class ProgramNode:AST{
    var block:BlockNode
    init(block:BlockNode){
        self.block = block
    }
    
    override func visit() -> Any? {
        return block.safeVisit()
    }
}

class BlockNode:AST{
    var compound_statement:CompoundNode
    init(compound_statement:CompoundNode){
        self.compound_statement = compound_statement
    }
    override func visit() -> Any? {
        return compound_statement.safeVisit()
    }
}