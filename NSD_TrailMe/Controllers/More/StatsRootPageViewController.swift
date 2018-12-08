//
//  StatsRootPageViewController.swift
//  TrailMe
//
//  Created by Nathaniel Coleman on 11/8/18.
//  Copyright © 2018 November 7th design. All rights reserved.
//

import UIKit

class StatsRootPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    lazy var viewControllersList: [UIViewController] = {
        let storyBoard = UIStoryboard(name: "Statistic", bundle: nil)
        let walkVC = storyBoard.instantiateViewController(withIdentifier: "WalkViewController")
        let runVC = storyBoard.instantiateViewController(withIdentifier: "RunViewController")
        let cycleVC = storyBoard.instantiateViewController(withIdentifier: "CycleViewController")
        return[walkVC, runVC, cycleVC]
    }()

    var pageControl = UIPageControl()


    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        self.dataSource = self
        if let firstVC = viewControllersList.first {
            self.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        setupPageControl()
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentVC = pageViewController.viewControllers![0]
        self.pageControl.currentPage = viewControllersList.index(of: pageContentVC)!
    }

    func setupPageControl() {
        pageControl = UIPageControl(frame: CGRect(x: 0.0, y: UIScreen.main.bounds.maxY - 50.0, width: UIScreen.main.bounds.width, height: 50.0))
        pageControl.numberOfPages = viewControllersList.count
        pageControl.currentPage = 0
        pageControl.tintColor = .black
        pageControl.pageIndicatorTintColor = mainColor
        pageControl.currentPageIndicatorTintColor = .black
        view.addSubview(pageControl)


    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let viewControllerIndex = viewControllersList.index(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else { return nil }
        guard viewControllersList.count > previousIndex else { return nil}

        return viewControllersList[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = viewControllersList.index(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        guard viewControllersList.count != nextIndex else { return nil }
        guard viewControllersList.count > nextIndex else { return nil }

        return viewControllersList[nextIndex]
    }
}
