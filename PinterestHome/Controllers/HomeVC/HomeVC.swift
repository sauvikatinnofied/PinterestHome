//
//  HomeVC.swift
//  PinterestHome
//
//  Created by Sauvik Dolui on 27/01/17.
//  Copyright © 2017 Sauvik Dolui. All rights reserved.
//

import UIKit


enum LoadingState {
    case onGoing
    case finshed
    case yetToLoad
    
}
class HomeVC: UIViewController {

    
    @IBOutlet weak var pinterestCollection: HomeCollectionView!
    // TODO: Pull to refresh
    
    // MARK: Private Properties
    fileprivate let baseURL = URL(string: "https://gist.githubusercontent.com/")!
    fileprivate var pinterestPosts: [PinterestPost] = [] // Intially an empty array
    fileprivate var onMemoryCache = OnMemoryCache.shared
    fileprivate var httpCacheClient: HTTPCacheClient!
    fileprivate var loadingSate: LoadingState = .yetToLoad
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
        
        let client = HTTPClient(baseURL: baseURL, session: URLSession.shared)
        httpCacheClient = HTTPCacheClient(httpClient: client, cache: onMemoryCache)
        
        if let layout = pinterestCollection?.collectionViewLayout as? PinterestFlowLayout {
            layout.delegate = self
        }
        
        loadPosts()
        addPullToRefresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        onMemoryCache.purge()
    }
    
    
    func loadPosts() {
        
        // JSON Request
        let allPostRequest = HTTPRequestFor<JSONArrayOf<PinterestPost>>(endpoint: PicturePostEndPoint.allPosts, baseURL: baseURL)
        loadingSate = .onGoing
        _ = httpCacheClient.request(request: allPostRequest) { [weak self] (response) in
           
            guard let strongSelf = self else { return }
            strongSelf.loadingSate = .finshed
            (strongSelf.pinterestCollection.viewWithTag(999) as? UIRefreshControl)?.endRefreshing()
            if let posts = response.result?.value {
                strongSelf.pinterestPosts = posts + posts
                strongSelf.pinterestCollection.reloadData()
            } else {
                
            }
        }
        
        // To cancel a task
        //task?.cancel()
    }
    
    func addPullToRefresh() {
        let refreshControll = UIRefreshControl()
        refreshControll.tag = 999
        refreshControll.tintColor = Color.tintColor.innstace
        refreshControll.addTarget(self, action: #selector(HomeVC.didPullToRefresh), for: .valueChanged)
        pinterestCollection.addSubview(refreshControll)
    }
    
    func didPullToRefresh(sender: UIRefreshControl) {
        loadPosts()
    }
}

extension HomeVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return self.pinterestPosts.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let post = self.pinterestPosts[indexPath.row]
        let cell = PinCell.instantiateAsReusable(inCollectionView: collectionView, at: indexPath)
        cell.loadImage(post: post)
        cell.backgroundColor = UIColor(hexString: post.color)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension HomeVC : PinterestLayoutDelegate {

    func collectionView(_ collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath: NSIndexPath,
                        withWidth width: CGFloat) -> CGFloat {
        let post = pinterestPosts[indexPath.item]
        return CGFloat(post.height) * (width/CGFloat(post.width))
    }
}


