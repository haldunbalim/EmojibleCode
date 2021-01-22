//
//  Interpreter.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 4.12.2020.
//

import Foundation
fileprivate let runScreen = RunCodeCoordinator.getInstance().runScreen!


class Interpreter{
    var dispatchQueue = DispatchQueue(label: "interpreter_queue",qos: .utility)
    private var workItem: DispatchWorkItem?
    
    var isCancelled:Bool{
        return workItem!.isCancelled
    }
    
    var inputSemaphore: DispatchSemaphore!
    
    private init() {}
    
    private func interpret(tree:AST){
        do{
            _ = try tree.visit()
        }catch InterpreterErrors.GenericError(let str){
            runScreen.errorMessage = str
            runScreen.performSelector(onMainThread: #selector(runScreen.showErrorMessageAndDismiss), with: nil, waitUntilDone: false)
        }
        catch{
            runScreen.errorMessage = error.localizedDescription
            runScreen.performSelector(onMainThread: #selector(runScreen.showErrorMessageAndDismiss), with: nil, waitUntilDone: false)
        }
    }
    
    func runCode(code:String) throws{
        do{
            inputSemaphore = DispatchSemaphore(value: 0)
            let lexer = Lexer(text: code)
            try lexer.lex()
            let local_mem = Memory(assignments: GlobalMemory.getInstance().getAssignments())
            let parser = Parser(lexer_out: lexer.lexedText, memory: local_mem)
            let tree = try parser.parse()
            workItem = DispatchWorkItem {
                self.interpret(tree: tree)
            }
            dispatchQueue.async(execute: workItem!)
        }catch{
            throw error
        }
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
