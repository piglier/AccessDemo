//
//  ViewController.swift
//  GitHubDemo
//
//  Created by 朱彥睿 on 2024/8/17.
//

import UIKit
import Combine
import ComposableArchitecture

class ListViewController: UIViewController {

    lazy var listVM: ViewStoreOf<ListViewModel> = ViewStoreOf<ListViewModel>(listStore, observe: { $0 })
    lazy var profileVS: ViewStoreOf<ProfileReducer> = ViewStoreOf<ProfileReducer>(profileStore, observe: { $0 })
    
    var presentPofileView: ((StoreOf<ProfileReducer>) -> Void)?
    
    private var combineLastest: AnyCancellable?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bindingStyle()
        bindingUI()
        binding()
        listVM.send(.viewDidLoad)
    }
    

    // private fucntion
    private func bindingStyle() {
        view.backgroundColor = .white
    }
    
    private func bindingUI() {
        self.view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.setCollectionViewLayout(createLayout(), animated: false)
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.register(UserListCell.self, forCellWithReuseIdentifier: "UserListCell")
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func binding() {
        listVM.publisher.users.removeDuplicates().sink { [weak self] users in
            guard let self = self else { return }
            var snapshot = NSDiffableDataSourceSnapshot<Section, User>()
            snapshot.appendSections([.main])
            snapshot.appendItems(users, toSection: .main)
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }.store(in: &cancelables)
    }
    
    
    // private property
    private var listStore: StoreOf<ListViewModel> = Store(initialState: ListViewModel.State(), reducer: { ListViewModel() })
    private var profileStore: StoreOf<ProfileReducer> = Store(initialState: ProfileReducer.State(), reducer: { ProfileReducer() })
    private var cancelables: [AnyCancellable] = []
    private let basicThreshold = 700
    
    private enum Section: Hashable {
        case main
    }
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private lazy var dataSource = UICollectionViewDiffableDataSource<Section, User>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserListCell", for: indexPath) as! UserListCell
        cell.populate(user: itemIdentifier)
        return cell
    }
}

extension ListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if listVM.state.users.count > indexPath.row {
            let login = listVM.state.users[indexPath.row].login
            profileVS.send(.fetch(login))
            guard let present = presentPofileView else { return }
            present(profileStore)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetHeight = scrollView.contentOffset.y
        guard offsetHeight > 0 else { return }
        let state = listVM.state
        let callNextApiThreshold = basicThreshold + (state.loadedPage - 1) * 2000
        if !state.isFetching && offsetHeight > CGFloat(callNextApiThreshold) {
            let willLoadingSince = listVM.state.loadedPage * 20 + 1
            listVM.send(.paginated(since: willLoadingSince))
        }
    }
}
