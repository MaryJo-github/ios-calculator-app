//
//  ExpressionParser.swift
//  Calculator
//
//  Created by MARY on 2023/06/03.
//

import Foundation

enum ExpressionParser {
    static func parse(from input: String) -> Formula {
        let operands = componentsByOperators(from: input)
        let operators = input.compactMap { Operator(rawValue: $0) }
        var operandsQueue = CalculatorItemQueue<Double>()
        var operatorsQueue = CalculatorItemQueue<Operator>()
          
        operands.compactMap { Double($0) }.forEach { operandsQueue.enqueue($0) }
//        operands.forEach {
//            guard let operand = Double($0) else { return }
//            operandsQueue.enqueue(operand)
//        }
        operators.forEach { operatorsQueue.enqueue($0) }
        
        return Formula(operands: operandsQueue, operators: operatorsQueue)
    }
    
    static private func componentsByOperators(from input: String) -> [String] {
        let operators = Operator.allCases
                                .map { String($0.rawValue) }
                                .joined()
        
        return input.components(separatedBy: CharacterSet(charactersIn: operators))
    }
}
