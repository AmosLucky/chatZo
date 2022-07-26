import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:social_app/Utils/colors.dart';
import 'package:social_app/Utils/dimensions.dart';
import 'package:social_app/Utils/utils.dart';
import 'package:social_app/models/User.dart';
import 'package:social_app/models/post.dart';
import 'package:social_app/resources/firestore_methods.dart';
import 'package:social_app/screens/comment.dart';
import 'package:social_app/widgets/like_animation.dart';

import '../providers/user_provider.dart';

class PostCard extends StatefulWidget {
  Post post;
  User user;
  PostCard({required this.post, required this.user});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentLen = 0;
  User? user;

  void getCommentLength() async {
    user = widget.user;
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("posts")
          .doc(widget.post.postId)
          .collection("comments")
          .get();
      setState(() {
        commentLen = snap.docs.length;
        print(commentLen);
      });
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  @override
  void initState() {
    getCommentLength();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 10,
      ),
      decoration: BoxDecoration(
          color: mobileBackgroundColor,
          border: Border.all(
              color: size.width > webScreenSize
                  ? webBackgroundColor
                  : mobileBackgroundColor)),
      child: Column(children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
          ).copyWith(right: 0),
          margin: EdgeInsets.only(bottom: 10),
          child: Row(children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(widget.post.profileImage),
            ),
            Expanded(
                child: Padding(
              padding: EdgeInsets.only(left: 8),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.post.username,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ]),
            )),
            widget.post.uid == user!.uid
                ? IconButton(
                    onPressed: () => options(context),
                    icon: Icon(Icons.more_vert))
                : Container()
          ]),

          ///////////IMAGES SECTION///////
        ),
        GestureDetector(
          onDoubleTap: () async {
            await FirestoreMethod()
                .likePost(widget.post.postId, user!.uid, widget.post.likes);
            isLikeAnimating = true;
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: size.height * 0.35,
                width: double.infinity,
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: widget.post.photoUrl,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                    child: CircularProgressIndicator(
                        value: downloadProgress.progress),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              AnimatedOpacity(
                opacity: isLikeAnimating ? 1 : 0,
                duration: Duration(milliseconds: 400),
                child: LikeAnimation(
                  child: Icon(Icons.favorite, color: Colors.white, size: 100),
                  isAnimaing: isLikeAnimating,
                  duration: Duration(milliseconds: 400),
                  onEnd: () {
                    setState(() {
                      isLikeAnimating = false;
                    });
                  },
                ),
              )
            ],
          ),
        ),

        /////////////Likes/////////////////
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Row(children: [
            LikeAnimation(
              isAnimaing: widget.post.likes.contains(user!.uid),
              smallLike: true,
              child: IconButton(
                  onPressed: () async {
                    await FirestoreMethod().likePost(
                        widget.post.postId, user!.uid, widget.post.likes);
                    // setState(() {
                    //   isLikeAnimating = true;
                    // });
                  },
                  icon: widget.post.likes.contains(user!.uid)
                      ? Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : Icon(Icons.favorite_border)),
            ),
            IconButton(
                onPressed: () {
                  var route = MaterialPageRoute(
                      builder: (BuildContext) => Comment(
                            post: widget.post,
                          ));
                  Navigator.of(context).push(route);
                },
                icon: Icon(Icons.comment)),
            IconButton(onPressed: () {}, icon: Icon(Icons.send)),
            Expanded(
                child: Container(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        onPressed: () {}, icon: Icon(Icons.bookmark_outline))))
          ]),
        ),

        ////////////DESCRIPTION AND NUMBER OF COMMENTS
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(fontWeight: FontWeight.bold),
                  child: Text(
                    widget.post.likes.length > 0
                        ? " ${widget.post.likes.length} likes"
                        : "No like",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8),
                  child: RichText(
                      text: TextSpan(
                          style: TextStyle(color: primaryColor),
                          children: [
                        TextSpan(
                            text: widget.post.username,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: " " + widget.post.description),
                      ])),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      commentLen > 0
                          ? "view all ${commentLen} comments"
                          : "No comment",
                      style: TextStyle(fontSize: 16, color: secondaryColor),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    DateFormat.yMMMd()
                        .format(widget.post.datePublished.toDate()),
                    style: TextStyle(fontSize: 16, color: secondaryColor),
                  ),
                ),
              ]),
        )
      ]),
    );
  }

  options(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => Dialog(
              child: ListView(
                  shrinkWrap: true,
                  children: ["Delete", "Edit"]
                      .map((e) => InkWell(
                            onTap: () {
                              if (e == "Delete") {
                                FirestoreMethod()
                                    .deletePost(widget.post.postId);
                                setState(() {});
                                Navigator.pop(context);
                              }
                            },
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                child: Text(e)),
                          ))
                      .toList()),
            ));
  }
}
