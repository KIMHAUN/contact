import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';

void main() {
  runApp(
      MaterialApp(
          home: MyApp()
      ));
}

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}


class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  getPermission() async{
    var status = await Permission.contacts.status;
    if (status.isGranted) {
      var contacts = await ContactsService.getContacts();
      //print(contacts[0].familyName);
      // var newPerson = Contact();
      // newPerson.givenName = '하은';
      // newPerson.familyName = '김';
      // await ContactsService.addContact(newPerson);
      setState((){
        name = contacts;
      });

    } else if (status.isDenied) {
      print('거절됨');
      //Permission.contacts.request(); //허락해달라고 팝업 띄우는 코드
      openAppSettings(); //앱 설정 화면 켜줌
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    //위젯 로드될 때 한 번 실행됨
    super.initState();
    getPermission();
  }

  int total = 3;
  var name = []; //List<dynamic>
  var like = [0, 0, 0];
  //var name = "연락처 앱";
  addOne() {
    setState(() {
      total++;
    });
  }

  addName(input) {
    var newPerson = Contact();
    newPerson.givenName = input;
//  newPerson.familyName = '김';
    setState(() {
      name.add(newPerson);
      ContactsService.addContact(newPerson);
    });
  }

  @override
  build(context) {
    return Scaffold(
      floatingActionButton: Builder( //Builder : 족보 생성
          builder: (BuildContext context) {
            return FloatingActionButton(
              child: Text(''),
              onPressed: (){
                print(context.findAncestorWidgetOfExactType<MaterialApp>());
                showDialog(context: context, builder: (context){
                  return DialogUI( nameList: name, addOne: addOne, addName:addName );
                });
              },
            );
          }
      ),

      appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(total.toString(), style: TextStyle(color: Colors.black)),
          actions: [
            IconButton(icon: Icon(Icons.search), onPressed: null,),
            IconButton(icon: Icon(Icons.list), onPressed: null,),
            IconButton(icon: Icon(Icons.notifications_none_outlined), onPressed: null,),
            IconButton(icon: Icon(Icons.contacts), onPressed: (){
              getPermission();
            },),
          ]
      ),
      body: ListView.builder(
        itemCount: name.length,
        itemBuilder: (context, i){
          //print(i);
          return ListTile(
            leading: Image.asset('assets/profile.png', width: 100,),
            //leading: Text(like[i].toString()),
            title: Text(name[i].givenName ?? '이름이 없는 놈'),
            trailing: TextButton(onPressed: () {
              //Response to button press
              setState(() {
                like[i]++;
              });
            },
              child: Text("좋아요"),),
          );
        },
      ),
      //ShopItem(),
      bottomNavigationBar: BottomBar(),
    );
  }
}

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: Image.asset('assets/camera.png'),
            ),
            Container(
                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Text("홍길동")),
          ]
      ),
    );
  }
}

class BottomBar extends StatelessWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      BottomAppBar(
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.call), Icon(Icons.message), Icon(Icons.event_note_outlined)
            ],
          ),
        ),
      );
  }
}

class ShopItem extends StatelessWidget {
  const ShopItem({Key? key}) : super(key: key);

  @override
  build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(30),

        child: Row(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: Image.asset('assets/camera.png'),
            ),
            Container(
                width: 150,
                height: 100,
                padding: EdgeInsets.all(6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "카메라",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                    Text(
                        "개봉제3동 1분전",
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w100,
                            color: Color(0xff9f9393)
                        )),
                    Text("5,000원",
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontFamily: "맑은 고딕"
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.favorite_border),
                        Text("4"),
                      ],
                    )
                  ],
                )
            )
          ],
        )
    );
  }
}
class DialogUI extends StatelessWidget {
  //등록 2줄.
  // 부모가 보낸 state는 read-only가 좋음
  //중괄호 안의 파라미터는 optional
  DialogUI({Key? key, this.nameList, this.addOne, this.addName}) : super(key: key);
  final nameList;
  final addOne;
  final addName;
  var inputData = TextEditingController();
  //var inputData2 = {};
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.fromLTRB(0, 80, 80, 80),
      actions: [
        TextField(controller: inputData,
          decoration: InputDecoration(
              labelText: '입력하세욤'
          ),
        ),
        Row(
          children: [
            TextButton(onPressed: (){
              Navigator.of(context).pop();
            }
                , child: const Text('취소')),
            TextButton(onPressed: (){
              addOne();
              addName(inputData.text);
              print(nameList);
              Navigator.of(context).pop();
            }, child: Text('완료'))
          ],
        )
      ],
    );
  }
}