//
//  Untitled.swift
//  DetailModule
//
//  Created by Rizvi Naqvi on 13/11/2024.
//

import UIKit
import Common
import Entities
import Utils

/// A view controller for displaying detailed file information and options for file conversion and sharing.
public class FileDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    /// The view model responsible for managing file detail data.
    public var viewModel: FileDetailViewModelType?
    
    /// Router protocol for navigation.
    public var router: FileDetailRouterProtocol?
    
    /// Delegate for handling file detail view events.
    weak var delegate: MyFileDetailViewControllerDelegate?
    
    // MARK: - UI Components
    
    /// Lazy-loaded image view for displaying the file thumbnail.
    public lazy var fileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .white
        return imageView
    }()
    
    /// Lazy-loaded table view for displaying file conversion options.
    public lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomConvertedTypeCell.self, forCellReuseIdentifier: CustomConvertedTypeCell.reuseIdentifier)
        return tableView
    }()
    
    /// Label to display the file size value.
    public lazy var sizeValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .right
        return label
    }()
    
    /// Stack view for displaying the size title and value.
    public lazy var sizeStack: UIStackView = {
        let sizeTitleLabel = UILabel()
        sizeTitleLabel.text = "Size:"
        sizeTitleLabel.font = UIFont.systemFont(ofSize: 14)
        sizeTitleLabel.textAlignment = .left
        
        let stack = UIStackView(arrangedSubviews: [sizeTitleLabel, sizeValueLabel])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    /// Label for displaying the file title.
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    public lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "multiply.circle.fill"), for: .normal)
        button.tintColor = .gray // Optional: Set the color of the icon
        button.addTarget(self, action: #selector(dismissPopup), for: .touchUpInside)
        return button
    }()
    
    public lazy var titleStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, cancelButton])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()


    
    // MARK: - Initializers
    
    /// Initializes the view controller with a view model and router.
    /// - Parameters:
    ///   - viewModel: The view model conforming to `FileDetailViewModelType`.
    ///   - router: The router for navigation conforming to `FileDetailRouterProtocol`..
    public init(
        viewModel: FileDetailViewModelType,
        router: FileDetailRouterProtocol
    ) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    /// Required initializer for using the view controller in storyboards.
    /// - Parameter coder: The NSCoder instance.
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}



extension FileDetailViewController {
    // MARK: - Functions
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        binding()
    }
    
    /// Binds view model callbacks for updating progress and handling events.
    private func binding() {
        viewModel?.onProgressUpdateType = { [weak self] childId in
            DispatchQueue.main.async {
                self?.updateFileProgress(index: childId)
            }
        }
        viewModel?.onProgressUpdateFile = { [weak self] model in
            DispatchQueue.main.async {
                self?.delegate?.didUpdateProgress(for: model)
            }
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        populateInitialValues()
    }
    
    /// Configures the UI layout for the file detail view.
    private func setupView() {
        
        let container = UIView()
        container.backgroundColor = .white
        container.layer.cornerRadius = 12
        container.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(container)
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            container.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16), // Use safeArea for bottom
        ])

//
        setupTitleAndImage(in: container)
        setupTableView(in: container)
        adjustTableViewHeight()
    }
    
    /// Configures the title label and file image within the container view.
    /// - Parameter container: The parent container view.
    private func setupTitleAndImage(in container: UIView) {

        container.addSubview(titleStack)
        
        titleStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleStack.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            titleStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            titleStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -15),
            titleStack.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        container.addSubview(fileImage)
  
        fileImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            fileImage.topAnchor.constraint(equalTo: titleStack.bottomAnchor, constant: 30),
            fileImage.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            fileImage.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 30), // Align with the left side
            fileImage.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -30),
            fileImage.heightAnchor.constraint(equalTo: container.heightAnchor, multiplier: UIDevice.current.userInterfaceIdiom == .pad ? 0.5 : 0.3)

        ])
        
        // Add the lazy sizeStack
        container.addSubview(sizeStack)
        NSLayoutConstraint.activate([
            sizeStack.topAnchor.constraint(equalTo: fileImage.bottomAnchor, constant: 16),
            sizeStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            sizeStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            sizeStack.heightAnchor.constraint(equalToConstant: 20)
        ])

    }
    
    private func populateInitialValues() {
        if let file = viewModel?.myFiles.model[viewModel?.myFiles.selectedIndex ?? 0] {
            titleLabel.text = file.name
            fileImage.image = file.thumnail_image // Replace with actual image
            sizeValueLabel.text = file.size
        }
    }
    
    private func adjustTableViewHeight() {
        guard let file = viewModel?.myFiles.model[viewModel?.myFiles.selectedIndex ?? 0] else { return }
        let rowHeight: CGFloat = 44
        let totalHeight = CGFloat(file.convetedFilesObj.count) * rowHeight
        let maxHeight = UIScreen.main.bounds.height * 0.4 // Limit table height
        
        tableView.heightAnchor.constraint(equalToConstant: min(totalHeight, maxHeight)).isActive = true
        adjustPopoverSize()
    }

    
    /// Configures the table view within the container view.
    /// - Parameter container: The parent container view.
    private func setupTableView(in container: UIView) {
        container.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: sizeStack.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
    }
    
  public  override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        adjustPopoverSize()
    }
    
    func adjustPopoverSize() {
        let maxTableViewHeight = max(tableView.contentSize.height, 20)
        let contentHeight = min(maxTableViewHeight + fileImage.frame.height + sizeStack.frame.height + titleStack.frame.height + 80, view.frame.height) // Maximum height of view.frame.height
        self.preferredContentSize.height = contentHeight
      }

    
    /// Dismisses the popup view controller.
    @objc public func dismissPopup() {
        dismiss(animated: true, completion: nil)
    }
    

    
    /// Updates the file progress for a specific index.
    /// - Parameter index: The index of the file.
    public func updateFileProgress(index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        if let cell = tableView.cellForRow(at: indexPath) as? CustomConvertedTypeCell,
           let item = viewModel?.myFiles.model[viewModel?.myFiles.selectedIndex ?? 0].convetedFilesObj[index] {
            cell.configure(with: item.exportOptions.0.rawValue, status: item.exportOptions.1)
        }
    }
    
    @objc public func convertActionButton(sender: UIButton) {
        let index = sender.tag
        viewModel?.convertFile(index: index)
    }
    
    @objc public func shareActionButton(sender: UIButton) {
        let index = sender.tag
        viewModel?.shareConvertedFile(urlString: viewModel?.myFiles.model[viewModel?.myFiles.selectedIndex ?? 0].convetedFilesObj[index].pathUrl ?? "", controller: self, barButtonItem: sender as UIView)
    }
    
    @objc public func cancelButtonActionButton(sender: UIButton) {
        let index = sender.tag
        let newTuple = ConversionFileIDs(parentId: viewModel?.myFiles.model[viewModel?.myFiles.selectedIndex ?? 0].pathIndexRow ?? -1, childID: index)
        viewModel?.cancelConvertFile(model: newTuple)
    }
    

}



extension FileDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - TableView Data Source and Delegate
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.myFiles.model[viewModel?.myFiles.selectedIndex ?? 0].convetedFilesObj.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomConvertedTypeCell.reuseIdentifier, for: indexPath) as! CustomConvertedTypeCell
        if let item = viewModel?.myFiles.model[viewModel?.myFiles.selectedIndex ?? 0].convetedFilesObj[indexPath.row] {
            cell.configure(with: item.exportOptions.0.rawValue, status: item.exportOptions.1)
            configureActions(for: cell, at: indexPath.row)
        }
        return cell
    }
    
    private func configureActions(for cell: CustomConvertedTypeCell, at index: Int) {
        cell.statusButton.addTarget(self, action: #selector(convertActionButton(sender:)), for: .touchUpInside)
        cell.statusButton.tag = index
        cell.cancelButton.addTarget(self, action: #selector(cancelButtonActionButton(sender:)), for: .touchUpInside)
        cell.cancelButton.tag = index
        cell.shareButton.addTarget(self, action: #selector(shareActionButton(sender:)), for: .touchUpInside)
        cell.shareButton.tag = index
    }
    
    
}


extension FileDetailViewController: PresentableDetailView {
    
    // MARK: - PresentableDetailView
    
    /// Passes the model and delegate to the view controller.
    /// - Parameters:
    ///   - model: The data model.
    ///   - delegate: The delegate instance.
    public func passData(model: Any, delegate: Any) {
        if let model = model as? SelectedFileModel,
           let delegate = delegate as? MyFileDetailViewControllerDelegate {
            self.delegate = delegate
            viewModel?.myFiles = model
            tableView.reloadData()
        }
    }
    
}

