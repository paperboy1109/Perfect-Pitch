//
//  RecordedAudio.swift
//  PitchPerfect
//
//  Created by Daniel J Janiak on 1/31/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    
    var filePathUrl: NSURL!
    
    var title: String!
    
    init(filePathUrl: NSURL!, title: String!) {
        
        self.filePathUrl = filePathUrl
        self.title = title
    }

}