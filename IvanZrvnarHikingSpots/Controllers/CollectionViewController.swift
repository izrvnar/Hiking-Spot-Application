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

    
    //MARK: - Data Source
    
    lazy var dataSource = HikingDataSource(collectionView: collectionView){
        (collectionView: UICollectionView, indexPath: IndexPath, spot: HikingSpot) -> UICollectionViewCell? in
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HikingSpotCell
        cell.dateLabel.text = (self.df.string(from: spot.dateLabel))
        cell.dateLabel.layer.cornerRadius = 4
        cell.dateLabel.clipsToBounds = true
        cell.contentView.isUserInteractionEnabled = false
        
        // fetching image
       if let hikingImage = spot.image{
           cell.imageView.image = self.hikingSpots.fetchImage(withIdentifier: hikingImage)
        }
        
        return cell
    }
    let itemsPerRow: CGFloat = 2
    let interItemSpacing: CGFloat = 1
   

    
    //MARK: - View did load
    override func viewDidLoad() {
        super.viewDidLoad()

        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(HikingSpotCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // loading hiking spots
        hikingSpots.loadSpot()
        // creating a new snapshot
        createSnapShot(for: hikingSpots.allHikingSpots)
        
        


        
        // Do any additional setup after loading the view.
        
    }//: View did load
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateSnapShot(for: hikingSpots.allHikingSpots)
    }
    
    
    

    
     //MARK: - Navigation

     //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//         Get the new view controller using [segue destinationViewController].
        guard let destinationVC = segue.destination as? DetailViewController else {return}
        destinationVC.hikingSpotStore = hikingSpots
        
        if segue.identifier == "add"{
            // create a new spot
        } else if segue.identifier == "edit"{
            
            guard let selectedIndexPath = collectionView.indexPathsForSelectedItems?[0] else {return}
        
            let spot = hikingSpots.allHikingSpots[selectedIndexPath.item]
            destinationVC.hikingSpot = spot
           
        }
//         Pass the selected object to the new view controller.
    }


    

    
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
    
    
    // adding proper spacing to collectionview image 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return interItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return interItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let phoneWidth = view.safeAreaLayoutGuide.layoutFrame.width
        let totalSpacing = itemsPerRow * interItemSpacing
        
        let itemWidth = (phoneWidth - totalSpacing) / itemsPerRow

        //keeps aspect ratio for height
        return CGSize(width: itemWidth, height: itemWidth * 3 / 2)
    }
    
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "edit", sender: nil)
//
//
//    }
    
    
 


}//: Collection View Controller

//MARK: -Extensions

extension CollectionViewController: UICollectionViewDelegateFlowLayout{
    
}



