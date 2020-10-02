//
//  Kisi.swift
//  Paramiz
//
//  Created by Ahmet Acar on 2.10.2020.
//  Copyright © 2020 Ahmet Acar. All rights reserved.
//

import Foundation
import RealmSwift

class Kisi: Object {
    //dynamic ile tanimlanan verinin degeri degistiginde bunu realmModel tarafinda da degismesini saglamakta -- bu ifade objective c den kalma oldugu icin basina da objective c etiketi aldi
    @objc dynamic var adi: String = ""
    @objc dynamic var soyadi: String = ""
    @objc dynamic var yasi: Int = 1
}
