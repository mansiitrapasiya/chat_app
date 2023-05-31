import 'dart:math' show pi;
// import 'package:flutter/material.dart';

// enum CircleSide { left, right }

// extension Topath on CircleSide {
//   Path toPath(Size size) {
//     final path = Path();
//     late Offset offset;
//     late bool clockwise;
//     switch (this) {
//       case CircleSide.left:
//         path.moveTo(size.width, 0);

//         offset = Offset(size.width, size.height);
//         clockwise = false;
//         break;
//       case CircleSide.right:
//         offset = Offset(0, size.height);
//         clockwise = true;

//         break;
//     }
//     path.arcToPoint(offset,
//         radius: Radius.elliptical(size.width / 2, size.height / 2),
//         clockwise: clockwise);
//     path.close();
//     return path;
//   }
// }

// class HalfCircleclipper extends CustomClipper<Path> {
//   final CircleSide side;

//   HalfCircleclipper({required this.side});
//   @override
//   Path getClip(Size size) => side.toPath(size);
//   @override
//   bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
// }

// class AnimationPage extends StatefulWidget {
//   const AnimationPage({super.key});

//   @override
//   State<AnimationPage> createState() => _AnimationPageState();
// }

// extension on VoidCallback {
//   Future<void> delayed(Duration duration) => Future.delayed(duration, this);
// }

// class _AnimationPageState extends State<AnimationPage>
//     with TickerProviderStateMixin {
//   late AnimationController _counterClcokwiseController;
//   late Animation<double> _counterClcokwiseAnimation;
//   late AnimationController _fipContoller;
//   late Animation<double> _fipAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _counterClcokwiseController =
//         AnimationController(vsync: this, duration: Duration(seconds: 1));

//     _counterClcokwiseAnimation = Tween<double>(begin: 0, end: -(pi / 2))
//         .animate(CurvedAnimation(
//             parent: _counterClcokwiseController, curve: Curves.bounceOut));
//     _fipContoller =
//         AnimationController(vsync: this, duration: Duration(seconds: 1));
//     _fipAnimation = Tween<double>(begin: 0, end: pi).animate(
//         CurvedAnimation(parent: _fipContoller, curve: Curves.bounceOut));
//     //status  listners

//     _counterClcokwiseController.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         _fipAnimation = Tween<double>(
//                 begin: _fipAnimation.value, end: _fipAnimation.value + pi)
//             .animate(CurvedAnimation(
//                 parent: _fipContoller, curve: Curves.bounceOut));
//         _fipContoller.forward();
//       }
//     });
//     // _fipContoller
//     //   ..reset()
//     //   ..forward();
//     _fipContoller.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         _counterClcokwiseAnimation = Tween<double>(
//                 begin: _counterClcokwiseAnimation.value,
//                 end: _counterClcokwiseAnimation.value + -(pi / 2))
//             .animate(CurvedAnimation(
//                 parent: _counterClcokwiseController, curve: Curves.bounceOut));
//       }
//     });
//     _fipContoller
//       ..reset()
//       ..forward();
//   }

//   @override
//   void dispose() {
//     _counterClcokwiseController.dispose();
//     _fipContoller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     _counterClcokwiseController
//       ..reset()
//       ..forward.delayed(Duration(seconds: 1));

//     return SafeArea(
//       child: Scaffold(
//         body: AnimatedBuilder(
//           animation: _counterClcokwiseController,
//           builder: (context, child) {
//             return Transform(
//               alignment: Alignment.center,
//               transform: Matrix4.identity()
//                 ..rotateZ(_counterClcokwiseAnimation.value),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   AnimatedBuilder(
//                     animation: _fipContoller,
//                     builder: (context, child) {
//                       return Transform(
//                         alignment: Alignment.centerRight,
//                         transform: Matrix4.identity()
//                           ..rotateY(_fipAnimation.value),
//                         child: ClipPath(
//                           clipper: HalfCircleclipper(side: CircleSide.left),
//                           child: Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(color: Colors.amber),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                   AnimatedBuilder(
//                     animation: _fipAnimation,
//                     builder: (context, child) {
//                       return Transform(
//                         alignment: Alignment.centerLeft,
//                         transform: Matrix4.identity()
//                           ..rotateY(_fipAnimation.value),
//                         child: ClipPath(
//                           clipper: HalfCircleclipper(side: CircleSide.right),
//                           child: Container(
//                             height: 100,
//                             width: 100,
//                             decoration: const BoxDecoration(
//                                 color: Color.fromARGB(255, 114, 78, 90)),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

const widthAndHeight = 100.0;

class D3Animation extends StatefulWidget {
  const D3Animation({super.key});

  @override
  State<D3Animation> createState() => _D3AnimationState();
}

class _D3AnimationState extends State<D3Animation>
    with TickerProviderStateMixin {
  late AnimationController _xController;
  late AnimationController _yController;
  late AnimationController _zController;
  late Tween<double> _animation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _xController =
        AnimationController(vsync: this, duration: Duration(seconds: 10));
    _yController =
        AnimationController(vsync: this, duration: Duration(seconds: 20));
    _zController =
        AnimationController(vsync: this, duration: Duration(seconds: 30));
    _animation = Tween<double>(begin: 0, end: pi * 2);
  }

  @override
  void dispose() {
    _xController.dispose();
    _yController.dispose();
    _zController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _xController
      ..reset()
      ..repeat();
    _yController
      ..reset()
      ..repeat();
    _zController
      ..reset()
      ..repeat();

    return Scaffold(
      body: Column(
        children: [
          // SizedBox(
          //   height: widthAndHeight,
          //   width: double.infinity,
          // ),
          Padding(
            padding: const EdgeInsets.only(left: 50, top: 50),
            child: AnimatedBuilder(
              animation: Listenable.merge([
                _xController,
                _yController,
                _zController,
              ]),
              builder: (context, child) {
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..rotateX(_animation.evaluate(_xController))
                    ..rotateY(_animation.evaluate(_yController))
                    ..rotateZ(_animation.evaluate(_zController)),
                  child: Stack(
                    children: [
                      Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..translate(Vector3(0, 0, -widthAndHeight)),
                        child: Container(
                          color: Colors.purple,
                          width: widthAndHeight,
                          height: widthAndHeight,
                        ),
                      ),
                      // left side
                      Transform(
                        alignment: Alignment.centerLeft,
                        transform: Matrix4.identity()..rotateY(pi / 2.0),
                        child: Container(
                          color: Colors.red,
                          width: widthAndHeight,
                          height: widthAndHeight,
                        ),
                      ),
                      // left side
                      Transform(
                        alignment: Alignment.centerRight,
                        transform: Matrix4.identity()..rotateY(-pi / 2.0),
                        child: Container(
                          color: Colors.blue,
                          width: widthAndHeight,
                          height: widthAndHeight,
                        ),
                      ),
                      // front
                      Container(
                        color: Colors.green,
                        width: widthAndHeight,
                        height: widthAndHeight,
                      ),
                      // top side
                      Transform(
                        alignment: Alignment.topCenter,
                        transform: Matrix4.identity()..rotateX(-pi / 2.0),
                        child: Container(
                          color: Colors.purple,
                          width: widthAndHeight,
                          height: widthAndHeight,
                        ),
                      ),
                      // bottom side
                      Transform(
                        alignment: Alignment.bottomCenter,
                        transform: Matrix4.identity()..rotateX(pi / 2.0),
                        child: Container(
                          color: Colors.amber,
                          width: widthAndHeight,
                          height: widthAndHeight,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
