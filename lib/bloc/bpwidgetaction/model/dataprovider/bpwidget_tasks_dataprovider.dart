// ignore_for_file: public_member_api_docs, sort_constructors_first
/*
  @author     : karthick.d  13/10/2025
  @desc       : base class for setting datasource for various tasks
                example NavaigationTask , SaveAndGoNavigationTask etc
                NavigationTask extends BPTaskParam
                

*/
class BPTaskDataprovider {
  final String url;
  final Map<String, dynamic>? data;
  BPTaskDataprovider({required this.url, this.data});

  @override
  String toString() => 'BPTaskDataprovider(url: $url, data: $data)';
}
