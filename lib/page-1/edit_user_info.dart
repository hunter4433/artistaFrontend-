import 'package:flutter/material.dart';

class user_information extends StatefulWidget {
  @override
  _UserInformationState createState() => _UserInformationState();
}

class _UserInformationState extends State<user_information> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _buildingController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _pinCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch data from the backend and populate the respective text controllers
    fetchData("Name", _nameController);
    fetchData("Last Name", _lastNameController);
    fetchData("Phone No", _phoneController);
    fetchData("Building", _buildingController);
    fetchData("City", _cityController);
    fetchData("State", _stateController);
    fetchData("Pin Code", _pinCodeController);
  }

  Future<void> fetchData(String field, TextEditingController controller) async {
    // In real scenario, you would fetch data from the backend based on the field
    // For demonstration, I'm just returning some dummy data after a short delay
    await Future.delayed(Duration(seconds: 1));
    switch (field) {
      case "Name":
        controller.text = "Abhishek";
        break;
      case "Last Name":
        controller.text = "Doe";
        break;
      case "Phone No":
        controller.text = "1234567890";
        break;
      case "Building":
        controller.text = "Sample Building, Some Street";
        break;
      case "City":
        controller.text = "New York";
        break;
      case "State":
        controller.text = "NY";
        break;
      case "Pin Code":
        controller.text = "10001";
        break;
      default:
        controller.text = "Sample $field Data";
    }
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
        actions: [
          GestureDetector(
            onTap: () {
              // Implement save action here
              // You can access text from controllers and save to backend
              print('Save button tapped');
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: Text(
                  'Done',
                  style: TextStyle(
                    color: Colors.red, // Change the text color as needed
                    fontSize: 16, // Change the font size as needed
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              height: 844 * fem,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildEditableRow("Name:", _nameController, fem, ffem),
                  buildEditableRow("Last Name:", _lastNameController, fem, ffem),
                  buildEditableRow("Phone No:", _phoneController, fem, ffem),
                  buildEditableRow("Building:", _buildingController, fem, ffem),
                  buildEditableRow("City:", _cityController, fem, ffem),
                  buildEditableRow("State:", _stateController, fem, ffem),
                  buildEditableRow("Pin Code:", _pinCodeController, fem, ffem),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildEditableRow(String label, TextEditingController controller, double fem, double ffem) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          TextFormField(
            controller: controller,
            style: TextStyle(
              fontSize: 16,
            ),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xffe5195e), // Change the focused border color as needed
                  width: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _nameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _buildingController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pinCodeController.dispose();
    super.dispose();
  }
}

void main() {
  runApp(MaterialApp(
    home: user_information(),
  ));
}
