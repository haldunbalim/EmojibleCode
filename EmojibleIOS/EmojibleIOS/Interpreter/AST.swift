//
//  AST.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 3.12.2020.
//

import Foundation

fileprivate let runScreen = RunCodeCoordinator.getInstance().runScreen!
fileprivate var isCancelled: Bool { Interpreter.getInstance().isCancelled }

enum InterpreterErrors: Error {
    case GenericError(str:String)
}

enum EmojibleErrors: Error {
    case C1
}

class AST{
    func visit() throws -> Any?{
        return nil
    }
    
    func safeVisit() throws -> Any?{
        if isCancelled{
            return nil
        }
        do{
            return try self.visit()
        }catch{
            throw error
        }
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
    
    override func visit() throws -> Any?{
        do{
            let left = try self.left.safeVisit()
            let right = try self.right.safeVisit()
            if let left_val = left  as? Int, let right_val = right as? Int{
                return visitInt(left:left_val , right:right_val)
            }else if let left_val = left as? Bool, let right_val = right as? Bool{
                return visitBool(left:Bool(left_val), right:Bool(right_val))
            }else if let left_val = left as? NSNumber, let right_val = right as? NSNumber{
                return visitFloat(left:Float(truncating: left_val), right:Float(truncating: right_val))
            }
            else{
                throw InterpreterErrors.GenericError(str: "Expected Number or Boolean for binary operator at line \(String(describing:self.token.lineNumber))")
            }
        }
        catch{
            throw error
        }
    }
    
    func visitBool(left:Bool,right:Bool) -> Any?{
        if op.type == TokenType.AND{
            return left && right
        }else if op.type == TokenType.OR{
            return left || right
        }
        return nil
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
        
        let resultInt:Int = Int((result as! Float).rounded(.down))
        
        
        
        return resultInt
    }
    
}

class TouchedNode:AST{
    var token: Token
    
    init(token:Token){
        self.token = token
        
    }
    
    override func visit() -> Any? {
        return TouchSensor.getInstance().isTouched()
    }
}

class FlippedNode:AST{
    var token: Token
    
    init(token:Token){
        self.token = token
        
    }
    
    override func visit() -> Any? {
        return FlipSensor.getInstance().isFlipped()
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
    
    override func visit() throws ->Any?{
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
            throw InterpreterErrors.GenericError(str: "\(input) be converted to number")
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
        let backgroundColor = color.token.value as? String
        runScreen.backgroundColor = backgroundColor
        runScreen.performSelector(onMainThread: #selector(runScreen.changeBackgroundColor), with: nil, waitUntilDone: false)
        return nil
    }
}

class DisplayNode:AST{
    var token:Token
    var op:Token
    var expr:AST
    init(op:Token, expr:AST){
        self.token = op
        self.op = op
        self.expr = expr
        
    }
    
    override func visit() throws -> Any? {
        do{
            let expr_res = try expr.safeVisit()
            if let str = expr_res as? String {
                if str.contains(".m4a") && FileSystemManager.getInstance().fileExists(filename: str){
                    AudioPlayer.getInstance().playAudio(filename: str)
                }else{
                    runScreen.outText = str
                    runScreen.performSelector(onMainThread: #selector(runScreen.changeLabelText), with: nil, waitUntilDone: false)
                }
            }else if let str = expr_res as? Int {
                runScreen.outText = String(describing: str)
                runScreen.performSelector(onMainThread: #selector(runScreen.changeLabelText), with: nil, waitUntilDone: false)
            }else if let str = expr_res as? Float {
                runScreen.outText = String(describing: str)
                runScreen.performSelector(onMainThread: #selector(runScreen.changeLabelText), with: nil, waitUntilDone: false)
            }
            else if let str = expr_res as? Bool {
                runScreen.outText = String(describing: str)
                runScreen.performSelector(onMainThread: #selector(runScreen.changeLabelText), with: nil, waitUntilDone: false)
            }
            return nil
        }catch{
            throw error
        }
    }
        
}

class TTSNode:AST{
    var token:Token
    var op:Token
    var expr:AST
    init(op:Token, expr:AST){
        self.token = op
        self.op = op
        self.expr = expr
        
    }
    
    override func visit() throws -> Any? {
        do{
            let expr_res = try expr.safeVisit()
            if let str = expr_res  as? String {
                TextToSpeech.getInstance().convertTextToSpeech(text: str, language: "English")
            }
            return nil
        }catch{
            throw error
        }
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
    
    override func visit() throws -> Any? {
        do{
            let expr_res = try expr.safeVisit()
            if let num = expr_res  as? Int {
                if op.type == TokenType.PLUS{
                    return +num
                }else if op.type == TokenType.MINUS{
                    return -num
                }
            }
            if let num = expr_res as? Float {
                if op.type == TokenType.PLUS{
                    return +num
                }else if op.type == TokenType.MINUS{
                    return -num
                }
            }
            return nil
        }
        catch{
            throw error
        }
    }
}

class CompoundNode:AST{
    var children: [AST]
    init(children:[AST]?=nil){
        self.children = children == nil ? []:children!
    }
    
    override func visit() throws-> Any? {
        do{
            for child in children{
                _ = try child.safeVisit()
                if isCancelled{
                    return nil
                }
            }
            return nil
        }
        catch{
            throw error
        }
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
    
    override func visit() throws -> Any? {
        do{
            let var_name = left.value
            let var_value = try right.safeVisit()
            if isCancelled{
                return nil
            }
            memory.addAssignment(assignment: AssignmentModel(identifier: var_name as! String, value: var_value!))
            return nil
        }catch{
            throw error
        }
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
    
    override func visit() throws -> Any? {
        
        do{
            guard let lower_bound = try self.lower_bound.safeVisit() as? Int else{
                throw InterpreterErrors.GenericError(str:"Random number cannot be called with non integer lower bound")
            }
            guard let upper_bound = try self.upper_bound.safeVisit() as? Int else{
                throw InterpreterErrors.GenericError(str:"Random number cannot be called with non integer upper bound")
            }
            if lower_bound >= upper_bound{
                throw InterpreterErrors.GenericError(str:"lower bound cannot be greater than upper bound")
            }
            return Int.random(in: lower_bound ..< upper_bound)
        }catch{
            throw error
        }
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
    
    override func visit() throws -> Any? {
        do{
            guard let bool = try bool_statement.safeVisit() as? Bool else {
                throw InterpreterErrors.GenericError(str:"If statement must have boolean first argument")
                return nil
            }
            if bool{
                return try true_statement.safeVisit()
            }else{
                return try false_statement.safeVisit()
            }
        }catch{
            throw error
        }
    }
}

class ForNode:AST{
    var op:TokenType
    var times:AST
    var body:BlockNode
    var hasPlayerInBody: Bool
    init(op:TokenType, times:AST, body:BlockNode, hasPlayerInBody:Bool){
        self.op = op
        self.times = times
        self.body = body
        self.hasPlayerInBody = hasPlayerInBody
        
    }
    
    override func visit() throws -> Any? {
        do{
            guard let times = try self.times.safeVisit() as? Int else{
                throw InterpreterErrors.GenericError(str:"For statement must have integer times argument")
            }
            for _ in 0..<times{
                _ = try body.safeVisit()
                if isCancelled{
                    return nil
                }
                if hasPlayerInBody{
                    usleep(useconds_t(Constants.SLEEP_DURATION_IN_FOR))
                }
            }
            return nil
        }
        catch{
            throw error
        }
    }
}

class WhileNode:AST{
    var op:TokenType
    var bool_statement:AST
    var body:BlockNode
    var hasSensorInBody: Bool
    init(op:TokenType, bool_statement:AST, body:BlockNode, hasSensorInBody:Bool){
        self.op = op
        self.bool_statement = bool_statement
        self.body = body
        self.hasSensorInBody = hasSensorInBody
        
    }
    
    override func visit() throws -> Any? {
        do{
            while true{
                guard let bool_cond = try bool_statement.safeVisit() as? Bool else{
                    return nil

                }
                if bool_cond{
                    break
                }
                if isCancelled{
                    return nil
                }
                _ = try body.safeVisit()
                if self.hasSensorInBody{
                    usleep(useconds_t(Constants.SLEEP_DURATION_IN_WHILE))
                }
            }
            return nil
        }catch{
            throw error
        }
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
    
    override func visit() throws -> Any? {
        
        let var_name = value as! String
        
        for assignment in memory.getAssignments(){
            if assignment.identifier == var_name{
                return assignment.getValue()
            }
        }
        throw InterpreterErrors.GenericError(str:"\(var_name) is an undefined variable")
        
    }
}

class NoOpNode:AST{
}

class ProgramNode:AST{
    var block:BlockNode
    init(block:BlockNode){
        self.block = block
    }
    
    override func visit() throws -> Any? {
        do{
            return try block.safeVisit()
        }catch{
            throw error
        }
    }
}

class BlockNode:AST{
    var compound_statement:CompoundNode
    init(compound_statement:CompoundNode){
        self.compound_statement = compound_statement
    }
    override func visit() throws -> Any? {
        do{
            return try compound_statement.safeVisit()
        }catch{
            throw error
        }
    }
}
