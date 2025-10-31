import 'dart:convert';

import 'package:dashboard/bloc/apiBuilder/apibuilder_props_bloc.dart';
import 'package:dashboard/bloc/apiBuilder/apibuilder_props_event.dart';
import 'package:dashboard/bloc/apiBuilder/apibuilder_props_state.dart';
import 'package:dashboard/bloc/apiBuilder/model/apibuilder_props.dart';
import 'package:dashboard/core/api/api_call.dart';
import 'package:dashboard/core/api/api_client.dart';
import 'package:dashboard/widgets/customcontrols/key_value_reactive_dropdown.dart';
import 'package:dashboard/widgets/customcontrols/key_value_reactive_textbox.dart';
import 'package:dio/dio.dart';
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
  bool _isLoading = false;
  RequestObject requestObject = RequestObject({});
  dynamic responseObject = '';
  String selectedHeaderKey = '';
  final form = FormGroup({
    'apiName': FormControl<String>(validators: [Validators.required]),
    'apiEndpoint': FormControl<String>(validators: [Validators.required]),
    'apiMethodName': FormControl<String>(),
    'httpMethod': FormControl<String>(validators: [Validators.required]),
    'headers': FormArray([]),
    'requestKey': FormArray([]),
    'responses': FormArray([]),
  });

  final headerEntryForm = FormGroup({
    'key': FormControl<String>(validators: [Validators.required]),
    'value': FormControl<String>(validators: [Validators.required]),
     'otherKey': FormControl<String>(),
    'otherValue': FormControl<String>(),
  });

  final requestEntryForm = FormGroup({
    'key': FormControl<String>(validators: [Validators.required]),
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
    try {
      if (form.valid) {
        final headersArray = form.control('headers') as FormArray;
        print('***********************>$responseObject');
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
          requestKeys: requestObject,
          responses: ApiResponse.fromJson(responseObject),
        );

        context.read<ApiBloc>().add(AddApi(api));

        /* ************** SAVE to shared preference *****************************/
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
        responseObject = '';
        requestObject = RequestObject({});
      } else {
        form.markAllAsTouched();
      }
    } catch (error) {
      print(error);
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
    final responseArray = form.control('responses') as FormArray;
    setState(() {
      headersArray.clear();
      for (var h in api.headers) {
        headersArray.add(
          FormGroup({
            'key': FormControl<String>(value: h.key),
            'value': FormControl<String>(value: h.value),
            'otherKey': FormControl<String>(value: ""),
            'otherValue': FormControl<String>(value: ""),
          }),
        );
      }
      requestObject = api.requestKeys;
      responseObject = api.responses;
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
    print('method------------->$method');

    // Prepare headers
    Map<String, String> headers = {
      for (var h in headersArray.controls)
        if ((h as FormGroup).control('key').value != null &&
            (h).control('value').value != null)
          h.control('key').value: h.control('value').value,
    };

    // Prepare body (request keys)
    dynamic body = requestObject.toJson();

    try {
      // http.Response response;
      Response response;
      response =
          await ApiCall(
            dio: ApiClient().getDio(),
            url: url,
            method: method,
            headers: headers,
            request: body,
          ).callApi();
      // if (method == 'GET' || method == 'get') {
      //   // Add query params for GET
      //   // final uri = Uri.parse(url).replace(queryParameters: body);
      //   final uri = Uri.parse(url);
      //   // response = await http.get(uri, headers: headers);
      //   response = await dio.get(
      //     url,
      //     data: jsonEncode(body),
      //     options: Options(headers: headers),
      //   );
      //   print('GET Dio response $response');
      // } else if (method == 'POST' || method == 'post') {
      //   response = await dio.post(
      //     url,
      //     data: jsonEncode(body),
      //     options: Options(headers: headers),
      //   );
      //   print('POST Dio response $response');
      //   // response = await http.post(
      //   //   Uri.parse(url),
      //   //   headers: headers,
      //   //   body: jsonEncode(body),
      //   // );
      // } else if (method == 'DELETE' || method == 'delete') {
      //   response = await dio.delete(
      //     url,
      //     data: jsonEncode(body),
      //     options: Options(headers: headers),
      //   );
      //   print('DELETE Dio response $response');
      //   // response = await http.post(
      //   //   Uri.parse(url),
      //   //   headers: headers,
      //   //   body: jsonEncode(body),
      //   // );
      // } else {
      //   response = await dio.put(
      //     url,
      //     data: jsonEncode(body),
      //     options: Options(headers: headers),
      //   );
      //   print('PUT Dio response $response');
      //   // response = await http.post(
      //   //   Uri.parse(url),
      //   //   headers: headers,
      //   //   body: jsonEncode(body),
      //   // );
      // }
      // print('responseText------------------>${response.body}');
      // final formatted = _formatDynamicJson(response.body);
      // String responseText = response.body;
      // final decoded = jsonDecode(response.body);
      // _populateResponseArray(decoded);
      setState(() {
        responseObject = response.data;
      });
      print('responseObject------------------>${responseObject}');
    } catch (error) {
      print(error);
    } finally {
      setState(() => _isLoading = false);
    }
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
          appBar: AppBar(title: const Text('API Builder'), elevation: 2),
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
    return 
    SingleChildScrollView(
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
                      backgroundColor: Colors.red,
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
                      backgroundColor: Colors.red,
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
    Map<String, String> headersObject = {};
    for (var h in headersArray.controls) {
      final group = h as FormGroup;
      final key = group.control('key').value;
      final value = group.control('value').value;
      final otherKey = group.control('otherKey').value;
      final otherValue = group.control('otherValue').value;
 
      if (key != null && value != null && key.toString().isNotEmpty) {
        headersObject[key] = value;
      }
      if (otherKey != null &&
          otherValue != null &&
          otherKey.toString().isNotEmpty) {
        headersObject[otherKey] = otherValue;
      }
    }

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
                // _formatAsJson(requestObject),
                JsonEncoder.withIndent('  ').convert(requestObject),
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
                  // responseObject,
                  JsonEncoder.withIndent('  ').convert(responseObject),
                  // _formatAsJson(responseObject),
                  // buildResponseJson(responseArray),
                  // responseObject,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 14),
                ),
              ),
            ),
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
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    KeyValueReactiveDropdown(
                      formControlName: 'key',
                      labeltext: 'Header Key',
                      width: 260,
                      dropdownEntries: const [
                        'authorization',
                        'content-Type',
                        'accept',
                        'other',
                      ],
                      onSelected: (selected) {
                        setState(() {
                          selectedHeaderKey = selected.value;
                        });
                      },
                    ),
                    const SizedBox(width: 20),
                    KeyValueReactiveDropdown(
                      formControlName: 'value',
                      labeltext: 'Header Value',
                      width: 260,
                      dropdownEntries: getOptions(),
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      onPressed: () {
                        if (headerEntryForm.valid) {
                          final headersArray =
                              form.control('headers') as FormArray;
                          headersArray.add(
                            FormGroup({
                              'key': FormControl<String>(
                                value: headerEntryForm.control('key').value,
                              ),
                              'value': FormControl<String>(
                                value: headerEntryForm.control('value').value,
                              ),
                              'otherKey': FormControl<String>(
                                value:
                                    headerEntryForm.control('otherKey').value,
                              ),
                              'otherValue': FormControl<String>(
                                value:
                                    headerEntryForm.control('otherValue').value,
                              ),
                            }),
                          );
                          headerEntryForm.reset();
                          setState(() {
                            selectedHeaderKey = '';
                          });
                        } else {
                          headerEntryForm.markAllAsTouched();
                        }
                      },
                      icon: const Icon(Icons.add),
                      tooltip: "Add",
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                selectedHeaderKey == "other"
                    ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        KeyValueReactiveTextbox(
                          formControlName: 'otherKey',
                          labeltext: 'Header Key',
                          width: 260,
                        ),
                        const SizedBox(width: 20),
                        KeyValueReactiveTextbox(
                          formControlName: 'otherValue',
                          labeltext: 'Header Value',
                          width: 260,
                        ),
                        const SizedBox(width: 20),
                      ],
                    )
                    : SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<dynamic> getOptions() {
    switch (selectedHeaderKey.toLowerCase()) {
      case 'authorization':
        return ['Bearer Token', 'Basic Auth'];
      case 'content-type':
        return ['application/json', 'multipart/form-data', 'text/plain'];
      case 'accept':
        return ['application/json', 'text/html'];
      default:
        return [];
    }
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
                  labeltext: 'Request Value',
                  width: 260,
                ),
                const SizedBox(width: 20),
                IconButton(
                  onPressed: () {
                    if (requestEntryForm.valid) {
                      final key = requestEntryForm.control('key').value;
                      final value = requestEntryForm.control('value').value;

                      setState(() {
                        requestObject = requestObject.addNestedKey(key, value);
                        print(
                          const JsonEncoder.withIndent(
                            '  ',
                          ).convert(requestObject),
                        );
                      });

                      requestEntryForm.reset();
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
