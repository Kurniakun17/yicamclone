import 'package:flutter/material.dart';
import 'package:gesture_zoom_box/gesture_zoom_box.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Home extends StatefulWidget {
  final WebSocketChannel channel;
  const Home({Key? key, required this.channel}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final videoWidth = 640;
  final videoHeight = 480;

  double newVideoSizeWidth = 640;
  double newVideoSizeHeight = 480;

  late bool isLandscape;

  @override
  void initState() {
    super.initState();
    isLandscape = false;
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: ((context, orientation) {
        var screenWidth = MediaQuery.of(context).size.width;
        var screenHeight = MediaQuery.of(context).size.height;

        if (orientation == Orientation.portrait) {
          isLandscape = false;
          newVideoSizeWidth = screenWidth > videoWidth.toDouble()
              ? videoWidth.toDouble()
              : screenWidth;
          newVideoSizeHeight = videoHeight * newVideoSizeWidth / videoWidth;
        } else {
          isLandscape = false;
          newVideoSizeHeight = screenHeight > videoHeight.toDouble()
              ? videoHeight.toDouble()
              : screenHeight;
          newVideoSizeWidth = videoWidth * newVideoSizeHeight / videoHeight;
        }
        return Container(
          color: Colors.black,
          child: StreamBuilder(
            stream: widget.channel.stream,
            builder: ((context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                );
              } else {
                return Stack(
                  children: [
                    GestureZoomBox(
                      maxScale: 5,
                      doubleTapScale: 2,
                      duration: const Duration(milliseconds: 200),
                      child: Image.memory(
                        snapshot.data,
                        gaplessPlayback: true,
                        width: newVideoSizeWidth,
                        height: newVideoSizeHeight,
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        child: Column(
                          children: const [
                            SizedBox(
                              height: 16,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                );
              }
            }),
          ),
        );
      }),
    );
  }
}
