import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../components/alert_feedback.dart';
import '../models/validator.dart';

class Feedbacks extends StatefulWidget {
  const Feedbacks({Key? key}) : super(key: key);

  @override
  State<Feedbacks> createState() => _FeedbacksState();
}

class _FeedbacksState extends State<Feedbacks> with Validator{

  FirebaseFirestore db = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final double minValue = 8.0;
  final _feedbackTypeList = <String>["Comments", "Bugs", "Questions"];
  String _feedbackType = "";
  final formKey = GlobalKey<FormState>();
  final TextStyle _errorStyle = const TextStyle(
    color: Colors.red,
    fontSize: 16.6,
  );

  @override
  initState() {
    _feedbackType = _feedbackTypeList[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color(0xFF166DE0),
        elevation: 0,
        title: 
          const Text(
            "FEEDBACK",
            style: TextStyle(
              color: Colors.white
            ),
          ),
          centerTitle: true,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                final isValidForm = formKey.currentState!.validate();
                if (isValidForm) {
                  sendFeedback(
                    _nameController.text,
                    _emailController.text, 
                    _messageController.text,
                    _feedbackType,
                  );
                  showDialog(context: context, 
                    builder: (BuildContext context){
                      return const AlertFeedback(text: 'Thank you for your feedback!');
                    }
                  );
                }
              },
                child: 
                const Text(
                  "SEND",
                  style: TextStyle(
                    color: Color(0xFFFDE1E1)
                  ),
                )
              )
          ],
      ),
      body: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: formKey,
        child: ListView(
          children: <Widget>[
            _buildAssetHeader(),
            _buildCategory(),
            _buildName(),
            SizedBox(
              height: minValue * 3,
            ),
            _buildEmail(),
            SizedBox(
              height: minValue * 3,
            ),
            _buildDescription(),
            SizedBox(
              height: minValue * 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssetHeader() {
    return Container(
      width: double.maxFinite,
      height: 220.0,
      child: Container(),
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/feedback.png"),
            fit: BoxFit.cover)),
    );
  }

  Widget _buildCategory() {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: minValue * 2, horizontal: minValue * 3),
      child: Row(
        children: <Widget>[
          const Text(
            "Select feedback type",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: minValue * 2,
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                color: Colors.white, 
                borderRadius: BorderRadius.circular(10)
              ),
              child: DropdownButton<String>(
                onChanged: (String? type) {
                  setState(() {
                    _feedbackType = type as String;
                  });
                },
                hint: Text(
                  _feedbackType,
                  style: const TextStyle(fontSize: 16.0),
                ),
                items: _feedbackTypeList
                  .map((type) => DropdownMenuItem<String>(
                    child: Text(type),
                    value: type,
                  ))
                  .toList(),
                icon: const Icon(Icons.arrow_drop_down),
                iconSize: 42,
                underline: const SizedBox(),
              ),
            )
          )
        ],
      ),
    );
  }

  Widget _buildName() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: minValue * 3),
      child: TextFormField(
        validator: nameValidator,
        controller: _nameController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          errorStyle: _errorStyle,
          contentPadding:
            EdgeInsets.symmetric(vertical: minValue, horizontal: minValue),
          labelText: 'Name',
          labelStyle: const TextStyle(fontSize: 16.0, color: Colors.black87)
        ),
      ),
    );
  }

  Widget _buildEmail() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: minValue * 3),
      child: TextFormField(
        validator: validateEmail,
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        onChanged: (String value) {},
        decoration: InputDecoration(
          errorStyle: _errorStyle,
          border: const UnderlineInputBorder(),
          contentPadding:
            EdgeInsets.symmetric(vertical: minValue, horizontal: minValue),
          labelText: 'Email',
          labelStyle: const TextStyle(fontSize: 16.0, color: Colors.black87)
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: minValue * 3),
      child: TextFormField(
        validator: descriptionValidator,
        controller: _messageController,
        keyboardType: TextInputType.text,
        maxLines: 3,
        decoration: InputDecoration(
          errorStyle: _errorStyle,
          labelText: 'Description',
          contentPadding:
            EdgeInsets.symmetric(vertical: minValue, horizontal: minValue),
          labelStyle: const TextStyle(fontSize: 16.0, color: Colors.black87)
        ),
      ),
    );
  }

  Future<void> sendFeedback(name, email, description, type) async {
    db.collection("Feedback")
    .get().then((event) {
        db.collection('Feedback')
        .add({
          "Timestamp": Timestamp.now(),
          "Name": name,
          "Email": email,
          "Description": description,
          "Type": type,
        });
      }
    );
  }


}