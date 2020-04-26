//
//  ViewController.swift
//  Gifted
//
//  Created by Nick Nguyen on 4/24/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit
import Photos
extension MainViewController: PHPhotoLibraryChangeObserver {
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.async {
            var updatedFetchResults = false
            if let userAlbums = self.userAlbums,
                let changes = changeInstance.changeDetails(for: userAlbums) {
                self.userAlbums = changes.fetchResultAfterChanges
                updatedFetchResults = true
            }
            if let userFavorites = self.userFavorites,
                let changes = changeInstance.changeDetails(for: userFavorites) {
                self.userFavorites = changes.fetchResultAfterChanges
                updatedFetchResults = true
            }
            if updatedFetchResults {
                self.bottomCollectionView.reloadData()
            }
        }
    }
}
class MainViewController: UIViewController
{
// My thinking make me make this app.
    
    @IBOutlet weak var pageView: UIPageControl! {
        didSet {
            pageView.numberOfPages = photos.count
            pageView.currentPage = 0
            pageView.pageIndicatorTintColor = .black
        }
    }
    
    @IBOutlet weak var topCollectionView: UICollectionView! {
        didSet {
            topCollectionView.delegate = self
            topCollectionView.dataSource = self
        }
    }
    
 
    @IBOutlet weak var bottomCollectionView: UICollectionView! {
        didSet {
            bottomCollectionView.delegate = self
            bottomCollectionView.dataSource = self
        }
    }
    
    
    private var menuOptions = ["Photo to Gif",
                               "Video to Gif",
                               "AR","Camera",
                               "Gif Editor",
                               "Timelapse",
                               "Slowmotion",
                               "Live Photo to GIF"]
    
    private let photos = [ UIImage(named: "art"),
                           UIImage(named: "background"),
                           UIImage(named: "smile"),
                           UIImage(named: "rose"),
                           UIImage(named: "selfie"),
                           UIImage(named: "sit")  ]
    
    private var timer = Timer()
    private var counter = 0
    private var minimumSpacing: CGFloat = 5
    var selectedAssets: [PHAsset] = []
    
    let AssetCollectionCellReuseIdentifier = "AssetCollectionCell"
    private let sectionNames = ["", "", "Albums"]
    private var userAlbums: PHFetchResult<PHAssetCollection>?
    private var userFavorites: PHFetchResult<PHAssetCollection>?
    //MARK:- Outlets
    func fetchCollections() {
        if let albums = PHCollectionList.fetchTopLevelUserCollections(with: nil) as? PHFetchResult<PHAssetCollection> {
            userAlbums = albums
        }
        userFavorites = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumFavorites, options: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true

        
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 1.4523, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
       
    }
    
    @objc func changeImage() {
        // automate page view
        if counter < photos.count {
            let index = IndexPath(item: counter, section: 0)
            self.topCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pageView.currentPage = counter
            counter += 1
        } else {
            counter = 0
            let index = IndexPath(item: counter, section: 0)
            self.topCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            pageView.currentPage = counter
            counter = 1
        }
    }


}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
            case bottomCollectionView:
                return menuOptions.count
            default: // top collection view
                return photos.count
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
            case bottomCollectionView:
                let menu = menuOptions[indexPath.row]
                let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: indexPath) as! BottomCollectionViewCell
                cell.menuLabel.text = menu
                
                return cell
            default: // top collection view
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopCell", for: indexPath) as! TopCollectionViewCell
                if let onboardingView = cell.viewWithTag(111) as? UIImageView {
                    onboardingView.image = photos[indexPath.row]
                } else if let pageView = cell.viewWithTag(222) as? UIPageControl {
                    pageView.currentPage = indexPath.row
                }
                
                return cell
            
            
        }
        
    }
  
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
            case bottomCollectionView:
                let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
                var totalUsableWidth = collectionView.frame.width
                let inset = self.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: indexPath.section)
                totalUsableWidth -= inset.left + inset.right
                
                let minWidth: CGFloat = 150.0
                let numberOfItemsInOneRow = Int(totalUsableWidth / minWidth)
                totalUsableWidth -= CGFloat(numberOfItemsInOneRow - 1) * flowLayout.minimumInteritemSpacing
                let width = totalUsableWidth / CGFloat(numberOfItemsInOneRow)
                return CGSize(width: width, height: width)
            default:
                let size = topCollectionView.frame.size
                
                return CGSize(width: size.width, height: size.height  )
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch collectionView {
            case topCollectionView:
                return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            default:
                return UIEdgeInsets(top: 0, left: 20.0, bottom: 0, right: 20.0)
        }
       
    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
            case topCollectionView:
                return 0.0
            default:
                return minimumSpacing
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
            case topCollectionView:
                return 0.0
            default:
                return minimumSpacing
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
            case 0:
                performSegue(withIdentifier: "PhotoToGif", sender: indexPath)
//                print(indexPath.row)
          
            default:
                print(indexPath.row)
        }
    }
}
