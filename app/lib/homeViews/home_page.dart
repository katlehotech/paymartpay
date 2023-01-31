import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return a listview with a child icon-textbutton called 'connect bank'
    return SafeArea(minimum: EdgeInsets.all(16.0),
        child: ListView(shrinkWrap: true,
          children: [
      TextButton.icon(
        style: TextButton.styleFrom(backgroundColor: Colors.blue, iconColor: Colors.white, foregroundColor: Colors.white),
        onPressed: (){},
        icon: const Icon(Icons.add_card),
        label: const Text('Connect Bank')
        ,),
          Card(
            margin: EdgeInsets.only(top: 16),
            color: Colors.blue, 
            shape: StadiumBorder(side: BorderSide()),
            child: ListView(shrinkWrap: true,
              children: const [
            Text('Bank Name', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),),
              Text('R3000')
          ],),)
    ],));
  }
}
