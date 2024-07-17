//
//  FetchingStatusView.swift
//  ASBInterviewExercise
//
//  Created by yanhu on 17/07/24.
//

import UIKit
import SnapKit

class FetchingStatusView: UIView {
    
    enum Status {
        case noNetwork
        case fetching
        case success
        case failure(String)
    }
    
    private let statusLabel = UILabel()
    private var fetchingTimer: Timer?
    private var fetchingDotsCount = 0
    
    var status: Status = .success {
        didSet {
            updateStatus()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        addSubview(statusLabel)
        statusLabel.textAlignment = .center
        statusLabel.textColor = .gray
        statusLabel.font = UIFont.systemFont(ofSize: 16)
        
        statusLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        isUserInteractionEnabled = false
    }

    private func updateStatus() {
        switch status {
        case .noNetwork:
            statusLabel.text = "No network connection, please check."
            statusLabel.isHidden = false
            stopFetchingTimer()
        case .fetching:
            startFetchingTimer()
            statusLabel.isHidden = false
        case .success:
            statusLabel.isHidden = true
            stopFetchingTimer()
        case .failure(let errorMessage):
            statusLabel.text = errorMessage
            statusLabel.isHidden = false
            stopFetchingTimer()
        }
    }

    private func startFetchingTimer() {
        stopFetchingTimer()
        fetchingDotsCount = 0
        fetchingTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateFetchingLabel), userInfo: nil, repeats: true)
    }

    private func stopFetchingTimer() {
        fetchingTimer?.invalidate()
        fetchingTimer = nil
    }

    @objc private func updateFetchingLabel() {
        fetchingDotsCount = (fetchingDotsCount + 1) % 4
        let dots = String(repeating: ".", count: fetchingDotsCount)
        statusLabel.text = "Fetching Data\(dots)"
    }

    deinit {
        stopFetchingTimer()
    }
}
