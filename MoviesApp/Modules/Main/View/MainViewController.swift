//
//  MainViewController.swift
//  MoviesApp
//
//  Created by Lesly Higuera on 12/06/24.
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
    
    private let adultOptions = ["No", "Yes"]
    private let languageOptions = ["en", "es", "fr", "it", "pt", "ko", "ja", "zh", "th", "hi"]
    private let voteOptions = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    
    private var adultSelectedRow = 0
    private var lenguageSelectedRow = 0
    private var voteSelectedRow = 0
    
    var viewModel: MainViewModel
    var router: MainRouter
    
    lazy var adapter = MainAdapter(viewModel: viewModel)
    
    // MARK: - Initializers
    
    init(viewModel: MainViewModel, router: MainRouter) {
        self.viewModel = viewModel
        self.router = router
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
        setClearFiltersButtonBorders()
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
    
    private func resetPickerViewPositions() {
        pickerView.selectRow(0, inComponent: 0, animated: true)
        pickerView.selectRow(0, inComponent: 1, animated: true)
        pickerView.selectRow(0, inComponent: 2, animated: true)
    }
    
    private func setClearFiltersButtonBorders() {
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
            router.goToMovieDetails(movie: movie)
        }
    }
    
    private func validateEvents(event: MainViewModelOutput) {
        switch event {
        case .isLoading(let isLoading):
            showLoadingView(isLoading: isLoading)
        case .didGetData:
            tableView.reloadData()
            segmentedControl.isEnabled = true
        case .errorMessage(_):
            showAlert(title: "Error", message: "Has been ocurred fetching movie list")
        case .emptySearch(let emptySearch):
            viewModel.emptySearchBehaviour(isEmptySearch: emptySearch)
        case .emptySearchResults(_):
            showAlert(title: "Without results", message: "No results found for the search, try again")
        case .emptyFiltersResults:
            clearFiltersButton.isHidden = true
            showAlert(title: "Warning", message: "We did not find results for your search, try again")
        }
    }
    
    private func showLoadingView(isLoading: Bool) {
        isLoading ? loadingView.startAnimating() : loadingView.stopAnimating()
        loadingView.isHidden = isLoading ? false : true
    }
    
    // MARK: - Actions
    
    @IBAction private func filtersButtonAction(_ sender: Any) {
        hidePickerComponents(isHidden: false)
        clearFiltersButton.isHidden = true
    }

    
    @IBAction private func segmentedControlAction(_ sender: Any) {
        segmentedControl.isEnabled = false
        clearFiltersButton.isHidden = true
        searchTextField.text = ""
        
        title = viewModel.segmentedControlActionWithTitle(selectedSegmentIndex: segmentedControl.selectedSegmentIndex)
    }
    
    @IBAction private func cancelButtonAction(_ sender: Any) {
        hidePickerComponents(isHidden: true)
        
        clearFiltersButton.isHidden = viewModel.isFiltering ? false : true
    }
    
    @IBAction private func doneButtonAction(_ sender: Any) {
        hidePickerComponents(isHidden: true)
        clearFiltersButton.isHidden = false
        
        viewModel.searchStateBy(text: searchTextField.text ?? "")
        
        viewModel.searchBehaviourWhenIsFiltering(searchText: searchTextField.text ?? "")

        DispatchQueue.main.asyncAfter(deadline: .now() + (viewModel.isFiltering ? 1.5 : 0), execute: { [self] in
            self.viewModel.filterMovies(languageOptions: self.languageOptions, voteOptions: voteOptions, adultSelectedRow: adultSelectedRow, lenguageSelectedRow: lenguageSelectedRow, voteSelectedRow: voteSelectedRow)
        })
    }
    
    @IBAction private func clearFiltersButtonAction(_ sender: Any) {
        viewModel.isFiltering = false
        clearFiltersButton.isHidden = true
        searchTextField.text = ""
        resetPickerViewPositions()
        viewModel.clearAndReloadMovies()
    }
    
}

// MARK: - UIPickerViewDelegate
extension MainViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return adultOptions[row]
        case 1:
            return languageOptions[row]
        case 2:
            return voteOptions[row]
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
            voteSelectedRow = row
        default:
             break
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        30
    }
    
}

// MARK: - UIPickerViewDataSource
extension MainViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return adultOptions.count
        case 1:
            return languageOptions.count
        case 2:
            return voteOptions.count
        default:
            return 0
        }
    }
    
}

// MARK: - UITextFieldDelegate
extension MainViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        clearFiltersButton.isHidden = true
        viewModel.textFieldDidChangeSelection(text: textField.text)
    }
    
}
