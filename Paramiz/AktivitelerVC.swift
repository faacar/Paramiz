//
//  AktivitelerVC.swift
//  Paramiz
//
//  Created by Ahmet Acar on 29.09.2020.
//  Copyright © 2020 Ahmet Acar. All rights reserved.
//

import UIKit

class AktivitelerVC: UITableViewController {

    
    
    var aktivitelerListesi = [Aktivite]()
    var veriler = UserDefaults.standard
    let plistDosyaAdi = "AktivitelerListesi.plist"
    let dosyaYolu = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("AktivitelerListesi.plist")

    override func viewDidLoad() {

        
        let a1 = Aktivite()
        a1.Adi = "Ev"
        a1.Bittimi = true
        aktivitelerListesi.append(a1)

        let a2 = Aktivite()
        a2.Adi = "Kapadokya gezisi"
        aktivitelerListesi.append(a2)
        
        let a3 = Aktivite()
        a3.Adi = "Istanbul gezisi"
        a3.Bittimi = false
        aktivitelerListesi.append(a3)
        
        let a4 = Aktivite()
        a4.Adi = "Okul arkadaslari"
        a4.Bittimi = true
        aktivitelerListesi.append(a4)
        
        verileriYukle()
  //artik verileri bu sekilde kaydetmeme gerek yok
//        if let aktiviteler = veriler.array(forKey: "AktivitelerListesi") as? [Aktivite] {
//            aktivitelerListesi = aktiviteler
//        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aktivitelerListesi.count
    }
    //cellforrowat
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "aktiviteCell")
        //let cell = tableView.dequeueReusableCell(withIdentifier: "aktiviteCell", for: indexPath)
        cell.textLabel?.text = aktivitelerListesi[indexPath.row].Adi
   
        if aktivitelerListesi[indexPath.row].Bittimi {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }

    
    //didselectrowat -- satira basildiginda yapicalak islemler
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        aktivitelerListesi[indexPath.row].Bittimi = !aktivitelerListesi[indexPath.row].Bittimi
        
//        if secilenHucre?.accessoryType == .checkmark { // UITableViewCell.AccessoryType.checkmark bu sekilde de calisiyor
//            secilenHucre?.accessoryType = .none
//        } else {
//            secilenHucre?.accessoryType = .checkmark
//        }
        tableView.reloadData() // cellForRowAt metodu tekrar calisacak ve butun satirlar yeniden oluscak
    }
    
    @IBAction func btnAktiviteEkle(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Aktivite Ekle", message: "Eklemek Istediginiz Aktivite", preferredStyle: .alert) // cikan pencerenin ustunde cikicak mesaj
        alertController.addTextField { txtAktiviteAdi in
            txtAktiviteAdi.placeholder = "Aktivite Adi"
        }
        let ekleACtion = UIAlertAction(title: "Ekle", style: .default) { action in
            let txtAktiviteAdi = alertController.textFields![0]
            
            if !txtAktiviteAdi.text!.isEmpty { //herhangi bir aktivite girildiyse - bir deger girisi varsa
                let a1 = Aktivite()
                a1.Adi = txtAktiviteAdi.text!
                self.aktivitelerListesi.append(a1)
                //self.veriler.set(self.aktivitelerListesi, forKey: "AktiviteListesi")
                self.verileriKaydet()
                self.tableView.reloadData()
            }
        }
        alertController.addAction(ekleACtion) // alertController'a ekledik
        present(alertController, animated: true, completion: nil) // alertController'in sunumu
    }
    //verileri Plist'e kaydeder
    func verileriKaydet() {
        do {
            let data = try PropertyListEncoder().encode(self.aktivitelerListesi)
            try data.write(to: self.dosyaYolu)
        } catch {
            print("Veriler kaydedilirken hata meydanda geldi: \(error.localizedDescription)")
        }
    }
    //verileri Plist'den ceker
    func verileriYukle() {
        
        if let veri = try? Data(contentsOf: dosyaYolu) {
            do {
                aktivitelerListesi = try PropertyListDecoder().decode([Aktivite].self, from: veri)
            } catch {
                print("Verileri getirirken hata meydana geldi: \(error.localizedDescription)")
            }
        }
        
    }
    

}
