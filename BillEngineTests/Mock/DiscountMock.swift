//
//  DiscountMock.swift
//  BillEngineTests
//
//  Created by Aliasgar Mala on 2020-06-26.
//  Copyright © 2020 Aliasgar Mala. All rights reserved.
//

import Foundation
@testable import BillEngine

struct DiscountMock: DiscountRepresentable {
    var uniqueId: String
    var label: String
    var amount: Double
    var isEnabled: Bool
    var discountType: Type
}
