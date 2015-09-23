//
//  MessageDelegate.swift
//  Xmpp
//
//  Created by djg on 14-7-16.
//  Copyright (c) 2014年 djg All rights reserved.
//

import Foundation

struct Message{
    var subject:String
    var content:String
    var sender:String
    var ctime:String
}

protocol MessageDelegate{
    func newMessageReceived(msg:Message)
}