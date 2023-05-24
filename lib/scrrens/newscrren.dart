import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/data/userdata.dart';
import 'package:chat_app/model.dart';
import 'package:chat_app/scrrens/profilescrreen.dart';
import 'package:chat_app/widgets/chat_user_card.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class NewScrren extends StatefulWidget {
  NewScrren({
    super.key,
    this.data,
  });

  final data;

  @override
  State<NewScrren> createState() => _NewScrrenState();
}

class _NewScrrenState extends State<NewScrren> {
  final selected = <int>[];

  doTheUpdate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final list =
        widget.data?.map((e) => Chatuser.fromJson(e.data())).toList() ?? [];
    if (list.isNotEmpty) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: selected.isEmpty
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          height: 40,
                          width: 40,
                          child: Hero(
                            tag: UserData.mee.image,
                            child: CachedNetworkImage(
                              imageUrl: UserData.mee.image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Hero(
                          tag: UserData.user.displayName.toString(),
                          child: Text(
                            UserData.user.displayName.toString(),
                            style: const TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 180, 218, 248),
                                fontFamily: "Acme"),
                          ),
                        ),
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return ProfileScrreen(user: UserData.mee);
                            }));
                          },
                          child: const Icon(
                            Icons.person_2,
                            color: Color.fromARGB(255, 180, 218, 248),
                          )),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selected.length.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                      InkWell(
                          onTap: () async {
                            UserData.deleteChat(list[selected.first]);
                          },
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ))
                    ],
                  ),
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: list.length,
              itemBuilder: (context, index) {
                return ChatUserCard(
                  index: index,
                  user: list[index],
                  selected: selected,
                  onChanged: doTheUpdate,
                );
              }),
        ],
      );
    } else {
      return const Center(
          child: Text(
        "No result found",
        style: TextStyle(
          color: Color.fromARGB(255, 180, 218, 248),
        ),
      ));
    }
  }
}
