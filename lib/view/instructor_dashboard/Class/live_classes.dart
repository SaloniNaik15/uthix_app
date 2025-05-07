import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class LiveClasses extends StatefulWidget {
  const LiveClasses({Key? key}) : super(key: key);

  @override
  State<LiveClasses> createState() => _LiveClassesState();
}

class _LiveClassesState extends State<LiveClasses> {
  late YoutubePlayerController _youtubeController;

  @override
  void initState() {
    super.initState();
    _youtubeController = YoutubePlayerController.fromVideoId(
      videoId: YoutubePlayerController.convertUrlToId('https://www.youtube.com/watch?v=mlIUKyZIUUU')!,
      params: const YoutubePlayerParams(
        mute: false,
        showFullscreenButton: true,
        enableCaption: true,
        showVideoAnnotations: true,
        enableJavaScript: true,
      ),
    );
  }

  @override
  void dispose() {
    _youtubeController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerScaffold(
      controller: _youtubeController,
      builder: (context, player) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 2,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_outlined,
                size: 25,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    width: MediaQuery.sizeOf(context).width,
                    height: 230,
                    margin: const EdgeInsets.only(top: 20),
                    child: player,
                  ),
                ),
                SizedBox(height: 20.h),
                // _buildChatSection();  (You can add chat section here)
              ],
            ),
          ),
        );
      },
    );
  }
}