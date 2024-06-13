//
//  MainViewController.swift
//  MoviesApp
//
//  Created by Admin on 12/06/24.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var pickerViewContainer: UIView!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    private var pickerOptions = ["Adult", "Original lenguage", "Vote average"]
    
    private var selectedRow = 0
    
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
        viewModel.getPopularMovies()
    }
    
    // MARK: - Methods
    
    private func setupUI() {
        title = "Popular"
        setSegmentedControlAppearence()
        configureTableView()
        configurePickerView()
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
    
    private func hidePickerComponents(isHidden: Bool) {
        pickerViewContainer.isHidden = isHidden
        backgroundView.isHidden = isHidden
    }
    
    private func setupBindings() {
        viewModel.outputEvents.observe { [weak self] event in
            self?.validateEvents(event: event)
        }
        adapter.didSelectRowAt.observe { [unowned self] anime in
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
            //segmentedControl.isEnabled = true
        case .errorMessage(let error):
            print(error)
            //showAlert(title: "Error", message: "Has been ocurred fetching anime list.")
        }
    }
    
    private func filtersMovies(selectedRow: Int) {
        switch selectedRow {
        case 0:
            viewModel.movies = viewModel.movies.filter({ $0.adult == true})
            tableView.reloadData()
        case 1:
            print("One")
        case 2:
            print("Two")
        default:
            break
        }
    }
    
    // MARK: - Actions
    
    @IBAction func filtersButtonAction(_ sender: Any) {
        hidePickerComponents(isHidden: false)
    }

    
    @IBAction private func segmentedControlAction(_ sender: Any) {
        //segmentedControl.isEnabled = false
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            title = "Popular"
            viewModel.getPopularMovies()
        case 1:
            title = "Top Rated"
            viewModel.movies = []
            tableView.reloadData()
        default:
            break
        }
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        hidePickerComponents(isHidden: true)
    }
    
    @IBAction func doneButtonAction(_ sender: Any) {
        hidePickerComponents(isHidden: true)
        filtersMovies(selectedRow: selectedRow)
    }
    
}

extension MainViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        pickerOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        30
    }
    
}

extension MainViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerOptions.count
    }
    
}
