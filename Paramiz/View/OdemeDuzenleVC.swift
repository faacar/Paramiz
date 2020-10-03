//
//  OdemeDuzenleVC.swift
//  Paramiz
//
//  Created by Ahmet Acar on 2.10.2020.
//  Copyright © 2020 Ahmet Acar. All rights reserved.
//

import UIKit
import RealmSwift

class OdemeDuzenleVC: UIViewController {

    let realm = try! Realm()
    var secilenOdeme: Odeme?
    var secilenAktivite: Aktivite?
    
    @IBOutlet weak var guncelleButton: UIButton!
    @IBOutlet weak var txtOdemeKisiAdi: UITextField!
    @IBOutlet weak var txtAciklama: UITextField!
    @IBOutlet weak var txtUcret: UITextField!
    @IBOutlet weak var lblAktiviteAdi: UILabel!
    @IBOutlet weak var lblToplamOdeme: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guncelleButton.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gorunumuAyarla()
    }
    
    @IBAction func btnGuncelleCliked(_ sender: UIButton) {
        if let secilenOdeme = secilenOdeme {
            do {
                try realm.write {
                    secilenOdeme.odeyeninAdi = txtOdemeKisiAdi.text!
                    secilenOdeme.aciklama = txtAciklama.text!
                    secilenOdeme.miktar = Int((txtUcret.text)!)!
                    print("Odeme basariyla guncellendi")
                }
            } catch {
                print("Guncelleme aninda bir hata ile karsilasildi: \(error.localizedDescription)")
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    
    
    
    func gorunumuAyarla() {
        txtOdemeKisiAdi.text = secilenOdeme?.odeyeninAdi
        txtAciklama.text = secilenOdeme?.aciklama
        txtUcret.text = "\(secilenOdeme!.miktar)"
        
        lblAktiviteAdi.text = "Aktivite Adi: \(secilenAktivite!.Adi)"
        let toplamOdeme = secilenAktivite?.odemeler.filter("odeyeninAdi == %@", secilenOdeme?.odeyeninAdi).sum(ofProperty: "miktar") ?? 0
        lblToplamOdeme.text = "Yaptigi Toplam Odeme: \(toplamOdeme) Lira"
    }


}
