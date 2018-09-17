//
//  MainTabController.swift
//  tabcontroller_tutorial
//

import Foundation
import UIKit

class MainTabController : UITabBarController, UITabBarControllerDelegate {
    
static var transitionDirectionLeft: Bool = false
    
//    let myDropDownBounceTransitionAnimControl = dropDownBounce_AnimTrnsition()
//    let myShrinkDownTransitionAnimControl = shrinkDown_AnimTransition()
//    let myCrossFade_AnimTransition = CrossFade_AnimTransition()
//    let myCircularTransition = CircularTransition()
//    let mySlideDownFromCorner_AnimTransition = SlideDownFromCorner_AnimTransition()
    let myInverseRotatingCUBE_AnimTransition = inverseRotatingCUBE_AnimTransition()
    let myUpFromBottom_AnimTrnsition = upFromBottom_AnimTrnsition()
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let fromVCIndex = tabBarController.childViewControllers.index(of: fromVC)!
        let toVCIndex = tabBarController.childViewControllers.index(of: toVC)!
        
        if fromVCIndex == 3 { // if coming from Debug screen, transition LEFT, exit
            MainTabController.transitionDirectionLeft = true
            return myInverseRotatingCUBE_AnimTransition
        }
        
        if toVCIndex == 0 { // to MAPSCREEN
            MainTabController.transitionDirectionLeft = true
        } else if toVCIndex == 1 { // to TableView
            if fromVCIndex == 0 { // test where transition coming FROM
                MainTabController.transitionDirectionLeft = false
            } else { // from either Charts or Debug ViewController
                MainTabController.transitionDirectionLeft = true
            }
        } else if toVCIndex == 2 { // to Charts
            MainTabController.transitionDirectionLeft = false
        } else if toVCIndex == 3 { // to DEBUG screen
            return myUpFromBottom_AnimTrnsition
//            let mySearchRadiusViewController: searchRadiusViewController = segue.destination as! searchRadiusViewController
//            mySearchRadiusViewController.mySearchDistanceSliderDelegate = self
        }
        
        //return myOtherSlideDownFromCorner_AnimTransition
        //return mySlideDownFromCorner_AnimTransition
        //return myCircularTransition
        //return myDropDownBounceTransitionAnimControl
        //return myShrinkDownTransitionAnimControl
        return myInverseRotatingCUBE_AnimTransition
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print ("MainTabController viewDidLoad")
        self.delegate = self
        // Do any additional setup after loading the view.
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        print ("MainTabController ViewWillAppear \n")
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

