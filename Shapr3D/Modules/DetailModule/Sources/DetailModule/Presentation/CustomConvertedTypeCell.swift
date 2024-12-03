//
//  Untitled.swift
//  DetailModule
//
//  Created by Rizvi Naqvi on 13/11/2024.
//
import UIKit
import Utils

public class CustomConvertedTypeCell: UITableViewCell {
    // MARK: - Constants
    static let reuseIdentifier = "CustomConvertedTypeCell"
    
    // MARK: - UI Components
    private lazy var formatLabel: UILabel = createLabel(isHidden: false,fontSize: 15, weight: .bold)
    private lazy var progressLabel: UILabel = createLabel(fontSize: 12, weight: .light)
    private lazy var progressBar: UIProgressView = {
        let bar = UIProgressView(progressViewStyle: .default)
        bar.isHidden = true
        return bar
    }()
    
    public lazy var statusButton: UIButton = createButton()
    public lazy var shareButton: UIButton = createButton()
    public lazy var cancelButton: UIButton = createButton(tintColor: .red)
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
 
extension CustomConvertedTypeCell {
    // MARK: - Configuration
    /// Configures the cell with file format and export status.
    func configure(with format: String, status: ExportStatus) {
        formatLabel.text = format
        resetViewState()
        switch status {
        case .progress(let progress):
            updateProgressState(progress: progress)
        case .failed:
            updateStatusLabel(text: "Failed!", color: .red)
            configureButton(statusButton, icon: "arrow.forward.circle", tintColor: .blue, isHidden: false)
        case .success:
            updateStatusLabel(text: "Success!", color: .black)
            configureButton(shareButton, icon: "square.and.arrow.up.fill", tintColor: .blue, isHidden: false)
        case .ready:
            configureButton(shareButton, icon: "square.and.arrow.up.fill", tintColor: .blue, isHidden: false)
        case .zero:
            configureButton(statusButton, icon: "arrow.forward.circle", tintColor: .blue, isHidden: false)
        case .cancel:
            configureButton(statusButton, icon: "arrow.forward.circle", tintColor: .blue, isHidden: false)
        }
    }
    
    // MARK: - Private Helpers
    /// Resets the visibility and state of all UI components.
    private func resetViewState() {
        [progressBar, progressLabel, statusButton, shareButton, cancelButton].forEach { $0.isHidden = true }
    }
    
    /// Updates the view for a progress state.
    private func updateProgressState(progress: Float) {
        progressBar.isHidden = false
        progressLabel.isHidden = false
        cancelButton.isHidden = false
        progressBar.progress = progress
        progressLabel.text = "\(Int(progress * 100))%"
        progressLabel.textColor = .black
        configureButton(cancelButton, icon: "xmark.circle", tintColor: .red, isHidden: false)
    }
    
    /// Updates the progress label with given text and color.
    private func updateStatusLabel(text: String, color: UIColor) {
        progressLabel.isHidden = false
        progressLabel.text = text
        progressLabel.textColor = color
    }
    
    /// Configures a button with the given properties.
    private func configureButton(_ button: UIButton, icon: String, tintColor: UIColor, isHidden: Bool) {
        button.setImage(UIImage(systemName: icon), for: .normal)
        button.tintColor = tintColor
        button.isHidden = isHidden
    }
    
    /// Creates a UILabel with specified font size and weight.
    private func createLabel(isHidden: Bool = true, fontSize: CGFloat, weight: UIFont.Weight) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: fontSize, weight: weight)
        label.isHidden = isHidden
        return label
    }
    
    /// Creates a UIButton with an optional tint color.
    private func createButton(tintColor: UIColor? = nil) -> UIButton {
        let button = UIButton(type: .system)
        button.tintColor = tintColor ?? .blue
        button.isHidden = true
        return button
    }
    
    // MARK: - Layout Setup
    private func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [
            formatLabel, progressLabel, progressBar, statusButton, shareButton, cancelButton
        ])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
