import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget{

   Dashboard({Key key}): super(key: key);
   @override
   DashBoardState createState()=> DashBoardState();
}

class DashBoardState extends State<Dashboard>{
  @override
  Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         title: Text("Prime",style: TextStyle(color: Colors.white)),
         centerTitle: true,
       ),
       body: Container(
         padding: EdgeInsets.all(10),
         child: Column(
           mainAxisAlignment: MainAxisAlignment.start,
           crossAxisAlignment: CrossAxisAlignment.center,
           children: <Widget>[
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               children: <Widget> [
                 Card(
                   shape: RoundedRectangleBorder(
                     borderRadius: const BorderRadius.all(Radius.circular(10))
                   ),
                   child: IconButton(
                     padding: EdgeInsets.all(8),
                     color: Colors.green,
                     icon: Icon(Icons.add_shopping_cart_outlined),
                   ),
                 )
               ],
             )
           ],
         ),
       ),
     );
  }
}

