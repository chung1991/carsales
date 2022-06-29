//
//  ViewController.swift
//  CarSales
//
//  Created by Chung EXI-Nguyen on 6/17/22.
//

import UIKit

// features
// 1. list all car summary
// 2. swipe to see all images of car

// MARK: Models

enum CarAddOnText {
    case text(String)
}

struct CarTextAddOnInfo {
    let text: CarAddOnText
}

struct CarImageAddOnInfo {
    let image: String
    let text: CarAddOnText
}

struct CarNumberAddOnInfo {
    let number: Int
    let text: CarAddOnText
}

struct CarCatalog {
    let id: Int
    let images: [String]
    let likeCount: Int
    let title: String
    let price: Int
    let miles: Int
    let location: String
    let phone: String
    let typeInfo: CarTextAddOnInfo
    let priceInfo: CarNumberAddOnInfo
    let addonInfo: [CarImageAddOnInfo]
}

// MARK: Services

struct CarCatalogService {
    
    struct Constants {
        static let noAccidentAddon = "noAccidentAddon"
        static let personalUseAddon = "personalUseAddon"
        static let carfaxOwnerAddon = "carfaxOwnerAddon"
        static let serviceHistoryAddon = "serviceHistoryAddon"
    }
    
    func getCatalogs() -> [CarCatalog] {
        var ans: [CarCatalog] = []
        for i in 0..<20 {
            let carId = Int.random(in: 1...3)
            let carYear = Int.random(in: 1999...2022)
            let carModelRepo = ["Toyota 4Runner", "Toyota RAV4", "TESLA MODEL S", "Honda Odyssey", "Nissan Altima", "Hyundai Sonata"]
            let locationRepo = ["Monroe, WA", "Auburn, WA", "Kent, WA", "Seattle, WA", "Tacoma, WA"]
            let phoneRepo = ["(360) 205-9220", "(720) 205-9220", "(452) 205-9220", "(561) 205-9220", "(723) 205-9220"]
            let typeInfoRepo = ["BEST SELLER", "PRICE DROP"]
            let greatValue = Int.random(in: 1000...4000)
            
            let catalog = CarCatalog(id: i,
                                     images: ["car\(carId)-1", "car\(carId)-2", "car\(carId)-3", "car\(carId)-4"],
                                     likeCount: Int.random(in: 5...15),
                                     title: "\(carYear) \(carModelRepo.randomElement()!)",
                                     price: Int.random(in: 20000...50000),
                                     miles: Int.random(in: 1000...100000),
                                     location: locationRepo.randomElement()!,
                                     phone: phoneRepo.randomElement()!,
                                     typeInfo: CarTextAddOnInfo(text: CarAddOnText.text(typeInfoRepo.randomElement()!)),
                                     priceInfo: CarNumberAddOnInfo(number: greatValue,
                                                                   text: CarAddOnText.text("CARFAX Value")),
                                     addonInfo: getAddonInfo(i))
            ans.append(catalog)
        }
        return ans
    }
    
    func getAddonInfo(_ catalog: Int) -> [CarImageAddOnInfo] {
        var info: [CarImageAddOnInfo] = []
        info.append(CarImageAddOnInfo(image: "tick",
                                      text: CarAddOnText.text("No Accident Or Damage Reported")))
        info.append(CarImageAddOnInfo(image: "house",
                                      text: CarAddOnText.text("Personal Use")))
        info.append(CarImageAddOnInfo(image: "carfax",
                                      text: CarAddOnText.text("CARFAX 1-Owner")))
        let sericeHistoryCount = Int.random(in: 1...3)
        info.append(CarImageAddOnInfo(image: "wrench",
                                      text: CarAddOnText.text("\(sericeHistoryCount) Service History Records")))
        return info
    }
}

// MARK: View Models

protocol ViewModelDelegate: AnyObject {
    func didSetData()
}

struct ViewModel {
    var data: [CarCatalog] = [] {
        didSet {
            delegate?.didSetData()
        }
    }
    weak var delegate: ViewModelDelegate?
    let service = CarCatalogService()
    
    mutating func load() {
        data = service.getCatalogs()
    }
}

// MARK: Custom Cells

class CarCatalogViewCell: UITableViewCell {
    static let id = "CarCatalogViewCell"
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupAutolayout()
        setupDelegates()
    }
    
    var catalog: CarCatalog?
    
    lazy var carImageView: MultiImageView = {
        let imageView = MultiImageView(frame: contentView.bounds)
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    lazy var typeInfoLabel: UILabel = {
        let label = PaddingLabel(withInsets: 5, 5, 10, 10)
        return label
    }()
    
    lazy var likeCountLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var heartImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var mileLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var locationLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var greatValue: UILabel = {
        let label = PaddingLabel(withInsets: 5, 5, 5, 5)
        return label
    }()
    
    lazy var greatValueBelow: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var greatValueTitle: UILabel = {
        let label = UILabel()
        return label
    }()
    
    struct Constants {
        static let collectionViewPadding = 20.0
        static let itemHeight = 30.0
    }
    
    lazy var collectionView: UICollectionView = {
        var width = frame.width
        let padding = Constants.collectionViewPadding
        let itemWidth = (width - (padding * 2.0)) / 2.0
        let itemHeight = Constants.itemHeight
        let itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = itemSize
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        let collectionView = UICollectionView(frame: bounds,
                                              collectionViewLayout: layout)
        return collectionView
    }()
    
    lazy var horizontalSeparator: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor(displayP3Red: 191.0/255.0,
                                         green: 191.0/255.0,
                                         blue: 194.0/255.0,
                                         alpha: 1.0)
        return uiView
    }()
    
    lazy var phoneButton: ViewButton = {
        let button = ViewButton()
        return button
    }()
    
    lazy var verticalSeparator: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor(displayP3Red: 191.0/255.0,
                                         green: 191.0/255.0,
                                         blue: 194.0/255.0,
                                         alpha: 1.0)
        return uiView
    }()
    
    lazy var availabiltyButton: ViewButton = {
        let button = ViewButton()
        return button
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        carImageView.image = nil
        typeInfoLabel.text = nil
        likeCountLabel.text = nil
        heartImageView.image = nil
        titleLabel.text = nil
        priceLabel.text = nil
        mileLabel.text = nil
        locationLabel.text = nil
        greatValue.text = nil
        greatValueBelow.text = nil
        greatValueTitle.text = nil
        phoneButton.button.setTitle(nil, for: .normal)
        availabiltyButton.button.setTitle(nil, for: .normal)
    }
    
    func configure(_ catalog: CarCatalog) {
        self.catalog = catalog
        carImageView.configureData(catalog.images)
        switch catalog.typeInfo.text {
            case .text(let str):
            typeInfoLabel.text = str
        }
        likeCountLabel.text = "\(catalog.likeCount)"
        heartImageView.image = UIImage(systemName: "heart",
                                       withConfiguration: UIImage.SymbolConfiguration(pointSize: 16,
                                                                                      weight: .bold))
        titleLabel.text = catalog.title
        priceLabel.text = "$\(catalog.price)"
        mileLabel.text = "| \(catalog.miles) mi"
        locationLabel.text = "| \(catalog.location)"
        greatValue.text = "GREAT VALUE"
        greatValueBelow.text = "$\(catalog.priceInfo.number) below"
        switch catalog.priceInfo.text {
            case .text(let str):
            greatValueTitle.text = str
        }
        collectionView.reloadData()
        phoneButton.button.setTitle(catalog.phone, for: .normal)
        availabiltyButton.button.setTitle("CHECK AVAILABILITY", for: .normal)
    }
    
    func setupViews() {
        contentView.addSubview(carImageView)
        
        typeInfoLabel.backgroundColor = UIColor(displayP3Red: 82.0/255.0,
                                                green: 122.0/255.0,
                                                blue: 67.0/255.0,
                                                alpha: 1.0)
        typeInfoLabel.textColor = .white
        typeInfoLabel.font = .systemFont(ofSize: 14, weight: .bold)
        typeInfoLabel.textAlignment = .left
        carImageView.addSubview(typeInfoLabel)
        
        likeCountLabel.textColor = .white
        likeCountLabel.font = .systemFont(ofSize: 16, weight: .bold)
        likeCountLabel.textAlignment = .right
        carImageView.addSubview(likeCountLabel)
        
        heartImageView.tintColor = .white
        carImageView.addSubview(heartImageView)
        
        contentView.addSubview(titleLabel)
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.textAlignment = .left
        
        contentView.addSubview(priceLabel)
        priceLabel.font = .systemFont(ofSize: 18, weight: .bold)
        priceLabel.textAlignment = .left
        
        contentView.addSubview(mileLabel)
        mileLabel.font = .systemFont(ofSize: 18, weight: .thin)
        mileLabel.textAlignment = .left
        
        contentView.addSubview(locationLabel)
        locationLabel.font = .systemFont(ofSize: 18, weight: .thin)
        locationLabel.textAlignment = .left
        
        contentView.addSubview(greatValue)
        greatValue.textColor = .white
        greatValue.font = .systemFont(ofSize: 14, weight: .bold)
        greatValue.textAlignment = .left
        greatValue.backgroundColor = UIColor(displayP3Red: 17.0/255.0,
                                             green: 76.0/255.0,
                                             blue: 31.0/255.0,
                                             alpha: 1.0)
        
        contentView.addSubview(greatValueBelow)
        greatValueBelow.textColor = UIColor(displayP3Red: 17.0/255.0,
                                            green: 76.0/255.0,
                                            blue: 31.0/255.0,
                                            alpha: 1.0)
        greatValueBelow.font = .systemFont(ofSize: 12, weight: .medium)
        greatValueBelow.textAlignment = .left
        
        contentView.addSubview(greatValueTitle)
        greatValueTitle.font = .systemFont(ofSize: 12, weight: .light)
        greatValueTitle.textAlignment = .left
        
        contentView.addSubview(collectionView)
        collectionView.register(AddOnCell.self, forCellWithReuseIdentifier: "cell")
        
        contentView.addSubview(horizontalSeparator)
        

        contentView.addSubview(phoneButton)
        phoneButton.button.setTitleColor(UIColor(displayP3Red: 0.0/255.0,
                                          green: 67.0/255.0,
                                          blue: 147.0/255.0,
                                          alpha: 1.0),
                                  for: .normal)
        
        contentView.addSubview(verticalSeparator)
        
        contentView.addSubview(availabiltyButton)
        availabiltyButton.button.setTitleColor(UIColor(displayP3Red: 0.0/255.0,
                                          green: 67.0/255.0,
                                          blue: 147.0/255.0,
                                          alpha: 1.0),
                                        for: .normal)
    }
    
    func setupAutolayout() {
        carImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            carImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0),
            carImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0),
            carImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0),
            carImageView.heightAnchor.constraint(equalToConstant: 200.0)
        ])
        
        typeInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            typeInfoLabel.topAnchor.constraint(equalTo: carImageView.topAnchor, constant: 0.0),
            typeInfoLabel.leadingAnchor.constraint(equalTo: carImageView.leadingAnchor, constant: 0.0)
        ])
        
        heartImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heartImageView.topAnchor.constraint(equalTo: carImageView.topAnchor, constant: 12.0),
            heartImageView.trailingAnchor.constraint(equalTo: carImageView.trailingAnchor, constant: -10.0)
        ])
        
        likeCountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            likeCountLabel.centerYAnchor.constraint(equalTo: heartImageView.centerYAnchor),
            likeCountLabel.trailingAnchor.constraint(equalTo: heartImageView.leadingAnchor, constant: -5.0)
        ])
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: carImageView.bottomAnchor, constant: 10.0),
            titleLabel.leadingAnchor.constraint(equalTo: carImageView.leadingAnchor, constant: 10.0),
            titleLabel.trailingAnchor.constraint(equalTo: carImageView.trailingAnchor, constant: 0.0)
        ])
        
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5.0),
            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor)
        ])
        
        mileLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mileLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5.0),
            mileLabel.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 5.0)
        ])

        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5.0),
            locationLabel.leadingAnchor.constraint(equalTo: mileLabel.trailingAnchor, constant: 5.0)
        ])
        
        greatValue.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            greatValue.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 10.0),
            greatValue.leadingAnchor.constraint(equalTo: priceLabel.leadingAnchor, constant: 0.0)
        ])
        
        greatValueBelow.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            greatValueBelow.centerYAnchor.constraint(equalTo: greatValue.centerYAnchor),
            greatValueBelow.leadingAnchor.constraint(equalTo: greatValue.trailingAnchor, constant: 10.0)
        ])
        
        greatValueTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            greatValueTitle.centerYAnchor.constraint(equalTo: greatValue.centerYAnchor),
            greatValueTitle.leadingAnchor.constraint(equalTo: greatValueBelow.trailingAnchor, constant: 5.0)
        ])
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let padding = Constants.collectionViewPadding
        let height = Constants.itemHeight * 2
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: greatValue.bottomAnchor, constant: 10.0),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            collectionView.heightAnchor.constraint(equalToConstant: height)
        ])
        
        horizontalSeparator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            horizontalSeparator.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 5.0),
            horizontalSeparator.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor, constant: 0.0),
            horizontalSeparator.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor, constant: 0.0),
            horizontalSeparator.heightAnchor.constraint(equalToConstant: 1.0)
        ])
        
        verticalSeparator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            verticalSeparator.topAnchor.constraint(equalTo: horizontalSeparator.bottomAnchor, constant: 0.0),
            verticalSeparator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            verticalSeparator.widthAnchor.constraint(equalToConstant: 1.0),
            verticalSeparator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0.0)
        ])
        
        phoneButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            phoneButton.topAnchor.constraint(equalTo: horizontalSeparator.bottomAnchor, constant: 0.0),
            phoneButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0.0),
            phoneButton.trailingAnchor.constraint(equalTo: verticalSeparator.leadingAnchor, constant: 0.0),
            phoneButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0.0)
        ])
        
        availabiltyButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            availabiltyButton.topAnchor.constraint(equalTo: horizontalSeparator.bottomAnchor, constant: 0.0),
            availabiltyButton.leadingAnchor.constraint(equalTo: verticalSeparator.trailingAnchor, constant: 0.0),
            availabiltyButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0.0),
            availabiltyButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0.0)
        ])
    }
    
    func setupDelegates() {
        collectionView.dataSource = self
    }
}

extension CarCatalogViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return catalog?.addonInfo.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? AddOnCell,
        let catalog = catalog else {
            return UICollectionViewCell()
        }
        
        let addonInfo = catalog.addonInfo[indexPath.row]
        cell.configure(addonInfo)
        return cell
    }
}

class AddOnCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let title: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10.0, weight: .thin)
        label.numberOfLines = 2
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupAutolayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        title.text = nil
        imageView.image = nil
    }
    
    func configure(_ addon: CarImageAddOnInfo) {
        switch addon.text {
        case .text(let str):
            title.text = str
        }
        imageView.image = UIImage(named: addon.image)
    }
    
    func setupViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(title)
    }
    
    func setupAutolayout() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0.0),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.widthAnchor.constraint(lessThanOrEqualTo: contentView.heightAnchor, multiplier: 0.8)
        ])
        
        title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10.0),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0.0),
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

// MARK: Custom UI

class MultiImageView: UIImageView {
    var data: [String] = []
    var dataIndex = -1
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDelegates()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupDelegates() {
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(didTap))
        tapRecognizer.numberOfTouchesRequired = 1
        addGestureRecognizer(tapRecognizer)
    }
    
    @objc func didTap() {
        guard dataIndex != -1 else { return }
        dataIndex = (dataIndex + 1) % data.count
        image = UIImage(named: data[dataIndex])
    }
    
    func configureData(_ data: [String]) {
        guard data.count > 0 else { return }
        self.data = data
        dataIndex = 0
        image = UIImage(named: data[dataIndex])
    }
}

class PaddingLabel: UILabel {
    var topInset: CGFloat
    var bottomInset: CGFloat
    var leftInset: CGFloat
    var rightInset: CGFloat
    
    required init(withInsets top: CGFloat, _ bottom: CGFloat, _ left: CGFloat, _ right: CGFloat) {
        self.topInset = top
        self.bottomInset = bottom
        self.leftInset = left
        self.rightInset = right
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += topInset + bottomInset
            contentSize.width += leftInset + rightInset
            return contentSize
        }
    }
    
}

class ViewButton: UIView {
    lazy var button: UIButton = {
        let uiButton = UIButton()
        return uiButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupAutolayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(button)
        button.titleLabel?.font = .systemFont(ofSize: 10, weight: .bold)
    }
    
    func setupAutolayout() {
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: View

class ViewController: UIViewController {
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.allowsSelection = false
        return tableView
    }()
    
    var viewModel = ViewModel()
    let dispatchQueue = DispatchQueue.main
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupAutolayout()
        setupDelegates()
        viewModel.load()
    }
    
    func setupViews() {
        view.addSubview(tableView)
        tableView.register(CarCatalogViewCell.self, forCellReuseIdentifier: CarCatalogViewCell.id)
    }
    
    func setupAutolayout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0)
        ])
    }
    
    func setupDelegates() {
        viewModel.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 420
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CarCatalogViewCell.id,
                                                       for: indexPath) as? CarCatalogViewCell else {
            return UITableViewCell()
        }
        let catalog = viewModel.data[indexPath.row]
        cell.configure(catalog)
        return cell
    }
}

extension ViewController: ViewModelDelegate {
    func didSetData() {
        dispatchQueue.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}
