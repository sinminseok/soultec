import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soultec/App/Pages/calendar_page.dart';
import 'package:soultec/App/Pages/user_page.dart';
import 'package:soultec/App/widgets/drawer.dart';

import 'package:soultec/auth.dart';

import '../constants.dart';
import 'Pages/main_page.dart';

class Home_page extends StatefulWidget {
  late final String? uid;
  Home_page({required this.uid});


  @override
  _Home_pageState createState() => _Home_pageState();
}

class _Home_pageState extends State<Home_page> {
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
     bottomNavigationBar: getFooter(pageIndex),
      drawer:  My_Drawer(),
      appBar: AppBar(backgroundColor: kPrimaryColor , elevation: 0,),
      body: getBody()
    );
  }

  getBody(){
    List <Widget> pages = [
      Main_page(),
      Calendar_page(),
      MyPage()

      //User_page(user: widget.user),
    ];
    return IndexedStack(
        index: pageIndex,
        children: pages
    );
  }

  Widget getFooter(int pageIndex) {

    List bottomlist = [
      pageIndex==0 ? Icons.home :Icons.home_outlined,
      pageIndex==1 ? Icons.calendar_today :Icons.calendar_today_outlined,
      pageIndex==2 ? Icons.person :Icons.person_outline,
    ];
    return Container(
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
          color:Colors.white
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 20,left: 20,right: 20,bottom: 20),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate( bottomlist.length ,(index){
              return InkWell(
                  onTap: (){
                    selectedTap(index);
                  },
                  child:Icon(bottomlist[index] , color: Colors.black, size: 34,)
              );
            }
            )

        ),
      ),
    );

  }
  selectedTap(index){
    setState(() {
      pageIndex = index;
    });
  }
}
