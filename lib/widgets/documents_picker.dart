import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:printing/printing.dart';

import '../util/util.dart';
import 'error_message_widget.dart';

typedef FileDocument = PlatformFile;

class DocumentsPickerViewer extends StatefulWidget {
  void Function(List<FileDocument> value)? onChange;
  bool multplesFile;
  List<String> urls;
  String addLabel;

  DocumentsPickerViewer({
    required this.onChange,
    required this.urls,
    this.multplesFile = true,
    this.addLabel = 'Add document',
  });

  @override
  State<DocumentsPickerViewer> createState() => _DocumentsPickerViewerState();
}

class _DocumentsPickerViewerState extends State<DocumentsPickerViewer> {
  List<FileDocument>? currentValues;
  late Future<List<FileDocument>> _listDocsFuture;

  @override
  void initState() {
    _listDocsFuture = getCurrntDocs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _listDocsFuture,
        builder: (c, snap) {
          var picker = DocumentsPicker(
            addLabel: widget.addLabel,
            initialValues: currentValues ?? snap.data,
            onChange: widget.onChange == null
                ? null
                : (values) {
                    currentValues = values;
                    widget.onChange!(values);
                  },
            multplesFile: widget.multplesFile,
          );
          if (snap.hasError) {
            return Column(children: [
              ErrorMessageWidget(snap.error.toString(), snap.stackTrace),
              picker,
            ]);
          }
          return picker;
        });
  }

  Future<List<FileDocument>> getCurrntDocs() async {
    if (currentValues != null) return currentValues!;
    if (widget.urls.isEmpty) return [];
    var result = <FileDocument>[];
    for (var url in widget.urls) {
      var content = await loadContentDoc(url);
      if (content.isNotEmpty)
        result.add(FileDocument(
          name: url,
          path: url,
          bytes: content,
          size: content.length,
        ));
    }
    return result;
  }

  Future<Uint8List> loadContentDoc(String url) async {
    if (url.isEmpty) return Uint8List.fromList([]);
    var response = await get(Uri.parse(url));
    return response.bodyBytes;
  }
}

class DocumentsPicker extends StatelessWidget {
  RxList<FileDocument> listDocs;
  void Function(List<FileDocument> value)? onChange;
  bool multplesFile;
  String addLabel;

  DocumentsPicker({
    required this.onChange,
    List<FileDocument>? initialValues,
    this.multplesFile = true,
    required this.addLabel,
  }) : listDocs = initialValues?.obs ?? <FileDocument>[].obs {
    if (onChange != null) listDocs.listen(onChange!);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        width: Get.width - kPadding * 2,
        decoration: onChange == null
            ? null
            : BoxDecoration(
                border: Border(),
                color: Get.theme.cardColor,
              ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Obx(
            () => listDocs.isEmpty
                ? buildEmptyList()
                : Wrap(children: [
                    for (var doc in listDocs)
                      Card(
                        child: Stack(children: [
                          if (doc.extension == 'pdf')
                            AspectRatio(
                                aspectRatio: 21 / 29,
                                child: PdfPreview(
                                  padding: EdgeInsets.zero,
                                  useActions: false,
                                  build: (format) => doc.bytes!,
                                )),
                          if (doc.extension != 'pdf')
                            Image.memory(
                              doc.bytes!,
                              width: 125,
                            ),
                          if (onChange != null)
                            Positioned(
                              top: 0,
                              left: 0,
                              child: IconButton(
                                  onPressed: () => removeDoc(doc),
                                  icon: Icon(Icons.close,
                                      color: Get.theme.primaryColor)),
                            )
                        ]),
                      )
                  ]),
          ),
          if (onChange != null)
            Padding(
              padding: EdgeInsets.all(kPaddingInternal),
              child: ElevatedButton(
                  child: Text(addLabel.tr), onPressed: addDocument),
            )
        ]));
  }

  Future<void> addDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        withData: true,
        allowMultiple: multplesFile);
    if (result == null) return;
    if (multplesFile != true) listDocs.clear();
    listDocs.addAll(result.files);
  }

  removeDoc(FileDocument doc) {
    listDocs.remove(doc);
  }

  Widget buildPdfIcon(FileDocument doc) {
    return SizedBox(
        height: 150,
        width: 150,
        child: GridTile(
          footer: Container(
            padding: EdgeInsets.symmetric(horizontal: kPaddingInternal),
            color: Get.theme.primaryColor,
            child: Text(doc.name, style: TextStyle(color: Colors.white)),
          ),
          child: Icon(
            Icons.file_present,
            size: 125,
          ),
        ));
  }

  Widget buildEmptyList() {
    if (onChange == null) return Container();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: kPadding),
        Icon(
          Icons.file_present_sharp,
          size: 36,
        ),
        Text(
          'Upload your files in JPG, PNG or PDF format'.tr,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}