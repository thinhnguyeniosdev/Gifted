//
//  CustomizeViewController.swift
//  Gifted
//
//  Created by Nick Nguyen on 4/26/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit
import ARKit
import Photos
import ImageIO
import MobileCoreServices

// STUCK: Share gif to Twitter
// STUCK: Slider to adjust speed
// STUCK: scroll to bottom
// STUCK: Progress view repeate over and over

// TODO: Drag and Drop

class CustomizeViewController: UIViewController, ARSessionDelegate, UIActivityItemSource, ReorderCollectionViewControllerDelegate {
    func didReorder(images: [UIImage]) {
     imagesToMakeGIF = images
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
       return "Hello"
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return "Hi"
    }
    
    //MARK:- Properties

    private let progressView: UIProgressView = {
        let pg = UIProgressView()
        pg.translatesAutoresizingMaskIntoConstraints = false
        pg.progressViewStyle = .default
        pg.tintColor = .link
        pg.backgroundColor = .gray
        return pg
    }()
    let options = ["Speed" ,"Boomerang" , "AR","Canvas","Reorder" , "Filters" , "Stickers", "Text", "Tune" ]
               
    
    let optionImages = [
        UIImage(systemName: "waveform"),
        UIImage(systemName: "lasso"),
        UIImage(systemName: "square.stack.3d.down.right"),
        UIImage(systemName: "aspectratio"),
        UIImage(systemName: "arrow.clockwise.circle"),
        UIImage(systemName: "pencil"),
        UIImage(systemName: "smiley"),
        UIImage(systemName: "textformat.size"),
        UIImage(systemName: "radiowaves.left")
        
    ]
    private var gifURL: URL {
        let documentsURL = FileManager.default.urls( for: .documentDirectory,in: .userDomainMask).first
        let imageURL = documentsURL!.appendingPathComponent("MyImage.gif")
        return imageURL
    }
    var imagesToMakeGIF: [UIImage]? {
        didSet {
            progress = Progress(totalUnitCount: Int64(imagesToMakeGIF!.count))
            
        }
    }
    

    //MARK:- Outlets
    
    @IBOutlet weak var gifImageView: UIImageView!
    
    @IBOutlet weak var optionCollectionView: UICollectionView!  {
        didSet {
            optionCollectionView.delegate = self
            optionCollectionView.dataSource = self
        }
    }
    
    //MARK:- Life Cycle
    
    private let speedSlider: UISlider = {
       let slide = UISlider()
        slide.translatesAutoresizingMaskIntoConstraints = false
        slide.minimumValue = 0.05
        slide.maximumValue = 2.0
        slide.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        return slide
    }()
    
    @objc func sliderValueChanged(sender: UISlider) {
        //STUCK:
//        print(sender.value)
//
//        let imageViewForGif = createGifImage(with: imagesToMakeGIF!, duration: Double(sender.value) * Double(imagesToMakeGIF!.count))
//                view.addSubview(imageViewForGif)
//
//        NSLayoutConstraint.activate([
//
//            imageViewForGif.leadingAnchor.constraint(equalTo: gifImageView.leadingAnchor),
//
//            imageViewForGif.trailingAnchor.constraint(equalTo: gifImageView.trailingAnchor),
//
//            imageViewForGif.topAnchor.constraint(equalTo: gifImageView.topAnchor),
//
//            imageViewForGif.bottomAnchor.constraint(equalTo: gifImageView.bottomAnchor)
//        ])
//
//        self.gifImageView = imageViewForGif
//        gifImageView = createGifImage(with: imagesToMakeGIF!, duration: Double(sender.value))
        
        
    }
 
   private let slowImage: UIImageView = {
    
       let image = UIImageView(image: UIImage(systemName: "hare"))
    
        image.translatesAutoresizingMaskIntoConstraints = false
    
        image.contentMode = .scaleAspectFit
    
        return image
    }()
    private let fastImage: UIImageView = {
        
        let image = UIImageView(image: UIImage(systemName: "tortoise"))
        
        image.translatesAutoresizingMaskIntoConstraints = false
        
        image.contentMode = .scaleAspectFit
        
        return image
    }()
    private lazy var horizontalStackView : UIStackView = {
        let stack = UIStackView(arrangedSubviews: [self.slowImage,self.speedSlider,self.fastImage])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 20
        return stack
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFit
        button.tintColor = .red
        button.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        button.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
      
        return button
    }()
    
    private lazy var checkButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(checkTapped), for: .touchUpInside)
        button.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        button.tintColor = #colorLiteral(red: 0.3882825077, green: 0.6711806059, blue: 0.5451156497, alpha: 1)
        return button
    }()
    
    private let speedLabel: UILabel = {
       let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Speed"
        lb.baselineAdjustment = .alignCenters
        lb.textAlignment = .center
        return lb
    }()
    
    lazy var horizontalTopStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [self.cancelButton,self.speedLabel,self.checkButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 10
        stack.backgroundColor = .white
        return stack
    }()
    
    var speedingViewHeight : NSLayoutConstraint?
    
    
    @objc func cancelTapped() {
        self.speedingViewHeight?.isActive = false
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func checkTapped() {
        self.speedingViewHeight?.isActive = false
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        print("Applying new speed")
    }
    
    //MARK:- Life Cycle
    @objc func valueChaned() {
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        speedSlider.value = 1.25
        
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        
        view.addSubview(progressView)
        
        view.addSubview(speedingView)
        
        speedingView.addSubview(horizontalStackView)
        
        speedingView.addSubview(horizontalTopStackView)
        
        speedSlider.isContinuous = true
        
        speedSlider.addTarget(self, action: #selector(valueChaned), for: .valueChanged)
        
        self.speedingViewHeight = speedingView.heightAnchor.constraint(equalToConstant: 200)
        
        constraintsEverything()
        
        guard let images = imagesToMakeGIF else  { return }
        
        print("images to make GIF : \(images.count)")
    }
    
    private func constraintsEverything() {
        NSLayoutConstraint.activate([
            
            speedingView.leadingAnchor.constraint(equalTo: gifImageView.leadingAnchor),
            
            speedingView.trailingAnchor.constraint(equalTo: gifImageView.trailingAnchor),
            
            speedingView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: 16),
            
            
        ])
        //          speedingViewHeight!
        NSLayoutConstraint.activate([
            
            progressView.leadingAnchor.constraint(equalTo: gifImageView.leadingAnchor),
            
            progressView.trailingAnchor.constraint(equalTo: gifImageView.trailingAnchor),
            
            progressView.topAnchor.constraint(equalTo: gifImageView.bottomAnchor),
            
            progressView.heightAnchor.constraint(equalToConstant: 5)
            
        ])
        
        NSLayoutConstraint.activate([
            
            horizontalStackView.centerXAnchor.constraint(equalTo: speedingView.centerXAnchor),
            
            horizontalStackView.centerYAnchor.constraint(equalTo: speedingView.centerYAnchor),
            
            horizontalStackView.leadingAnchor.constraint(equalTo: speedingView.leadingAnchor,constant: 16),
            
            horizontalStackView.trailingAnchor.constraint(equalTo: speedingView.trailingAnchor,constant: -16),
            
            
            horizontalTopStackView.leadingAnchor.constraint(equalTo: speedingView.leadingAnchor, constant: 16),
            
            horizontalTopStackView.trailingAnchor.constraint(equalTo: speedingView.trailingAnchor, constant: -16),
            
            horizontalTopStackView.heightAnchor.constraint(equalToConstant: 50),
            
            horizontalTopStackView.topAnchor.constraint(equalTo: speedingView.topAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
      
        navigationController?.navigationBar.isHidden = false
        
        navigationController?.isToolbarHidden = true
        
        startGif()
        
    }
    private let speedingView: UIView = {
       let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .white
        
        return view
    }()
    
    
    private func createGIF(with images: [UIImage], url: URL, loopCount: Int = 0, frameDelay: Double) {
        
        let destinationURL = url
        
        let destinationGIF = CGImageDestinationCreateWithURL(destinationURL as CFURL, kUTTypeGIF, images.count, nil)!
        
        // This dictionary controls the delay between frames
        // If you don't specify this, CGImage will apply a default delay
        let properties = [
            (kCGImagePropertyGIFDictionary as String): [(kCGImagePropertyGIFDelayTime as String): frameDelay]
        ]
        
        
        for img in images {
            // Convert an UIImage to CGImage, fitting within the specified rect
            let cgImage = img.cgImage
            // Add the frame to the GIF image
            CGImageDestinationAddImage(destinationGIF, cgImage!, properties as CFDictionary?)
        }
    
        // Write the GIF file to disk
        CGImageDestinationFinalize(destinationGIF)
    }
  
    
    private func createGifImage(with images: [UIImage],duration:Double) -> UIImageView {
      
        let animatedImage = UIImage.animatedImage(with:images, duration: duration ) // Create GIF
        
        let imageView = UIImageView(image: animatedImage)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }
    var timer = Timer()
    
    var progress : Progress!
      
    private func showSavingOptionAlert() {
        
        let ac = UIAlertController(title: "", message: "You are all set", preferredStyle: .actionSheet)
        
        ac.addAction(UIAlertAction(title: "Save to photo Library", style: .default, handler: saveGifToPhotoLibrary(action:)))
        
        ac.addAction(UIAlertAction(title: "Share GIF", style: .default, handler: openActivityVC(action:)))
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        
        present(ac, animated: true, completion: nil)
    }
    
    
    private func openActivityVC(action: UIAlertAction) {
        
        createGIF(with: imagesToMakeGIF!, url: gifURL, frameDelay: Double(speedSlider.value))
        
        let imageData = try! Data(contentsOf: gifURL, options: .alwaysMapped)

        let ac = UIActivityViewController(activityItems: [imageData], applicationActivities: nil)
        
        ac.excludedActivityTypes =  [.saveToCameraRoll,.addToReadingList,.postToWeibo,.print,.copyToPasteboard,.assignToContact]
        
        present(ac, animated: true, completion: nil)
    }
    
    private func saveGifToPhotoLibrary(action: UIAlertAction) {
        
        let ac = UIAlertController(title: "GIF Saved!", message: nil, preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            self.createGIF(with: self.imagesToMakeGIF!, url: self.gifURL, frameDelay: Double(self.speedSlider.value) )
            
            PHPhotoLibrary.shared().performChanges({ PHAssetChangeRequest.creationRequestForAssetFromImage(
                atFileURL: self.gifURL)})
            
           UIApplication.shared.open(URL(string:"photos-redirect://")!)
        }))
        
        present(ac, animated: true, completion: nil)
       
    }
    
    private func startGif() {
      
        let imageViewForGif = createGifImage(with: imagesToMakeGIF!, duration: 0.5 * Double(imagesToMakeGIF!.count))
        
        view.addSubview(imageViewForGif)
        
        NSLayoutConstraint.activate([
            
            imageViewForGif.leadingAnchor.constraint(equalTo: gifImageView.leadingAnchor),
            
            imageViewForGif.trailingAnchor.constraint(equalTo: gifImageView.trailingAnchor),
            
            imageViewForGif.topAnchor.constraint(equalTo: gifImageView.topAnchor),
            
            imageViewForGif.bottomAnchor.constraint(equalTo: gifImageView.bottomAnchor)
        ])

        self.gifImageView = imageViewForGif
        
        Timer.scheduledTimer(withTimeInterval: 0.25  , repeats: true) { (timer) in
            
            guard self.progress.isFinished == false else {
                
                self.progressView.setProgress(0, animated: true)
                
                self.progress = Progress(totalUnitCount: Int64(self.imagesToMakeGIF!.count))
                
                return
            }
            
            self.progress.completedUnitCount += 1
            
            let progressFloat = Float(self.progress.fractionCompleted)
            
                self.progressView.setProgress(progressFloat, animated: true)
                
            }
        
    }
    
    @objc func handle() {
//        let v = (gifImageView.image!.duration / Double(imagesToMakeGIF!.count))
        progressView.progress += Float(gifImageView.image!.duration) / Float(imagesToMakeGIF!.count)
    }
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem)
    {
        showSavingOptionAlert()
    // Save as gif,live photo or video, show activity controller to share to friend

  
    }
    
    @IBOutlet weak var stopButton: UIButton!
    
    @IBAction func pauseTapped(_ sender: UIButton) {
       
        if !sender.isSelected {

            gifImageView.image = imagesToMakeGIF!.last
            
            progressView.progress = 0
            
            sender.isSelected = true
        } else {
            progress = Progress(totalUnitCount: Int64(imagesToMakeGIF!.count))
            
            sender.isSelected = false
            
            startGif()
        }
    
    }
    
    
    
    @IBAction func reversePressed(_ sender: UIButton) {
        let reversedImages = Array(imagesToMakeGIF!.reversed())
        
        let imageViewForGif = createGifImage(with: reversedImages, duration: Double(speedSlider.value) * Double(reversedImages.count))
        
        view.addSubview(imageViewForGif)
        
        NSLayoutConstraint.activate([
            
            imageViewForGif.leadingAnchor.constraint(equalTo: gifImageView.leadingAnchor),
            
            imageViewForGif.trailingAnchor.constraint(equalTo: gifImageView.trailingAnchor),
            
            imageViewForGif.topAnchor.constraint(equalTo: gifImageView.topAnchor),
            
            imageViewForGif.bottomAnchor.constraint(equalTo: gifImageView.bottomAnchor)
        ])
        
        self.gifImageView = imageViewForGif
    }
    
    
    @IBAction func repeatPressed(_ sender: UIButton) {
        
    }
    
    //MARK:- Actions
    

}
extension CustomizeViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.item {
            case 0:
                self.speedingViewHeight!.isActive = true
                
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
            case 4:
                let vc = storyboard?.instantiateViewController(withIdentifier: "312") as! ReorderCollectionViewController
                
                vc.images = imagesToMakeGIF!
                vc.delegate = self 
                navigationController?.pushViewController(vc, animated: true)
            case 7 :
                let v = TextTypingViewController()
                let vc = UINavigationController(rootViewController: v)
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true, completion: nil)
              
            default:
            break
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.editCell.rawValue, for: indexPath) as! EditOptionCell
        cell.optionLabel.text = options[indexPath.row]
        cell.optionImageView.image = optionImages[indexPath.row]

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
}
