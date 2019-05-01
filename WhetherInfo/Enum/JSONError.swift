//
//  JSONError.swift
//  WhetherInfo
//
//  Created by Suraj Kodre on 30/04/19.
//  Copyright © 2019 Suraj Kodre. All rights reserved.
//

import UIKit

enum JSONError: String, Error {
	case NoData = "ERROR: no data"
	case ConversionFailed = "ERROR: conversion from JSON failed"
	case ParsingFail = "ERROR: parsing data gets fail"
}
