//
//  ShepDataModel.swift
//  Tandm
//
//  Created by Shepard Tamler on 12/13/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation
import MapKit

/// THREE SLASHES above a custom method puts that comment into the Xcode quickhelp

func meters2miles (meters: Double) -> Double {
    let miles = meters * 0.00062137
    return miles
}

func miles2meters (miles: Double) -> Double {
    let meters = miles * 1609.34
    return meters
}


//The class keyword in the Swift protocol definition limits protocol adoption to class types (and not structures or enums). This is important if we want to use a weak reference to the delegate. We need be sure we do not create a retain cycle between the delegate and the delegating objects, so we use a weak reference to delegate (see below).
protocol DataModelMapScreenDelegate: class {
    func showValidSearchResults(validSearchResults: [ShepSingleAnnotation])
    func drawNewRoute(thisRoute: MKRoute)
}

//Comparing to the callback way, Delegation pattern is easier to reuse across the app: you can create a base class that conforms to the protocol delegate and avoid code redundancy. However, delegation is harder to implement: you need to create a protocol, set the protocol methods, create Delegate property, assign Delegate to ViewController, and make this ViewController conform to the protocol. Also, the Delegate has to implement every method of the protocol by default.

class shepDataModel: NSObject {
    //We need be sure we do not create a retain cycle between the delegate and the delegating objects, so we use a weak reference to delegate.
    weak var myDataModelMapScreenDelegate: DataModelMapScreenDelegate!
    var validSearchResultsArray = [ShepSingleAnnotation]()
    
    static var theMASTERAnnotationsArray = [ShepSingleAnnotation]()
    static var MASTERAnnotationsArrayUpdated: Bool = false // if true then TableView will need redraw
    static let initialSearch: Double = 15
    static let initialDisplay: Double = 25
    static var myUserLocation: CLLocation = CLLocation()
    static var centsPerMileExpense: Int = 60
    static var currentTransportType = MKDirectionsTransportType.automobile
    static var howManySearchItemsFound = 0
    static var currentSearchDistance = CLLocationDistance(miles2meters(miles: initialSearch))
    static var currentDisplayDistance = CLLocationDistance(miles2meters(miles: initialDisplay))
    static var currentRoute = MKRoute()
    static var crowFliesDistance : Double = 1.0
    static var howManyRouteInfosCompleted: Int = 0
    static var whichRouteStyle : String = ""
    
    
//    class func buildSingleTableArray() -> [ShepSingleAnnotation] {
//        return theMASTERAnnotationsArray
//    }
 
    // MKPlacemark is a subclass of CLPlacemark, therefore you cannot just cast it. You can instantiate an MKPlacemark from a CLPlacemark using the code below
    //     if let addressDict = clPlacemark.addressDictionary, coordinate = clPlacemark.location.coordinate {
    //     let mkPlacemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
    //     init(placemark: MKPlacemark)
    // Initializes and returns a map item object using the specified placemark object.
    //     var placemark: MKPlacemark { get }
    
    // MARK: - Methods
    
    func choosetheGoldRoute() -> ShepSingleAnnotation {
        var myAnnotationsArray = shepDataModel.theMASTERAnnotationsArray
        print ("in model choosetheGoldRoute(), myAnnotationsArray.count is: \(myAnnotationsArray.count)")
        print ("this is before sort")
        myAnnotationsArray = myAnnotationsArray.sorted {($0.routeProfit) > ($1.routeProfit) }
        print ("this is after sort \n")
        
        var fakeIndexNumber : Int = 0
        goldRouteFinder: for eachAnnotation in myAnnotationsArray {
            print ("In model, chooseGoldRoute FOR LOOP ---- SORTED")
            print ("myFakeIndexlikeNumber is \(fakeIndexNumber)")
            fakeIndexNumber = fakeIndexNumber + 1
            let myTitle = eachAnnotation.title
            print ("       --------------\n myTitle            \(String(describing: myTitle!))")
            //let mySubTitle = myAnnotation.subtitle
            //print ("mySubTitle          \(String(describing: mySubTitle!))")
            let myDrivingDistance = eachAnnotation.routeDrivingDistance
            let routeExpense : Double = myDrivingDistance * Double(shepDataModel.centsPerMileExpense)/100
            print ("routeExpense is     \(shepCurrencyFromDouble(shepNumber: routeExpense))")
            let mytheGoldRouteScore = eachAnnotation.routeProfit
            let myFormattedtheGoldRouteScore = (shepCurrencyFromDouble(shepNumber: mytheGoldRouteScore))
            print ("-mytheGoldRouteScore \(myFormattedtheGoldRouteScore) ---  \(myFormattedtheGoldRouteScore) \n        --------------")
            print ("crowFliesDistance: \(String(format: "%.02f", eachAnnotation.crowFliesDistance)) miles")
           
            print ("DrivingDistance is: \(String(format: "%.02f", myDrivingDistance)) miles")
            let myDrivingTime = eachAnnotation.drivingTime
            let lineBreak = "\n-------------------------------------------------------------------------"
            print ("drivingTime is:    \(String(format: "%.02f", myDrivingTime)) minutes \(lineBreak)")
            
        }  //  choosetheChosenRoute()  LOOP
        print ("in Model fromTheFinalCompletionHandler : END OF choosetheGoldRoute()")
        print ("end of choosetheGoldRoute(), myAnnotationsArray.count is: \(myAnnotationsArray.count)")
       return myAnnotationsArray[0]
    }

    func getRouteInfoFromAppleVia2Annotations (source: ShepSingleAnnotation, destination: ShepSingleAnnotation) -> () {
        let sourceAnnotation = MKPointAnnotation()
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.coordinate = CLLocationCoordinate2DMake(destination.coordinate.latitude, destination.coordinate.longitude)
        let destinationLocation = CLLocation(latitude: destinationAnnotation.coordinate.latitude, longitude: destinationAnnotation.coordinate.longitude)
        sourceAnnotation.coordinate = CLLocationCoordinate2DMake(source.coordinate.latitude, source.coordinate.longitude)
        let sourceLocation = CLLocation(latitude: sourceAnnotation.coordinate.latitude, longitude: sourceAnnotation.coordinate.longitude)
        let sourceAnnotation_placemark = MKPlacemark(coordinate: CLLocationCoordinate2DMake(sourceAnnotation.coordinate.latitude, sourceAnnotation.coordinate.longitude), addressDictionary: nil)
        let destinationAnnotation_placemark = MKPlacemark(coordinate: CLLocationCoordinate2DMake(destinationAnnotation.coordinate.latitude, destinationAnnotation.coordinate.longitude), addressDictionary: nil)

        let directionsRequest = MKDirectionsRequest()
        directionsRequest.source = MKMapItem(placemark: sourceAnnotation_placemark)
        directionsRequest.destination = MKMapItem(placemark: destinationAnnotation_placemark)
        directionsRequest.transportType = shepDataModel.currentTransportType
        //  Set the transportation type to .Automobile for this particular scenario. (.Walking and .Any are also valid MKDirectionsTransportTypes.)
        //  Set requestsAlternateRoutes to true to fetch all the reasonable routes from the source to destination.
        let directions = MKDirections(request: directionsRequest)

        directions.calculate(completionHandler: {(response, error) in
//            // response has an array of MKRoutes
//            if error != nil {
//                print ("Directions Retreival Error: \(String(describing: error))")
//            } else {
//                //self.myMapView.removeOverlays(self.myMapView.overlays)
//                self.currentLinkedRoute = response!.routes[0] as MKRoute
//                let sourceLocation = CLLocation(latitude: sourceAnnotation.coordinate.latitude, longitude: sourceAnnotation.coordinate.longitude)
//                let destinationLocation = CLLocation(latitude: destinationAnnotation.coordinate.latitude, longitude: destinationAnnotation.coordinate.longitude)
//                self.crowFliesDistance = sourceLocation.distance(from: destinationLocation) // result is in meters
//                self.crowFliesDistance = meters2miles(meters: self.crowFliesDistance)
            
            // response has an array of MKRoutes
            if error != nil {
                print ("Directions Retreival Error: \(String(describing: error))")
            } else {
                //self.myMapView.removeOverlays(self.myMapView.overlays)
                //self.currentRoute = response!.routes[0] as MKRoute
                shepDataModel.howManyRouteInfosCompleted = shepDataModel.howManyRouteInfosCompleted + 1
                //let myRoute = self.currentRoute
                let myRoute = response!.routes[0] as MKRoute
                print ("INSIDE getRouteInfoFromAppleViaLocation COMPLETION HANDLER")
                print ("this is myRoute: \(String(describing: myRoute))")
                
                //destinationAnnotation.currentLinkedRoute = myRoute
                
                shepDataModel.crowFliesDistance = sourceLocation.distance(from: destinationLocation) // result is in meters
                shepDataModel.crowFliesDistance = meters2miles(meters: shepDataModel.crowFliesDistance)
                let myCount = shepDataModel.theMASTERAnnotationsArray.index(of: destination)! + 1
                print ("Array.index + 1 =       \(String(describing: myCount))")
                print ("howManyRouteInfosCompleted: \(String(describing: shepDataModel.howManyRouteInfosCompleted))")
                let theIndex = shepDataModel.theMASTERAnnotationsArray.index(of: destination)!
                let myAnnotation = shepDataModel.theMASTERAnnotationsArray[theIndex]
                myAnnotation.currentLinkedRoute = myRoute
                myAnnotation.crowFliesDistance = shepDataModel.crowFliesDistance
                let myDrivingDistance = myAnnotation.routeDrivingDistance
                let myTitle = myAnnotation.title
                print ("       --------------\n myTitle            \(String(describing: myTitle!))")
                //let mySubTitle = myAnnotation.subtitle
                //print ("mySubTitle          \(String(describing: mySubTitle!))")
                let routeExpense : Double = myDrivingDistance * Double(shepDataModel.centsPerMileExpense)/100
                print ("routeExpense is     \(self.shepCurrencyFromDouble(shepNumber: routeExpense))")
                let myGoldRouteScore = myAnnotation.routeProfit
                print ("-mytheGoldRouteScore \(self.shepCurrencyFromDouble(shepNumber: myGoldRouteScore))\n        --------------")
                print ("crowFliesDistance: \(String(format: "%.02f", myAnnotation.crowFliesDistance)) miles")
                //let myDrivingDistance = myAnnotation.routeDrivingDistance
                print ("DrivingDistance is: \(String(format: "%.02f", myDrivingDistance)) miles")
                let myDrivingTime = myAnnotation.drivingTime
                let lineBreak = "\n-------------------------------------------------------------------------"
                print ("drivingTime is:    \(String(format: "%.02f", myDrivingTime)) minutes \(lineBreak)")
                //                let mytheChosenRouteScore = myAnnotation.goldRouteScore
                //                print ("mytheChosenRouteScore \(shepCurrencyFromDouble(shepNumber: mytheChosenRouteScore)) \n")
                
                //IF ALL THE ROUTES REQUESTED FROM APPLE HAVE BEEN RECEIVED
                if self.validSearchResultsArray.count <= shepDataModel.howManyRouteInfosCompleted {
                    print("\n ALL THE ROUTES REQUESTED FROM APPLE HAVE BEEN RECEIVED \n")
                    shepDataModel.howManyRouteInfosCompleted = 0
                }
                
                if shepDataModel.whichRouteStyle == "route" {
                    shepDataModel.currentRoute = myRoute
                    self.myDataModelMapScreenDelegate?.drawNewRoute(thisRoute: myRoute)
                }
                
                // THIS IS THE END OF getRouteInfoVia2Annotations COMPLETION HANDLER
               // self.delegate?.drawNewRoute(thisRoute: self.currentLinkedRoute!)
            }
        })
    }
    
    func buildMASTERAnnotationsArrayViaAppleLocalSearch(searchString:String) {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchString
        validSearchResultsArray = [ShepSingleAnnotation]()
        /////////  CONVERSION FROM COORDINATES INTO MKMAPITEM
        let homeLocationCoord = shepDataModel.myUserLocation.coordinate
        let homeLocationPlacemark = MKPlacemark(coordinate: CLLocationCoordinate2DMake(homeLocationCoord.latitude, homeLocationCoord.longitude), addressDictionary: nil)
        let homeLocationMapItem = MKMapItem(placemark: homeLocationPlacemark)
        /////////  THEN MAKE ANNOTATION FROM MKMAPITEM
        let homeLocationAnnotation = ShepSingleAnnotation(myMapItem: homeLocationMapItem, currentLinkedRoute: MKRoute(), shepDollarValue: 0.0, myGigSource: myGigSource!)
        
        // 搜索当前区域
        // print ("in performLocalSearch searchRegion search distance: \(meters2miles(meters: self.currentSearchDistanceX))")
        let searchRegion1 = MKCoordinateRegionMakeWithDistance(shepDataModel.myUserLocation.coordinate, shepDataModel.currentSearchDistance, shepDataModel.currentSearchDistance)
        request.region = searchRegion1
        //request.region = myMapView.region
        // a MKLocalSearch object initiates a search operation and will deliver the results back into an array of MKMapItems. This will contain the name, latitude and longitude of the current POI.
        print ("before search.start theMASTERAnnotationsArray count: \(shepDataModel.theMASTERAnnotationsArray.count)")
        // 启动搜索,并且把返回结果保存到数组中
        let search = MKLocalSearch(request: request)
        
        search.start(completionHandler: {(response, error) in
            //let myViewController = ViewController()
            //var validSearchResultsArray: [ShepSingleAnnotation] = []
            print ("search.start completionHandler, theMASTERAnnotationsArray count: \(shepDataModel.theMASTERAnnotationsArray.count)")
            // Local searches are performed asynchronously
            //and a completion handler called when the search is complete.

            
            if error != nil {
                print("Error occured in search: \(error!.localizedDescription)")
            } else if response!.mapItems.count == 0 {
                print("No matches found")
            } else {
                print("search completionHandler   \(response!.mapItems.count) matches found \n ")
                //The code in the completion handler checks the response to make sure that matches were found
                //and then accesses the mapItems property of the response which contains an array of mapItem instances for the matching locations.
                shepSearchResultLoop: for item in response!.mapItems {
                    let searchResultCoordinates = item.placemark.coordinate
                    let searchResultLocation = CLLocation(latitude: searchResultCoordinates.latitude, longitude: searchResultCoordinates.longitude)
                    // a source locations are userLocation, currently Thompson
                    let sourceLocation = shepDataModel.myUserLocation
                    let mapItemDistance = sourceLocation.distance(from: searchResultLocation) // result is in meters
                    //let distanceInMiles = meters2miles(meters: mapItemDistance)
                    print ("Current search distance: \(meters2miles(meters: shepDataModel.currentSearchDistance)) and this distance: \(meters2miles(meters: mapItemDistance))")
                    print ("Early in shepSearchResultLoop, howManySearchItemsFound = \(shepDataModel.howManySearchItemsFound)")
                    if shepDataModel.howManySearchItemsFound > 4 {
                        print ("more than 4 found items in this search \n")
                        shepDataModel.howManySearchItemsFound += 1
                        continue shepSearchResultLoop
                    }
                    if mapItemDistance > shepDataModel.currentSearchDistance {  // if SearchResult is further away than currentSearchDistanceX
                        print ("took one down, too far away")
                        continue shepSearchResultLoop
                    } else {
                        shepDataModel.howManySearchItemsFound += 1
                        let shepDollarValue = Double(arc4random_uniform(100) + 1)
                        let validResult = ShepSingleAnnotation(myMapItem: item, currentLinkedRoute: MKRoute(), shepDollarValue: shepDollarValue, myGigSource: myGigSource!)
                        self.validSearchResultsArray.append(validResult)
                        print ("We just found a valid search result, validSearchResultsArray.count = \(self.validSearchResultsArray.count)")
                        //print ("We just found a valid search result, now calling getRouteInfoVia2Annotations")
                        self.getRouteInfoFromAppleVia2Annotations(source: homeLocationAnnotation, destination: validResult)
                        //self.getRouteInfoFromAppleViaLocation(sourceLocation: sourceLocation, destinationAnnotation: validResult)
                    }
                    print ("still inside shepSearchResultLoop, theMASTERAnnotationsArray count is \(shepDataModel.theMASTERAnnotationsArray.count)")
                    print ("still inside shepSearchResultLoop validSearchResultsArray count: \(self.validSearchResultsArray.count) \n")
                }
                
                shepDataModel.howManySearchItemsFound = 0
                shepDataModel.theMASTERAnnotationsArray.append(contentsOf: self.validSearchResultsArray)
                print ("shepSearchResultLoop is done now, theMASTERAnnotationsArray count is \(shepDataModel.theMASTERAnnotationsArray.count)")
                print ("shepSearchResultLoop is done now, validSearchResultsArray count is \(self.validSearchResultsArray.count) \n")
                self.myDataModelMapScreenDelegate?.showValidSearchResults(validSearchResults: self.validSearchResultsArray)
                if self.validSearchResultsArray.count > 0 {
                    shepDataModel.MASTERAnnotationsArrayUpdated = true
                    self.validSearchResultsArray.removeAll()
                }
            }
        })
        print ("OPENING GAMBIT, theMASTERAnnotationsArray count is \(shepDataModel.theMASTERAnnotationsArray.count) \n")
    }
    
    // MARK = utility methods
    func shepCurrencyFromDouble(shepNumber : Double) -> String  {
        let buckaroos = shepNumber as NSNumber
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        // formatter.locale = NSLocale.currentLocale() // This is the default
        return formatter.string(from: buckaroos)!
    }
}


//Part 1. CALLBACK AS COMPLETION HANDLER
///////////////////////////////////////////////////
//This way is very easy to setup. First, we create a requestData method that takes completion (a block):

//Completion here is a method, that takes a String as a data and has a Void return type.
//Inside requestData, we run the code to request the data from any source:

//All we need to do now is to call completion with the data we have just received:
//    class DataModel {
//        func performDataRequest(completion: ((_ shepdata: String) -> Void)) {
//            // the data was received and parsed to String
//            let myDataRequestData = "xyData from wherever"
//            let myotherDataReqData = "second " + myDataRequestData
//            completion(myotherDataReqData)
//        }
//    }

//The next step is to create an instance of DataModel in ViewController class and call requestData method. In completion, we call a private method useData:
//class ViewController: UIViewController {  //UIViewController {
//let dataModel = DataModel()
//dataModel.performDataRequest { [weak self] (data: String) in self?.useData(data: data)
    
