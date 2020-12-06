//
//  Interpreter.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 4.12.2020.
//

import Foundation
class Interpreter{
    var dispatchQueue = DispatchQueue(label: "interpreter_queue",qos: .utility)
    private var workItem: DispatchWorkItem?
    
    var isCancelled:Bool{
        return workItem!.isCancelled
    }
    
    var inputSemaphore: DispatchSemaphore!
    
    private init() {}
    
    private func interpret(tree:AST){
        _ = tree.visit()
    }
    
    func runCode(code:String){
        let lexer = Lexer(text: code)
        lexer.lex()
        let local_mem = Memory(assignments: GlobalMemory.getInstance().getAssignments())
        let parser = Parser(lexer_out: lexer.lexedText, memory: local_mem)
        let tree = parser.parse()
        workItem = DispatchWorkItem {
            self.interpret(tree: tree)
        }
        inputSemaphore = DispatchSemaphore(value: 0)
        dispatchQueue.async(execute: workItem!)
    }
    
    func finish(){
        workItem?.cancel()
        inputSemaphore.signal()
        
    }
    
    private static let instance = Interpreter()
    public static func getInstance() -> Interpreter{
        return .instance
    }
    
}
