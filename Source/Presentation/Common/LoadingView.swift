//  Copyright © 2020 Saqib Saud. All rights reserved.

import UIKit

class LoadingView: UIView {
    var container: UIView = {
        let view =  UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var subContainer: UIView = {
        let view =  UIView()
        view.layer.cornerRadius = 5.0
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.tertiarySystemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 0
        textLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        textLabel.textColor = UIColor.darkGray
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.text = "Loading..."
        return textLabel
    }()

    lazy var activityIndicatorView: UIActivityIndicatorView = {
       let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.style = .large
        activityIndicatorView.color = .systemBlue
        return activityIndicatorView
    }()

    lazy var blurEffectView: UIVisualEffectView = {
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blurView.translatesAutoresizingMaskIntoConstraints = false
        return blurView
    }()

    override init(frame: CGRect) {
      super.init(frame: frame)
      setupView()
    }

    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      setupView()
    }

    private func setupView() {
        setupViewConstraints()
    }

    func show() {
        // only apply the blur if the user has not disabled transparency effects
        if !UIAccessibility.isReduceTransparencyEnabled {
            container.backgroundColor = UIColor.clear
            container.addSubview(blurEffectView)
            container.sendSubviewToBack(blurEffectView)

            blurEffectView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
            blurEffectView.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
            blurEffectView.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
            blurEffectView.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        } else {
            container.backgroundColor = UIColor.black.withAlphaComponent(0.85)
        }

        activityIndicatorView.startAnimating()

        container.alpha = 0.0
        UIView.animate(withDuration: 0.5, animations: {
            self.container.alpha = 1.0
        })
    }

    func hide() {
        UIView.animate(withDuration: 0.5, animations: {
            self.container.alpha = 0.0
        })
    }

    func updateProgressTitle(_ title: String?) {
        textLabel.text = title
    }

    private func setupViewConstraints() {
        addSubview(container)
        container.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        container.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        container.topAnchor.constraint(equalTo: topAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        container.addSubview(subContainer)

        subContainer.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        subContainer.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true

        let stackView   = UIStackView(arrangedSubviews: [activityIndicatorView, textLabel])
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layoutMargins = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)

        subContainer.addSubview(stackView)

        stackView.topAnchor.constraint(equalTo: subContainer.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: subContainer.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: subContainer.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: subContainer.trailingAnchor).isActive = true
        stackView.widthAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
    }
}
