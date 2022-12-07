import 'package:flutter/material.dart';

class NavigationOption extends StatelessWidget {

  final String title;
  final bool selected;
  final Function() onSelected;
  const NavigationOption({Key? key, required this.title, required this.selected, required this.onSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onSelected();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: selected ? const Color(0xFF166DE0) : Colors.grey[400],
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          selected
          ? Column(
            children: [
              const SizedBox(
                height: 12,
              ),
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF166DE0),
                  shape: BoxShape.circle,
                  
                ),
              ),
            ]
          )
          : Container(),

        ],
      ),
    );
  }
}