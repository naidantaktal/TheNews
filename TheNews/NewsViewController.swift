//
//  NewsViewController.swift
//  TheNews
//
//  Created by Найдан Тактал on 05.02.2023.
//


import UIKit
import SafariServices
//import WebKit

class NewsViewController: UIViewController {

    @IBOutlet weak var table: UITableView!
    
    let myRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(NewsViewController.self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    

    @objc private func refresh(sender: UIRefreshControl) {
        sender.endRefreshing()
    }
    
    var viewTable: UITableView!
    
    var handlerCNN = CNNHandler()
    var viewCollection: UICollectionView!
    var handlerLilNews = LilNewsHandler()
    var viewModel: NewsViewModel!
    let downloader = ImageDownloader()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = NewsViewModel(controller: self)
        configure()
        viewModel.load()
    }
       // override func viewDidLoad() {
            //super.viewDidLoad()
          //  table.refreshControl = myRefreshControl
      //  }

    func load(title thisTitle: String) {
        title = thisTitle
    }

    func load(articles: [Article]) {
        handlerCNN.articles = articles
        handlerCNN.articles = articles
        handlerLilNews.items = articles
    }

    func load(_ style: NewsViewModel.Style) {
        updateVisibility(style)

        if style.isTable {
            updateTable(style)
        } else {
            updateCollection(style)
        }
    }

}

private extension NewsViewController {

    func configure() {
        view.backgroundColor = .systemGray6
        configureNavigation()
        configureViewTable()
        configureViewCollection()
    }

    func configureNavigation() {
        let styleImage = UIImage(systemName: "textformat.size")
        let styleBarbutton = UIBarButtonItem(title: nil, image: styleImage, primaryAction: nil, menu: viewModel.styleMenu)
        styleBarbutton.tintColor = .systemGray
        navigationItem.rightBarButtonItem = styleBarbutton

        let categoryImage = UIImage(systemName: "list.dash")
        let categoryBarButton = UIBarButtonItem(title: nil, image: categoryImage, primaryAction: nil, menu: viewModel.categoryMenu)
        categoryBarButton.tintColor = .systemGray
        navigationItem.leftBarButtonItem = categoryBarButton
    }

    func configureViewCollection() {
        let identifiers = NewsViewModel.Style.allCases
            .filter { !$0.isTable }
            .flatMap { $0.identifiers }
        viewCollection = UICollectionView(frame: .zero, direction: .horizontal, identifiers: identifiers)
        viewCollection.isHidden = true
        viewCollection.showsHorizontalScrollIndicator = false

        view.addSubviewForAutoLayout(viewCollection)
        NSLayoutConstraint.activate([
            viewCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            viewCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            viewCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    func configureViewTable() {
        let identifiers = NewsViewModel.Style.allCases
            .filter { $0.isTable }
            .flatMap { $0.identifiers }
        viewTable = UITableView(frame: .zero, style: .plain, identifiers: identifiers)
        viewTable.isHidden = true
        viewTable.separatorInset = .zero
        viewTable.rowHeight = UITableView.automaticDimension
        viewTable.cellLayoutMarginsFollowReadableWidth = true

        view.addSubviewForAutoLayout(viewTable)
        NSLayoutConstraint.activate([
            viewTable.topAnchor.constraint(equalTo: view.topAnchor),
            viewTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            viewTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewTable.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    func updateCollection(_ style: NewsViewModel.Style) {
        switch style {
        case .lilnews:
            viewCollection.dataSource = handlerLilNews
            viewCollection.delegate = handlerLilNews
        default:
            break
        }

        viewCollection.reloadData()
    }

    func updateTable(_ style: NewsViewModel.Style) {
        switch style {
        case .cnn:
            viewTable.dataSource = handlerCNN
            viewTable.delegate = handlerCNN
        case .lilnews:
            break
        }

        viewTable.reloadData()

        guard viewTable.numberOfSections > 0,
              viewTable.numberOfRows(inSection: 0) > 0 else { return }

        viewTable.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
    }

    func updateVisibility(_ style: NewsViewModel.Style) {
        switch style {
        case .lilnews:
            viewCollection.isHidden = false
            viewTable.isHidden = true

            viewCollection.isPagingEnabled = true
        default:
            viewCollection.isHidden = true
            viewTable.isHidden = false
        }
    }

}
