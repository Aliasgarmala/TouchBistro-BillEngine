//
//  BillEngineTests.swift
//  BillEngineTests
//
//  Created by Aliasgar Mala on 2020-06-25.
//  Copyright © 2020 Aliasgar Mala. All rights reserved.
//

import XCTest
@testable import BillEngine

class BillGeneratorTests: XCTestCase {


    func testCalculatePriceOfAllItems() {
        let array: [NSDecimalNumber] = [1,2,3]
        let sum = array.sumOfAll()
        
        XCTAssertEqual(sum, 6)
    }
    
    func testCalculatePercentageOfReturnsProperAmount() {
        XCTAssertEqual(BillGenerator.calculatePercentageOf(amount: 100, by: 0.10), 10)
        XCTAssertEqual(BillGenerator.calculatePercentageOf(amount: 0, by: 0.10), 0)
        // -ve value passed as percentage (maybe we shouldn't allow)
        XCTAssertEqual(BillGenerator.calculatePercentageOf(amount: 100, by: -0.10), -10)

    }
    
    func testDollarAmountDiscountTypeIsApplied() {
        let dollarDiscount = DiscountMock(uniqueId: "3", label: "5$", amount: 5, isEnabled: true, discountType: .dollarAmount)
        
        XCTAssertEqual(BillGenerator.calculateDiscount(discount: dollarDiscount, amount: 100), 5)
    }
    
    func testPercentageDiscountTypeIsApplied() {
        let percentageDiscount = DiscountMock(uniqueId: "3", label: "5%", amount: 0.05, isEnabled: true, discountType: .percentage)
               
        XCTAssertEqual(BillGenerator.calculateDiscount(discount: percentageDiscount, amount: 25), 1.25)
    }
    
    
    func testCalculateTotalDiscountsIsAppliedIncludingTax() {
        let mockDiscountItems = [ DiscountMock(uniqueId: "3", label: "5%", amount: 0.05, isEnabled: true, discountType: .percentage),
        ]
        
        //discounts are calculated after applying tax and not before
        XCTAssertNotEqual(BillGenerator.calculateTotalDiscount(subTotal: 100, totalTax: 5, discountItems: mockDiscountItems), 5)
        
        XCTAssertEqual(BillGenerator.calculateTotalDiscount(subTotal: 100, totalTax: 5, discountItems: mockDiscountItems), 5.25)
    }
    
    func testSpecializedCategoryOfTaxAppliedOnlyToThatCategoryItem() {
        let mockTaxDessertOnly = [ TaxMock(uniqueId: "1", label: "VAT", amount: 0.13, isEnabled: true, category: "Dessert"),
                                   TaxMock(uniqueId: "2", label: "Covid Tax", amount: 0.15, isEnabled: true, category: "All")
                                ]
        let mockDessertItems = [ ItemMock(uniqueId: "1", name: "Ice-cream", category: "Dessert", price: 15.00, isTaxExempt: false),
           ]
        
        XCTAssertEqual(BillGenerator.calculateTotalTax(orderItems: mockDessertItems, taxItems: mockTaxDessertOnly), 1.95)
        
    }
    
    func testDifferentTaxAppliedToGenericItemsAndSpecializedItem() {
        let mockAllTaxItems = [ TaxMock(uniqueId: "1", label: "VAT", amount: 0.13, isEnabled: true, category: "Dessert"),
                                   TaxMock(uniqueId: "2", label: "Covid Tax", amount: 0.15, isEnabled: true, category: "All")
                                ]
        let mockAllItems = [ ItemMock(uniqueId: "1", name: "Ice-cream", category: "Dessert", price: 15.00, isTaxExempt: false),
                                 ItemMock(uniqueId: "1", name: "Covid taxable ice-cream", category: "All", price: 25.00, isTaxExempt: false),
           ]
        
        XCTAssertEqual(BillGenerator.calculateTotalTax(orderItems: mockAllItems, taxItems: mockAllTaxItems), 5.70)
    }
    
    
    func testBillGeneratorWithOnlyTax() {
        
        let mockAllTaxItems = [
                                TaxMock(uniqueId: "1", label: "VAT", amount: 0.13, isEnabled: true, category: "Dessert"),
                                TaxMock(uniqueId: "2", label: "Covid Tax", amount: 0.15, isEnabled: true, category: "All"),
                            ]
                
        let mockOrderItems = [
                                ItemMock(uniqueId: "1", name: "Ice-cream", category: "Dessert", price: 25.00, isTaxExempt: false),
                                ItemMock(uniqueId: "1", name: "Covid taxable ice-cream", category: "All", price: 25.00, isTaxExempt: false),
                            ]
        
        let billGenerator = BillGenerator.generateBillItemsFor(orderItems: mockOrderItems, taxItems: mockAllTaxItems, discountItems: [])
        
        XCTAssertEqual("$50.00", billGenerator.preTaxTotal)
        XCTAssertEqual("$0.00", billGenerator.discountTotal)
        XCTAssertEqual("$57.00", billGenerator.postTaxAndDiscountTotal)
        XCTAssertEqual("$7.00", billGenerator.taxTotal)
        
    }
    
    func testBillGeneratorReturnZeroValueWhenNoOrderItems() {
        
        let mockAllTaxItems = [
                                TaxMock(uniqueId: "1", label: "VAT", amount: 0.13, isEnabled: true, category: "Dessert"),
                                TaxMock(uniqueId: "2", label: "Covid Tax", amount: 0.15, isEnabled: true, category: "All")
                            ]
        
        let mockDiscountItems = [ DiscountMock(uniqueId: "3", label: "5%", amount: 0.05, isEnabled: true, discountType: .percentage) ]
        
        let billGenerator = BillGenerator.generateBillItemsFor(orderItems: [], taxItems: mockAllTaxItems, discountItems: mockDiscountItems)
        
        XCTAssertEqual("$0.00", billGenerator.preTaxTotal)
        XCTAssertEqual("$0.00", billGenerator.discountTotal)
        XCTAssertEqual("$0.00", billGenerator.postTaxAndDiscountTotal)
        XCTAssertEqual("$0.00", billGenerator.taxTotal)
        
    }
    
    func testBillGeneratorWithTaxAndDiscountItemsAsPercentage() {
        
        let mockAllTaxItems = [
                                TaxMock(uniqueId: "1", label: "VAT", amount: 0.13, isEnabled: true, category: "Dessert"),
                                TaxMock(uniqueId: "2", label: "Covid Tax", amount: 0.15, isEnabled: true, category: "All"),
                            ]
                
        let mockOrderItems = [
                                ItemMock(uniqueId: "1", name: "Ice-cream", category: "Dessert", price: 25.00, isTaxExempt: false),
                                ItemMock(uniqueId: "1", name: "Covid taxable ice-cream", category: "All", price: 25.00, isTaxExempt: false),
                            ]
        let mockDiscountItems = [ DiscountMock(uniqueId: "3", label: "5%", amount: 0.05, isEnabled: true, discountType: .percentage) ]
        
        let billGenerator = BillGenerator.generateBillItemsFor(orderItems: mockOrderItems, taxItems: mockAllTaxItems, discountItems: mockDiscountItems)
        
        XCTAssertEqual("$50.00", billGenerator.preTaxTotal)
        XCTAssertEqual("$2.85", billGenerator.discountTotal)
        XCTAssertEqual("$54.15", billGenerator.postTaxAndDiscountTotal)
        XCTAssertEqual("$7.00", billGenerator.taxTotal)
        
    }
    
    func testBillGeneratorWithTaxAndDiscountItemsAsDollarAmount() {
        
        let mockAllTaxItems = [
                                TaxMock(uniqueId: "1", label: "VAT", amount: 0.13, isEnabled: true, category: "Dessert"),
                                TaxMock(uniqueId: "2", label: "Covid Tax", amount: 0.15, isEnabled: true, category: "All"),
                            ]
                
        let mockOrderItems = [
                                ItemMock(uniqueId: "1", name: "Ice-cream", category: "Dessert", price: 25.00, isTaxExempt: false),
                                ItemMock(uniqueId: "1", name: "Covid taxable ice-cream", category: "All", price: 25.00, isTaxExempt: false),
                            ]
        let mockDiscountItems = [ DiscountMock(uniqueId: "3", label: "5$", amount: 5, isEnabled: true, discountType: .dollarAmount) ]
        
        let billGenerator = BillGenerator.generateBillItemsFor(orderItems: mockOrderItems, taxItems: mockAllTaxItems, discountItems: mockDiscountItems)
        
        XCTAssertEqual("$50.00", billGenerator.preTaxTotal)
        XCTAssertEqual("$5.00", billGenerator.discountTotal)
        XCTAssertEqual("$52.00", billGenerator.postTaxAndDiscountTotal)
        XCTAssertEqual("$7.00", billGenerator.taxTotal)
        
    }
}
