//
//  ViewController.swift
//  Calculator
//
//  Created by Michelline Tran on 3/14/17.
//  Copyright © 2017 Michelline Tran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTyping = false {
        didSet {
            if !userIsInTheMiddleOfTyping {
                userIsInTheMiddleOfFloatingPointNumber = false
            }
        }
    }
    
    var userIsInTheMiddleOfFloatingPointNumber = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
        var digit = sender.currentTitle!
        
        if digit == "." {
            if userIsInTheMiddleOfFloatingPointNumber {
                return
            }
            
            if !userIsInTheMiddleOfTyping {
                digit = "0."
            }
            
            userIsInTheMiddleOfFloatingPointNumber = true
        }
        
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTyping = true
        }
    }
    
    var displayValue: Double {             //computed property
        get {
            return Double(display.text!)!
        }
        set {
            if newValue == 0.0 {
                display.text = "0"
            } else {
                display.text = String(newValue)
            }
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        
        if let result = brain.result {
                displayValue = result
        }
    }
}
