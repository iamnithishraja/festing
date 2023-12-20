class Post {
  Post(
      {required this.imageURL,
      required this.capion,
      required this.id,
      required this.numComments,
      required this.numLikes});
  int numComments, numLikes;
  String imageURL, capion;
  String id;
}
