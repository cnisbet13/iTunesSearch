//
//  DimmedPresentationContro.swift
//  CraigSearch
//
//  Created by Calvin Nisbet on 2015-05-11.
//  Copyright (c) 2015 Calvin Nisbet. All rights reserved.
//


import UIKit

class DimmedPresentationController: UIPresentationController {
    override func shouldRemovePresentersView() -> Bool {
        return false
    }
}