//
//  Calculator - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    private var expression = ""
    private var operandsValue = ""
    private var operatorValue = ""
    @IBOutlet weak var operandsLabel: UILabel!
    @IBOutlet weak var operatorLabel: UILabel!
    @IBOutlet weak var parentStackView: UIStackView!
    @IBOutlet weak var expressionScrollView: UIScrollView!
    
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
        
        if operandsValue.isEmpty == false {
            expression.append(operatorValue + operandsValue)
            insertStackView(with: operatorValue, operandsValue)
        }
        updateOperator(to: `operator`)
        initializeOperands()
    }
    
    @IBAction private func hitNumberButton(_ sender: UIButton) {
        guard let number = sender.currentTitle else { return }
        if operandsValue.contains(".") && number == "." { return }

        switch (operandsValue, number) {
        case ("0", "0"):
            return
        case ("0", "00"):
            return
        case ("", "0") where expression.isEmpty:
            return
        case ("", "00"):
            return
        case ("", "."):
            updateOperands(to: "0" + number)
        case ("0", _):
            updateOperands(to: number)
        case ("", _):
            updateOperands(to: number)
        default:
            updateOperands(to: operandsValue + number)
        }
    }
    
    @IBAction private func hitEqualsButton(_ sender: UIButton) {
        do {
            expression.append(operatorValue + operandsValue)
            insertStackView(with: operatorValue, operandsValue)
            print(expression)
            var formula = ExpressionParser.parse(from: expression)
            let result = try formula.result()
            
            operandsLabel.text = result.numberFormat()!
        } catch {
            operandsLabel.text = "NaN"
            print(error)
        }
        initializeOperands(labelUpdate: false)
        initializeOperator()
        initializeExpression()
        initializeStackView()
    }
    
    @IBAction private func hitAllClearButton(_ sender: UIButton) {
        initializeOperands()
        initializeOperator()
        initializeExpression()
        initializeStackView()
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

extension ViewController {
    private func createUILabel(text: String) -> UILabel {
        let label = UILabel()
        
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.textColor = .white
        label.text = text
        
        return label
    }
    
    private func createSubStackView(with labels: [UILabel]) -> UIStackView {
        let stackView = UIStackView()
        
        stackView.spacing = 8
        labels.forEach {
            stackView.addArrangedSubview($0)
        }
        
        return stackView
    }
    
    private func insertStackView(with strings: String...) {
        let labels = strings.map { createUILabel(text: $0) }
        let subStackView = createSubStackView(with: labels)
        
        parentStackView.addArrangedSubview(subStackView)
        expressionScrollView.layoutIfNeeded()
        expressionScrollView.scrollToBottom()
    }
    
    private func initializeStackView() {
        guard parentStackView.subviews.count > 0 else { return }
        
        parentStackView.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
    }
}
