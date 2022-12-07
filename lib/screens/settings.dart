import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../components/alert_delete_data.dart';
import '../components/bottom_navigation.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  int _selectedItemIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      bottomNavigationBar: CustomBottomNavigationBar(
        iconList: const [
          Icons.home,
          Icons.map,
          Icons.settings,
        ],
        onChange: (val) {
          setState(() {});
        },
        defaultSelectedIndex: 2,
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            const SizedBox(height: 30),
            Row(
              children: const [
                Icon(
                  Icons.app_settings_alt,
                  color: Colors.blue,
                ),
                SizedBox(width: 10),
                Text(
                  "Settings", 
                  style: TextStyle(
                    fontSize: 22, 
                    fontWeight: FontWeight.bold
                  )
                ),
              ],
            ),
            const Divider(height: 20, thickness: 1),
            const SizedBox(height: 5),
            buildOption(context, "Language", 0),
            buildOption(context, "Delete All Data", 1),
  
            const SizedBox(height: 30),
            Row(
              children: const [
                Icon(
                  Icons.help,
                  color: Colors.blue,
                ),
                SizedBox(width: 10),
                Text(
                  "Support", 
                  style: TextStyle(
                    fontSize: 22, 
                    fontWeight: FontWeight.bold
                  )
                ),
              ],
            ),
            const Divider(height: 20, thickness: 1),
            const SizedBox(height: 5),
            buildOption(context, "About this app", 3),
            buildOption(context, "Covid-19 Information", 2),
            buildOption(context, "Hotline Numbers", 4),

            const SizedBox(height: 30),
            Row(
              children: const [
                Icon(
                  Icons.feedback,
                  color: Colors.blue,
                ),
                SizedBox(width: 10),
                Text(
                  "Feedback", 
                  style: TextStyle(
                    fontSize: 22, 
                    fontWeight: FontWeight.bold
                  )
                ),
              ],
            ),
            const Divider(height: 20, thickness: 1),
            const SizedBox(height: 5),
            buildOption(context, "Send Feedback", 5),
            
            const SizedBox(height: 36),
            Center(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                  ),
                ),
                onPressed: () => [
                  logout(),
                  _deleteCacheDir(),
                  _deleteAppDir(),
                 Navigator.of(context)
                  .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false),
                
                ],  
                child: const Text(
                  "LOGOUT", 
                  style: TextStyle(
                    fontSize: 16,
                    letterSpacing: 2.2,
                    color: Colors.white
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector buildOption(BuildContext context, String title, int index) {
    return GestureDetector(
      child: InkWell(
        onTap: (){
          setState((){
            _selectedItemIndex = index;
          });
          if (_selectedItemIndex == 0){
            //Navigator.pushNamed(context, '/language');
            print("Language page not yet developed");
          }
          if (_selectedItemIndex == 1){
            showDialog(context: context, 
              builder: (BuildContext context){
                return const AlertDeleteData(text: 'Are you sure you want to delete all your data?');
              }
            );
          }
          if (_selectedItemIndex == 2){
            Navigator.pushNamed(context, '/covid19guidance');
          }
          if (_selectedItemIndex == 3){
            Navigator.pushNamed(context, '/aboutapp');
          }
          if (_selectedItemIndex == 4){
            Navigator.pushNamed(context, '/emergency');
          }
          if (_selectedItemIndex == 5){
            Navigator.pushNamed(context, '/feedback');
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600]
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios, 
                color: Colors.grey
              ),
            ],
          )
        )
      ),
    );
  }

  Future<void> logout() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
  }

  /// this will delete cache
  Future<void> _deleteCacheDir() async {
      final cacheDir = await getTemporaryDirectory();

      if (cacheDir.existsSync()) {
        cacheDir.deleteSync(recursive: true);
      }
  }

  /// this will delete app's temporary storage
  Future<void> _deleteAppDir() async {
      final appDir = await getApplicationSupportDirectory();

      if(appDir.existsSync()){
        appDir.deleteSync(recursive: true);
      }
  }

}
