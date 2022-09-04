import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatelessWidget {
  const CommentCard({Key? key, this.snap}) : super(key: key);

  final snap;

  @override
  Widget build(BuildContext context) {
    var parsedDate = DateTime.parse(snap['datePublished']);
    var datePublish = DateFormat('dd-MM-yyyy – kk:mm').format(parsedDate);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Row(
        children: [
          Padding(
            padding: const   EdgeInsets.only(right: 10),
            child: CircleAvatar(
              radius: 15,
              backgroundImage: NetworkImage(snap['profilePic'])
            ),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    text: snap['name'] + " ", 
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                    children: [
                      TextSpan(
                        text: snap['text'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500
                        )
                      )
                    ]
                  )
                ),
                Text(
                  datePublish,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey
                  ),
                )
              ],
            ),
          ),
          IconButton(
            onPressed: () {}, 
            icon: const Icon(Icons.favorite)
          )
        ],
      )
    );
  }
}