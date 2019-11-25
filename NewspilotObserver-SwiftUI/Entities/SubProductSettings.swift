//
//  SubProductSettings.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-10-23.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import Foundation
import os.log
//
//let testSettings =  """
//<?xml version="1.0" encoding="UTF-8"?>
//<settings>
//<field name="part">
//<option>1</option>
//<option>2</option>
//</field>
//<field name="edition">
//<option>1</option>
//<option>2</option>
//<option>3</option>
//<option>4</option>
//</field>
//<field name="version">
//<option>1</option>
//<option>2</option>
//</field>
//<field name="sequence"/>
//</settings>
//"""

enum ParsedElement:String {
    case part, edition, version, sequence, none
}

class SubProductSettings : NSObject, XMLParserDelegate {
    var parts:[String] = []
    var editions:[String] = []
    var versions:[String] = []
    var sequenses:[String] = []
    var parsedElement = ParsedElement.none
    var inOption = false
    
    init(xml:String) {
        super.init()
        if let data = xml.data(using: .utf8) {
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if inOption {
            switch parsedElement {
            case .edition:
                editions.append(string)
            case .part:
                parts.append(string)
            case .version:
                versions.append(string)
            case .sequence:
                sequenses.append(string)
            case .none:
                os_log("Found option text but not in any parsed element. Text:%@", log: .newspilot, type:.error, string)
            }
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        os_log("Parse error occured. Error:%@", log: .newspilot, type:.error, parseError.localizedDescription)
    }
    
    func parser(_ parser: XMLParser, validationErrorOccurred validationError: Error) {
        os_log("Validation error occured. Error:%@", log: .newspilot, type:.error, validationError.localizedDescription)
    }
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String,
                namespaceURI: String?, qualifiedName qName: String?,
                attributes attributeDict: [String : String] = [:]) {
        if elementName == "field" {
            if let name = attributeDict["name"] {
                if let element = ParsedElement(rawValue:name) {
                    parsedElement = element
                }else{
                    os_log("Strange field attribute for name %@", log: .newspilot, type:.error, name)
                    parsedElement = .none
                }
            }else{
                os_log("Could not find field name in %@", log: .newspilot, type:.error, attributeDict)
                parsedElement = .none
            }
        }else if elementName == "option" {
            inOption = true
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "option" {
            inOption = false
        }
    }
    
    func parserDidStartDocument(_ parser: XMLParser) {
        os_log("Parsing started", log: .newspilot, type:.debug)
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        os_log("Parsing done", log: .newspilot, type:.debug)
    }
    
}
