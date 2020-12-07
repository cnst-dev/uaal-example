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
    private var rotateLeftButton: UIButton!
    private var rotateRightButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        UnityManager.showUnity()
        let unityView = UnityManager.getUnityView()

        colorButton = UIButton(type: .system)
        colorButton.setTitle("Red", for: .normal)
        colorButton.frame = CGRect(x: 10, y: 150, width: 100, height: 44)
        colorButton.backgroundColor = .red
        colorButton.addTarget(self, action: #selector(changeColorInUnity), for: .touchUpInside)
        unityView?.addSubview(colorButton)

        rotateLeftButton = UIButton(type: .system)
        rotateLeftButton.setTitle("Rotate Left", for: .normal)
        rotateLeftButton.frame = CGRect(x: 10, y: 200, width: 100, height: 44)
        rotateLeftButton.backgroundColor = .green
        rotateLeftButton.addTarget(self, action: #selector(rotateLeftInUnity), for: .touchUpInside)
        unityView?.addSubview(rotateLeftButton)

        rotateRightButton = UIButton(type: .system)
        rotateRightButton.setTitle("Rotate Right", for: .normal)
        rotateRightButton.frame = CGRect(x: 10, y: 250, width: 100, height: 44)
        rotateRightButton.backgroundColor = .yellow
        rotateRightButton.addTarget(self, action: #selector(rotateRightInUnity), for: .touchUpInside)
        unityView?.addSubview(rotateRightButton)
    }

    @objc func changeColorInUnity() {
        UnityManager.sendUnityMessage("Cube", methodName: "ChangeColor", message: "red")
    }

    @objc func rotateLeftInUnity() {
        UnityManager.sendUnityMessage("Cube", methodName: "RotateLeft", message: "")
    }

    @objc func rotateRightInUnity() {
        UnityManager.sendUnityMessage("Cube", methodName: "RotateRight", message: "")
    }
}
