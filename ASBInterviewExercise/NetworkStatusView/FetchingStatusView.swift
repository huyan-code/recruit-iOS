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
    
    // on network errors, tap to trigger this callback
    var onReloadingRequest: (() -> Void)?
    
    var status: Status = .success {
        didSet {
            updateStatus()
        }
    }
    
    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.layer.cornerRadius = 8
        blurEffectView.clipsToBounds = true
        return blurEffectView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        // Add blur effect view
        addSubview(blurEffectView)
        blurEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // Add status label
        blurEffectView.contentView.addSubview(statusLabel)
        statusLabel.numberOfLines = 0
        statusLabel.textAlignment = .center
        statusLabel.textColor = .white
        statusLabel.font = UIFont.systemFont(ofSize: 16)
        
        statusLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }

    private func updateStatus() {
        let tip = "CHECK NETWORK SETTINGS, THEN TAP ME TO RELOAD."
        switch status {
        case .noNetwork:
            statusLabel.text = tip
            self.isHidden = false
            isUserInteractionEnabled = true
            stopFetchingTimer()
        case .fetching:
            startFetchingTimer()
            self.isHidden = false
            isUserInteractionEnabled = false
        case .success:
            self.isHidden = true
            isUserInteractionEnabled = false
            stopFetchingTimer()
        case .failure(let errorMessage):
            statusLabel.text = "\(errorMessage)\n\(tip)"
            self.isHidden = false
            isUserInteractionEnabled = true
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

    @objc private func handleTap() {
        switch status {
        case .noNetwork, .failure:
            onReloadingRequest?()
        case .fetching, .success:
            break
        }
    }

    deinit {
        stopFetchingTimer()
    }
}

