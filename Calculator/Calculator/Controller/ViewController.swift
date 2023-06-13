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
// 소수점 처리 -> 결과가 정수이면 정수로 보여주기
// 오류처리 -> nan 처리
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
    
    private func initializeOperands(labelUpdate: Bool = true) {
        operandsValue = ""
        if labelUpdate {
            operandsLabel.text = "0"
        }
    }
    
    private func initializeOperator() {
        operatorValue = ""
        operatorLabel.text = ""
    }
    
    private func updateOperands(to value: String) {
        operandsValue = value
        operandsLabel.text = value
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
        
        switch operandsValue {
        case "" where number == ".":
            updateOperands(to: "0" + number)
        case "":
            updateOperands(to: number)
        default:
            updateOperands(to: operandsValue + number)
        }
    }
    
    @IBAction private func hitEqualsButton(_ sender: UIButton) {
        do {
            expression.append(operatorValue + operandsValue)
            print(expression)
            var formula = ExpressionParser.parse(from: expression)
            let result = try formula.result()
            
            operandsLabel.text = result.numberFormat()!
        } catch {
            operandsLabel.text = "NaN"
            print(error)
        }
        
        initializeExpression()
        initializeOperator()
        initializeOperands(labelUpdate: false)
    }
    
    @IBAction private func hitAllClearButton(_ sender: UIButton) {
        initializeOperands()
        initializeOperator()
        initializeExpression()
    }
    
    @IBAction private func hitClearEntryButton(_ sender: UIButton) {
        initializeOperands()
    }
    
    @IBAction private func hitChangeSignButton(_ sender: UIButton) {
        guard operandsValue.isEmpty == false else { return }
        
        if operandsValue.hasPrefix("-") {
            updateOperands(to: String(operandsValue.dropFirst()))
        } else {
            updateOperands(to: "-" + operandsValue)
        }
    }
}
