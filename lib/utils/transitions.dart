import 'dart:ui';
import 'package:flutter/material.dart';

 class Transitions{

   // transition de glissement
   static Route glissement(Widget page){
     return PageRouteBuilder(
       pageBuilder: (context, animation, secondaryAnimation) => page,
       transitionsBuilder: (context, animation, secondaryAnimation, child) {

         // declaration des variables
         const begin = Offset(1.0, 0.0);
         const end = Offset.zero;
         const curve = Curves.ease;
         var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
         var offsetAnimation = animation.drive(tween);

         // retourner la transition en fonction du choix
         return
           // transition de glissement
          SlideTransition(
             position: offsetAnimation,
             child: child,
           );
         },
     );
   }

   // transition de fondu
   static Route fondu(Widget page){
     return PageRouteBuilder(
       pageBuilder: (context, animation, secondaryAnimation) => page,
       transitionsBuilder: (context, animation, secondaryAnimation, child) {
         return
           // transition de glissement
         FadeTransition(
               opacity: animation,
               child: child);
       },
     );
   }

   // transition de redimensionnement
   static Route redimensionnement(Widget page){
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
         return
         ScaleTransition(
              scale: animation,
              child: child);
      },
    );
  }

   // transition de rotation
   static Route rotation(Widget page){
     return PageRouteBuilder(
       pageBuilder: (context, animation, secondaryAnimation) => page,
       transitionsBuilder: (context, animation, secondaryAnimation, child) {
         return
           RotationTransition(
             turns: animation,
             child: child,
           );
       },
     );
   }

   // transition de renversement
   static Route renversement(Widget page){
     return PageRouteBuilder(
       pageBuilder: (context, animation, secondaryAnimation) => page,
       transitionsBuilder: (context, animation, secondaryAnimation, child) {
         return
           AnimatedBuilder(
             animation: animation,
             builder: (context, child) {
               final angle = animation.value * 3.14; // 180 degrees in radians
               return Transform(
                 transform: Matrix4.rotationY(angle),
                 alignment: Alignment.center,
                 child: child,
               );
             },
             child: child,
           );
       },
     );
   }

   // transition de floutage
   static Route floutage(Widget page){
     return PageRouteBuilder(
       pageBuilder: (context, animation, secondaryAnimation) => page,
       transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return
          AnimatedBuilder(
             animation: animation,
             builder: (context, child) {
               return BackdropFilter(
                 filter: ImageFilter.blur(
                   sigmaX: animation.value * 5.0,
                   sigmaY: animation.value * 5.0,
                 ),
                 child: FadeTransition(
                   opacity: animation,
                   child: child,
                 ),
               );
             },
             child: child,
           );
       },
     );
   }

   // transition 3D (profondeur)
   static Route profondeur(Widget page){
     return PageRouteBuilder(
       pageBuilder: (context, animation, secondaryAnimation) => page,
       transitionsBuilder: (context, animation, secondaryAnimation, child) {
         return
           AnimatedBuilder(
             animation: animation,
             builder: (context, child) {
               var perspective = 0.001;
               var scale = 1.0 - animation.value * 0.5;
               return Transform(
                 transform: Matrix4.identity()
                   ..setEntry(3, 2, perspective)
                   ..translate(0.0, 0.0, -200 * animation.value)
                   ..scale(scale),
                 alignment: Alignment.center,
                 child: child,
               );
             },
             child: child,
           );
       },
     );
   }

   // transition de glissement et de fondu
   static Route glissementFondu(Widget page){
     return PageRouteBuilder(
       pageBuilder: (context, animation, secondaryAnimation) => page,
       transitionsBuilder: (context, animation, secondaryAnimation, child) {

         // declaration des variables
         var slideAnimation = Tween<Offset>(
           begin: Offset(1.0, 0.0),
           end: Offset.zero,
         ).animate(animation);
         var fadeAnimation = Tween<double>(
           begin: 0.0,
           end: 1.0,
         ).animate(animation);

         return
            SlideTransition(
             position: slideAnimation,
             child: FadeTransition(
               opacity: fadeAnimation,
               child: child,
             ),
           );
       },
     );
   }

   // transition de glissement et de redimensionnement
   static Route redimensionnementGlissement(Widget page){
     return PageRouteBuilder(
       pageBuilder: (context, animation, secondaryAnimation) => page,
       transitionsBuilder: (context, animation, secondaryAnimation, child) {

         // declaration des variables
         var slideAnimation = Tween<Offset>(
           begin: Offset(1.0, 0.0),
           end: Offset.zero,
         ).animate(animation);

         var scaleAnimation = Tween<double>(
           begin: 0.5,
           end: 1.0,
         ).animate(CurvedAnimation(
           parent: animation,
           curve: Curves.fastOutSlowIn,
         ));

         return
           ScaleTransition(
             scale: scaleAnimation,
             child: SlideTransition(
               position: slideAnimation,
               child: child,
             ),
           );
       },
     );
   }

   // transition de redimensionnement et de rotation
   static Route rotationRedimensionnement(Widget page){
     return PageRouteBuilder(
       pageBuilder: (context, animation, secondaryAnimation) => page,
       transitionsBuilder: (context, animation, secondaryAnimation, child) {

         // declaration des variables
         var scaleAnimation = Tween<double>(
           begin: 0.5,
           end: 1.0,
         ).animate(CurvedAnimation(
           parent: animation,
           curve: Curves.fastOutSlowIn,
         ));
         var rotationAnimation = Tween<double>(
           begin: 0.0,
           end: 1.0,
         ).animate(animation);

         return
            RotationTransition(
             turns: rotationAnimation,
             child: ScaleTransition(
               scale: scaleAnimation,
               child: child,
             ),
           );
       },
     );
   }

}

