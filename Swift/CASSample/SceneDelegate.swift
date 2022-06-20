//
//  SceneDelegate.swift
//  CASSample
//
//  Copyright © 2022 Clever Ads Solutions. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
    }
}
