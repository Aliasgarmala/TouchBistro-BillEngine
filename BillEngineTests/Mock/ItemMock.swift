//
//  ItemMock.swift
//  BillEngineTests
//
//  Created by Aliasgar Mala on 2020-06-26.
//  Copyright © 2020 Aliasgar Mala. All rights reserved.
//

import Foundation
@testable import BillEngine

struct ItemMock: ItemRepresentable {
    var uniqueId: String
    let name: String
    let category: String
    let price: NSDecimalNumber
    var isTaxExempt: Bool
}
