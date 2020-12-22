//
//  ViewController.swift
//  Project1
//
//  Created by Carmen Morado on 10/6/20.
//

import UIKit

class ViewController: UICollectionViewController {
    var images = [Image]()
    var pictures = [String]()
    var pictures2 = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(suggest))
        
        collectionView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        
        performSelector(inBackground: #selector(loadImages), with: nil)
    }
    
    @objc func loadImages() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        for item in items {
            if item.hasPrefix("nssl") {
                // this is a picture to load!
                pictures.append(item)
                
                let image = Image(name: item, image: item)
                images.append(image)
            }
        }
        
       pictures2 = pictures
       pictures2.sort()
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures2.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Image", for: indexPath) as? ImageCell else {
            // we failed to get a PersonCell – bail out!
            fatalError("Unable to dequeue PersonCell.")
        }
        
        let image = images[indexPath.item]
        cell.name.text = pictures2[indexPath.row]
        cell.imageView.image = UIImage(named: image.name)
        
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7

        // if we're still here it means we got a PersonCell, so we can return it
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = images[indexPath.item]
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController{
            vc.selectedImage = image.name
            vc.selectedPictureNumber = indexPath.row + 1
            vc.totalPictures = pictures2.count
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func suggest() {
        let shareLink = "Try it: https://github.com/CarmenMorado/StormViewer"
        let vc = UIActivityViewController(activityItems: [shareLink], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    


}

