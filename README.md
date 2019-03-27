# MiniPhotos

## Collection View’s datasource composition
<p align="center">
<img src="https://user-images.githubusercontent.com/18760280/55086589-05200800-50ec-11e9-8ffc-69f7a30969bd.png">
</p>

<p align="center">
<img src="https://user-images.githubusercontent.com/18760280/55086590-05b89e80-50ec-11e9-8002-c3eaa2d9f0a5.png">
</p>

Each collectionView of the app is the result of a filtering option for the existing photos on the device.
CollectionView B is the result of compartmentalization separated by one or two days time range. It’s the most narrow time range that Photos app express, making it a detailed and narrowed view of the photos on the device, having four maximum photos take the whole width of the device.
CollectionView A a couple of weeks time range. It’s a birds eyes view of the photos on the device, having ten maximum photos for the device.
One thing I notice about CollectionView A is that it has either 1 to 10, 20, 30, 40, 50 photos for one row. 
If the number of photos that fall into a section is more than 50, it randomly chooses 50 photos to populate the section and discards the rest. Similarly, if the number of photos are 13, 10 photos are randomly chosen to populate the section and discards the rest.

## Collection View’s content position leveling for zooming-in

A collection of small cells makes CollectionView A while a collection of bigger cells makes CollectionView B.
A CollectionView A cell begins transitioning into a CollectionView B cell with a highly coordinated animation when it is tapped. After the animation, you notice the cells are all rearranged and the photo you just tapped has become bigger under the finger.

<p align="center">
<img src="https://user-images.githubusercontent.com/18760280/55086591-05b89e80-50ec-11e9-9b32-812cba29b800.png">
</p>

This position leveling doesn’t happen by itself.
You have to do some efforts to maneuver the scroll to accomplish that.

1. learn how the indexPath of Photo of interest in CollectionViewA is translated into indexPath of CollectionViewB.
2. call collectionView B’s scrollToItem(at:indexPath) with {left, top} option.
3. decrement collectionView B’s contentOffset y value by h as illustrated in the picture below.

<p align="center">
<img src="https://user-images.githubusercontent.com/18760280/55086592-05b89e80-50ec-11e9-9d20-57936f677b80.png">
</p>

## Coordinating zooming-in animation
Some cells crowded out towards the outside of the view. Some cells simply arrives to the destination position. Some cells are reloaded along the transition. If these are put together, it creates a smooth zooming-in effect. My current goal is to accomplish the same effect after rigorously observing what Photos app do.
