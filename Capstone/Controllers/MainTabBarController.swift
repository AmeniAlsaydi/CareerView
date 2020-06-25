//
//  MainTabBarController.swift
//  Capstone
//
//  Created by Amy Alsaydi on 5/27/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController, UIAdaptivePresentationControllerDelegate {

   
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
       let navController = UINavigationController(rootViewController: ProfileViewController(nibName: "ProfileViewControllerXib", bundle: nil))
        
      navController.tabBarItem = UITabBarItem(title: "Profile",
                                               image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
           return navController
    }()
    
    private var userData: User?
    
    private var defaultIndex: Int = 0
    private func loadDefaultLaunchScreen() {
        let defaultLaunchScreen = UserPreference.shared.getDefaultLaunchScreen()
        switch defaultLaunchScreen {
        case .jobHistory:
            defaultIndex = 0
        case .starStories:
            defaultIndex = 1
        case .interviewQuestions:
            defaultIndex = 2
        case .applicationTracker:
            defaultIndex = 3
        default:
            defaultIndex = 0
        }
    }
    override func viewDidLoad() {
           super.viewDidLoad()
        
        self.tabBar.tintColor = AppColors.primaryBlackColor
           viewControllers = [jobHistoryController, applicationTrackerController, starSituationController, interviewQuestionsController, settingsController]
        loadDefaultLaunchScreen()
        selectedIndex = defaultIndex
        getUserData()
    }
    private func getUserData() {
           DatabaseService.shared.fetchUserData { [weak self] (result) in
               switch result {
               case .failure(let error):
                   DispatchQueue.main.async {
                       print("Error fetching user Data: \(error.localizedDescription)")
                   }
               case .success(let userData):
                   DispatchQueue.main.async {
                       self?.userData = userData
                       self?.checkFirstTimeLogin()
                   }
               }
           }
       }
    private func checkFirstTimeLogin() {
        guard let user = userData else { return }
        if user.firstTimeLogin {
            let welcomeScreenViewController = WelcomeScreenViewController(nibName: "WelcomeScreenXib", bundle: nil)
            present(welcomeScreenViewController, animated: true, completion: nil)
        }
    }
}
