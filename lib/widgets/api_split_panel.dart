import 'package:dashboard/widgets/customcontrols/key_value_textbox.dart';
import 'package:dashboard/widgets/customcontrols/key_value_dropdown.dart';
import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SplitPanel());
  }
}

class SplitPanel extends StatefulWidget {
  final int columns;
  final double itemSpacing;
  const SplitPanel({super.key, this.columns = 2, this.itemSpacing = 2.0});

  @override
  State<SplitPanel> createState() => _SplitPanelState();
}

class _SplitPanelState extends State<SplitPanel> {
  List<Map<String, String>> headers = [];

  void addHeader(String key, String value) {
    setState(() {
      headers.add({"key": key, "value": value});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('API'), elevation: 2),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final leftPanelWidth = constraints.maxWidth / 2;
          final centerPanelWidth = constraints.maxWidth / 2;
          return Padding(
            padding: const EdgeInsets.only(top: 8, left: 4, right: 8),
            child: Stack(
              children: [
                Positioned(
                  width: leftPanelWidth - 150,
                  height: constraints.maxHeight,
                  left: 0,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Search....",
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        Card(
                          elevation: 30,
                          shadowColor: Colors.black,
                          child: SizedBox(
                            width: 700,
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Email validation:",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Row(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                        ),
                                        child: Text(
                                          "Edit",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                        ),
                                        child: Text(
                                          "Delete",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  // centerpanel for dragtarget
                  width: centerPanelWidth + 150,
                  height: constraints.maxHeight,
                  left: leftPanelWidth - 150,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: Colors.blue.shade300),
                    // flex: 3,
                    child: SingleChildScrollView(
                      // padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: KeyValueTextbox(
                              labeltext: 'API name',
                              width: 500,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: KeyValueTextbox(
                              labeltext: 'API Endpoint(URL)',
                              width: 500,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: KeyValueTextbox(
                              labeltext: 'API method name',
                              width: 500,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: KeyValueDropdown(
                              width: 500,
                              labeltext: 'HTTP method',
                              dropdownEntries: <DropdownMenuEntry>[
                                DropdownMenuEntry(value: 'GET', label: 'GET'),
                                DropdownMenuEntry(value: 'PUT', label: 'PUT'),
                                DropdownMenuEntry(
                                  value: 'DELETE',
                                  label: 'DELETE',
                                ),
                                DropdownMenuEntry(value: 'POST', label: 'POST'),
                              ],
                              onSelected: (value) {
                                print('required ? => $value');
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Headers', style: TextStyle(fontSize: 12)),
                                IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    // Your onPressed code here
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: KeyValueTextbox(
                              labeltext: 'Key',
                              width: 500,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: KeyValueTextbox(
                              labeltext: 'Value',
                              width: 500,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: KeyValueTextbox(
                              labeltext: 'Request key',
                              width: 500,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                  ),
                                  child: Text(
                                    "Test API",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  child: Text(
                                    "SAVE",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
