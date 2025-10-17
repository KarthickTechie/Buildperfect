// ignore_for_file: public_member_api_docs, sort_constructors_first
/*
  @author   :   karthick.d  09/10/2025
  @desc     :   keep page level constants , classes and object to create n pages
                abstract class and abstract methods to select page and return 
                selected pages
                

*/

import 'package:dashboard/utils/math_utils.dart';
import 'package:flutter/material.dart';

typedef PageRegistryMap = Map<String, PageGlobalConstants>;
typedef PageRegistryMapEntry = MapEntry<String, PageGlobalConstants>;

class PageGlobalConstants {
  String pageName;
  String pageId;
  bool isSelected;
  PageGlobalConstants({
    required this.pageName,
    required this.pageId,
    required this.isSelected,
  });
}

class BPPageController extends BPPageHelper with SelectePageMixin {
  PageRegistryMap pagesRegistry;
  BPPageController({required this.pagesRegistry});

  factory BPPageController.loadNPages(int totalPages) {
    PageRegistryMap pageRegistryMap = {};
    for (int i = 0; i < totalPages; i++) {
      String id = MathUtils.generateUniqueID();
      final entry = loadPage(pageId: id, pageName: 'page$i');
      pageRegistryMap.addEntries([entry]);
    }
    return BPPageController(pagesRegistry: pageRegistryMap);
  }

  @override
  PageGlobalConstants selectedPage() {
    return pagesRegistry.entries
        .where((element) => element.value.isSelected == true)
        .first
        .value;
  }

  @override
  void selectPage(String pageId) {
    if (pagesRegistry != null) {
      pagesRegistry[pageId]!.isSelected = true;
    }
  }
}

abstract class BPPageHelper {
  PageGlobalConstants selectedPage();
}

mixin SelectePageMixin {
  void selectPage(String pageId);
}

PageRegistryMapEntry loadPage({
  required String pageId,
  required String pageName,
  isSelected = false,
}) {
  return MapEntry(
    'page_$pageId',
    PageGlobalConstants(
      pageName: pageName,
      pageId: pageId,
      isSelected: isSelected,
    ),
  );
}
