//
//  BillGenerator.swift
//  BillEngine
//
//  Created by Aliasgar Mala on 2020-06-25.
//  Copyright © 2020 Aliasgar Mala. All rights reserved.
//

import Foundation

public final class BillGenerator {
    
    //We do not want the consumer to initialize this class
    private init() {}
    
    
    /// Calculate the Bill parameters based on passed order items, tax items and discount items
    /// - Parameters:
    ///   - orderItems: ItemRepresentable items
    ///   - taxItems: TaxRepresentable items
    ///   - discountItems: DiscountRepresentable items
    /// - Returns: BillRepresentable which gives subTotalAmount. taxAmount, DiscountAmount and TotalAmount
    public static func generateBillItemsFor(orderItems: [ItemRepresentable], taxItems:[TaxRepresentable], discountItems:[DiscountRepresentable]) -> BillRepresentable {
        
        if orderItems.isEmpty {
            return Bill(preTaxTotal: "$0.00", postTaxAndDiscountTotal: "$0.00", taxTotal: "$0.00", discountTotal: "$0.00")
        }
        
        let priceOfAllItems = orderItems.map{ $0.price }.sumOfAll()
        let subTotal = priceOfAllItems
        
        let taxTotal = calculateTotalTax(orderItems: orderItems, taxItems: taxItems)
        
        let discountTotal = calculateTotalDiscount(subTotal: subTotal, totalTax: taxTotal, discountItems: discountItems)
        
        let total = subTotal.adding(taxTotal).subtracting(discountTotal)
        
        let bill = Bill(preTaxTotal: subTotal.currencyValue, postTaxAndDiscountTotal: total.currencyValue, taxTotal: taxTotal.currencyValue, discountTotal: discountTotal.currencyValue)
        
        return bill
        
    }
    
    
    /// calculate the amount in percentage equivalent amount
    /// - Parameters:
    ///   - amount: amount on which discount is applied
    ///   - by: value in percentage format
    /// - Returns: amount after applying percentage
    internal static func calculatePercentageOf(amount: NSDecimalNumber, by: PercentageFormat) -> NSDecimalNumber {
        let amount = amount.multiplying(by: NSDecimalNumber.init(value: by))
        let handler = NSDecimalNumberHandler(roundingMode: .plain, scale: 2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)

        return amount.rounding(accordingToBehavior: handler)
    }
    
    /// based on the discountType get the appropriate discount value
    /// - Parameters:
    ///   - discount: Discount item
    ///   - amount: Discount to be applied on the amount
    /// - Returns: actual discount value
    internal static func calculateDiscount(discount: DiscountRepresentable, amount: NSDecimalNumber) -> NSDecimalNumber {
        
        switch discount.discountType {
            case .percentage:
                return calculatePercentageOf(amount: amount, by: discount.amount)
            case .dollarAmount:
                return NSDecimalNumber.init(value:discount.amount)
            }
    }
    
    /// Calculate total discount after tax is applied
    /// - Parameters:
    ///   - subTotal: pre taxed amount
    ///   - totalTax: tax amount
    ///   - discountItems: discount items
    /// - Returns: actual dollar value of the discount to be applied
    internal static func calculateTotalDiscount(subTotal: NSDecimalNumber, totalTax: NSDecimalNumber, discountItems: [DiscountRepresentable]) -> NSDecimalNumber {
        
        var totalDiscount: NSDecimalNumber = 0
        let totalPriceOfItemsWithTax = subTotal.adding(totalTax)
        
        discountItems.forEach { (discount) in
            totalDiscount = totalDiscount.adding(calculateDiscount(discount: discount, amount: totalPriceOfItemsWithTax))
        }
                
        return totalDiscount
    }
    
    /// Divide the items in categories so that individual taxes can be applied to particular category or the remaining items
    /// - Parameter taxItems: Tax items
    /// - Returns: Dictionary with all tax categories
    internal static func createTaxCategories(taxItems: [TaxRepresentable] ) -> [String: [ItemRepresentable]] {
        var taxCategoryDict: [String: [ItemRepresentable]] = [:]
        taxItems.forEach { (taxItem) in
            taxCategoryDict[taxItem.category] = []
        }
        
        //incase the taxes have no "all" category taxes
        if taxCategoryDict["All"] == nil {
            taxCategoryDict["All"] = []
        }
        
        return taxCategoryDict
    }
    
    
    
    /// Calculate tax based on categories, if special category is mentioned apply tax to only that category else apply to all
    /// - Parameters:
    ///   - orderItems: Order Items
    ///   - taxItems: tax Items
    /// - Returns: total tax calculated
    internal static func calculateTotalTax(orderItems: [ItemRepresentable], taxItems: [TaxRepresentable]) -> NSDecimalNumber {
        var dictionary: [String: [ItemRepresentable]] = createTaxCategories(taxItems: taxItems)
        
        let taxCategories = Set(taxItems.map{$0.category})

        for orderItem in orderItems where !orderItem.isTaxExempt {

            if taxCategories.contains(orderItem.category)  {
                dictionary[orderItem.category]!.append(orderItem)
            } else {
                dictionary["All"]!.append(orderItem)
            }
        }

        var totalTaxAmount: NSDecimalNumber = 0
        taxItems.forEach { (taxItem) in
            if let items = dictionary[taxItem.category] {
                
                let totalPrice  = items.map{ $0.price }.sumOfAll()
                totalTaxAmount = totalTaxAmount.adding(calculatePercentageOf(amount: totalPrice, by: taxItem.amount))
            }
        }
        
        return totalTaxAmount
    }
}
