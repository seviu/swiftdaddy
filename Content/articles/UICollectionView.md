---
date: 2020-08-01 09:41
description: iOS 14 Cell Registration
tags: uikit
---

## UICollectionView CellRegistration

Back before **iOS 14** if you want to dequeue a cell for reuse you needed to register it first. It was a tedious two step process which we all are used to.

Register 
```swift
collectionView.register(Cell.self, forCellWithReuseIdentifier: "Foo")
```

And dequeue
```swift
collectionView.dequeueReusableCell(withReuseIdentifier: "Foo", for: indexPath) as! Cell
```

iOS 14 brings us a very welcomed cell registration through an iOS 14 only UICollectionView extension:

```swift
public struct CellRegistration<Cell, Item> where Cell : UICollectionViewCell
```

If we are to make use of this new feature, we will need a data source. For our example we will use UICollectionViewDiffableDataSource available since iOS 13. 

iOS 14 gives us CellRegistration, a new mechanism to dequeue a reusable UICollectionViewCell.

We will need three elements when calling CellRegistration’s handle: 
    The UICollectionView where we render our cells.
    The Position of the cell: our IndexPath
    An Item, which is our model with all the information the cell will render: ItemIdentifierType. *Since we are using a diffable data source, it is important that our model adopts Hashable.*

UICollectionViewDiffableDataSource has as parameter a CellProvider, which is a closure that builds a UICollectionViewCell and has as all the elements needed to build our collection view an IndexPath and our Item, or model
```swift
UICollectionView, IndexPath and ItemIdentifierType (our model)
```
More on how to build it below.

As for UICollectionView we have now dequeueConfiguredReusableCell, which builds a  UICollectionViewCell. 

dequeueConfiguredReusableCell is special. It requires an IndexPath, an Item (our model) and a CellRegistration. CellRegistration is a struct which knows how to build and configure a UICollectionViewCell. It is initialised with a registration handler. This registration handler is a closure which accepts three parameters: Cell, IndexPath and Item. Cell must be a UICollectionViewCell and Item is our Model. 

> CellRegistration can also be built with a UINib. In that case the first parameter if its constructor is the nib, and the second one, the closure that configures our cell.

```swift
let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, MyAwesomeModel> 
{ (cell, indexPath, model) in
	var content = cell.defaultContentConfiguration()
	content.text = model.awesomeText
	cell.contentConfiguration = content
}
```

This CellRegistration's configuration handler is be called whenever we want to dequeue our reusable cell. 

```swift
dataSource = UICollectionViewDiffableDataSource<Section, Model>(collectionView: collectionView) 
{ (collectionView: UICollectionView, indexPath: IndexPath, item: Model) -> UICollectionViewCell? in
	collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
}
```        

 
 #### Easy isn't it?

So what happens is that our data source dequeues through dequeueConfiguredReusableCell a cell, passing a CellRegistration, an IndexPath and an Item (our model) and CellRegistration calls  it's closure, which configures the UICollectionViewCell according to our model and the index path.

### But why is this better?

Traditionally we always dequeue reusable cells with an identifier 
```swift
collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath)
``` 
which we need to registered before
```
swift collectionView.register(MyCell.self, forCellWithReuseIdentifier: "MyCell")
```

Now our data source (diffable or not) just needs to call collectionView.dequeueConfiguredReusableCell and that takes care of it all... Provided you have a CellRegistration, which is the element that binds everything together.

The separation is clear, and it is now possible to have a central place where we define how our cells are being set up.

> But there is even more. We can apply all this to Supplementary Views such as headers or  footers. Apple's WWDC sample code has even examples for badges that are rendered on top of our cells. For this we have a new UICollectionView function called dequeueConfiguredReusableSupplementary that behaves like dequeueConfiguredReusableCell but instead of returning a UICollectionViewCell returns a UICollectionReusableView
