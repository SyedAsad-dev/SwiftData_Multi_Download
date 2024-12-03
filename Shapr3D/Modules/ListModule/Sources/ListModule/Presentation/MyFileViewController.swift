//
//  File.swift
//  MyFiles
//
//  Created by Rizvi Naqvi on 12/11/2024.
//


import Foundation
import UIKit
import Common
import UniformTypeIdentifiers
import Utils
import Entities

/// ViewController responsible for displaying and managing a collection of user files.
public class MyFileViewController: UIViewController, PresentableListView {
    
    // MARK: - Properties
    
    /// ViewModel for managing file-related data and actions.
    public var viewModel: MyFileViewModelType?
    
    /// Router for handling navigation.
    public var router: FileListRouterProtocol?
    
    /// CollectionView for displaying file items.
    public lazy var collectionView: UICollectionView = {
          let layout = UICollectionViewFlowLayout()
          layout.scrollDirection = .vertical
          layout.minimumLineSpacing = 20
          layout.minimumInteritemSpacing = 0
          layout.itemSize = CGSize(width: 230, height: 230)
          layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
          let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
          collectionView.delegate = self
          collectionView.dataSource = self
          collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.reuseIdentifier)
          collectionView.backgroundColor = .white
          return collectionView
      }()
    
    private lazy var documentPicker: UIDocumentPickerViewController = {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType(filenameExtension: "shapr")!])
        picker.delegate = self
        picker.allowsMultipleSelection = true
        picker.modalPresentationStyle = .formSheet
        return picker
    }()
    
    // MARK: - Initializers
    
    public init(viewModel: MyFileViewModelType, router: FileListRouterProtocol) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

extension MyFileViewController {
    
    // MARK: - Lifecycle Methods
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "My Files"
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        setupCollectionView()
        setupNavigationBar()
        bindViewModel()
    }
    
    // MARK: - Setup Methods
    
    /// Configures the collection view and its layout.
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    /// Configures the navigation bar with a button for importing files.
    private func setupNavigationBar() {
        let importButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapImportFileButton))
        navigationItem.rightBarButtonItem = importButton
    }
    
    /// Binds the ViewModel to update the UI when data changes.
    private func bindViewModel() {
        viewModel?.myFileList.bind { [weak self] _ in
            self?.collectionView.reloadData()
        }
    }
        
    // MARK: - File Import
    
    @objc public func didTapImportFileButton() {
        present(documentPicker, animated: true)
    }
}


extension MyFileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    // MARK: - UICollectionViewDataSource
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.myFileList.value.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.reuseIdentifier, for: indexPath) as? CustomCollectionViewCell,
              let item = viewModel?.myFileList.value[indexPath.row] else {
            return UICollectionViewCell()
        }
        
        cell.configure(image: item.thumnail_image, with: item.name, list: item.convetedFilesObj)
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let items = viewModel?.myFileList.value {
            let selectedItem = items[indexPath.row]
            selectedItem.pathIndexRow = indexPath.row
            if let selectedCell = collectionView.cellForItem(at: indexPath) {
                router?.showDetails(for: SelectedFileModel(model: items, selectedIndex: indexPath.row), delegate: self , view: selectedCell)
                 }
            
        }
    }
}

// MARK: - UIDocumentPickerDelegate

extension MyFileViewController: UIDocumentPickerDelegate {
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        viewModel?.importedFiles(urls: urls)
    }
    
    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
    }
}



extension MyFileViewController: MyFileDetailViewControllerDelegate {
// MARK: - MyFileDetailViewControllerDelegate

public func didUpdateProgress(for model: Any) {
    guard let progressModel = model as? ProgressModel, let index = progressModel.parentId, index >= 0 else { return }
    let indexPath = IndexPath(row: index, section: 0)
    if let cell = collectionView.cellForItem(at: indexPath) as? CustomCollectionViewCell {
        cell.updateValueBasedOnProgress(progressModel)
    }
}
}


extension MyFileViewController: UIPopoverPresentationControllerDelegate {
   
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    public func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
       
    }

    public func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
}
