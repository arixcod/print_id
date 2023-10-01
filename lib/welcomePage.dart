import 'package:flutter/material.dart';
import 'package:print_id/login.dart';
import 'package:print_id/signup.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';



class WelcomePage extends StatefulWidget {


  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
final pagecontroller=PageController(
  initialPage: 1
);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          ShaderMask(shaderCallback: (bounds)=>LinearGradient(colors: [
            Colors.black,Colors.black12
          ],
             begin: Alignment.bottomCenter,
            end: Alignment.center,
          ).createShader(bounds),
            blendMode: BlendMode.darken,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage('images/ss.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken)
                ),
              ),
            ),
          ),

          Scaffold(
            backgroundColor: Colors.transparent,
              body: SafeArea(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(height: 50,),
                       Padding(
                         padding: const EdgeInsets.all(20.0),
                         child: WecomeText("Welcome To",30),
                       ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: WecomeText("Chhedilal Ramjee\nOffset Printers",40),
                        ),
                    SizedBox(height: 40,),
                        Expanded(
                          child: PageView(
                            controller: pagecontroller,
                            children: [
                            slidable_cards(ImagePath:'images/bagcustom.jpeg' ,Textvalue: 'Custom Bag Printing',),
                              slidable_cards(ImagePath:'images/marriage_cards.jpg' ,Textvalue: 'Marriage Card Printing ',),
                              slidable_cards(ImagePath:'images/icard.jpg' ,Textvalue: 'Id Cards Printing',),

                                                       ],),
                        ),
                      SizedBox(height: 40,),
                      Center(child: SmoothPageIndicator(controller: pagecontroller, count: 3
                        ,effect: const WormEffect(
                          dotColor: Colors.redAccent,
                          activeDotColor: Colors.greenAccent,
                          dotHeight: 10,
                          dotWidth: 10
                        ),
                      )
                      )
              ,      SizedBox(height: 20,),
                    buttonLogin(buttonText:'Login',namedroute: 1,),
                      SizedBox(height: 20,),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
  Text WecomeText(String textdata,double fontsize) {

    return Text(textdata,
                style: TextStyle(
                            fontSize: fontsize,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Poppins",
                              color: Colors.white
                    ),
                  );
  }
}

class slidable_cards extends StatelessWidget {

  final String ImagePath;
  final String Textvalue;
  const slidable_cards({
    super.key,
    required this.ImagePath,
    required this.Textvalue
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ShaderMask(
          shaderCallback: (bound)=>LinearGradient(colors:[
            Colors.black,Colors.black12
          ],
            begin: Alignment.bottomCenter,
            end: Alignment.center,
          ).createShader(bound),
          blendMode: BlendMode.darken,
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage(ImagePath),fit: BoxFit.fitHeight)
            ),
          ),
        ),

        Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end
                  ,
                  children: [
                    Text(Textvalue,
                    textAlign:TextAlign.left ,
                      style:
                      TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins'
                      )
                      ,),
                    SizedBox(width: 30,),
                    Icon(Icons.arrow_forward_outlined,color: Colors.white,)
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class buttonLogin extends StatelessWidget {

 final String buttonText;
  final int namedroute;
 const buttonLogin({
    super.key,required this.buttonText,
   required this.namedroute,


  });

  @override
  Widget build(BuildContext context) {
    return Padding
      (
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container
        (
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(12)
        ),
        child: TextButton(onPressed: (){
          Navigator.of(context).push( _createRoute(namedroute));
        }, child:
        Text(buttonText,
          style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'Poppins'
          ),
            )

        ),

      ),
    );
  }
}



//this is to create animational transition of the page


Route _createRoute(int route_num){
  var functionholder;
  if(route_num==1){
    functionholder=app_login();
  }
  else
    functionholder=app_signup();

  return PageRouteBuilder(
      pageBuilder:(context,animation,secondaryAnimation)=>functionholder,
      transitionsBuilder: (context,animation,secondaryAnimation,child){
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      }

  );

}



