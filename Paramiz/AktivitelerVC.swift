//
//  AktivitelerVC.swift
//  Paramiz
//
//  Created by Ahmet Acar on 29.09.2020.
//  Copyright © 2020 Ahmet Acar. All rights reserved.
//

import UIKit

class AktivitelerVC: UITableViewController {
//MARK: -TODO : uygulamaya hic veri girilmediyse nil oluyo ve uygulamanin cokmesine sebep oluyor ilk degeri bastan kendimiz atamaliyiz
    
    
    var aktivitelerListesi = ["Ev", "Kapadokya Gezisi", "Istanbul gezisi", "Okul Arkadaslari"]
    var veriler = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let liste = veriler.array(forKey: "AktiviteListesi") as? [String] { // eger henuz hic deger girilmediyse uygulama crash olmasin diye yazdim
            //veriler.set("", forKey: "AktiviteListesi")
            aktivitelerListesi = liste
        }
        for i in 1...100 {
            aktivitelerListesi.append("\(i)")
        }
    
        //aktivitelerListesi = veriler.array(forKey: "AktiviteListesi") as! [String]
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
        //let cell = UITableViewCell(style: .default, reuseIdentifier: "aktiviteCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "aktiviteCell", for: indexPath)
        cell.textLabel?.text = aktivitelerListesi[indexPath.row]
        return cell
    }
    //didselectrowat
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let secilenHucre = tableView.cellForRow(at: indexPath)
        if secilenHucre?.accessoryType == .checkmark { // UITableViewCell.AccessoryType.checkmark bu sekilde de calisiyor
            secilenHucre?.accessoryType = .none
        } else {
            secilenHucre?.accessoryType = .checkmark
        }
    }
    
    @IBAction func btnAktiviteEkle(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Aktivite Ekle", message: "Eklemek Istediginiz Aktivite", preferredStyle: .alert) // cikan pencerenin ustunde cikicak mesaj
        alertController.addTextField { txtAktiviteAdi in
            txtAktiviteAdi.placeholder = "Aktivite Adi"
        }
        let ekleACtion = UIAlertAction(title: "Ekle", style: .default) { action in
            let txtAktiviteAdi = alertController.textFields![0]
            
            if !txtAktiviteAdi.text!.isEmpty { //herhangi bir aktivite girildiyse - bir deger girisi varsa
                self.aktivitelerListesi.append(txtAktiviteAdi.text!)
                self.veriler.set(self.aktivitelerListesi, forKey: "AktiviteListesi")
                
                self.tableView.reloadData()
            }
        }
        alertController.addAction(ekleACtion) // alertController'a ekledik
        present(alertController, animated: true, completion: nil) // alertController'in sunumu
    }
    


}
