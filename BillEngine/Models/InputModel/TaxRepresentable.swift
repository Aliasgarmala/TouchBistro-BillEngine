//
//  TaxRepresentable.swift
//  POS
//
//  Created by Aliasgar Mala on 2020-06-24.
//  Copyright © 2020 TouchBistro. All rights reserved.
//

import Foundation

public typealias PercentageFormat = Double
/// A  tax item object that confirms to TaxRepresentable protocol
///   - uniqueId: String (Any unique identifier)
///   - label: String (name of the tax)
///   - amount: Double (amount to be charged as tax in percentage format eg: 0.05 for 5% )
///   - isEnabled: Bool (is the tax Enabled)
///   - category: String (category in which this item belongs) note: this should be same as category passed in Item and if this needs to be applied to all items pass it as "All"
public protocol TaxRepresentable {
    var uniqueId: String {get}
    var label: String {get}
    var amount: PercentageFormat {get}
    var isEnabled: Bool {get}
    var category: ItemCategory {get}
}

