import 'package:flutter/material.dart';

  class CustomBottomNavigationBar extends StatefulWidget {

    final int defaultSelectedIndex;
    final Function (int) onChange;
    final List<IconData> iconList;

    const CustomBottomNavigationBar({
      this.defaultSelectedIndex = 0, 
      required this.iconList,
      required this.onChange
    });
    
    @override
    State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();
  }
  
  class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
    int _selectedItemIndex = 0;
    List<IconData> _iconList = [];

    @override
    void initState() {
      super.initState();
      _selectedItemIndex = widget.defaultSelectedIndex;
      _iconList = widget.iconList;
    }

    @override
    Widget build(BuildContext context) {
      List<Widget> _navBarItemList = [];

      for (var i = 0; i < _iconList.length; i++){
        _navBarItemList.add(buildNavBarItem(_iconList[i], i));
      }

      return Row(
        children: _navBarItemList,  
      );
    }

    Widget buildNavBarItem(IconData icon, int index) {
      return GestureDetector(
        child: InkWell (
          onTap: (){
            widget.onChange(index);
            setState((){
              _selectedItemIndex = index;
            });
            if (_selectedItemIndex == 0){
              //Navigator.pushNamed(context, '/home');
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
            }
            if (_selectedItemIndex == 1){
              Navigator.pushNamed(context, '/gmap');
            }
            if (_selectedItemIndex == 2){
              Navigator.pushNamed(context, '/settings');
            }
          },
          child: Container(
            height: 60,
            width: MediaQuery.of(context).size.width / _iconList.length,
            decoration: index == _selectedItemIndex 
              ? BoxDecoration(
              border: const Border(
                bottom: BorderSide(width: 4, color: Colors.lightBlue),
              ),
              gradient: LinearGradient(colors: [
                Colors.blueGrey.withOpacity(0.4),
                Colors.blueGrey.withOpacity(0.015),
              ],
              begin : Alignment.bottomCenter,
              end: Alignment.topCenter,
              )
            ) : const BoxDecoration(), 
            child: Icon(
              icon, 
              color: index == _selectedItemIndex ? Colors.black : Colors.grey
            ),
          ),
        )
      );
    }
  }
