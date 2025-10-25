import 'package:dashboard/appdata/page/page_global_constants.dart';
import 'package:dashboard/widgets/rightpanels/panel_header.dart';
import 'package:dashboard/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PageContainer extends StatefulWidget {
  final double width;
  final BPPageController bpPageController;
  const PageContainer({
    super.key,
    required this.width,
    required this.bpPageController,
  });

  @override
  State<PageContainer> createState() => _PageContainerState();
}

class _PageContainerState extends State<PageContainer> {
  bool searchOpt = false;
  String searchText = "";
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 3,
        color: Colors.white,
        child: Column(
          children: [
            searchOpt == false
                ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: PanelHeader(
                          panelWidth: widget.width,
                          title: 'Page List',
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            searchOpt = true;
                          });
                        },
                        icon: Icon(Icons.search),
                      ),
                    ],
                  ),
                )
                : SearchBarWidget(
                  hintText: "Search Pages...",
                  onChanged: (value) {},
                  onPressed: (isCleared) {
                    setState(() {
                      searchOpt = false;
                    });
                  },
                ),

            Expanded(
              child: ListView.builder(
                itemCount: widget.bpPageController.pagesRegistry.entries.length,
                itemBuilder: (context, index) {
                  final page =
                      widget.bpPageController.pagesRegistry.entries
                          .elementAt(index)
                          .value;
                  return ListTile(title: Text(page.pageName));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
