import 'package:chataniac/helper/authenticate.dart';
import 'package:chataniac/helper/constants.dart';
import 'package:chataniac/helper/helperfunctions.dart';
import 'package:chataniac/helper/theme.dart';
import 'package:chataniac/services/auth.dart';
import 'package:chataniac/services/database.dart';
import 'package:chataniac/views/chat.dart';
import 'package:chataniac/views/search.dart';
import 'package:flutter/material.dart';

//for github
class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  Stream chatRooms;

  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data.docs.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                //print(snapshot.data.docs[index].data()['users'][1]);
                return ChatRoomsTile(
                  userName: snapshot.data.docs[index].data()['users'][1]
                      .toString(),
                      //.replaceAll("_", "")
                      //.replaceAll(Constants.myName, ""),
                  chatRoomId: snapshot.data.docs[index].data()["chatRoomId"],
                );
              });
        } else {
          return Container();
        }
      },
    );
  }

  @override
  void initState() {
    getUserInfogetChats();
    super.initState();
  }

  getUserInfogetChats() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    DatabaseMethods().getUserChats(Constants.myName).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        print(
            "we got the data + ${chatRooms.toString()} this is name  ${Constants.myName}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chataniac',
          style: TextStyle(
            fontFamily: 'Lobster',
            fontSize: 30 ,
          ) ,
        ),
        elevation: 0.0,
        centerTitle: false,
        actions: [
          GestureDetector(
            onTap: () {
              AuthService().signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app)),
          )
        ],
      ),
      body: Container(
        child: chatRoomsList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Search()));
        },
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  ChatRoomsTile({this.userName,@required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => Chat(
              chatRoomId: chatRoomId,
            )
        ));
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),     //const EdgeInsets.all(5.0),
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(25),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),//CustomTheme.colorAccent,
                borderRadius: BorderRadius.circular(25)),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Row(
              children: [
                Container(
                  //height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      color: CustomTheme.colorAccent,
                      borderRadius: BorderRadius.circular(40)),
                  child: Center(
                    child: Text(userName[0],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontFamily: 'OverpassRegular',
                            fontWeight: FontWeight.w300)),
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Text(userName,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontFamily: 'OverpassRegular',
                        fontWeight: FontWeight.w300))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
