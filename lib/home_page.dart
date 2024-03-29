import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:ui' as ui;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey _globalKey = GlobalKey();

  final ImagePicker picker = ImagePicker();
  XFile? photo;

  _saveLocalImage() async {
    RenderRepaintBoundary boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData =
        await (image.toByteData(format: ui.ImageByteFormat.png));
    if (byteData != null) {
      final result =
          await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
      print(result);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Simpan Berhasil')));
      // Utils.toast(result.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Flutter Basic',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        elevation: 3,
        backgroundColor: Colors.blue,
        actions: const [
          Icon(Icons.person, color: Colors.white),
          SizedBox(
            width: 8,
          ),
          Icon(Icons.settings, color: Colors.white),
          SizedBox(
            width: 16,
          ),
        ],
        leading: const Icon(
          Icons.menu,
          color: Colors.white,
        ),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RepaintBoundary(
                key: _globalKey,
                child: Container(
                  alignment: Alignment.center,
                  // width: 300,
                  height: 300,
                  color: Colors.blue,
                  child: photo == null
                      ? const SizedBox()
                      : Image.file(File(photo!.path)),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          ElevatedButton(
            onPressed: () {
              _saveLocalImage();
            },
            child: Text('Simpan Gambar', style: TextStyle(color: Colors.black)),
          )
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () async {
          photo = await picker.pickImage(source: ImageSource.camera);
          setState(() {});
        },
        child: const Icon(
          Icons.camera,
          color: Colors.white,
        ),
      ),

      // body: Column(
      //   children: [
      //     Container(
      //       padding: const EdgeInsets.all(16),
      //       width: 300,
      //       height: 300,
      //       decoration: BoxDecoration(
      //           color: Colors.red, borderRadius: BorderRadius.circular(20)),
      //       child: Image.network(
      //           'https://img.freepik.com/premium-photo/bakso-baso-is-indonesian-meatball-its-texture-is-similar-chinese-beef-ball-fish-ball_685424-102.jpg?w=900'),
      //     ),
      //     Image.asset('assets/images/img1.jpg'),
      //     const CircleAvatar(
      //       radius: 50,
      //       backgroundImage: NetworkImage(
      //           'https://img.freepik.com/premium-photo/bakso-baso-is-indonesian-meatball-its-texture-is-similar-chinese-beef-ball-fish-ball_685424-102.jpg?w=900'),
      //     )
      //   ],
      // ),
    );
  }
}
