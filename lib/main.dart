import 'dart:math';
import 'package:decorated_icon/decorated_icon.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  String title = "CITY";
  Map<String, Color> typeColor = {"CITY": const Color(0xff01CDE0), "SPORT+": const Color(0xffED0125), "ECO": const Color(0xff01EC5F), "SPORT": const Color(0xffFFCC33)};
  bool lastForward = false;

  int count = 1;
  Color bar2color = const Color(0xffC4C4C4);
  Color bar3color = const Color(0xffC4C4C4);
  Color bar4color = const Color(0xffC4C4C4);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _colorAnimation = ColorTween(begin: Colors.blue, end: const Color(0xff01EC5F))
        .animate(_controller);

    getPreferences();
    getTitlePreferences();

    setState(() {
    });
  }

  void countIncrease(){
    if(title == "CITY"){
      if(count != 4){
        count++;
        if(count == 2){
          bar2color = const Color(0xffFFCC33);
        }
        else if(count == 3){
          bar3color = const Color(0xffFFCC33);
        }
        else if(count == 4){
          bar4color = const Color(0xffFFCC33);
        }
      }
    }

    setState(() {
      setPreferences();
    });
  }

  void countDecrease(){
    if(title == "CITY"){
      if(count > 1){
        count--;
        if(count < 2){
          bar2color = const Color(0xffC4C4C4);
        }
        else if(count < 3){
          bar3color = const Color(0xffC4C4C4);
        }
        else if(count < 4){
          bar4color = const Color(0xffC4C4C4);
        }
      }
    }
    setState(() {
      setPreferences();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void
  changeInfo(String type){
    if(lastForward) {
      _colorAnimation =
          ColorTween(begin: typeColor[type], end: typeColor[title]).animate(
              _controller);
      _controller.reverse();
      lastForward = false;
    } else {
      _colorAnimation =
          ColorTween(begin: typeColor[title], end: typeColor[type]).animate(
              _controller);
      _controller.forward();
      lastForward = true;
    }
    title = type;
    setState(() {
      setTitlePreferences();
    });
  }

  Color getShadowColor(){
    try{
      Color? shadowColor = typeColor[title];
      return shadowColor!.withOpacity(0.57);
    }catch(e){
      return Colors.black.withOpacity(0.57);
    }
  }

  Future<void> getPreferences() async{
    final prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey('counter')) {
      count = prefs.getInt('counter')!;
    }else{
      count = 1;
    }

    if(count >= 2){
      bar2color = const Color(0xffFFCC33);
    }

    if(count >= 3){
      bar3color = const Color(0xffFFCC33);
    }

    if(count >= 4){
      bar4color = Color(0xffFFCC33);
    }
    setState(() {});
  }

  Future<void> setPreferences() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('counter',count);
  }

  Future<void> getTitlePreferences() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey('title')) {
      title = prefs.getString('title')!;
    }else{
      title = 'CITY';
    }

    if(title == "CITY"){
      changeInfo("CITY");
    }
    if(title == "ECO"){
      changeInfo("ECO");
    }
    if(title == "SPORT"){
      changeInfo("SPORT");
    }
    if(title == "SPORT+"){
      changeInfo("SPORT+");
    }
    setState(() {
    });
  }

  Future<void> setTitlePreferences() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('title',title);
  }


  Widget red_star(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (BuildContext _, Widget? __) {
        return Container(
          height:190,
          width:190,
          child: Stack(
            children: [
              Container(
                child: const Icon(
                Icons.star,
                  size: 190,
                ),
                alignment: Alignment.center,
              ),
              Container(
                child:DecoratedIcon(
                  Icons.star,
                  color: _colorAnimation.value,
                  size: 178,
                  shadows: [
                    BoxShadow(
                      color: getShadowColor(),
                      blurRadius: 50,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                alignment: Alignment.center,
              ),
              Container(
                child: Image.asset(
                  "images/fast.png",
                ),
                alignment: Alignment.center,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 65,
              ),
              Center(
                child: Column(
                  children: [
                    red_star(context),
                    Container(
                      transform: Matrix4.translationValues(0.0, -30.0, 0.0),
                      child:Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xff000000),
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.normal,
                          fontSize: 24,
                          // height: 24.55,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: Container(
                            width: 84,
                            height: 84,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                  begin: Alignment(-1.0, -2.0),
                                  end: Alignment(1.0, 2.0),
                                  colors: [
                                    Color(0xff00FF66),
                                    Color(0xff05AF49)
                                  ]),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "images/fast.png",
                                ),
                                const Text(
                                  "ECO",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xff000000),
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 18,
                                    // height: 24.55,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            changeInfo("ECO");
                          },
                        ),
                        const SizedBox(
                          width: 38,
                        ),
                        GestureDetector(
                          child: Container(
                            width: 84,
                            height: 84,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                  begin: Alignment(-1.0, -2.0),
                                  end: Alignment(1.0, 2.0),
                                  colors: [
                                    Color(0xffFF002E),
                                    Color(0xffAF0505)
                                  ],),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "images/fast.png",
                                ),
                                const Text(
                                  "SPORT+",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xff000000),
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 18,
                                    // height: 24.55,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            changeInfo("SPORT+");
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 29,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: Container(
                            width: 84,
                            height: 84,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                  begin: Alignment(-1.0, -2.0),
                                  end: Alignment(1.0, 2.0),
                                  colors: [Color(0xff00E0FF), Color(0xff05AFAF)]),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "images/fast.png",
                                ),
                                const Text(
                                  "CITY",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xff000000),
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 18,
                                    // height: 24.55,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            changeInfo("CITY");
                          },
                        ),
                        const SizedBox(
                          width: 38,
                        ),
                        GestureDetector(
                          child: Container(
                            width: 84,
                            height: 84,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                  begin: Alignment(-1.0, -2.0),
                                  end: Alignment(1.0, 2.0),
                                  colors: [Color(0xffFFCC33), Color(0xffB18E14)],),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "images/fast.png",
                                ),
                                const Text(
                                  "SPORT",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xff000000),
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 18,
                                    // height: 24.55,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            changeInfo("SPORT");
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 35,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                        width: 21,
                        height: 104,
                        color: Color(0xffC4C4C4),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Container(
                          width: 21,
                          height: 79,
                          color: Color(0xffC4C4C4),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Container(
                          width: 21,
                          height: 60,
                          color: Color(0xffC4C4C4),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Container(
                          width: 21,
                          height: 47,
                          color: Color(0xffC4C4C4),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 21,
                          height: 47,
                          color: Color(0xffFFCC33),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Container(
                          width: 21,
                          height: 60,
                          color: bar2color,
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Container(
                          width: 21,
                          height: 79,
                          color: bar3color,
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Container(
                          width: 21,
                          height: 104,
                          color: bar4color,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xffF2F2F2),
        selectedFontSize: 0,
        items: [
          BottomNavigationBarItem(
            icon: GestureDetector(
              child: Stack(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        width: 1,
                        color: const Color(0xffE7E7E7),
                      ),
                      color: const Color(0xffF2F2F2),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xffE0E0E0),
                          spreadRadius: -1,
                          blurRadius: 3,
                          offset: Offset(0, 6),
                        ),
                        BoxShadow(
                          color: Color(0xffC9C9C9),
                          spreadRadius: 5,
                          blurRadius: 13,
                          offset: Offset(0, 4),
                        )
                      ],
                    ),
                    child: const Icon(
                      Icons.remove,
                      color: Color(0xffEABA24),
                      size: 50,
                    ),
                  ),
                ],
              ),
              onTap: countDecrease,
            ),
            label: 'School',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "images/Pedal_Commander_Logo_Black.png",
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              child: Stack(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        width: 1,
                        color: Color(0xffE7E7E7),
                      ),
                      color: Color(0xffF2F2F2),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xffE0E0E0),
                          spreadRadius: -1,
                          blurRadius: 3,
                          offset: Offset(0, 6),
                        ),
                        BoxShadow(
                          color: Color(0xffC9C9C9),
                          spreadRadius: 5,
                          blurRadius: 13,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Color(0xffEABA24),
                      size: 50,
                    ),
                  ),
                ],
              ),
              onTap: countIncrease,
            ),
            label: 'School',
          ),
        ],
      ),
    );
  }
}
