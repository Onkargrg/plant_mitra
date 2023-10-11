import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {

  final VoidCallback onPressed;
  final String buttonText;

  const CustomElevatedButton({super.key,
    required this.onPressed,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          minimumSize: Size(double.infinity, 70),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onPressed: onPressed,
        child: Text(buttonText,style: TextStyle(
          fontSize: 25.0,
        ),),
      ),
    );
  }
}
