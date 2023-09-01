//
//  FamilyControlModel.swift
//  ScreenTimeAPIDemo3
//
//  Created by Kei Fujikawa on 2023/08/11.
//

import Foundation
import FamilyControls
import DeviceActivity
import ManagedSettings

class FamilyControlModel: ObservableObject {
    static let shared = FamilyControlModel()
    private let store = ManagedSettingsStore()
    private let center = DeviceActivityCenter()

    private init() {}

    var selectionToDiscourage = FamilyActivitySelection() {
        willSet {
            print ("got here \(newValue)")
            
            let applications = newValue.applicationTokens
            let categories = newValue.categoryTokens
            
            print ("applications \(applications)")
            print ("categories \(categories)")
            
            store.shield.applications = applications.isEmpty ? nil : applications
            
            store.shield.applicationCategories = ShieldSettings
                .ActivityCategoryPolicy
                .specific(
                    categories
                )
            store.shield.webDomainCategories = ShieldSettings
                .ActivityCategoryPolicy
                .specific(
                    categories
                )
        }
    }
    
    func authorize() async throws {
        try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
    }

    func initiateMonitoring() {
        let schedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: 0, minute: 0),
            intervalEnd: DateComponents(hour: 23, minute: 59),
            repeats: true,
            warningTime: nil
        )
        
        do {
            try center.startMonitoring(.daily, during: schedule)
        } catch {
            print ("Could not start monitoring \(error)")
        }
        store.dateAndTime.requireAutomaticDateAndTime = true
        store.account.lockAccounts = true
        store.passcode.lockPasscode = true
        store.siri.denySiri = true
        store.appStore.denyInAppPurchases = true
        store.appStore.maximumRating = 200
        store.appStore.requirePasswordForPurchases = true
        store.media.denyExplicitContent = true
        store.gameCenter.denyMultiplayerGaming = true
        store.media.denyMusicService = false
    }
    
    func stopMonitoring() {
        center.stopMonitoring()
    }
    
    func encourageAll(){
        store.shield.applications = []
        store.shield.applicationCategories = ShieldSettings
            .ActivityCategoryPolicy
            .specific(
                []
            )
        store.shield.webDomainCategories = ShieldSettings
            .ActivityCategoryPolicy
            .specific(
                []
            )
    }

}

extension DeviceActivityName {
    static let daily = Self("daily")
}
