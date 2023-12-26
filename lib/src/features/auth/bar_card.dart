import 'package:datingapp/src/features/auth/register_info.dart';
import 'package:flutter/material.dart';
import 'package:datingapp/src/features/auth/bar_list.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BarCard extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _BarCardState createState() => _BarCardState();
  final List<Bars> info;
  const BarCard({Key? key, required this.info}) : super(key: key);
}

class _BarCardState extends State<BarCard> {
  String selectedId = "";

  @override
  Widget build(BuildContext context) {
    return GroupedListView(
      order: GroupedListOrder.ASC,
      elements: widget.info,
      groupBy: (bar) => bar.id,
      groupSeparatorBuilder: (value) {
        return const SizedBox();
      },
      itemBuilder: (context, element) {
        return Column(
          children: [
            TextButton(
                onPressed: () async{
                  // ignore: constant_identifier_names
                  setState(() {
                    selectedId = element.id;
                  });
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.setString("bar_id", element.id);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${element.barName}\n${element.residence}',
                        style: const TextStyle(
                            color: Color.fromARGB(255, 155, 110, 124)),
                      ),
                    ),
                    Icon(
                      Icons.check,
                      color: selectedId == "" ? 1 == element.id ? Colors.pink : Colors.green : selectedId == element.id  ? Colors.pink : Colors.green,
                      size: 24.0,
                      semanticLabel: 'Text to announce in accessibility modes',
                    )
                  ],
                )),
            const Divider(
              color: Color.fromARGB(255, 155, 110, 124),
              thickness: 1.0,
            ),
          ],
        );
      },
    );
  }
}
