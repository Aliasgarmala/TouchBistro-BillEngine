//
//  BillRepresentable.swift
//  BillEngine
//
//  Created by Aliasgar Mala on 2020-06-25.
//  Copyright © 2020 Aliasgar Mala. All rights reserved.
//

import Foundation

public protocol BillRepresentable {
    var uniqueId: String {get}
    var preTaxTotal: String {get}
    var postTaxAndDiscountTotal: String {get}
    var taxTotal: String {get}
    var discountTotal: String {get}
}


struct Bill: BillRepresentable, Equatable {
    internal let uniqueId: String = UUID().uuidString
    let preTaxTotal: String
    let postTaxAndDiscountTotal: String
    let taxTotal: String
    let discountTotal: String
}
