//
//  CustomCollectionViewCell.swift
//  MyFiles
//
//  Created by Rizvi Naqvi on 12/11/2024.
//


import UIKit
import Entities
import Utils

/// A custom collection view cell for displaying file details with an image, title, progress bar, and file type labels.
class CustomCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "CustomCollectionViewCell"
    
    // MARK: - UI Elements
    
    /// Lazy-loaded file image view.
    private lazy var fileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    /// Lazy-loaded file type stack view containing labels.
    private lazy var fileTypeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()
    
    /// Lazy-loaded title label.
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .gray
        label.textAlignment = .left
        return label
    }()
    
    /// Lazy-loaded progress view.
    private lazy var progressView: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .default)
        progress.isHidden = true
        return progress
    }()
    
    /// Array of file type labels.
    private lazy var labels: [UILabel] = {
        let fileTypes: [ExportType] = [.STL, .STEP, .OBJ]
        return fileTypes.map { _ in createFileTypeLabel() }
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomCollectionViewCell {
    
    // MARK: - Setup Methods
    
    /// Configures the UI elements and layout of the cell.
    private func setupViews() {
        // Add file image view
        contentView.addSubview(fileImageView)
        
        // Add file type stack view and labels
        labels.forEach { fileTypeStackView.addArrangedSubview($0) }
        contentView.addSubview(fileTypeStackView)
        
        // Add title label
        contentView.addSubview(titleLabel)
        
        // Add progress view
        contentView.addSubview(progressView)
        
        // Apply constraints
        setupConstraints()
    }
    
    /// Creates and configures a label for file types.
    private func createFileTypeLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = .black
        label.backgroundColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        label.isHidden = true
        return label
    }
    
    /// Sets up Auto Layout constraints for UI elements.
    private func setupConstraints() {
        fileImageView.translatesAutoresizingMaskIntoConstraints = false
        fileTypeStackView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // File image view at the top
            fileImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            fileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            fileImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            fileImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),
            
            // File type stack view positioned at the bottom-right of the image
            fileTypeStackView.trailingAnchor.constraint(equalTo: fileImageView.trailingAnchor, constant: -8),
            fileTypeStackView.bottomAnchor.constraint(equalTo: fileImageView.bottomAnchor, constant: -8),
            
            // Title label below the image
            titleLabel.topAnchor.constraint(equalTo: fileImageView.bottomAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            // Progress view below the title label
            progressView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            progressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 4),
            progressView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
    }
    
    // MARK: - Configuration Methods
    
    /// Configures the cell with data.
    /// - Parameters:
    ///   - image: The file's thumbnail image.
    ///   - name: The file name.
    ///   - list: A list of file conversion details.
    func configure(image: UIImage?, with name: String, list: ConvertedFilesModelList) {
        if let imageData = image {
            fileImageView.image = imageData
        }
        titleLabel.text = name
        
        for (index, item) in list.enumerated() {
            if item.exportOptions.1 == .ready || item.exportOptions.1 == .success {
                labels[index].isHidden = false
                labels[index].text = item.exportOptions.0.rawValue
            } else {
                labels[index].isHidden = true
            }
        }
    }
    
    /// Updates the cell's progress view and labels based on a progress model.
    /// - Parameter model: The progress model containing update details.
    func updateValueBasedOnProgress(_ model: ProgressModel) {
        let label = labels[model.childId]
        switch model.status.1 {
        case .success, .ready:
            label.isHidden = false
            label.text = model.status.0.rawValue
            progressView.isHidden = true
        case .progress(let progress):
            progressView.isHidden = false
            progressView.progress = progress
        default:
            label.isHidden = true
            progressView.isHidden = true
        }
    }
}
