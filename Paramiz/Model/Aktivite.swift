//
//  Aktivite.swift
//  Paramiz
//
//  Created by Ahmet Acar on 30.09.2020.
//  Copyright © 2020 Ahmet Acar. All rights reserved.
//

import Foundation
import RealmSwift

class Aktivite: Object {
    @objc dynamic var Adi: String = ""
    @objc dynamic var Bittimi: Bool = false
    let odemeler = List<Odeme>()
}
