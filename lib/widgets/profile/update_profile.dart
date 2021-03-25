import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../helpers/channel_helper.dart';

class UpdateProfile extends StatefulWidget {
  final QueryDocumentSnapshot snap;

  const UpdateProfile({Key key, this.snap}) : super(key: key);

  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String url;
  File _selectedImage;
  bool _isLoading = false;
  Channel channel = Channel();
  TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.snap.get('name'));
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  _showPopup() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        contentPadding: const EdgeInsets.all(8.0),
        content: ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt_rounded),
              title: Text('Take a Picture'),
              onTap: () => Navigator.of(context).pop(true),
            ),
            Divider(indent: 15.0, endIndent: 15.0),
            ListTile(
              leading: Icon(Icons.photo_library_rounded),
              title: Text('Choose from Gallery'),
              onTap: () => Navigator.of(context).pop(false),
            ),
          ],
        ),
      ),
    );
  }

  void _selectPicture() async {
    var isCamera = await _showPopup();
    if (isCamera == null && !(isCamera is bool)) {
      print('Nothing chosen');
      return;
    }
    final pickedImage = isCamera
        ? await channel.getImageFromCamera()
        : await channel.getImageFromGallery();
    if (pickedImage != null) {
      final imageFile = File(pickedImage);
      setState(() => _selectedImage = imageFile);
    } else {
      print('No image selected!!');
    }
  }

  void _trySubmit() async {
    if (_formKey.currentState.validate()) {
      FocusScope.of(context).unfocus();
      if (_nameController.text.trim() == widget.snap.get('name') &&
          _selectedImage == null) return;
      _formKey.currentState.save();
      try {
        setState(() => _isLoading = true);
        if (_selectedImage != null) {
          final ref = FirebaseStorage.instance
              .ref()
              .child('user_images')
              .child(widget.snap.id + '.jpg');
          await ref.putFile(_selectedImage);
          url = await ref.getDownloadURL();
        }
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.snap.id)
            .update({
          'name': _nameController.text,
          'imageUrl':
              _selectedImage == null ? widget.snap.get('imageUrl') : url,
        }).whenComplete(
          () => setState(() => _isLoading = false),
        );
        _showSnackBar('Profile updated successfully');
        Navigator.of(context).pop();
      } catch (e) {
        _showSnackBar(e.message);
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 8.0,
        margin: const EdgeInsets.all(8.0),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).cardColor,
        duration: const Duration(seconds: 3),
        content: Text(
          message,
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 15.0,
        right: 15.0,
      ),
      children: [
        const Icon(
          Icons.horizontal_rule_rounded,
          size: 40.0,
          color: Colors.grey,
        ),
        Text(
          'Update Profile',
          textAlign: TextAlign.center,
          style: GoogleFonts.varelaRound(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            color: theme.accentColor,
          ),
        ),
        isPortrait
            ? Column(
                children: [
                  buildImage(),
                  buildForm(theme),
                ],
              )
            : Row(
                children: [
                  buildImage(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: buildForm(theme),
                    ),
                  ),
                ],
              ),
      ],
    );
  }

  Form buildForm(ThemeData theme) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            cursorColor: theme.accentColor,
            style: TextStyle(
              color: Colors.blueAccent,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.person_outline_rounded,
                color: Colors.blueAccent[100],
              ),
              labelText: 'Name',
              labelStyle: TextStyle(
                fontSize: 16,
                color: Colors.blueAccent[100],
                fontWeight: FontWeight.bold,
              ),
              errorStyle: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.blueAccent[100]),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.blueAccent),
              ),
              filled: true,
              fillColor: Colors.grey.withOpacity(0.2),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            ),
            controller: _nameController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value.isEmpty) return 'Please enter a name';
              return null;
            },
          ),
          SizedBox(height: 10.0),
          MaterialButton(
            onPressed: _isLoading ? null : _trySubmit,
            height: 40,
            elevation: 8.0,
            textColor: theme.canvasColor,
            color: theme.accentColor,
            splashColor: Colors.blueAccent[100],
            highlightColor: Colors.blueAccent[100].withOpacity(0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: _isLoading
                ? Padding(
                    padding: const EdgeInsets.all(12.5),
                    child: LinearProgressIndicator(),
                  )
                : Text(
                    "Update",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
          SizedBox(height: 10.0),
        ],
      ),
    );
  }

  InkWell buildImage() {
    return InkWell(
      onTap: _selectPicture,
      child: Container(
        height: 150.0,
        width: 150.0,
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.symmetric(vertical: 16.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueAccent[100]),
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.grey.withOpacity(0.2),
        ),
        child: _selectedImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(19.0),
                child: Image.file(
                  _selectedImage,
                  fit: BoxFit.cover,
                  frameBuilder:
                      (context, child, frame, wasSynchronouslyLoaded) =>
                          wasSynchronouslyLoaded
                              ? child
                              : AnimatedOpacity(
                                  child: child,
                                  opacity: frame == null ? 0 : 1,
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.easeOut,
                                ),
                ),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(19.0),
                child: Image.network(
                  widget.snap.get('imageUrl'),
                  fit: BoxFit.cover,
                ),
              ),
      ),
    );
  }
}
