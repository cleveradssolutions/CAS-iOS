//
//  MainVC.swift
//  CASSample
//
//  Copyright © 2025 Clever Ads Solutions. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    weak var coordinator: AppCoordinator?
    private var formats: [FormatsSection] = FormatsSection.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Select Ad format"
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        //
        MainTVCell.registerForTableView(tableView)
    }
}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return formats.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTVCell.cellIdentifier, for: indexPath) as? MainTVCell else { return UITableViewCell() }
        cell.configureCell(formats[indexPath.row].title)
        return cell
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedItem = formats[indexPath.row]
        
        switch selectedItem {
        case .appOpen:
            coordinator?.navigateToAppOpenAd()
        case .banner:
            coordinator?.navigateToBannerAd()
        case .native:
            coordinator?.navigateToNativeAd()
        case .nativeTemplate:
            coordinator?.navigateToNativeTemplate()
        case .interstitial:
            coordinator?.navigateToInterstitialAd()
        case .rewarded:
            coordinator?.navigateToRewardedAd()
        }
    }
}
