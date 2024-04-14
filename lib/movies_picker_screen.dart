
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MoviesPickerScreen extends StatefulWidget {
  const MoviesPickerScreen({super.key});

  @override
  State<MoviesPickerScreen> createState() => _MoviesPickerScreenState();
}

class _MoviesPickerScreenState extends State<MoviesPickerScreen> {

  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final List<String> storedImage = [];
  XFile? _pickedImage;

  @override
  void initState() {
    super.initState();
    _getImageFromStorage();
  }

  Future<void> _getImageFromStorage() async {
    final storageRef = _firebaseStorage.ref().child('picture');
    final listResult = listAllPaginated(storageRef);
    storedImage.clear();
    await for(ListResult result in listResult){
      for (Reference reference in result.items){
        final url = await reference.getDownloadURL();
        storedImage.add(url);
        setState(() {});
      }
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Images'),
      ),
      body: GridView.builder(
        itemCount: storedImage.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemBuilder: (context, index){
          return Card(
            child: Image.network(
              storedImage[index],
              fit: BoxFit.cover,
            ),
          );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _takeImageFromGallery();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Stream<ListResult> listAllPaginated(Reference storedRef) async* {
    String? pageToken;
    do{
      final listResult = await storedRef.list(
        ListOptions(
          maxResults: 100,
          pageToken: pageToken,
        )
      );
      yield listResult;
      pageToken = listResult.nextPageToken;
    }while (pageToken != null);
  }

  Future<void> _takeImageFromGallery() async {
    final ImagePicker imagePicker = ImagePicker();
    _pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    if(_pickedImage != null) {
      File imageFile = File(_pickedImage!.path);
      await _uploadImageToFireBase(imageFile);
    }
  }

  Future<void> _uploadImageToFireBase(File imageFile) async {
    final storageRef = _firebaseStorage.ref().child('picture/${_pickedImage!.name}');
    await storageRef.putFile(imageFile);
    _getImageFromStorage();
  }
}
