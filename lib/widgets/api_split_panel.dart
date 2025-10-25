import 'dart:convert';

import 'package:dashboard/bloc/apiBuilder/apibuilder_props_bloc.dart';
import 'package:dashboard/bloc/apiBuilder/apibuilder_props_event.dart';
import 'package:dashboard/bloc/apiBuilder/apibuilder_props_state.dart';
import 'package:dashboard/bloc/apiBuilder/model/apibuilder_props.dart';
import 'package:dashboard/pages/home_screen.dart';
import 'package:dashboard/widgets/customcontrols/key_value_reactive_dropdown.dart';
import 'package:dashboard/widgets/customcontrols/key_value_reactive_textbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       debugShowCheckedModeBanner: false,
      home: BlocProvider(create: (_) => ApiBloc(), child: const SplitPanel()),
    );
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
  String _apiResponse = '';
  bool _isLoading = false;
  final form = FormGroup({
    'apiName': FormControl<String>(),
    'apiEndpoint': FormControl<String>(),
    'apiMethodName': FormControl<String>(),
    'httpMethod': FormControl<String>(),
    'headers': FormArray([]),
    'requestKey': FormArray([]),
    'responses': FormArray([]),
  });

  final headerEntryForm = FormGroup({
    'key': FormControl<String>(),
    'value': FormControl<String>(),
  });

  final requestEntryForm = FormGroup({
    'key': FormControl<String>(),
    'value': FormControl<String>(),
  });

  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _loadSavedApis();
  }

  // ====== SAVE API ======
  void _saveApi() async {
    if (form.valid) {
      final headersArray = form.control('headers') as FormArray;
      final requestArray = form.control('requestKey') as FormArray;
      final responseArray = form.control('responses') as FormArray;

      final api = ApiModel(
        apiName: form.control('apiName').value,
        apiEndpoint: form.control('apiEndpoint').value,
        apiMethodName: form.control('apiMethodName').value ?? '',
        httpMethod: form.control('httpMethod').value,
        headers:
            headersArray.controls
                .map(
                  (c) => Header(
                    key: c.value['key'] ?? '',
                    value: c.value['value'] ?? '',
                  ),
                )
                .toList(),
        requestKeys:
            requestArray.controls
                .map(
                  (c) => RequestKey(
                    key: c.value['key'] ?? '',
                    value: c.value['value'] ?? '',
                  ),
                )
                .toList(),
        responses:
            responseArray
                .controls // 👈 Added
                .map(
                  (c) => ResponseKey(
                    key: c.value['key'] ?? '',
                    value: c.value['value'] ?? '',
                  ),
                )
                .toList(),
      );

      context.read<ApiBloc>().add(AddApi(api));
      _apiResponse = "";

      /* ************** SAVE to shared preference ****************************8 */
      final prefs = await SharedPreferences.getInstance();
      final currentList = prefs.getStringList('saved_apis') ?? [];
      currentList.add(jsonEncode(api.toJson()));
      await prefs.setStringList('saved_apis', currentList);

      print("API saved:-----------------> ${api.toJson()}");

      /*  ************************************  */

      form.reset();
      (form.control('headers') as FormArray).clear();
      (form.control('requestKey') as FormArray).clear();
      (form.control('responses') as FormArray).clear();
      headerEntryForm.reset();
      requestEntryForm.reset();
    } else {
      form.markAllAsTouched();
    }
  }

  Future<void> _loadSavedApis() async {
    final prefs = await SharedPreferences.getInstance();
    final savedList = prefs.getStringList('saved_apis') ?? [];

    if (savedList.isNotEmpty) {
      final List<ApiModel> loadedApis =
          savedList.map((item) => ApiModel.fromJson(jsonDecode(item))).toList();

      // Push loaded APIs into BLoC
      for (var api in loadedApis) {
        context.read<ApiBloc>().add(AddApi(api));
      }

      debugPrint("✅ Loaded ${loadedApis.length} APIs from local storage");
    }
  }

  // ====== EDIT API ======
  void _editApi(int index) {
    final api = context.read<ApiBloc>().state.apis[index];

    form.reset();
    form.patchValue({
      'apiName': api.apiName,
      'apiEndpoint': api.apiEndpoint,
      'apiMethodName': api.apiMethodName,
      'httpMethod': api.httpMethod,
    });

    final headersArray = form.control('headers') as FormArray;
    final requestArray = form.control('requestKey') as FormArray;
    final responseArray = form.control('responses') as FormArray;
    setState(() {
      headersArray.clear();
      for (var h in api.headers) {
        headersArray.add(
          FormGroup({
            'key': FormControl<String>(value: h.key),
            'value': FormControl<String>(value: h.value),
          }),
        );
      }

      requestArray.clear();
      for (var r in api.requestKeys) {
        requestArray.add(
          FormGroup({
            'key': FormControl<String>(value: r.key),
            'value': FormControl<String>(value: r.value),
          }),
        );
      }

      responseArray.clear();
      for (var r in api.responses) {
        responseArray.add(
          FormGroup({
            'key': FormControl<String>(value: r.key),
            'value': FormControl<String>(value: r.value),
          }),
        );
      }
      _apiResponse = api.responses.toString();
      print('responseArray----------->${responseArray}');
    });
  }

  // ====== DELETE API ======
  void _deleteApi(int index) {
    context.read<ApiBloc>().add(DeleteApi(index));
  }

  String _formatDynamicJson(String rawResponse) {
    try {
      final decoded = jsonDecode(rawResponse);

      if (decoded is List || decoded is Map) {
        // Pretty print with indentation
        const encoder = JsonEncoder.withIndent('  ');
        return encoder.convert(decoded);
      } else {
        // Primitive type (e.g. string, int, bool)
        return decoded.toString();
      }
    } catch (e) {
      // If invalid JSON, return as-is
      return rawResponse;
    }
  }

  // ===========TEST API =========
  Future<void> _testApi() async {
    if (!form.valid) {
      form.markAllAsTouched();
      return;
    }
    setState(() => _isLoading = true);
    final url = form.control('apiEndpoint').value;
    final method = form.control('httpMethod').value;
    final headersArray = form.control('headers') as FormArray;
    final requestArray = form.control('requestKey') as FormArray;
    print('method------------->$method');

    // Prepare headers
    Map<String, String> headers = {
      for (var h in headersArray.controls)
        if ((h as FormGroup).control('key').value != null &&
            (h).control('value').value != null)
          h.control('key').value: h.control('value').value,
    };

    // Prepare body (request keys)
    Map<String, dynamic> body = {
      for (var r in requestArray.controls)
        if ((r as FormGroup).control('key').value != null)
          r.control('key').value: r.control('value').value ?? "",
    };

    try {
      http.Response response;

      if (method == 'GET' || method == 'get') {
        // Add query params for GET
        // final uri = Uri.parse(url).replace(queryParameters: body);
        final uri = Uri.parse(url);
        response = await http.get(uri, headers: headers);
      } else {
        response = await http.post(
          Uri.parse(url),
          headers: headers,
          body: jsonEncode(body),
        );
      }

      final formatted = _formatDynamicJson(response.body);
      String responseText = response.body;
      final decoded = jsonDecode(response.body);
      _populateResponseArray(decoded);
      setState(() {
        _apiResponse = formatted;
      });
      print('responseText------------------>$responseText');
    } catch (error) {
      print(error);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _populateResponseArray(dynamic responseJson) {
    final responseArray = form.control('responses') as FormArray;
    responseArray.clear();
    print(
      '_populateResponseArray------->${responseJson is Map<String, dynamic>}',
    );
    print('_populateResponseArray List------->${responseJson is List}');
    if (responseJson is Map<String, dynamic>) {
      // ✅ For simple object response
      responseJson.forEach((key, value) {
        responseArray.add(
          FormGroup({
            'key': FormControl<String>(value: key),
            'value': FormControl<String>(value: value.toString()),
          }),
        );
      });
    } else if (responseJson is List) {
      // ✅ For list of objects
      for (var item in responseJson) {
        if (item is Map<String, dynamic>) {
          item.forEach((key, value) {
            responseArray.add(
              FormGroup({
                'key': FormControl<String>(value: key),
                'value': FormControl<String>(value: value.toString()),
              }),
            );
          });
        }
      }
    } else {
      // ✅ For any other data type
      responseArray.add(
        FormGroup({
          'key': FormControl<String>(value: 'response'),
          'value': FormControl<String>(value: responseJson.toString()),
        }),
      );
    }

    debugPrint(
      "✅ Response mapped to FormArray (${responseArray.controls.length} items)",
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApiBloc, ApiState>(
      builder: (context, state) {
        final filteredApis =
            state.apis
                .where(
                  (api) =>
                      api.apiName.toLowerCase().contains(searchQuery) ||
                      api.apiEndpoint.toLowerCase().contains(searchQuery),
                )
                .toList();

        return Scaffold(
          appBar: AppBar(
            elevation: 2,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              },
            ),
            title: const Text('API Builder'),
          ),
          body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final panelWidth = constraints.maxWidth / 3;

              return Padding(
                padding: const EdgeInsets.only(top: 8, left: 4, right: 8),
                child: Stack(
                  children: [
                    // LEFT PANEL
                    Positioned(
                      width: panelWidth - 50,
                      height: constraints.maxHeight,
                      left: 0,
                      child: _buildLeftPanel(filteredApis),
                    ),

                    // CENTER PANEL
                    Positioned(
                      width: panelWidth + 100,
                      height: constraints.maxHeight,
                      left: panelWidth - 50,
                      child: _buildCenterPanel(),
                    ),

                    // RIGHT PANEL
                    Positioned(
                      width: panelWidth,
                      height: constraints.maxHeight,
                      left: (panelWidth * 2) + 50,
                      child: _buildRightPanel(),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  // ====== LEFT PANEL ======
  Widget _buildLeftPanel(List<ApiModel> filteredApis) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: (val) => setState(() => searchQuery = val.toLowerCase()),
            decoration: InputDecoration(
              hintText: "Search....",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredApis.length,
            itemBuilder: (context, index) {
              final api = filteredApis[index];
              final stateApis = context.read<ApiBloc>().state.apis;

              return Card(
                elevation: 4,
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(api.apiName),
                  subtitle: Text(api.apiEndpoint),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _editApi(stateApis.indexOf(api)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteApi(stateApis.indexOf(api)),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ====== CENTER PANEL ======
  Widget _buildCenterPanel() {
    return SingleChildScrollView(
      child: ReactiveForm(
        formGroup: form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildApiInputs(),
            _buildHeaderSection(),
            _buildRequestKeySection(),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : _testApi,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    icon:
                        _isLoading
                            ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : const Icon(Icons.play_arrow, color: Colors.white),
                    label: Text(
                      _isLoading ? "Testing..." : "Test API",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),

                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _saveApi,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text(
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
    );
  }

  // ====== RIGHT PANEL ======
  Widget _buildRightPanel() {
    final headersArray = form.control('headers') as FormArray;
    final requestArray = form.control('requestKey') as FormArray;
    final responseArray = form.control('responses') as FormArray;
    Map<String, String> headersObject = {
      for (var h in headersArray.controls)
        if ((h as FormGroup).control('key').value != null &&
            h.control('value').value != null)
          h.control('key').value: h.control('value').value,
    };

    Map<String, String> requestObject = {
      for (var r in requestArray.controls)
        if ((r as FormGroup).control('key').value != null)
          r.control('key').value: r.control('value').value ?? "",
    };

    // var responseObject = {
    //   for (var r in responseArray.controls)
    //     if ((r as FormGroup).control('key').value != null)
    //       r.control('key').value: r.control('value').value ?? "",
    // };
    // List<Map<String, dynamic>> responseList =
    //     responseArray.controls.map((r) {
    //       final group = r as FormGroup;
    //       return {
    //         'key': group.control('key').value,
    //         'value': group.control('value').value ?? "",
    //       };
    //     }).toList();
    // final responseObject = jsonEncode(responseList);
    print(
      '_buildRightPanel responseArray-------------->${responseArray.controls}',
    );
    // print('_buildRightPanel responseObject-------------->$responseObject');

    return Container(
      color: Colors.grey.shade100,
      padding: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Structured View",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              "Headers Object:",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 6, bottom: 12),
              padding: const EdgeInsets.all(8),
              color: Colors.white,
              child: Text(
                _formatAsJson(headersObject),
                style: const TextStyle(fontFamily: 'monospace'),
              ),
            ),
            Text(
              "Request Object:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              color: Colors.white,
              child: Text(
                _formatAsJson(requestObject),
                style: const TextStyle(fontFamily: 'monospace'),
              ),
            ),
            Text(
              "Response Object:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(
                maxHeight: 250,
              ), // 👈 Fixed height scroll box
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: SingleChildScrollView(
                // 👈 Scrollable container
                scrollDirection: Axis.vertical,
                child: SelectableText(
                  const JsonEncoder.withIndent(
                    '  ',
                  ).convert(buildResponseJson(responseArray)),
                  // _formatAsJson(responseObject),
                  // buildResponseJson(responseArray),
                  // responseObject,
                  // _apiResponse,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 14),
                ),
              ),
            ),
            // Text(
            //   "Response Object:",
            //   style: TextStyle(
            //     fontWeight: FontWeight.bold,
            //     color: Colors.green,
            //   ),
            // ),
            // if (_apiResponse != null) ...[
            //   Container(
            //     width: double.infinity,
            //     padding: const EdgeInsets.all(8),
            //     color: Colors.white,
            //     child: Text(
            //       _apiResponse!,
            //       style: const TextStyle(fontFamily: 'monospace'),
            //     ),
            //   ),
            // ],
          ],
        ),
      ),
    );
  }

  String _formatAsJson(Map<dynamic, dynamic> obj) {
    return obj.isEmpty
        ? "{}"
        : "{\n${obj.entries.map((e) => '  \"${e.key}\": \"${e.value}\"').join(',\n')}\n}";
  }

  dynamic buildResponseJson(FormArray responseArray) {
    final items = <Map<String, dynamic>>[];

    Map<String, dynamic> currentObject = {};

    for (var i = 0; i < responseArray.controls.length; i++) {
      final control = responseArray.controls[i] as FormGroup;
      final key = control.control('key').value;
      final value = control.control('value').value;

      // If key already exists → means new object starts
      if (currentObject.containsKey(key)) {
        items.add(currentObject);
        currentObject = {};
      }

      currentObject[key] = value;

      // Add the last object
      if (i == responseArray.controls.length - 1) {
        items.add(currentObject);
      }
    }

    // If it’s only one object, return Map; else, return List
    return items.length == 1 ? items.first : items;
  }

  // ====== COMMON UI SECTIONS ======
  Widget _buildApiInputs() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: KeyValueReactiveTextbox(
            labeltext: 'API name',
            width: 500,
            formControlName: 'apiName',
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: KeyValueReactiveTextbox(
            labeltext: 'API Endpoint(URL)',
            width: 500,
            formControlName: 'apiEndpoint',
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: KeyValueReactiveTextbox(
            labeltext: 'API method name',
            width: 500,
            formControlName: 'apiMethodName',
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: KeyValueReactiveDropdown(
            width: 500,
            labeltext: 'HTTP method',
            dropdownEntries: ['POST', 'GET', 'PUT', 'DELETE'],
            formControlName: 'httpMethod',
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderSection() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Headers", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ReactiveForm(
            formGroup: headerEntryForm,
            child: Row(
              children: [
                KeyValueReactiveTextbox(
                  formControlName: 'key',
                  labeltext: 'Header Key',
                  width: 260,
                ),
                const SizedBox(width: 20),
                KeyValueReactiveTextbox(
                  formControlName: 'value',
                  labeltext: 'Header Value',
                  width: 260,
                ),
                const SizedBox(width: 20),
                IconButton(
                  onPressed: () {
                    if (headerEntryForm.valid) {
                      final headersArray = form.control('headers') as FormArray;
                      headersArray.add(
                        FormGroup({
                          'key': FormControl<String>(
                            value: headerEntryForm.control('key').value,
                          ),
                          'value': FormControl<String>(
                            value: headerEntryForm.control('value').value,
                          ),
                        }),
                      );
                      headerEntryForm.reset();
                      setState(() {});
                    } else {
                      headerEntryForm.markAllAsTouched();
                    }
                  },
                  icon: const Icon(Icons.add),
                  tooltip: "Add",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestKeySection() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Request Keys", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(width: 8),
          ReactiveForm(
            formGroup: requestEntryForm,
            child: Row(
              children: [
                KeyValueReactiveTextbox(
                  formControlName: 'key',
                  labeltext: 'Request Key',
                  width: 260,
                ),
                const SizedBox(width: 20),
                KeyValueReactiveTextbox(
                  formControlName: 'value',
                  labeltext: 'Request Key',
                  width: 260,
                ),
                const SizedBox(width: 20),
                IconButton(
                  onPressed: () {
                    if (requestEntryForm.valid) {
                      final requestArray =
                          form.control('requestKey') as FormArray;
                      requestArray.add(
                        FormGroup({
                          'key': FormControl<String>(
                            value: requestEntryForm.control('key').value,
                          ),
                          // 'value': FormControl<String>(value: ""),
                          'value': FormControl<String>(
                            value: requestEntryForm.control('value').value,
                          ),
                        }),
                      );
                      requestEntryForm.reset();
                      setState(() {});
                    } else {
                      requestEntryForm.markAllAsTouched();
                    }
                  },
                  icon: const Icon(Icons.add),
                  tooltip: "Add",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
