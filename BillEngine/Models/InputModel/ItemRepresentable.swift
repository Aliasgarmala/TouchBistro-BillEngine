//
//  ItemRepresentable.swift
//  POS
//
//  Created by Aliasgar Mala on 2020-06-24.
//  Copyright © 2020 TouchBistro. All rights reserved.
//

import Foundation
///same for item and tax
public typealias ItemCategory = String

//can make isTaxExempt default to false

/// A  menu item object that confirms to ItemRepresentable protocol
///   - uniqueId: String (Any unique identifier)
///   - name: String (name of the item)
///   - category: String (category in which this item belongs) note: this should be same as category passed in tax
///   - price:  NSDecimalNumber (price of the item)
///   - isTaxExempt: Bool (is the item exempt from tax)
public protocol ItemRepresentable {

    var uniqueId: String {get}
    var name: String {get}
    var category: ItemCategory {get}
    var price: NSDecimalNumber {get}
    var isTaxExempt: Bool {get}
}

