//
//  UnityManager.swift
//  NativeiOSApp
//
//  Created by Konstantin Khokhlov on 07.12.2020.
//  Copyright © 2020 unity. All rights reserved.
//

import Foundation
import UnityFramework

class UnityManager: UIResponder, UIApplicationDelegate, UnityFrameworkListener, NativeCallsProtocol {

    private struct UnityMessage {
        let objectName : String?
        let methodName : String?
        let messageBody : String?
    }

    private static var instance : UnityManager!
    private var ufw : UnityFramework!
    private static var hostMainWindow : UIWindow! // Window to return to when exiting Unity window
    private static var launchOpts : [UIApplication.LaunchOptionsKey: Any]?

    private static var cachedMessages = [UnityMessage]()

    // MARK: - Static functions (that can be called from other scripts)

    static func getUnityRootViewController() -> UIViewController! {
        return instance.ufw.appController()?.rootViewController
    }

    static func getUnityView() -> UIView! {
        return instance.ufw.appController()?.rootView
    }

    static func setHostMainWindow(_ hostMainWindow : UIWindow?) {
        UnityManager.hostMainWindow = hostMainWindow
    }

    static func setLaunchinOptions(_ launchingOptions :  [UIApplication.LaunchOptionsKey: Any]?) {
        UnityManager.launchOpts = launchingOptions
    }

    static func showUnity() {
        if(UnityManager.instance == nil || UnityManager.instance.unityIsInitialized() == false) {
            UnityManager().initUnityWindow()
        }
        else {
            UnityManager.instance.showUnityWindow()
        }
    }

    static func hideUnity() {
        UnityManager.instance?.hideUnityWindow()
    }

    static func pauseUnity() {
        UnityManager.instance?.pauseUnityWindow()
    }

    static func unpauseUnity() {
        UnityManager.instance?.unpauseUnityWindow()
    }

    static func unloadUnity() {
        UnityManager.instance?.unloadUnityWindow()
    }

    static func sendUnityMessage(_ objectName : String, methodName : String, message : String) {
        let msg : UnityMessage = UnityMessage(objectName: objectName, methodName: methodName, messageBody: message)

        // Send the message right away if Unity is initialized, else cache it
        if(UnityManager.instance != nil && UnityManager.instance.unityIsInitialized()) {
            UnityManager.instance.ufw.sendMessageToGO(withName: msg.objectName, functionName: msg.methodName, message: msg.messageBody)
        }
        else {
            UnityManager.cachedMessages.append(msg)
        }
    }

    // MARK - Callback from UnityFrameworkListener
    func unityDidUnload(_ notification: Notification!) {
        ufw.unregisterFrameworkListener(self)
        ufw = nil
        UnityManager.hostMainWindow?.makeKeyAndVisible()
    }

    func showHostMainWindow(_ color: String!) {
        let alert = UIAlertController(title: "From Unity", message: "The cube is \(color ?? "blank")", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .cancel))
        UnityManager.getUnityRootViewController().present(alert, animated: true)
    }

    // MARK: - Private functions (called within the class)

    private func unityIsInitialized() -> Bool {
        return ufw != nil && (ufw.appController() != nil)
    }

    private func initUnityWindow() {
        if unityIsInitialized() {
            showUnityWindow()
            return
        }

        ufw = UnityFrameworkLoad()!
        ufw.setDataBundleId("com.unity3d.framework")
        ufw.register(self)
        NSClassFromString("FrameworkLibAPI")?.registerAPIforNativeCalls(self)

        ufw.runEmbedded(withArgc: CommandLine.argc, argv: CommandLine.unsafeArgv, appLaunchOpts: UnityManager.launchOpts)

        sendUnityMessageToGameObject()

        UnityManager.instance = self
    }

    private func showUnityWindow() {
        if unityIsInitialized() {
            ufw.showUnityWindow()
            sendUnityMessageToGameObject()
        }
    }

    private func hideUnityWindow() {
        if(UnityManager.hostMainWindow == nil) {
            print("WARNING: hostMainWindow is nil! Cannot switch from Unity window to previous window")
        }
        else {
            UnityManager.hostMainWindow?.makeKeyAndVisible()
        }
    }

    private func pauseUnityWindow() {
        ufw.pause(true)
    }

    private func unpauseUnityWindow() {
        ufw.pause(false)
    }

    private func unloadUnityWindow() {
        if unityIsInitialized() {
            UnityManager.cachedMessages.removeAll()
            ufw.unloadApplication()
        }
    }

    private func sendUnityMessageToGameObject() {
        if (UnityManager.cachedMessages.count >= 0 && unityIsInitialized())
        {
            for msg in UnityManager.cachedMessages {
                ufw.sendMessageToGO(withName: msg.objectName, functionName: msg.methodName, message: msg.messageBody)
            }

            UnityManager.cachedMessages.removeAll()
        }
    }

    private func UnityFrameworkLoad() -> UnityFramework? {
        let bundlePath: String = Bundle.main.bundlePath + "/Frameworks/UnityFramework.framework"

        let bundle = Bundle(path: bundlePath )
        if bundle?.isLoaded == false {
            bundle?.load()
        }

        let ufw = bundle?.principalClass?.getInstance()
        if ufw?.appController() == nil {
            // unity is not initialized
            //            ufw?.executeHeader = &mh_execute_header

            let machineHeader = UnsafeMutablePointer<MachHeader>.allocate(capacity: 1)
            machineHeader.pointee = _mh_execute_header

            ufw!.setExecuteHeader(machineHeader)
        }
        return ufw
    }
}
