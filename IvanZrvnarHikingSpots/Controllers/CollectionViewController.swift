//
//  CollectionViewController.swift
//  IvanZrvnarHikingSpots
//
//  Created by Ivan Zrvnar on 2022-04-26.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController, UINavigationControllerDelegate {
    //MARK: - Properties
    var hikingSpots = HikingSpotStore()
    let df: DateFormatter = {
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .long
        dateFormat.timeStyle = .none
        dateFormat.doesRelativeDateFormatting = true
        return dateFormat
    }()
    
    lazy var dataSource = HikingDataSource(collectionView: collectionView){
        (collectionView: UICollectionView, indexPath: IndexPath, spot: HikingSpot) -> UICollectionViewCell? in
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HikingSpotCell
        cell.dateLabel.text = self.df.string(from: spot.dateLabel)
        
        // fetching image
        if let hikingImage = spot.image{
            cell.imageView.image = self.hikingSpots.fetchImage(withIdentifier: hikingImage)
        }
        return cell
    }
   

    
    //MARK: - View did load
    override func viewDidLoad() {
        super.viewDidLoad()

        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        hikingSpots.loadSpot()
        createSnapShot(for: hikingSpots.allHikingSpots)
        
        func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            updateSnapShot(for: hikingSpots.allHikingSpots)
        }
        

        
        // Do any additional setup after loading the view.
        
    }//: View did load

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    

    
        // MARK: - Methods

// load initalSnapshot
    func createSnapShot(for savedItems: [HikingSpot]){
        var snapshot = NSDiffableDataSourceSnapshot<Section, HikingSpot>()
        snapshot.appendSections([.main])
        snapshot.appendItems(savedItems, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    // update Snapshot
    
    func updateSnapShot(for spots: [HikingSpot]){
        var snapshot = NSDiffableDataSourceSnapshot<Section, HikingSpot>()
        snapshot.appendSections([.main])
        snapshot.appendItems(spots, toSection: .main)
        
        snapshot.reloadItems(spots)
        dataSource.apply(snapshot, animatingDifferences: true)
    }



}//: Collection View Controller

//MARK: -Extensions


