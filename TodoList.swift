//
//  TodoList.swift
//  LocalNotificationsTutorial
//
//  Created by Jason Newell on 2/3/15.
//
//

import Foundation
import UIKit

class TodoList {
    var badgeNumber:Int = 0
    class var sharedInstance : TodoList {
        struct Static {
            static let instance : TodoList = TodoList()
        }
        return Static.instance
    }
    
    private let ITEMS_KEY = "todoItems"
    
    func allItems() -> [TodoItem] {
        var todoDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey(ITEMS_KEY) ?? [:]
        let items = Array(todoDictionary.values)
        return items.map({TodoItem(deadline: $0["deadline"] as! NSDate, title: $0["title"] as! String, UUID: $0["UUID"] as! String!)}).sorted({(left: TodoItem, right:TodoItem) -> Bool in
            (left.deadline.compare(right.deadline) == .OrderedAscending)
        })
    }
    
    func addItem(item: TodoItem) {
        // persist a representation of this todo item in NSUserDefaults
        var todoDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey(ITEMS_KEY) ?? Dictionary() // if todoItems hasn't been set in user defaults, initialize todoDictionary to an empty dictionary using nil-coalescing operator (??)
        
        var keys = todoDictionary.keys.filter({$0 == item.UUID})
        if(keys.array.count > 0){
            return
        }
        todoDictionary[item.UUID] = ["deadline": item.deadline, "title": item.title, "UUID": item.UUID] // store NSData representation of todo item in dictionary with UUID as key
        NSUserDefaults.standardUserDefaults().setObject(todoDictionary, forKey: ITEMS_KEY) // save/overwrite todo item list
        
        // create a corresponding local notification
        var notification = UILocalNotification()
        notification.alertBody = item.title // text that will be displayed in the notification
        notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
        
        notification.fireDate = item.deadline  // todo item due date (when notification will be fired)
       // notification.fireDate =  NSDate(timeInterval: -600, sinceDate: item.deadline)
        
        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        notification.userInfo = ["title": item.title, "UUID": item.UUID] // assign a unique identifier to the notification so that we can retrieve it later
        notification.category = "TODO_CATEGORY"
        
        
        //同意接收通知，才提示本地消息通知
        if(UIApplication.sharedApplication().isRegisteredForRemoteNotifications()){
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        }
      
        self.SetBadgeByNumber(1)
    }
    
    func removeItem(item: TodoItem) {
        self.removeItemByID(item.UUID)
        self.SetBadgeByNumber(-1)
    }
    
    func removeItemByID(itemID: String) {
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications as! [UILocalNotification] { // loop through notifications...
            if (notification.userInfo!["UUID"] as! String == itemID) { // ...and cancel the notification that corresponds to this TodoItem instance (matched by UUID)
                UIApplication.sharedApplication().cancelLocalNotification(notification) // there should be a maximum of one match on UUID
                break
            }
        }
        
        if var todoItems = NSUserDefaults.standardUserDefaults().dictionaryForKey(ITEMS_KEY) {
            todoItems.removeValueForKey(itemID)
            NSUserDefaults.standardUserDefaults().setObject(todoItems, forKey: ITEMS_KEY) // save/overwrite todo item list
        }
        
      //  self.setBadgeNumbers()
        self.SetBadgeByNumber(-1)
    }
    
    func removeItemAll() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(ITEMS_KEY)
       
       //  self.setBadgeNumbers()
        self.SetBadgeNumber(0)
    }
    
    func scheduleReminderforItem(item: TodoItem) {
        var notification = UILocalNotification() // create a new reminder notification
        notification.alertBody = "Reminder: Todo Item \"\(item.title)\" Is Overdue" // text that will be displayed in the notification
        notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
        notification.fireDate = NSDate().dateByAddingTimeInterval(30 * 60) // 30 minutes from current time
        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        notification.userInfo = ["title": item.title, "UUID": item.UUID] // assign a unique identifier to the notification that we can use to retrieve it later
        notification.category = "TODO_CATEGORY"
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
//    func setBadgeNumbers() {
//        var notifications = UIApplication.sharedApplication().scheduledLocalNotifications as! [UILocalNotification] // all scheduled notifications
//        var todoItems: [TodoItem] = self.allItems()
//        var overdueItems = todoItems.filter({ (todoItem) -> Bool in
//            return todoItem.deadline.compare(NSDate()) != .OrderedDescending
//        })
//        UIApplication.sharedApplication().applicationIconBadgeNumber = overdueItems.count
//    }
    
    
    func SetBadgeByNumber(count:Int){
        self.badgeNumber = self.badgeNumber + count
        if self.badgeNumber >= 0 {
            UIApplication.sharedApplication().applicationIconBadgeNumber = self.badgeNumber
        }

    }
    
    
    func SetBadgeNumber(count:Int){
        self.badgeNumber =  count
        if self.badgeNumber >= 0 {
        UIApplication.sharedApplication().applicationIconBadgeNumber = self.badgeNumber
        }
    }
}