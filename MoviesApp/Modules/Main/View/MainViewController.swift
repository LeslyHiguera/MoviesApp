//
//  MainViewController.swift
//  MoviesApp
//
//  Created by Admin on 12/06/24.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var pickerView: UIPickerView!
    @IBOutlet private weak var pickerViewContainer: UIView!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var loadingView: UIActivityIndicatorView!
    @IBOutlet private weak var clearFiltersButton: UIButton!
    
    // MARK: - Properties
    
    private let adultPickerOptions = ["No", "Yes"]
    private let lenguagePickerOptions = ["en", "es", "fr", "it", "pt", "ko", "ja", "zh", "th", "hi"]
    private let voteAveragePickerOptions = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    
    private var adultSelectedRow = 0
    private var lenguageSelectedRow = 0
    private var voteAverageSelectedRow = 0
    
    var viewModel: MainViewModel
    
    lazy var adapter = MainAdapter(viewModel: viewModel)
    
    // MARK: - Initializers
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Controller lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.page = 1
        viewModel.getMovies()
    }
    
    // MARK: - Methods
    
    private func setupUI() {
        setupNavigationBar()
        searchTextField.delegate = self
        setSegmentedControlAppearence()
        configureTableView()
        configurePickerView()
        setClearFiltersButton()
    }
    
    private func setupNavigationBar() {
        title = "Popular"
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .redWineColor
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setSegmentedControlAppearence() {
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                   NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .semibold)]
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes, for: .selected)
    }
    
    private func configureTableView() {
        tableView.register(.init(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "movieTableViewCell")
        tableView.delegate = adapter
        tableView.dataSource = adapter
    }
    
    private func configurePickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    private func setClearFiltersButton() {
        clearFiltersButton.layer.cornerRadius = 6
        clearFiltersButton.layer.borderWidth = 1
        clearFiltersButton.layer.borderColor = UIColor.redWineColor.cgColor
    }
    
    private func hidePickerComponents(isHidden: Bool) {
        pickerViewContainer.isHidden = isHidden
        backgroundView.isHidden = isHidden
    }
    
    private func setupBindings() {
        viewModel.outputEvents.observe { [weak self] event in
            self?.validateEvents(event: event)
        }
        adapter.didSelectRowAt.observe { [unowned self] movie in
            // TODO: Acción cuando se da tap a una celda
        }
    }
    
    private func validateEvents(event: MainViewModelOutput) {
        switch event {
        case .isLoading(let isLoading):
            if isLoading {
                loadingView.startAnimating()
                loadingView.isHidden = false
            } else {
                loadingView.stopAnimating()
                loadingView.isHidden = true
            }
        case .didGetData:
            tableView.reloadData()
            segmentedControl.isEnabled = true
        case .errorMessage(let error):
            print(error)
            //showAlert(title: "Error", message: "Has been ocurred fetching anime list.")
        case .emptySearch(let emptySearch):
            if emptySearch {
                viewModel.isFiltering = false
                clearAndReloadMovies()
            }
        case .emptySearchResults(_):
            print("Alert")
            // show alert
        }
    }
    
    private func filterMovies(adultSelectedRow: Int, lenguageSelectedRow: Int, voteAverageSelectedRow: Int) {
        viewModel.isFiltering = true
        let isForAdults = adultSelectedRow == 0 ? false : true
        let lenguaje = lenguagePickerOptions[lenguageSelectedRow]
        let voteAverage = Int(voteAveragePickerOptions[voteAverageSelectedRow])
        
        let filteredMovies = viewModel.movies.filter({ $0.adult == isForAdults && $0.originalLanguage == lenguaje && Int($0.voteAverage ?? 0.0) == voteAverage })
        
        if filteredMovies.count > 0 {
            viewModel.movies = filteredMovies
            tableView.reloadData()
        } else {
            viewModel.isFiltering = false
            clearFiltersButton.isHidden = true
            showAlert(title: "Warning", message: "We did not find results for your search, try again")
            clearAndReloadMovies()
        }
    }
    
    private func clearAndReloadMovies() {
        viewModel.movies = []
        viewModel.page = 1
        viewModel.getMovies()
    }
    
    // MARK: - Actions
    
    @IBAction private func filtersButtonAction(_ sender: Any) {
        hidePickerComponents(isHidden: false)
        clearFiltersButton.isHidden = true
    }

    
    @IBAction private func segmentedControlAction(_ sender: Any) {
        segmentedControl.isEnabled = false
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            title = "Popular"
            viewModel.category = .popular
            clearAndReloadMovies()
        case 1:
            title = "Top Rated"
            viewModel.category = .topRated
            clearAndReloadMovies()
        default:
            break
        }
    }
    
    @IBAction private func cancelButtonAction(_ sender: Any) {
        hidePickerComponents(isHidden: true)
        
        clearFiltersButton.isHidden = viewModel.isFiltering ? false : true
    }
    
    @IBAction private func doneButtonAction(_ sender: Any) {
        hidePickerComponents(isHidden: true)
        clearFiltersButton.isHidden = false
        if viewModel.isFiltering {
            clearAndReloadMovies()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + (viewModel.isFiltering ? 1.5 : 0), execute: {
            self.filterMovies(adultSelectedRow: self.adultSelectedRow, lenguageSelectedRow: self.lenguageSelectedRow, voteAverageSelectedRow: self.voteAverageSelectedRow)
        })
    }
    
    @IBAction private func clearFiltersButtonAction(_ sender: Any) {
        viewModel.isFiltering = false
        clearFiltersButton.isHidden = true
        pickerView.selectRow(0, inComponent: 0, animated: true)
        pickerView.selectRow(0, inComponent: 1, animated: true)
        pickerView.selectRow(0, inComponent: 2, animated: true)
        clearAndReloadMovies()
    }
    
}

extension MainViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return adultPickerOptions[row]
        case 1:
            return lenguagePickerOptions[row]
        case 2:
            return voteAveragePickerOptions[row]
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            adultSelectedRow = row
        case 1:
            lenguageSelectedRow = row
        case 2:
            voteAverageSelectedRow = row
        default:
             break
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        30
    }
    
}

extension MainViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return adultPickerOptions.count
        case 1:
            return lenguagePickerOptions.count
        case 2:
            return voteAveragePickerOptions.count
        default:
            return 0
        }
    }
    
}

extension MainViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        viewModel.textFieldDidChangeSelection(text: textField.text)
    }
    
}
