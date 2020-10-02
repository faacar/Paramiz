//
//  Odeme.swift
//  Paramiz
//
//  Created by Ahmet Acar on 2.10.2020.
//  Copyright © 2020 Ahmet Acar. All rights reserved.
//

import Foundation
import RealmSwift


class Odeme: Object {
    @objc dynamic var odeyeninAdi: String = ""
    @objc dynamic var aciklama: String = ""
    @objc dynamic var miktar: Int = -1
    var aktivite = LinkingObjects(fromType: Aktivite.self, property: "odemeler")
}
