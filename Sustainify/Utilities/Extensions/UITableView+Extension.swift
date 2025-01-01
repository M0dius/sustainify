//
//  UITableView+Extension.swift
//  Sustain
//
//  Created by Ganesh Raju Galla on 29/12/24.
//

import Foundation
import UIKit

// MARK: - ReusableView Protocol
protocol ReusableView: AnyObject {
    static var defaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}

// MARK: - NibLoadableView Protocol
protocol NibLoadableView: AnyObject {
    static var nibName: String { get }
}

extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return String(describing: self)
    }
}

// MARK: - UITableView Extension
extension UITableView {

    // MARK: - Register Methods

    /// Register a cell with a nib file
    /// - Parameter cell: UITableViewCell type to register
    func register<T: UITableViewCell>(_ cell: T.Type) where T: ReusableView, T: NibLoadableView {
        let nib = UINib(nibName: cell.nibName, bundle: nil)
        register(nib, forCellReuseIdentifier: cell.defaultReuseIdentifier)
    }

    /// Register a header/footer view with a nib file
    /// - Parameter reusableView: UITableViewHeaderFooterView type to register
    func registerHeaderFooter<T: UITableViewHeaderFooterView>(_ reusableView: T.Type) where T: ReusableView, T: NibLoadableView {
        let nib = UINib(nibName: reusableView.nibName, bundle: nil)
        register(nib, forHeaderFooterViewReuseIdentifier: reusableView.defaultReuseIdentifier)
    }

    // MARK: - Dequeue Methods

    /// Dequeue a reusable cell
    /// - Parameters:
    ///   - cell: UITableViewCell type
    ///   - indexPath: IndexPath
    /// - Returns: Dequeued UITableViewCell
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        return cell
    }

    /// Dequeue a reusable header/footer view
    /// - Parameter reusableView: UITableViewHeaderFooterView type
    /// - Returns: Dequeued UITableViewHeaderFooterView
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T? where T: ReusableView {
        return dequeueReusableHeaderFooterView(withIdentifier: T.defaultReuseIdentifier) as? T
    }

    // MARK: - Utility Methods

    /// Reload data with a completion handler
    /// - Parameter completion: Completion handler
    func reloadData(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion: { _ in
            completion()
        })
    }

    /// Set the height of the table header view
    /// - Parameter height: Desired height
    func setHeightTableHeaderView(height: CGFloat) {
        guard let headerView = tableHeaderView else { return }
        var frame = headerView.frame
        frame.size.height = height
        headerView.frame = frame
        tableHeaderView = headerView
    }

    /// Set the height of the table footer view
    /// - Parameter height: Desired height
    func setHeightTableFooterView(height: CGFloat) {
        guard let footerView = tableFooterView else { return }
        var frame = footerView.frame
        frame.size.height = height
        footerView.frame = frame
        tableFooterView = footerView
    }

    /// Hide the separator for the last cell
    func setLastCellSeparatorHidden() {
        tableFooterView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 0, height: 0.001)))
    }
}
