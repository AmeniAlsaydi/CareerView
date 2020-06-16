//
//  MainTabBarController.swift
//  Capstone
//
//  Created by Amy Alsaydi on 5/27/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

   
    private lazy var jobHistoryController: UINavigationController = {
       let navController = UINavigationController(rootViewController: JobHistoryController(nibName: "JobHistoryXib", bundle: nil)
        )
        
      navController.tabBarItem = UITabBarItem(title: "Job History",
                                               image: UIImage(systemName: "rectangle.grid.1x2"), selectedImage: UIImage(systemName: "rectangle.grid.1x2.fill"))
           return navController
    }()
    
    private lazy var starSituationController: UINavigationController = {
       let navController = UINavigationController(rootViewController: StarStoryMainController(nibName: "StarStoryMainXib", bundle: nil))
        
      navController.tabBarItem = UITabBarItem(title: "STARS",
                                               image: UIImage(systemName: "star"), selectedImage: UIImage(systemName: "star.fill"))
           return navController
    }()
    
    private lazy var interviewQuestionsController: UINavigationController = {
       let navController = UINavigationController(rootViewController: InterviewQuestionsMainController(nibName: "InterviewQuestionsMainXib", bundle: nil))
        
      navController.tabBarItem = UITabBarItem(title: "Interview",
                                               image: UIImage(systemName: "questionmark.square"), selectedImage: UIImage(systemName: "questionmark.square.fill"))
           return navController
    }()
    
    private lazy var applicationTrackerController: UINavigationController = {
       let navController = UINavigationController(rootViewController: ApplicationTrackerController(nibName: "ApplicationTrackerXib", bundle: nil))
        
      navController.tabBarItem = UITabBarItem(title: "Tracker",
                                               image: UIImage(systemName: "chart.bar"), selectedImage: UIImage(systemName: "chart.bar.fill"))
           return navController
    }()
    
    private lazy var settingsController: UINavigationController = {
       let navController = UINavigationController(rootViewController: SettingsController(nibName: "SettingsXib", bundle: nil))
        
      navController.tabBarItem = UITabBarItem(title: "Profile",
                                               image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
           return navController
    }()
    
    override func viewDidLoad() {
           super.viewDidLoad()
        self.tabBar.tintColor = AppColors.primaryBlackColor
           viewControllers = [jobHistoryController, starSituationController, interviewQuestionsController, applicationTrackerController, settingsController]
       }
       
}
