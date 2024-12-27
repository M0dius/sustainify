// StoreDetailsViewController.swift
import UIKit

class StoreDetailsViewController: UIViewController,
                                 UITableViewDataSource,
                                 UITableViewDelegate,
                                 UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    // The store passed from HomeViewController
    var store: Store?
    
    // Search bar & dropdown data
    private let searchBar = UISearchBar()
    private var dropdownTableView: UITableView!
    private var isDropdownVisible = false
    private var isFilterDropdownVisible = false

    // Data for search and filter dropdown
    private var dropdownItems: [StoreItem] = []
    private var filteredDropdownItems: [StoreItem] = []
    private let filterOptions = ["A-Z", "Z-A", "Price: Low-High", "Price: High-Low"]

    private var filterDropdownTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let store = store {
            self.title = store.name
        }
        
        setupSearchBar()
        setupMainTableView()
        setupDropdowns()
    }
    
    // MARK: - Search Bar
    func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search items..."
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        
        let filterButton = UIBarButtonItem(title: "Filter",
                                            style: .plain,
                                            target: self,
                                            action: #selector(toggleFilterDropdown))
        navigationItem.rightBarButtonItem = filterButton
    }
    
    @objc private func toggleFilterDropdown() {
        isFilterDropdownVisible.toggle()
        filterDropdownTableView.isHidden = !isFilterDropdownVisible
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let store = store else { return }
        
        if searchText.isEmpty {
            dropdownItems = []
            isDropdownVisible = false
        } else {
            dropdownItems = store.allStoreItems.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
            isDropdownVisible = !dropdownItems.isEmpty
        }
        
        dropdownTableView.isHidden = !isDropdownVisible
        dropdownTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dropdownItems = []
        isDropdownVisible = false
        dropdownTableView.isHidden = true
        searchBar.resignFirstResponder()
    }

    // MARK: - Main TableView
    func setupMainTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200

        tableView.register(StoreInfoTableViewCell.self,
                           forCellReuseIdentifier: "storeInfoCell")
        
        tableView.register(BestSellingItemsTableViewCell.self,
                           forCellReuseIdentifier: "bestSellingCell")
        
        tableView.register(AllItemsTableViewCell.self,
                           forCellReuseIdentifier: "allItemsCell")
    }

    // MARK: - Dropdown Setup
    func setupDropdowns() {
        // Search Dropdown
        dropdownTableView = UITableView()
        dropdownTableView.dataSource = self
        dropdownTableView.delegate = self
        dropdownTableView.register(DropdownItemCell.self,
                                   forCellReuseIdentifier: "dropdownCell")
        dropdownTableView.translatesAutoresizingMaskIntoConstraints = false
        dropdownTableView.isHidden = true
        dropdownTableView.layer.borderWidth = 1
        dropdownTableView.layer.borderColor = UIColor.lightGray.cgColor
        dropdownTableView.layer.cornerRadius = 5
        view.addSubview(dropdownTableView)

        NSLayoutConstraint.activate([
            dropdownTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            dropdownTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            dropdownTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            dropdownTableView.heightAnchor.constraint(equalToConstant: 200)
        ])

        // Filter Dropdown
        filterDropdownTableView = UITableView()
        filterDropdownTableView.dataSource = self
        filterDropdownTableView.delegate = self
        filterDropdownTableView.register(UITableViewCell.self, forCellReuseIdentifier: "filterCell")
        filterDropdownTableView.translatesAutoresizingMaskIntoConstraints = false
        filterDropdownTableView.isHidden = true
        filterDropdownTableView.layer.borderWidth = 1
        filterDropdownTableView.layer.borderColor = UIColor.lightGray.cgColor
        filterDropdownTableView.layer.cornerRadius = 5
        view.addSubview(filterDropdownTableView)

        NSLayoutConstraint.activate([
            filterDropdownTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            filterDropdownTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            filterDropdownTableView.widthAnchor.constraint(equalToConstant: 150),
            filterDropdownTableView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    // MARK: - UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == dropdownTableView {
            return dropdownItems.count
        } else if tableView == filterDropdownTableView {
            return filterOptions.count
        } else {
            return 3 // Store Info, Best Selling, All Items
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == dropdownTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "dropdownCell", for: indexPath) as! DropdownItemCell
            let item = dropdownItems[indexPath.row]
            cell.configure(itemImage: UIImage(named: item.imageName), itemName: item.name, itemPrice: item.price)
            return cell
        } else if tableView == filterDropdownTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "filterCell", for: indexPath)
            cell.textLabel?.text = filterOptions[indexPath.row]
            return cell
        } else {
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "storeInfoCell", for: indexPath) as! StoreInfoTableViewCell
                if let store = store {
                    cell.configure(with: store)
                }
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "bestSellingCell", for: indexPath) as! BestSellingItemsTableViewCell
                if let store = store {
                    cell.configure(with: store.bestSellingItems)
                }
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "allItemsCell", for: indexPath) as! AllItemsTableViewCell
                if let store = store {
                    cell.configure(with: store.allStoreItems)
                }
                return cell
            default:
                return UITableViewCell()
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == filterDropdownTableView {
            let selectedFilter = filterOptions[indexPath.row]
            applyFilter(selectedFilter)
            isFilterDropdownVisible = false
            filterDropdownTableView.isHidden = true
        } else if tableView == dropdownTableView {
            let selectedItem = dropdownItems[indexPath.row]
            print("Selected Item: \(selectedItem.name)")
            isDropdownVisible = false
            dropdownTableView.isHidden = true
        }
    }

    private func applyFilter(_ filter: String) {
        switch filter {
        case "A-Z":
            dropdownItems.sort { $0.name < $1.name }
        case "Z-A":
            dropdownItems.sort { $0.name > $1.name }
        case "Price: Low-High":
            dropdownItems.sort { $0.price < $1.price }
        case "Price: High-Low":
            dropdownItems.sort { $0.price > $1.price }
        default:
            break
        }
        dropdownTableView.reloadData()
    }
}
