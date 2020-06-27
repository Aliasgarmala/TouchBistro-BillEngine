//
//  Box.swift
//  BillEngine
//
//  Created by Aliasgar Mala on 2020-06-27.
//  Copyright © 2020 Aliasgar Mala. All rights reserved.
//

import Foundation
class Box<T> {
    typealias Listener = (T) -> Void
    var listener: Listener?

    var value: T {
        didSet {
            listener?(value)
        }
    }

    init(_ value:T) {
        self.value = value
    }

    //you can stop listening by passing nil
    func bind(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}

