import 'package:flutter/material.dart';

class CustomizeSoundSystemPage extends StatefulWidget {
  @override
  _CustomizeSoundSystemPageState createState() =>
      _CustomizeSoundSystemPageState();
}

class _CustomizeSoundSystemPageState extends State<CustomizeSoundSystemPage> {
  final List<Map<String, dynamic>> items = [
    {
      'name': 'Smoke Machine with extra Liquid',
      'price': 2000,
      'quantity': 0,
      'image': 'assets/page-1/images/smoke_gunreal.jpg',
    },
    {
      'name': 'LED Wall 8X20',
      'price': 12000,
      'quantity': 0,
      'image': 'assets/page-1/images/dance_floor.jpg',
    },
    {
      'name': 'Cordless Mic',
      'price': 650,
      'quantity': 0,
      'image': 'assets/page-1/images/dance_floor.jpg',
    },
    {
      'name': 'Wired Mic',
      'price': 400,
      'quantity': 0,
      'image': 'assets/page-1/images/dance_floor.jpg',
    },
    {
      'name': 'LED Light',
      'price': '300/per piece',
      'quantity': 0,
      'image': 'assets/page-1/images/dance_floor.jpg',
    },
    {
      'name': 'Sharpy Light',
      'price': '650/per piece',
      'quantity': 0,
      'image': 'assets/page-1/images/dance_floor.jpg',
    },
    {
      'name': 'LED Floor 12X16',
      'price': 6500,
      'quantity': 0,
      'image': 'assets/page-1/images/dance_floor.jpg',
    },
    {
      'name': 'Floor 12X12',
      'price': 3500,
      'quantity': 0,
      'image': 'assets/page-1/images/dance_floor.jpg',
    },
    {
      'name': 'Floor 12X16',
      'price': 4000,
      'quantity': 0,
      'image': 'assets/page-1/images/dance_floor.jpg',
    },

  ];

  final List<Map<String, dynamic>> plans = [
    {
      'name': 'Signature Kit',
      'price': 25000,
      'image': 'assets/page-1/images/dance_floor.jpg',
      'includedItems': [
        {'name': 'Operator', 'quantity': 'For entire event', 'image': 'assets/page-1/images/dance_floor.jpg'},
        {'name': 'LED Walls', 'quantity': '8X20', 'image': 'assets/page-1/images/smoke_gunreal.jpg'},
        {'name': 'LED Floor', 'quantity': '12X16', 'image': 'assets/page-1/images/dance_floor.jpg'},
        {'name': 'Single Trust', 'quantity': 1, 'image': 'assets/page-1/images/dance_floor.jpg'},
        {'name': 'Base', 'quantity': 2, 'image': 'assets/page-1/images/smoke_gunreal.jpg'},
        {'name': 'Top', 'quantity': 4, 'image': 'assets/page-1/images/dance_floor.jpg'},
        {'name': 'Sharpy Lights', 'quantity': 4, 'image': 'assets/page-1/images/dance_floor.jpg'},
        {'name': 'Wireless Mic', 'quantity': 1, 'image': 'assets/page-1/images/dance_floor.jpg'},
      ],
    },
    {
      'name': 'Prime Kit',
      'price': 15000,
      'image': 'assets/page-1/images/dance_floor.jpg',
      'includedItems': [
        {'name': 'Operator', 'quantity': 'For entire event', 'image': 'assets/page-1/images/dance_floor.jpg'},
        {'name': 'LED Floor', 'quantity': '12X16', 'image': 'assets/page-1/images/dance_floor.jpg'},
        {'name': 'Single Trust', 'quantity': 1, 'image': 'assets/page-1/images/dance_floor.jpg'},
        {'name': 'Base', 'quantity': 2, 'image': 'assets/page-1/images/smoke_gunreal.jpg'},
        {'name': 'Top', 'quantity': 4, 'image': 'assets/page-1/images/dance_floor.jpg'},
        {'name': 'Sharpy Lights', 'quantity': 4, 'image': 'assets/page-1/images/dance_floor.jpg'},
        {'name': 'Wireless Mic', 'quantity': 1, 'image': 'assets/page-1/images/dance_floor.jpg'},
      ],
    },
    {
      'name': 'Standard Kit',
      'price': 8000,
      'image': 'assets/page-1/images/dance_floor.jpg',
      'includedItems': [
        {'name': 'Operator', 'quantity': 'For entire event', 'image': 'assets/page-1/images/dance_floor.jpg'},
        {'name': 'Base', 'quantity': 2, 'image': 'assets/page-1/images/smoke_gunreal.jpg'},
        {'name': 'Top', 'quantity': 4, 'image': 'assets/page-1/images/dance_floor.jpg'},
        {'name': 'Floor', 'quantity': '12x12', 'image': 'assets/page-1/images/dance_floor.jpg'},
        {'name': 'LED Lights', 'quantity': 5, 'image': 'assets/page-1/images/dance_floor.jpg'},
        {'name': 'Wireless Mic', 'quantity': 1, 'image': 'assets/page-1/images/dance_floor.jpg'},
      ],
    },
    {
      'name': 'Basic Kit',
      'price': 6000,
      'image': 'assets/page-1/images/dance_floor.jpg',
      'includedItems': [
        {'name': 'Operator', 'quantity': 'For entire event', 'image': 'assets/page-1/images/dance_floor.jpg'},
        {'name': 'Base', 'quantity': 2, 'image': 'assets/page-1/images/smoke_gunreal.jpg'},
        {'name': 'Top', 'quantity': 2, 'image': 'assets/page-1/images/dance_floor.jpg'},
        {'name': 'Floor', 'quantity': '12x12', 'image': 'assets/page-1/images/dance_floor.jpg'},
        {'name': 'LED Lights', 'quantity': 5, 'image': 'assets/page-1/images/dance_floor.jpg'},
        {'name': 'Wireless Mic', 'quantity': 1, 'image': 'assets/page-1/images/dance_floor.jpg'},
      ],
    },
  ];



  void showFullScreenImage(String imagePath) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void showPlanDetailsDialog(Map<String, dynamic> plan) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  plan['name'],
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    plan['image'],
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: plan['includedItems'].length,
                    itemBuilder: (context, index) {
                      final item = plan['includedItems'][index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.asset(
                                item['image'],
                                width: 80,
                                height: 90,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                '${item['name']} \n(${item['quantity']})',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffe5195e),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: Text(
                    'OK',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildPlanCard(Map<String, dynamic> plan) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool isAdded = plan['isAdded'] ?? false;

        return GestureDetector(
          onTap: () => showPlanDetailsDialog(plan), // Dialog box functionality retained
          child: Container(
            width: 180,
            height: 270,
            child: Card(
              shadowColor: Color(0xFFE9E8E6),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(12.0)),
                    child: Image.asset(
                      plan['image'],
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    plan['name'],
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '₹${plan['price']}',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        plan['isAdded'] = !isAdded;
                        isAdded = plan['isAdded'];
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      isAdded ? Colors.green : Color(0xffe5195e),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      minimumSize: Size(100, 35), // Adjusted button dimensions
                      padding: EdgeInsets.symmetric(vertical: 5.0), // Padding
                    ),
                    child: Text(
                      isAdded ? 'Added' : 'Add',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15, // Adjust font size for better fit
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F6F4),
      appBar: AppBar(
        title: Text(
          'Party Addons',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Large image at the top
          Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/page-1/images/okok.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Heading for Horizontal Plan Cards
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 20, 0, 5),
                  child: Text(
                    'Pick a Complete Setup for Your Party',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Horizontal Plan Cards
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: plans.map((plan) {
                      return Container(
                        margin: EdgeInsets.only(right: 0),
                        child: buildPlanCard(plan),
                      );
                    }).toList(),
                  ),
                ),
                // Heading for Vertical Item Cards
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 20, 0, 0),
                  child: Text(
                    'Select Only What You Need for Your Event',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Vertical Item Cards
                ...items.map((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 0, horizontal: 0),
                    child: Card(
                      shadowColor: Color(0xFFE9E8E6),
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showFullScreenImage(item['image']);
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: Image.asset(
                                  item['image'],
                                  width: 115,
                                  height: 125,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 18),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['name'],
                                    style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    '₹${item['price']}',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(height: 9),
                                  Row(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            if (item['quantity'] > 0) {
                                              item['quantity']--;
                                            }
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: Size(32, 32),
                                          backgroundColor: Color(0xFFFFF0F2),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(12),
                                          ),
                                        ),
                                        child: Text(
                                          '-',
                                          style: TextStyle(
                                            fontSize: 23,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xffe5195e),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 40,
                                        child: Center(
                                          child: Text(
                                            '${item['quantity']}',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            item['quantity']++;
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: Size(32, 32),
                                          backgroundColor: Color(0xFFFFF0F2),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(12),
                                          ),
                                        ),
                                        child: Text(
                                          '+',
                                          style: TextStyle(
                                            fontSize: 23,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xffe5195e),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 10, 40, 30),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffe5195e),
                padding: EdgeInsets.symmetric(vertical: 10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: Center(
                child: Text(
                  'ADD',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
