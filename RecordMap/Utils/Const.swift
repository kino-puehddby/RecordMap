//
//  Const.swift
//  RecordMap
//
//  Created by 杉田 尚哉 on 2019/02/01.
//  Copyright © 2019 hisayasugita. All rights reserved.
//

import Foundation
import MapKit

public struct Map {
    public static let latitudeDelta: CLLocationDegrees = 0.003
    public static let longitudeDelta: CLLocationDegrees = 0.003
    public static let distanceFilter: CLLocationDistance = 5
    public static let circleRadius: CLLocationDistance = 10
    
    public struct FloatingPanel {
        // A top inset from safe area
        public static let fullPosition: CGFloat = UIScreen.main.bounds.height * 0.1
        // A bottom inset from the safe area
        public static let tipPosition: CGFloat = 75
        public static let sideSpace: CGFloat = 10
        public static let width = UIScreen.main.bounds.width - sideSpace * 2
    }
}

public struct SemiModal {
    public struct TableView {
        public static let headerCellHeight: CGFloat = 75
        public static let heightForRow: CGFloat = 55
        public static let upperSide: CGFloat = 10
    }
}
