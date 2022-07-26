import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Shima extends StatefulWidget {
  const Shima({Key? key}) : super(key: key);

  @override
  _ShimaState createState() => _ShimaState();
}

class _ShimaState extends State<Shima> {
  bool _enabled = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Shimmer.fromColors(
              baseColor: Colors.white,
              highlightColor: const Color(0xffeeeeee),
              enabled: _enabled,
              child: ListView.builder(
                itemBuilder: (_, __) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 48.0,
                        height: 48.0,
                        color: Colors.white,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              height: 8.0,
                              color: Colors.white,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 2.0),
                            ),
                            Container(
                              width: double.infinity,
                              height: 8.0,
                              color: Colors.white,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 2.0),
                            ),
                            Container(
                              width: 40.0,
                              height: 8.0,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                itemCount: 12,
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 8.0),
          //   child: FlatButton(
          //       onPressed: () {
          //         setState(() {
          //           _enabled = !_enabled;
          //         });
          //       },
          //       child: Text(
          //         _enabled ? 'Stop' : 'Play',
          //         style: TextStyle(
          //             fontSize: 18.0,
          //             color: _enabled ? Colors.redAccent : Colors.green),
          //       )),
          // )
        ],
      ),
    );
  }
}
