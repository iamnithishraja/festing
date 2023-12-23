class Post {
  Post({
    required this.imageURL,
    required this.capion,
    required this.id,
    required this.numComments,
    required this.numLikes,
    required this.isLiked,
    this.creatorId,
    this.rollno,
    this.name,
    this.dp,
  });
  int numComments, numLikes;
  String imageURL, capion;
  String id;
  String? creatorId, rollno, name, dp;
  bool isLiked;
}
