# TouchBistro-BillEngine

Bill Engine is a lightweight and a fast framework that serves all your billing needs.

Main Class is Bill Generator where Bill is generated based on given inputs.

Bill Generator class is fully Unit tested

# Input
* Consuming application should provide Order Items, Tax Items and Discount Items.
  These items should adhere to ItemRepresentable, TaxRepresentable and DiscountRepresentable protocol respectively.
  
# Output
  * Output is represented by BillRepresentable protocol. 
  Which consist of Unique Identifier, preTaxTotal, discountTotal, postTaxAndDiscountTotal(final total), taxTotal
  
 # Assumptions
  1) When a tax is applied to a special category of items (eg: Alcohol), those items are exempted from the overall bill (eg: 5% tax).
  In other words only alcohol will be charged at 10% and remaining bill will be charged at 5% (excluding alcohol)

  2) I have applied taxes first and then discounts
  
  3) Discounts are applied based on the order in which they appear in the sample app (send as an array maintaining order)
  
 # Improvements
 
  * There's a lot of type safety measures we can introduce for further reducing unintentional wrong input. 
  1) We let the consumer make sure the tax category and item category should be the same (for specialized taxes). 
  Even though we inform the user by documentation. It would be good to show the compile time error in case invalid category is passed
  
  2) We put the responsibility to the user to put category: "All" for tax item which should be applied to the entire bill,
  this should be default and hidden from user
  
  3) if the discount type is percentage (we give the responsibility to the consuming application to pass the amount as 0.05 for 5%) rather we can take 5 as the amount and can convert it appropriately in the framework
  not confusing users to pass different formats when using discount or dollar amount discount.
