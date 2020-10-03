//
//  AktivitelerVC.swift
//  Paramiz
//
//  Created by Ahmet Acar on 29.09.2020.
//  Copyright © 2020 Ahmet Acar. All rights reserved.
//

import UIKit
import RealmSwift


class AktivitelerVC: UITableViewController {

    
    
    var aktivitelerListesi: Results<Aktivite>?
    let realm = try! Realm()
    override func viewDidLoad() {
        
        verileriYukle()
        
    }

    //kac bolum olsun onu belirler
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //her bolumde kac satir oldugunu belirler
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aktivitelerListesi?.count ?? 0
    }
    //cellforrowat -- cell'lerin icindeki verileri doldurur
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "aktiviteCell")
        //let cell = tableView.dequeueReusableCell(withIdentifier: "aktiviteCell", for: indexPath)
        cell.textLabel?.text = aktivitelerListesi?[indexPath.row].Adi ?? "Aktivite Bulunamadi"
   
        if aktivitelerListesi?[indexPath.row].Bittimi ?? false {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }

    //didselectrowat -- satira basildiginda yapicalak islemler
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        performSegue(withIdentifier: "odemeListesiSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "odemeListesiSegue" {
            let hedefVC = segue.destination as! OdemeListesiVC
            if let seciliIndex = tableView.indexPathForSelectedRow {
                hedefVC.secilenAktivite = aktivitelerListesi?[seciliIndex.row]
            }
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
                let a1 = Aktivite()
                a1.Adi = txtAktiviteAdi.text!
                self.verileriKaydet(aktivite: a1)
                self.tableView.reloadData()
            }
        }
        alertController.addAction(ekleACtion) // alertController'a ekledik
        present(alertController, animated: true, completion: nil) // alertController'in sunumu
    }

    func verileriKaydet(aktivite: Aktivite) {
        do {
            try realm.write {
                realm.add(aktivite)
            }
        } catch {
            print("Realm bir hata verdi:\(error.localizedDescription)")
        }
    }
    
    func verileriYukle() {
        aktivitelerListesi = realm.objects(Aktivite.self)
        tableView.reloadData()
    }

}
