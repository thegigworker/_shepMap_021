//
//  JUST_SOME_NOTES.swift
//  Created by Shepard Tamler on 4/18/18.
//


/////////////
//  In an app, the FIRST RESPONDER is an object that is first on the line for receiving many kinds of app events, including key events, motion events, and action messages, among others. In other words, many of the events generated by the user are initially routed to the first responder.
//////////////


/*  RE INSTANCE METHOD V CLASS METHOD
You can only call an instance method on an instance of a class. For example, you would have to create an instance of myScript, then call it:
     let script = myScript()
     script.thisIsmyFunction()
You can also choose to make thisIsmyFunction a class method (which is formally known as a "type method" in Swift), and call it like the way you are doing right now:
    class func thisIsmyFunction() {...}
Note the class modifier in front of func. Of course, this means you can't access self inside the function, because there is no longer an instance of the class.
 */


/* A NOTE RE ?? OPERATOR RE OPTIONALS
 "nil coalescing operator" (also called "default operator")
 
 let something = myVariable ?? myOtherVariable
 Can be thought of as  "let something = UNWRAPPED myVariable if it's not nil, OTHERWISE let something = myOtherVariable"
 
 equivalent to
 let something = myVariable != nil ? myVariable! : myOtherVariable
 */


/*
 NOTE RE THIS SYSTEM ERROR:  this class is not key value coding-compliant for the key XXX.'
 Another common cause if you are using Storyboard, your UIButton might have more then one assignings, a wrong Outlet or Action or an extra one.
 Open your storyboard and right click the XXX
 You will see that there is more than one assign/ref to this XXX. Remove one of the "Main..." greyed windows with the small "x":
 */


/*  PROJECT NAVIGATOR CODES
 ? - means the file has not been added to source control
 M - Modified
 A - Added file, not yet under source control
 A+ - Moved / renamed
 U - Newer version of a file on source control
 I - Item is being ignored
 ! - Item is missing (e.g. you moved or deleted it). This also indicates that a directory is incomplete (a checkout or update was interrupted).
 
 */


/* THE IF LET STATEMENT TAKES AN OPTIONAL VARIABLE.
 If it is nil, the else block or nothing is executed. If it has a value, the value is assigned to a different variable as a non-optional type.
 So, the following code would output the value of score1 or "No" if there is none:
 
 if let score1Unwrapped = score1
 { print(score1Unwrapped)
 } else {print("No")}
 
 A shorter version of the same would be:
 print(score1 ?? "No")
 
 In your case, where you don't actually use the value stored in the optional variable, you can also check if the value is nil:
 
 if score1 != nil {
 ...
 }
 */


// CONVERT INT TO STRING
//to convert an Int to String:
//      let text = "\(myInt)"
//to convert OPTIONAL Integers to Strings:
//      String(describing:YourInteger ?? 0)



//TIME INTERVAL
//let start = Date()
//[code]
//let end = Date()
//print(“Elapsed Time: \(end.timeIntervalSince(start))”)



/* TERNARY CONDITIONAL OPERATORS are a shorthand way of making something equal one thing or another based on a true or false condition
     something =  condition ? expression : expression
 
NIL COALESCING OPERATOR.  (Optional defaulting)
//var someOptional : Int?
//var aDefaultValue = 42
//var theAnswer = someOptional ?? aDefaultValue
Since someOptional is nil (we didn’t set it to a valid Int yet), theAnswer will of course be 42.
Equivalent to:
    if (someOptional != nil) {
    theAnswer = someOptional!
} else {
    theAnswer = aDefaultValue
}
 */


// INTERESTING GUARD STATEMENT TEST CODE
//    // The rating must be between 0 and 5 inclusively
//    guard (rating >= 0) && (rating <= 5) else {
//    return nil
//    }
// INTERESTING GUARD STATEMENT TEST CODE


/*  CREATING AN ARRAY BY ADDING TWO ARRAYS TOGETHER
 var threeDoubles = Array(repeating: 0.0, count: 3)
 // threeDoubles is of type [Double], and equals [0.0, 0.0, 0.0]
 You can create a new array by adding together two existing arrays with compatible types with the addition operator (+). The new array’s type is inferred from the type of the two arrays you add together:
 var anotherThreeDoubles = Array(repeating: 2.5, count: 3)
 // anotherThreeDoubles is of type [Double], and equals [2.5, 2.5, 2.5]
 var sixDoubles = threeDoubles + anotherThreeDoubles
 // sixDoubles is inferred as [Double], and equals [0.0, 0.0, 0.0, 2.5, 2.5, 2.5]
 */


/*  YES, SWIFT HAS THE SET CLASS.
 Check if no members same
 Set1.isDisjointWith(Set2)    Returns true if the two Sequences have no members in common.
 
 Combine Sets
 Set1.union(Set2)    Returns a new Set containing the members of both set1 and set2.
 
 Combine Sets In Place
 Set1.unionInPlace(Set2)    Mutates set2 to add the members of set1 to it.
 
 Subtract One Set From Another
 set2.subtract(entreeSet)    Returns a new Set with the values of entreeSet removed from set2, if they were present.
 
 Subtract One Set From Another In Place
 set2.subtractInPlace(entreeSet)    Mutates the set2 Set to subtract an values that were specified in the entreeSet (like above).
 
 Create Set of Common Members
 moreFoods.intersect(entreeSet)    Returns a new Set with the values that were in common between moreFoods and entreeSet.
 
 Create Set of Common Members In Place
 moreFoods.intersectInPlace(entreeSet)    Mutates the moreFoods Set to perform the intersect method above.
 
 Create Set of Uncommon Members
 moreFoods.exclusiveOr(dessertsSet)    Returns a new Set containing the values that were in either moreFoods or dessertsSet, but NOT both.
 
 Create Set of Uncommon Members In Place
 moreFoods.exclusiveOrInPlace(dessertsSet)    Mutates the moreFoods Set with the result of the exclusiveOr method above.
 
 ///////////////////////////////////////////////////////
 //entreeSet   is {"Salad", "Sandwiches"}
 //sameFoodSet is {"Salad", "Chips", "Sandwiches"}
 //otherFoods  is {"Quiche", "Donuts"}
 
 foodSet.contains("Chips")               //returns true
 
 entreeSet.isSubsetOf(foodSet)           //returns true
 sameFoodSet.isStrictSubsetOf(foodSet)   //returns false
 
 foodSet.isSupersetOf(entreeSet)         //returns true
 foodSet.isStrictSupersetOf(sameFoodSet) //returns false
 foodSet.isStrictSupersetOf(entreeSet)   //returns true
 
 foodSet.isDisjointWith(entreeSet)       //returns false
 foodSet.isDisjointWith(otherFoods)      //returns true
 ///////////////////////////////////////////////////////
 
 let array1 = ["a", "b", "c"]
 let array2 = ["a", "b", "d"]
 
 let set1:Set<String> = Set(array1)
 let set2:Set<String> = Set(array2)
 
 Swift 3.0+ can do operations on sets as:
 
 firstSet.union(secondSet)// Union of two sets
 firstSet.intersection(secondSet)// Intersection of two sets
 firstSet.symmetricDifference(secondSet)// exclusiveOr
 
 Swift 2.0 can calculate on array arguments:
 
 set1.union(array2)       // {"a", "b", "c", "d"}
 set1.intersect(array2)   // {"a", "b"}
 set1.subtract(array2)    // {"c"}
 set1.exclusiveOr(array2) // {"c", "d"}
 
 Swift 1.2+ can calculate on sets:
 
 set1.union(set2)        // {"a", "b", "c", "d"}
 set1.intersect(set2)    // {"a", "b"}
 set1.subtract(set2)     // {"c"}
 set1.exclusiveOr(set2)  // {"c", "d"}
 
 If you're using custom structs, you need to implement Hashable.
 */

/* SWIFT KEYPATHS
 //
 //SWIFT KEYPATHS ARE A WAY OF STORING UNINVOKED REFERENCES TO PROPERTIES, which is a fancy way of saying they refer to a property itself rather than to that property’s value.
 
 //Here’s an example struct storing a name and maximum warp speed of a starship:
 struct Starship {
 var name: String
 var maxWarp: Double
 }
 
 let voyager = Starship(name: "Voyager", maxWarp: 9.975)
 //Keypaths let us refer to the name or maxWarp properties without reading them directly, like this:
 
 let nameKeyPath = \Starship.name
 let warpKeyPath = \Starship.maxWarp
 //If you want to read those keypaths on a specific starship, Swift will return you the actual values attached to those properties:
 
 print(voyager[keyPath: nameKeyPath])
 print(voyager[keyPath: warpKeyPath])
 //In practice, this means you can refer to the same property in multiple places all using the same keypath – and if you decide you want a different property you can change it in just one place.
//
 //Let define a struct called Cavaliers and a struct called Player, then create one instance of each:
 
 // an example struct
 struct Player {
 var name: String
 var rank: String
 }
 
 // another example struct, this time with a method
 struct Cavaliers {
 var name: String
 var maxPoint: Double
 var captain: Player
 
 func goTomaxPoint() {
 print("\(name) is now travelling at warp \(maxPoint)")
 }
 }
 
 // create instances of those two structs
 let james = Player(name: "Lebron", rank: "Captain")
 let irving = Cavaliers(name: "Kyrie", maxPoint: 9.975, captain: james)
 
 // grab a reference to the `goTomaxPoint()` method
 let score = irving.goTomaxPoint
 
 // call that reference
 score()
 //The last lines create a reference to the goTomaxPoint() method called score. The problem is, we can't create a reference to the captain's name property but keypath can do.
 
 let nameKeyPath = \Cavaliers.name
 let maxPointKeyPath = \Cavaliers.maxPoint
 let captainName = \Cavaliers.captain.name
 let cavaliersName = irving[keyPath: nameKeyPath]
 let cavaliersMaxPoint = irving[keyPath: maxPointKeyPath]
 let cavaliersNameCaptain = irving[keyPath: captainName]
 */

////////////////////////////////

/*
 //Since Swift is a statically dispatched language, dynamic features are not its strong suit. Swift 4 added support for key path and allow you to do something like this:
 
 extension Array {
 mutating func sort<T: Comparable>(byKeyPath keyPath: KeyPath<Element, T>) {
 sort(by: { $0[keyPath: keyPath] < $1[keyPath: keyPath] })
 }
 }
 
 struct DataModel {
 var title: String
 var dollar: Double
 }
 
 var myArray = [DataModel(title: "A", dollar: 12), DataModel(title: "B", dollar: 10)]
 let keyPath = \DataModel.dollar
 myArray.sort(byKeyPath: keyPath)
 
 //But there is no way to construct the key path from String. It must be known at compile time to ensure type safety.
 */

