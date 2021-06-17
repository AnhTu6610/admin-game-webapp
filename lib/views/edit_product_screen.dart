import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:logger/logger.dart';
import 'package:trival_admin/data_source/network_data/config/apisubdomain.dart';
import 'package:trival_admin/data_source/network_data/config/restclient.dart';
import 'package:trival_admin/models/response/all_product_res.dart';

class EditProductScreen extends StatefulWidget {
  final ProductDetail product;
  const EditProductScreen({Key? key, required this.product}) : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  RestClient rest = new RestClient(new Dio(), baseUrl: domainServer);
  GlobalKey<FormState> _keyForm = new GlobalKey<FormState>();
  TextEditingController _cateText = new TextEditingController();
  TextEditingController _nameText = new TextEditingController();
  TextEditingController _desText = new TextEditingController();
  bool _isLoadding = false;

  List<String> _oldImg = [];
  List<PlatformFile> _images = [];

  Future getImage() async {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: true,
    );

    setState(() {
      if (pickedFile?.files.first != null) {
        for (var i = 0; i < pickedFile!.files.length; i++) {
          _images.add(pickedFile.files[i]);
        }
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _oldImg = widget.product.image!;
    _cateText.text = widget.product.category!;
    _nameText.text = widget.product.name!;
    _desText.text = widget.product.description!;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _keyForm,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text("Edit product", style: Theme.of(context).textTheme.headline6),
                      Spacer(),
                      CloseButton(),
                    ],
                  ),
                  Divider(),
                  SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _cateText,
                              decoration: InputDecoration(labelText: "Category"),
                            ),
                            TextFormField(
                              controller: _nameText,
                              decoration: InputDecoration(labelText: "Name"),
                            ),
                            TextFormField(
                              controller: _desText,
                              decoration: InputDecoration(labelText: "description"),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 20),
                      Flexible(
                        flex: 2,
                        child: Column(
                          children: [
                            GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _oldImg.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 16 / 9,
                                mainAxisSpacing: 5,
                                crossAxisSpacing: 5,
                              ),
                              itemBuilder: (context, index) => Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Image.network(
                                    "$domainServer${_oldImg[index]}",
                                    fit: BoxFit.cover,
                                  ),
                                  Container(
                                    color: Colors.white,
                                    margin: EdgeInsets.all(5),
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _oldImg.removeAt(index);
                                        });
                                      },
                                      icon: Icon(Icons.delete_outline_outlined),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(),
                            GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _images.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 16 / 9,
                                mainAxisSpacing: 5,
                                crossAxisSpacing: 5,
                              ),
                              itemBuilder: (context, index) => Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Image.memory(
                                    _images[index].bytes!,
                                    height: 200,
                                  ),
                                  Container(
                                    color: Colors.white,
                                    margin: EdgeInsets.all(5),
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _images.removeAt(index);
                                        });
                                      },
                                      icon: Icon(Icons.delete_outline_outlined),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            ElevatedButton.icon(
                              onPressed: () {
                                getImage();
                              },
                              icon: Icon(Icons.add),
                              label: Text("Images"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _isLoadding = true;
                      });
                      await rest
                          .updateProduct(
                        id: widget.product.id!,
                        category: _cateText.text,
                        name: _nameText.text,
                        description: _desText.text,
                        status: "success",
                        oldImg: _oldImg,
                        img: _images.map((e) => e.bytes!.toList()).toList(),
                      )
                          .catchError(
                        (Object obj) {
                          switch (obj.runtimeType) {
                            case DioError:
                              final res = (obj as DioError).response;
                              Logger().e("Got error : ${res?.statusCode} -> ${res?.statusMessage}");
                              break;
                            default:
                          }
                        },
                      ).then((value) {
                        if (value?.response.statusCode == 200) Navigator.pop(context, true);
                      });

                      setState(() {
                        _isLoadding = false;
                      });
                    },
                    child: Text("Submit"),
                  ),
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: _isLoadding,
          child: Container(
            color: Colors.white30,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ],
    );
  }
}
