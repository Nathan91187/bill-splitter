import 'package:flutter/material.dart';
class ConfirmationDialog {
  void showConfirmationDialog(BuildContext context, String title,String body,String firstButtonTitle,String secondButtonTitle, Future<void> Function() callback,IconData icon) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF111111),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Colors.amber, width: 1.5),
          ),
          title: Row(
            children: [
              Icon(icon, color: Colors.amber),
              SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            body,
            style: TextStyle(color: Colors.white70, height: 1.4),
          ),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              style: FilledButton.styleFrom(
                  backgroundColor: Colors.grey
              ),
              child: Text(
                firstButtonTitle,
                style: TextStyle(color: Colors.black),
              ),
            ),
            FilledButton(
              onPressed: () async{
                await callback();
                if(dialogContext.mounted){
                Navigator.pop(dialogContext);}
              },
              style: FilledButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
              ),
              child: Text(
                secondButtonTitle,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }
}