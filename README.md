# kmean_Image_Segmentation
Using k-means algorithm to depict an image in terms of only k-colors

# Pseudo Code

1.	Create a class called Pxls (abb for pixels) to store a particular pixel’s location (x,y) and it’s color (r,g,b).
2.	Make an ArrayList of Pxls objects called data which I populated with Pxls objects of the given image.
3.	Select k distinct random points from the ArrayList data which served to be the initial centroids for the k-means algorithm.
4.	Make an ArrayList of ArrayList of Pxls object to hold k-clusters of data together.
5.	After initializing the centroids, iterate over all the Pxls objects in the ArrayList data and find the centroid which is closest to each and every Pxls object. Then assign that Pxls object to the cluster dominated by the centroid which the Pxls object is closest to. In this way, each and every Pxls object is categorized into k-clusters.
6.	Created an image wherein the pixels are colored based on the centroid color value of the cluster that the pixel belongs to.
7.	Average the centroid color values by taking the arithmetic mean of the color values of all the pixels belonging to a particular cluster.
8.	Iterate over Steps 5 to 7 see that the entire image is now defined only in terms of k-color values.

# Reference Links
1. https://en.wikipedia.org/wiki/K-means_clustering
2. https://www.youtube.com/watch?v=yR7k19YBqiw&t=1s
