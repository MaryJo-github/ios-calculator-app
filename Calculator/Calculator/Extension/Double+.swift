//
//  Double+.swift
//  Calculator
//
//  Created by MARY on 2023/06/03.
//

import Foundation

extension Double: CalculateItem {}

extension Double {
    func numberFormat() -> String? {
        let numberFormatter = NumberFormatter()
        
        numberFormatter.numberStyle = .decimal
        numberFormatter.roundingMode = .halfDown
        numberFormatter.usesSignificantDigits = true
        numberFormatter.maximumSignificantDigits = 21
//        numberFormatter.maximumFractionDigits = 20
        
        return numberFormatter.string(for: self)
    }
}
