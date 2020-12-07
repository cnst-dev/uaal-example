//
//  MainViewController.swift
//  NativeiOSApp
//
//  Created by Konstantin Khokhlov on 07.12.2020.
//  Copyright © 2020 unity. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    private var colorButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        UnityManager.showUnity()

        colorButton = UIButton(type: .system)
        colorButton.setTitle("Red", for: .normal)
        colorButton.frame = CGRect(x: 0, y: 0, width: 100, height: 44)
        colorButton.center = CGPoint(x: 50, y: 120)
        colorButton.backgroundColor = .red
        colorButton.addTarget(self, action: #selector(changeColorInUnity), for: .touchUpInside)

        let unityView = UnityManager.getUnityView()
        unityView?.addSubview(colorButton)
    }

    @objc func changeColorInUnity() {
        UnityManager.sendUnityMessage("Cube", methodName: "ChangeColor", message: "red")
    }
}
