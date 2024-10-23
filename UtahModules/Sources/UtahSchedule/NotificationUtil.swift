//
//  NotificationUtil.swift
//
//  Various helper functions for creating, deleting, and managing local notifications
//
//  Created by Jonah Brooks on 10/23/24.
//

import Foundation
import UserNotifications

public enum NotificationUtil {
    
    public static var sixMinuteWalkTestIdentifiedRoot = "edu.utah.ustep.SixMinuteWalkTestNotification"
    public static var assessmentBundleIdentifiedRoot = "edu.utah.ustep.AssessmentBundleNotification"
    public static var daysUntilFirstSixMinuteWalkTestReminder = 30 // Number of days after a module is completed before reminders start
    public static var daysUntilFirstAssessmentBundleReminder = 30
    public static var hourOfSixMinuteWalkTestReminders = 13 // Send reminders at 1pm each day
    public static var minuteOfSixMinuteWalkTestReminders = 0
    public static var secondOfSixMinuteWalkTestReminders = 0
    public static var hourOfAssessmentBundleReminders = 13 // Send reminders at 1pm each day
    public static var minuteOfAssessmentBundleReminders = 0
    public static var secondOfAssessmentBundleReminders = 10
    // Note that the following 5 lines cannot add up to more than 63 (since one of the 64 is taken by login reminders)
    public static var numberOfDailySixMinuteWalkTestReminders = 14
    public static var numberOfWeeklySixMinuteWalkTestReminders = 16
    public static var numberOfDailyAssessmentBundleReminders = 14
    public static var numberOfWeeklyAssessmentBundleReminders = 16
    public static var sixMinuteWalkTestReminderTitle = "U-STEP Six Minute Walk Test"
    public static var sixMinuteWalkTestReminderSubtitle = "Don't forget! Your U-STEP monthly Six Minute Walk Test is waiting!"
    public static var assessmentBundleReminderTitle = "U-STEP Monthly Survey Bundle"
    public static var assessmentBundleReminderSubtitle = "Don't forget! Your U-STEP monthly survey bundle is waiting! Your feedback matters!"
    
    public static func GetDelayedMauallyRepeatingNotificationIdentifiers(
        repetitions: Int,
        nameRoot: String
    ) -> [String] {
        var identifiers: [String] = []
        for repetition in 0..<repetitions {
            identifiers.append(nameRoot + String(repetition))
        }
        return identifiers
    }
    
    public static func SetDelayedManuallyRepeatingNotifications(
        start: Date,
        intervalInSeconds: Int,
        repetitions: Int,
        title: String,
        subtitle: String,
        nameRoot: String
    ) async {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()
        
        guard (settings.authorizationStatus == .authorized) ||
                (settings.authorizationStatus == .provisional) else { return }
        
        // Configure notification content
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.sound = UNNotificationSound.default
        
        var notificationDate = start
        let calendar = Calendar.current
        let identifiers = GetDelayedMauallyRepeatingNotificationIdentifiers(repetitions: repetitions, nameRoot: nameRoot)
        for identifier in identifiers {
            // Set the trigger to the right day and time
            let notificationDateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: notificationDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: notificationDateComponents, repeats: false)
            
            // Create the notification request
            let request = UNNotificationRequest(
                identifier: identifier,
                content: content,
                trigger: trigger
            )
            
            // Add the notification
            do {
                try await center.add(request)
            } catch {
                print("Failed to add request " + identifier)
            }
            
            // Prepare for next loop by incrementing notificationDate by interval
            notificationDate = notificationDate.addingTimeInterval(TimeInterval(intervalInSeconds))
        }
    }
    
    public static func RemoveDelayedManuallyRepeatingNotifications(
        repetitions: Int,
        nameRoot: String
    ) {
        let center = UNUserNotificationCenter.current()
        let identifiers = GetDelayedMauallyRepeatingNotificationIdentifiers(repetitions: repetitions, nameRoot: nameRoot)
        center.removePendingNotificationRequests(withIdentifiers: identifiers)
        center.removeDeliveredNotifications(withIdentifiers: identifiers)
    }
    
    public static func SetSixMinuteWalkTestNotifications() async {
        // Setup the daily reminder notifications
        let dailyReminderStartDate = Calendar.current.date(byAdding: .day, value: daysUntilFirstSixMinuteWalkTestReminder, to: Date())!
        var dailyReminderDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: dailyReminderStartDate)
        dailyReminderDateComponents.hour = hourOfSixMinuteWalkTestReminders
        dailyReminderDateComponents.minute = minuteOfSixMinuteWalkTestReminders
        dailyReminderDateComponents.second = secondOfSixMinuteWalkTestReminders
        
        let dailyNameRoot = sixMinuteWalkTestIdentifiedRoot+String("Daily")
        let secondsInDay = 60*60*24
        RemoveDelayedManuallyRepeatingNotifications(
            repetitions: numberOfDailySixMinuteWalkTestReminders,
            nameRoot: dailyNameRoot
        )
        await SetDelayedManuallyRepeatingNotifications(
            start: Calendar.current.date(from: dailyReminderDateComponents)!,
            intervalInSeconds: secondsInDay,
            repetitions: numberOfDailySixMinuteWalkTestReminders,
            title: sixMinuteWalkTestReminderTitle,
            subtitle: sixMinuteWalkTestReminderSubtitle,
            nameRoot: dailyNameRoot
        )
        
        // Setup the weekly reminder notifications
        let weeklyReminderStartDate = Calendar.current.date(byAdding: .day, value: daysUntilFirstSixMinuteWalkTestReminder+numberOfDailySixMinuteWalkTestReminders, to: Date())!
        var weeklyReminderDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: weeklyReminderStartDate)
        weeklyReminderDateComponents.hour = hourOfSixMinuteWalkTestReminders
        weeklyReminderDateComponents.minute = minuteOfSixMinuteWalkTestReminders
        weeklyReminderDateComponents.second = secondOfSixMinuteWalkTestReminders
        
        let weeklyNameRoot = sixMinuteWalkTestIdentifiedRoot+String("Weekly")
        let secondsInWeek = secondsInDay*7
        RemoveDelayedManuallyRepeatingNotifications(
            repetitions: numberOfWeeklySixMinuteWalkTestReminders,
            nameRoot: weeklyNameRoot
        )
        await SetDelayedManuallyRepeatingNotifications(
            start: Calendar.current.date(from: weeklyReminderDateComponents)!,
            intervalInSeconds: secondsInWeek,
            repetitions: numberOfWeeklySixMinuteWalkTestReminders,
            title: sixMinuteWalkTestReminderTitle,
            subtitle: sixMinuteWalkTestReminderSubtitle,
            nameRoot: weeklyNameRoot
        )
    }
    
    public static func SetAssessmentBundleNotifications() async {
        // Setup the daily reminder notifications
        let dailyReminderStartDate = Calendar.current.date(byAdding: .day, value: daysUntilFirstAssessmentBundleReminder, to: Date())!
        var dailyReminderDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: dailyReminderStartDate)
        dailyReminderDateComponents.hour = hourOfAssessmentBundleReminders
        dailyReminderDateComponents.minute = minuteOfAssessmentBundleReminders
        dailyReminderDateComponents.second = secondOfAssessmentBundleReminders
        
        let dailyNameRoot = assessmentBundleIdentifiedRoot+String("Daily")
        let secondsInDay = 60*60*24
        RemoveDelayedManuallyRepeatingNotifications(
            repetitions: numberOfDailyAssessmentBundleReminders,
            nameRoot: dailyNameRoot
        )
        await SetDelayedManuallyRepeatingNotifications(
            start: Calendar.current.date(from: dailyReminderDateComponents)!,
            intervalInSeconds: secondsInDay,
            repetitions: numberOfDailyAssessmentBundleReminders,
            title: assessmentBundleReminderTitle,
            subtitle: assessmentBundleReminderSubtitle,
            nameRoot: dailyNameRoot
        )
        
        // Setup the weekly reminder notifications
        let weeklyReminderStartDate = Calendar.current.date(byAdding: .day, value: daysUntilFirstAssessmentBundleReminder+numberOfDailyAssessmentBundleReminders, to: Date())!
        var weeklyReminderDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: weeklyReminderStartDate)
        weeklyReminderDateComponents.hour = hourOfAssessmentBundleReminders
        weeklyReminderDateComponents.minute = minuteOfAssessmentBundleReminders
        weeklyReminderDateComponents.second = secondOfAssessmentBundleReminders
        
        let weeklyNameRoot = assessmentBundleIdentifiedRoot+String("Weekly")
        let secondsInWeek = secondsInDay*7
        RemoveDelayedManuallyRepeatingNotifications(
            repetitions: numberOfWeeklyAssessmentBundleReminders,
            nameRoot: weeklyNameRoot
        )
        await SetDelayedManuallyRepeatingNotifications(
            start: Calendar.current.date(from: weeklyReminderDateComponents)!,
            intervalInSeconds: secondsInWeek,
            repetitions: numberOfWeeklyAssessmentBundleReminders,
            title: assessmentBundleReminderTitle,
            subtitle: assessmentBundleReminderSubtitle,
            nameRoot: weeklyNameRoot
        )
    }
    
    public static func TestSetAssessmentBundleNotifications() async {
        // Setup the daily reminder notifications
        let dailyReminderStartDate = Calendar.current.date(byAdding: .second, value: 120, to: Date())!
        let dailyReminderDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dailyReminderStartDate)
        
        let dailyNameRoot = assessmentBundleIdentifiedRoot+String("Daily")
        let secondsInDay = 10
        RemoveDelayedManuallyRepeatingNotifications(
            repetitions: numberOfDailyAssessmentBundleReminders,
            nameRoot: dailyNameRoot
        )
        await SetDelayedManuallyRepeatingNotifications(
            start: Calendar.current.date(from: dailyReminderDateComponents)!,
            intervalInSeconds: secondsInDay,
            repetitions: numberOfDailyAssessmentBundleReminders,
            title: assessmentBundleReminderTitle,
            subtitle: assessmentBundleReminderSubtitle,
            nameRoot: dailyNameRoot
        )
        
        // Setup the weekly reminder notifications
        let weeklyReminderStartDate = Calendar.current.date(byAdding: .second, value: 120+(secondsInDay*numberOfDailyAssessmentBundleReminders), to: Date())!
        let weeklyReminderDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: weeklyReminderStartDate)
        
        let weeklyNameRoot = assessmentBundleIdentifiedRoot+String("Weekly")
        let secondsInWeek = secondsInDay*7
        RemoveDelayedManuallyRepeatingNotifications(
            repetitions: numberOfWeeklyAssessmentBundleReminders,
            nameRoot: weeklyNameRoot
        )
        await SetDelayedManuallyRepeatingNotifications(
            start: Calendar.current.date(from: weeklyReminderDateComponents)!,
            intervalInSeconds: secondsInWeek,
            repetitions: numberOfWeeklyAssessmentBundleReminders,
            title: assessmentBundleReminderTitle,
            subtitle: assessmentBundleReminderSubtitle,
            nameRoot: weeklyNameRoot
        )
    }
}
