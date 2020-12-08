//
//  MainViewController.swift
//  NativeiOSApp
//
//  Created by Konstantin Khokhlov on 07.12.2020.
//  Copyright © 2020 unity. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    // MARK: - Outlets
    private var colorButton: UIButton!
    private var rotateLeftButton: UIButton!
    private var rotateRightButton: UIButton!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        UnityManager.showUnity()

        guard let unityView = UnityManager.getUnityView() else { return }
        loadView(in: unityView)
    }

    // MARK: - Methods
    func loadView(in root: UIView) {
        colorButton = UIButton(type: .system)
        colorButton.setTitle("Red", for: .normal)
        colorButton.frame = CGRect(x: 10, y: 150, width: 100, height: 44)
        colorButton.backgroundColor = .red
        colorButton.addTarget(self, action: #selector(changeColorInUnity), for: .touchUpInside)
        root.addSubview(colorButton)

        rotateLeftButton = UIButton(type: .system)
        rotateLeftButton.setTitle("Rotate Left", for: .normal)
        rotateLeftButton.frame = CGRect(x: 10, y: 200, width: 100, height: 44)
        rotateLeftButton.backgroundColor = .green
        rotateLeftButton.addTarget(self, action: #selector(rotateLeftInUnity), for: .touchUpInside)
        root.addSubview(rotateLeftButton)

        rotateRightButton = UIButton(type: .system)
        rotateRightButton.setTitle("Rotate Right", for: .normal)
        rotateRightButton.frame = CGRect(x: 10, y: 250, width: 100, height: 44)
        rotateRightButton.backgroundColor = .yellow
        rotateRightButton.addTarget(self, action: #selector(rotateRightInUnity), for: .touchUpInside)
        root.addSubview(rotateRightButton)
    }

    // MARK: - Actions
    @objc private func changeColorInUnity() {
        UnityManager.sendUnityMessage("Cube", methodName: "ChangeColor", message: "red")
    }

    @objc private func rotateLeftInUnity() {
        UnityManager.sendUnityMessage("Cube", methodName: "RotateLeft", message: "")
    }

    @objc private func rotateRightInUnity() {
        UnityManager.sendUnityMessage("Cube", methodName: "RotateRight", message: "")
    }
}
