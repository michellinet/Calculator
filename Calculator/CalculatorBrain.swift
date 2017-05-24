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
    
    mutating func addUnaryOperation(named symbol: String, _ operation: @escaping (Double) -> Double) {
        operations[symbol] = Operation.unaryOperation(operation)
    }
    
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
        "×" : Operation.binaryOperation({ $0 * $1 }),       //previously, Operation.binaryOperation(multiply), but I do it for da closure
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOperation(sqrt),
        "log" : Operation.unaryOperation(log10),
        "cos" : Operation.unaryOperation(cos),
        "sin" : Operation.unaryOperation(sin),
        "tan" : Operation.unaryOperation(tan),
        "±" : Operation.unaryOperation({ -$0 }),            //previously, Operation.unaryOperation(changeSign), but closures
        "=" : Operation.equals,
        "C" : Operation.clear
    ]
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
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
                accumulator = 0
            default :
                break
            }
            
        }
        
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
    
    private var resultIsPending: Bool {
        return pendingBinaryOperation != nil
    }
    
    //MARK: Set Operand
    mutating func setOperand(_ operand: Double) {           //due to copy-on-write
        accumulator = operand
    }
    
    mutating func setOperand(variable named: String) {
        stack.append(Operation.variable(named))
    }

    //MARK: Result
    var result: Double? {
        return accumulator
    }
    
}
