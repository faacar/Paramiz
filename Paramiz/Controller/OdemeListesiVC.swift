//
//  OdemeListesiVC.swift
//  Paramiz
//
//  Created by Ahmet Acar on 1.10.2020.
//  Copyright © 2020 Ahmet Acar. All rights reserved.
//

import UIKit
import RealmSwift

class OdemeListesiVC: UITableViewController, UISearchBarDelegate {

    
    @IBOutlet weak var searhBar: UISearchBar!
    
    let realm = try! Realm()
    var odemeListesi: Results<Odeme>?
    var secilenAktivite: Aktivite? {
        didSet { // secilen aktiviteye eger bir deger atanirsa o zaman buradaki kodlari calistir
            odemeleriYukle()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searhBar.delegate = self

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // 
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return odemeListesi?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "odemeCell",for: indexPath)
        
        
        
        if let odeme = odemeListesi?[indexPath.row] {
            cell.textLabel?.text = "\(odeme.odeyeninAdi) - \(odeme.miktar) Lira"
        } else {
            cell.textLabel?.text = "Henuz eklenen bir odeme bulunamadi" // buralari bi daha incele bakim
        }
        return cell
    }
    

    @IBAction func btnOdemeEkleClicked(_ sender: Any) {
        let alertController = UIAlertController(title: "Odeme", message: "Odeme Ekle", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { txtKisiAdi in
            txtKisiAdi.placeholder = "Odeyen Kisi"
        }
        alertController.addTextField { txtAciklama in
            txtAciklama.placeholder = "Aciklama"
        }
        alertController.addTextField { txtUcret in
            txtUcret.placeholder = "Ucret"
            txtUcret.keyboardType = .numberPad
        }
        
        let add = UIAlertAction(title: "Ekle", style: UIAlertAction.Style.default) { action in
            let txtKisiAdi = alertController.textFields![0]
            let txtAciklama = alertController.textFields![1]
            let txtUcret = alertController.textFields![2]
            
            if let secilenAktivite = self.secilenAktivite {
                do {
                    try self.realm.write {
                        let yeniOdeme = Odeme()
                        yeniOdeme.odeyeninAdi = txtKisiAdi.text ?? "Girilmedi"
                        yeniOdeme.aciklama = txtAciklama.text ?? "Girilmedi"
                        yeniOdeme.miktar = Int(txtUcret.text ?? "-1")!
                        secilenAktivite.odemeler.append(yeniOdeme)
                    }
                } catch {
                    print("Odeme eklerken hata meydana geldi: \(error.localizedDescription)")
                }
            }
            self.tableView.reloadData()
        }
        let cancel = UIAlertAction(title: "Iptal", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(add)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
        
    }
    
    func odemeleriYukle() {
        odemeListesi = secilenAktivite?.odemeler.sorted(byKeyPath: "odeyeninAdi", ascending: true)
    }
    //didSelectRowAt
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "odemeDuzenleSegue", sender: self)
    }
    //OdemeDuzenleVC sayfasina gidis islemleri
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "odemeDuzenleSegue" {
            let hedefVC = segue.destination as! OdemeDuzenleVC
            if let seciliIndex = tableView.indexPathForSelectedRow {
                if let secilenOdeme = odemeListesi?[seciliIndex.row] {
                    hedefVC.secilenOdeme = secilenOdeme
                    hedefVC.secilenAktivite = secilenAktivite
                    hedefVC.title = "\(secilenOdeme.odeyeninAdi) Odeme Bilgileri"
                }
            }
        }
    }
    //candEditRowAt -- herhangi bri satirin editlenip editlenemiyecegini ayarlar
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    //editingstyle
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let secilenOdeme = odemeListesi?[indexPath.row] {
                do {
                    try realm.write {
                        realm.delete(secilenOdeme)
                        print("Odeme basariyla silindi")
                    }
                } catch {
                    print("Silme islemi sirasinda bir hata ile karsilasildi: \(error.localizedDescription)")
                }
            }
        }
        tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if odemeListesi?.count == 0 {
            odemeleriYukle()
        }
        odemeListesi = odemeListesi?.filter("odeyeninAdi == %@", searchBar.text!).sorted(byKeyPath: "miktar", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {//eger kisi searhBar'daki butun mesaji silmisse herseyi eski haline getir
            odemeleriYukle()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder() // kullanici tum degerleri sildiginde klavye yok olacak
            }
        }
    }
    
}
