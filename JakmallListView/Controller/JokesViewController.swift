//
//  JokesViewController.swift
//  JakmallListView
//
//  Created by Fachreza Audrian Naufal on 1/12/19.
//  Copyright © 2019 Fachreza Audrian Naufal. All rights reserved.
//

import UIKit
import SkeletonView

class JokesViewController: UIViewController {
    
    /*
     MARK: - CoreData, UserDefaults
     CoreData -> Biasanya dipakai jika ingin menyimpan data persistent dalam jumlah banyak (history chat)
     UserDefaults -> Dipakai jika butuh simpen data kecil", contoh buat simpen settings / preferences usernya, initial nama, flag/boolean.
     Dalam kasus ini, saya menyimpan 10 data pertama menggunakan variabel penampung. Dikarenakan data tersebut tergolong kecil tapi bukan merupakan preferences user atau boolean/flag.
     */

    
    var jokesData: [ValueModel] = []
    
    var jokesTemp: [ValueModel] = []
    
    @IBOutlet weak var addMoreButton: UIButton!
    
    var jokesService: JokesServiceApi?
    
    let defaults = UserDefaults.standard
    
    lazy var refreshTableView: UIRefreshControl = {
        let refreshTableControl = UIRefreshControl()
        refreshTableControl.tintColor = UIColor.gray
        refreshTableControl.addTarget(self, action: #selector(refreshHandle), for: .valueChanged)
        
        return refreshTableControl
    }()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = refreshTableView
        defineJokesService()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.jokesData = []
        self.jokesService = nil
    }
    
    private func defineJokesService(){
        
        self.jokesService = JokesServiceApi()
        self.jokesService?.delegate = self
        self.jokesService?.getJokes()
    }
    
     /*
     MARK: - SwitchedArray
        Tampung array ke index sekian.
        Hapus index sekian dari array.
        Tampung semua array value terakhir ke sebuah variabel
        Hapus semua array.
        Tambahkan index array terlebih dahulu lalu tambahkan semua value array yang ditampung pada variabel.
     }
     */
    
    private func switchedArray(_ index: Int){
        
        let switchedValue = jokesData[index]
        jokesData.remove(at: index)
        let data = jokesData
        jokesData.removeAll()
        jokesData.append(switchedValue)
        jokesData.append(contentsOf: data)
    }
    
    /*
     MARK: - saveJokesAddButton
        Fungsi ini digunakan untuk menampung total dari tombol yang sudah di klik
    */
    
    private func saveJokesAddMax(_ total: Int){
        defaults.set(total, forKey: "JokesMax")
    }
    
    /*
     MARK: - fetchJokesMax
     Fungsi ini digunakan untuk mengambil value total user tapped button
     */
    
    private func fetchJokesMax() -> Int{
        let total = defaults.integer(forKey: "JokesMax")
        return total
    }
    
    /*
     MARK: - addMoreDataButtonTapped
     Fungsi ini digunakan untuk menambahkan jumlah user klik button
     */
    
    @IBAction func addMoreDataButtonTapped(_ sender: UIButton) {
        
        var jokesAddMax = fetchJokesMax()
        self.jokesService?.getJokes()
        jokesAddMax = jokesAddMax + 1
        saveJokesAddMax(jokesAddMax)
    }
    
    /*
     MARK: - refreshHandle
     Fungsi ini digunakan untuk menghandle dari aksi refresh oleh table view
     */
    
    @objc func refreshHandle(){
        
        self.jokesData.removeAll()
        self.jokesData.append(contentsOf: jokesTemp)
        
//        if let savedJokes = defaults.object(forKey: "SavedJokes") as? Data {
//            let decoder = JSONDecoder()
//            if let loadedJokes = try? decoder.decode([ValueModel].self, from: savedJokes) {
//                self.jokesData.append(contentsOf: loadedJokes)
//            }
//        }

        refreshTableView.endRefreshing()
        self.addMoreButton.isHidden = false
        let jokesAddMax = 0
        saveJokesAddMax(jokesAddMax)
        self.tableView.reloadData()
    }
}

/*
 MARK: - JokesDelegate
 Merupakan extension delegasi guna untuk menghandle response jokes dari Api
 */

extension JokesViewController: JokesDelegate{
    
    func getAllJokes(_ jokes: [ValueModel]?, _ status: Bool) {
        
        guard status == true else {
            AlertHelper.showAlert(title: "Informasi Sistem", message: "Kesalahan pada server", vc: self)
            return
        }
        
        if fetchJokesMax() == 2{
            self.addMoreButton.isHidden = true
        }
        
        guard let jokesResponse = jokes else {return}
        
        if jokesData.count == 0 {
            
            
            //            let encoder = JSONEncoder()
            //            if let encoded = try? encoder.encode(jokes) {
            //                defaults.set(encoded, forKey: "SavedJokes")
            //            }
            
            self.jokesTemp.append(contentsOf: jokesResponse)
            
        }
        
        self.jokesData.append(contentsOf: jokesResponse)
        self.tableView.reloadData()
    }
}

/*
 MARK: - TableDataResource, TableViewDelegate
 Merupakan extension delegasi guna untuk menghandle table view
 */

extension JokesViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jokesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "jokesIdentifier", for: indexPath) as! JokesTableViewCell
        
        if indexPath.row == 0 {
            cell.jokesButton.setImage(nil, for: .normal)
            cell.jokesButton.setTitle("We're on Top", for: .normal)
        }else{
            cell.jokesButton.setImage(UIImage(named: "Up"), for: .normal)
            cell.jokesButton.setTitle(nil, for: .normal)
        }
        
        cell.jokesText.text = jokesData[indexPath.row].joke
        cell.jokesButton.tag = indexPath.row
        cell.jokesButton.addTarget(self, action: #selector(jokesButtonHandler(sender:)), for: .touchUpInside)
        
        cell.hideAnimation()
        return cell
    }
    
    @objc func jokesButtonHandler(sender: UIButton){
        
        let selectedIndex = IndexPath(row: sender.tag, section: 0)
        switchedArray(selectedIndex.row)
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(250)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let message = jokesData[indexPath.row].joke {
            AlertHelper.showAlertTableView(title: "", message: message, vc: self)
        }
    }
}
