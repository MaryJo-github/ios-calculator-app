//
//  Calculator - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//


// =으로 계산 끝난 후 숫자 터치시 operands 초기화
/* ------------------------------ */
// label 0일 때 숫자 입력시 0빼고 저장 (연산자 연속으로 누를때 0과 같이 저장되는 오류)
// 오류처리 (notdivisiblebyzero)
// 45/ = invalidOperands인 이유
//

import UIKit

final class ViewController: UIViewController {
    private var expression = ""
    private var operandsValue = ""
    private var operatorValue = ""
    @IBOutlet weak var operandsLabel: UILabel!
    @IBOutlet weak var operatorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeOperands()
        initializeOperator()
    }
    
    // MARK: - Function
    private func initializeExpression() {
        expression = ""
    }
    
    private func initializeOperands(withLabel: Bool = true) {
        operandsValue = ""
        if withLabel {
            operandsLabel.text = "0"
        }
    }
    
    private func initializeOperator() {
        operatorValue = ""
        operatorLabel.text = ""
    }
    
    private func updateOperands(to value: String) {
        operandsValue = value
        operandsLabel.text = value.isEmpty ? "0" : value
    }
    
    private func updateOperator(to `operator`: String) {
        operatorValue = `operator`
        operatorLabel.text = `operator`
    }
    
    // MARK: - IBAction
    @IBAction private func hitOperatorButton(_ sender: UIButton) {
        guard let `operator` = sender.currentTitle else { return }

        // 이전에입력했던연산자 + 숫자(*52)를 스크롤뷰에 업데이트
        // 해당 string을 expression 에 추가
        // 누른 연산자로 OperatorLabel 변경
        // ValueLabel을 0으로 변경
        // 누른 연산자 저장
        
        if operandsValue.isEmpty == false {
            expression.append(operatorValue + operandsValue)
        }
        updateOperator(to: `operator`)
        initializeOperands()
    }
    
    @IBAction private func hitNumberButton(_ sender: UIButton) {
        guard let number = sender.currentTitle else { return }

        // 누른 번호 저장
        // 이전에 누른 번호와 합쳐서 ValueLabel 업데이트
        // .5 -> 0.5
        
        if operandsValue.isEmpty {
            updateOperands(to: number)
        } else {
            updateOperands(to: operandsValue + number)
        }
    }
    
    @IBAction private func hitEqualsButton(_ sender: UIButton) {
        guard let `operator` = sender.currentTitle else { return }

        expression.append(operatorValue + operandsValue)
        print(expression)
        
        do {
            var formula = try ExpressionParser.parse(from: expression)
            operandsLabel.text = "\(try formula.result())"
        } catch {
            print(error)
        }
        
        initializeExpression()
        initializeOperator()
        initializeOperands(withLabel: false)
    }
    
    @IBAction private func hitAllClearButton(_ sender: UIButton) {
        initializeOperands()
        initializeOperator()
        initializeExpression()
    }
    
    @IBAction private func hitClearEntryButton(_ sender: UIButton) {
        
    }
    
    @IBAction private func hitChangeSignButton(_ sender: UIButton) {
        guard operandsValue.isEmpty == false else { return }
        
        if operandsValue.hasPrefix("-") {
            updateOperands(to: operandsValue.trimmingCharacters(in: CharacterSet(charactersIn: "-")))
        } else {
            updateOperands(to: "-" + operandsValue)
        }
    }
}
