//
//  DiscountRepresentable.swift
//  POS
//
//  Created by Aliasgar Mala on 2020-06-24.
//  Copyright © 2020 TouchBistro. All rights reserved.
//

import Foundation

/// A  tax item object that confirms to TaxRepresentable protocol
///   - uniqueId: String (Any unique identifier)
///   - label: String (name of the discount)
///   - amount: Double (discount type is percentage then amount should be percentage type )
///   - isEnabled: Bool (is the discount Enabled)
///   - discountType: Type (is the discount dollar type or percentage type)
public protocol DiscountRepresentable {
    var uniqueId: String {get}
    var label: String {get}
    var amount: Double {get}
    var isEnabled: Bool {get}
    var discountType: Type {get}
}


/// Dollar value or percentage type enum
public enum Type {
    case percentage
    case dollarAmount
}

