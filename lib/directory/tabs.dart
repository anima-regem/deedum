import 'dart:math' as math;
import 'package:deedum/browser_tab.dart';
import 'package:deedum/main.dart';
import 'package:deedum/shared.dart';

import 'package:extended_text/extended_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Tabs extends StatelessWidget {
  final onNewTab;
  final onSelectTab;
  final onDeleteTab;
  final onBookmark;
  final List tabs;

  final tabKey = GlobalObjectKey(DateTime.now().millisecondsSinceEpoch);

  Tabs(this.tabs, this.onNewTab, this.onSelectTab, this.onDeleteTab, this.onBookmark);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.orange,
          centerTitle: true,
          title: Text(
              [
                "████████╗ █████╗ ██████╗ ███████╗",
                "╚══██╔══╝██╔══██╗██╔══██╗██╔════╝",
                "   ██║   ███████║██████╔╝███████╗",
                "   ██║   ██╔══██║██╔══██╗╚════██║",
                "   ██║   ██║  ██║██████╔╝███████║",
                "   ╚═╝   ╚═╝  ╚═╝╚═════╝ ╚══════╝"
              ].join("\n"),
              style: TextStyle(fontSize: 5.5, fontFamily: "DejaVu Sans Mono")),
        ),
        body: SingleChildScrollView(
            child: Column(
                children: <Widget>[
                      Card(
                        color: Colors.black12,
                        child: ListTile(
                          onTap: () => onNewTab(),
                          leading: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          title: Text("New Tab", style: TextStyle(color: Colors.white)),
                        ),
                      )
                    ] +
                    tabs
                        //.map((tab) => Text("${tab["key"]} ${tab["key"].currentState}")).toList()

                        .mapIndexed((index, tab) {
                      var tabState = ((tab["key"] as GlobalObjectKey).currentState as BrowserTabState);
                      var uriString = tabState?.uri?.toString();
                      var selected = appKey.currentState.previousTabIndex == index + 1;

                        var bookmarked = appKey.currentState.bookmarks.contains(uriString);
                      if (uriString != null) {
                                                return Padding(
                                                    padding: EdgeInsets.only(top: 8),
                                                    child: Card(
                                                        shape: selected
                                                            ? RoundedRectangleBorder(
                                                                side: BorderSide(color: Colors.black, width: 2),
                                                                borderRadius: BorderRadius.circular(5))
                                                            : null,
                                                        child: Row(children: [
                                                          Expanded(
                                                              flex: 1,
                                                              child: ListTile(
                                                                onTap: () => onSelectTab(index + 1),
                                                                leading: Icon(Icons.description),
                                                                subtitle: ExtendedText(
                                                                  tabState.contentData.content
                                                                      .substring(0, math.min(tabState.contentData.content.length, 500)),
                                                                  overflow: TextOverflow.ellipsis,
                                                                  maxLines: 2,
                                                                ),
                                                                title: Text("${tabState.uri.host}", style: TextStyle(fontSize: 14)),
                                                              )),
                                                          IconButton(
                                                            icon: Icon(bookmarked ? Icons.bookmark : Icons.bookmark_border,
                                                                color:
                                                                    bookmarked ? Colors.orange : null),
                                    onPressed: () {
                                      onBookmark(uriString);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      onDeleteTab(index);
                                    },
                                  ),
                                ])));
                      } else {
                        return Text("No tab?");
                      }
                    }).toList())));
  }
}
