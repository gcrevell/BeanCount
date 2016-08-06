//
//  TagTypes.swift
//  BeanCount
//
//  Created by Voltmeter Amperage on 8/5/16.
//  Copyright © 2016 Gabriel Revells. All rights reserved.
//

import UIKit

enum StudentTags {
    case phoneNumber
    case studentClass
    case otherBook
    case otherLightbulb
    case otherFileCabinet
    case otherComputer
}

let tagsArray: [StudentTags] = [.phoneNumber,
                                .studentClass,
                                .otherBook,
                                .otherComputer,
                                .otherLightbulb,
                                .otherFileCabinet]

func getImage(of tag: StudentTags) -> UIImage {
    switch tag {
    case .phoneNumber:
        return UIImage(named: "phone.png")!
        
    case .studentClass:
        return UIImage(named: "desk.png")!
        
    case .otherBook:
        return UIImage(named: "open book.png")!
        
    case .otherLightbulb:
        return UIImage(named: "lightbulb.png")!
        
    case .otherFileCabinet:
        return UIImage(named: "file cabinet.png")!
        
    case .otherComputer:
        return UIImage(named: "computer.png")!
    }
}

func getTitle(of tag: StudentTags) -> String {
    switch tag {
    case .phoneNumber:
        return "Phone Number"
        
    case .studentClass:
        return "Class"
        
    case .otherBook:
        fallthrough
    case .otherLightbulb:
        fallthrough
    case .otherFileCabinet:
        fallthrough
    case .otherComputer:
        return "Other"
    }
}

func getTextPlaceholder(of tag: StudentTags) -> String {
    switch tag {
    case .phoneNumber:
        return "Student phone number"
        
    case .studentClass:
        return "Student class"
        
    case .otherBook:
        fallthrough
    case .otherLightbulb:
        fallthrough
    case .otherFileCabinet:
        fallthrough
    case .otherComputer:
        return "Enter information"
    }
}

func getSaveTitle(of tag: StudentTags) -> String {
    switch tag {
    case .phoneNumber:
        return "Phone Number"
        
    case .studentClass:
        return "Class"
        
    case .otherBook:
        return "Other Book"
        
    case .otherLightbulb:
        return "Other Light Bulb"
        
    case .otherFileCabinet:
        return "Other File Cabinet"
        
    case .otherComputer:
        return "Other Computer"
    }
}
