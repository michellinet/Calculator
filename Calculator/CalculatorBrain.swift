//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Michelline Tran on 3/15/17.
//  Copyright © 2017 Michelline Tran. All rights reserved.
//

import Foundation

//func changeSign(operand: Double) -> Double {
//    return -operand
//}

//func multiply(op1: Double, op2: Double) -> Double {
//    return op1 * op2
//}

struct CalculatorBrain {
    
    private var accumulator: Double?
    
    private var stack = [Operation]()
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double,Double) -> Double)
        case equals
        case clear
        case operand(Double)
        case variable(String)
    }
    
    private var operations: Dictionary<String,Operation> = [
        "+" : Operation.binaryOperation({ $0 + $1 }),
        "−" : Operation.binaryOperation({ $0 - $1 }),
        "÷" : Operation.binaryOperation({ $0 / $1 }),
        "×" : Operation.binaryOperation({ $0 * $1 }),
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOperation(sqrt),
        "log" : Operation.unaryOperation(log10),
        "cos" : Operation.unaryOperation(cos),
        "sin" : Operation.unaryOperation(sin),
        "tan" : Operation.unaryOperation(tan),
        "±" : Operation.unaryOperation({ -$0 }),
        "=" : Operation.equals,
        "C" : Operation.clear
    ]
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            stack.append(operation)

            switch operation {
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function) :
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .equals :
                performPendingBinaryOperation()
            case .clear :
                stack = []
                memory = nil
            default:
                break
            }
            
        }
        
    }
    
    mutating func addUnaryOperation(named symbol: String, _ operation: @escaping (Double) -> Double) {
        operations[symbol] = Operation.unaryOperation(operation)
    }
    
    //MARK: Pending Binary Operation implementation
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    //MARK: Evaluate
    
    var memory: Dictionary<String,Double>?
    
    func evaluate(using variables: Dictionary<String,Double>? = nil)
        -> (result: Double?, isPending: Bool, description: String) {
            
            var lookup: Dictionary<String,Double>?
            if let variables = variables {
                lookup = variables
            } else {
                lookup = memory
            }
            
            var acc: Double = 0.0
            var pendingBinaryOperation: PendingBinaryOperation?
            var pendingStatus: Bool {
                return pendingBinaryOperation != nil
            }
            
            for element in stack {
                
                switch element {
                case .constant(let value):
                    if let pending = pendingBinaryOperation {
                        acc = pending.perform(with: value)
                    } else {
                        acc = value
                    }
                    
                    pendingBinaryOperation = nil
                
                case .variable(let name):
                    let value = lookup?[name] ?? 0.0
                    
                    if let pending = pendingBinaryOperation {
                        acc = pending.perform(with: value)
                    } else {
                        acc = value
                    }
                    
                    pendingBinaryOperation = nil
                    
                case .unaryOperation(let function):
                    acc = function(acc)
               
                case .binaryOperation(let function):
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: acc)
                
                default:
                    break
                }
            }
            
            return (acc, pendingStatus, "")
    }
    
    //MARK: Set Operand
    mutating func setOperand(_ operand: Double) {
        stack.append(Operation.constant(operand))
        accumulator = operand
    }
    
    mutating func setOperand(variable named: String) {
        stack.append(Operation.variable(named))
    }
    
    //MARK: M
    
//    var M: Double {
//        get {
//            return 0.0
//        }
//        set (newM){
//            M = newM
//        }
//    }
    
    var M: String = "M"
    
    //MARK: Result
    var result: Double? {
        return evaluate().result
    }
    
    var resultIsPending: Bool {
        return evaluate().isPending
    }
    
}
