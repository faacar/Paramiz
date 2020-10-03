//
//  AktivitelerVC.swift
//  Paramiz
//
//  Created by Ahmet Acar on 29.09.2020.
//  Copyright © 2020 Ahmet Acar. All rights reserved.
//

import UIKit
import RealmSwift


class AktivitelerVC: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var aktivitelerListesi: Results<Aktivite>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        
        verileriYukle()
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
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
        
        let sonuc: Int = aktivitelerListesi?[indexPath.row].odemeler.sum(ofProperty: "miktar") ?? 0
        
        if let adi = aktivitelerListesi?[indexPath.row].Adi {
            cell.textLabel?.text = "\(adi) - \(sonuc)"
        } else {
            cell.textLabel?.text = "Aktivite Bulunamadi"
        }
        
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
    
    //caneditrowat -- silme islemine onay
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    //editingstyle -- edit olarak ne yapilacak onun yazilmasi
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let silincekAktivite = aktivitelerListesi?[indexPath.row] {
                do {
                    try realm.write {
                        realm.delete(silincekAktivite.odemeler)
                        realm.delete(silincekAktivite)
                    }
                } catch {
                    print("Aktiviteyi silerken hata meydanda geldi: \(error.localizedDescription)")
                }
            }
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        aktivitelerListesi = aktivitelerListesi?.filter("Adi CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "Adi", ascending: true)
        tableView.reloadData()
    }
    //textdidchange
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            verileriYukle() // kullanicinin girdigi bir deger yok o zaman tum verileri yukle
            DispatchQueue.main.async {
                searchBar.resignFirstResponder() // kullanici tum degerleri sildiginde klavye yok olacak
            }
        }
    }

}
