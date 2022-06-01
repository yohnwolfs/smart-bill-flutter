import 'package:account_book/models/finance.dart';
import 'package:account_book/navigator/navigation_util.dart';
import 'package:account_book/pages/book_manage_page/book_form.dart';
import 'package:account_book/state/finance_book.dart';
import 'package:account_book/widgets/no_content.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';

class BookManagePage extends StatefulWidget {
  BookManagePage({Key? key}) : super(key: key);

  @override
  _BookManagePageState createState() => _BookManagePageState();
}

class _BookManagePageState extends State<BookManagePage>
    with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;

  final picker = ImagePicker();

  void updateFinanceBookBg(FinanceBook book, PickedFile file) async {
    String path = file.path;
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
    FormData formData = FormData.fromMap(
        {"image": await MultipartFile.fromFile(path, filename: name)});

    Provider.of<FinanceBookState>(context, listen: false)
        .updateFinanceBookBg(book.id!, formData);
  }

  void showEditPanel(FinanceBook book) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return FinanceBookForm(
            data: book,
            onSave: (params) {
              Provider.of<FinanceBookState>(context, listen: false)
                  .updateFinanceBook(book.id!, params);
              Navigator.pop(context);
            },
            onDelete: (deletedData) {
              Provider.of<FinanceBookState>(context, listen: false)
                  .deleteFinanceBook(book.id!);
              Navigator.pop(context);
            },
          );
        });
  }

  void onEnterBook(String bookId) async {
    NavigationUtil.getInstance()
        .pushNamed('book_finance_list', arguments: bookId);
  }

  Widget renderSwiper(List<FinanceBook>? books) {
    if (books == null || books.length == 0)
      return SpinKitThreeBounce(
        color: Theme.of(context).primaryColor,
        size: 50.0,
      );
    // else if (books.length == 0)
    //   return NoContent();
    else
      return new Swiper(
        loop: false,
        itemBuilder: (BuildContext context, int index) {
          final book = books.elementAt(index);

          return Container(
              child: Stack(children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                  height: 260,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey[400]!,
                          blurRadius: 20,
                          offset: Offset(0, 10),
                          spreadRadius: 2)
                    ],
                  ),
                  child: AspectRatio(
                      aspectRatio: 0.74,
                      child: (book.image != null && book.image != '')
                          ? Image.network('${Config().server}${book.image}',
                              fit: BoxFit.cover, errorBuilder: (context, a, b) {
                              return Image.asset(
                                'images/book_default.jpg',
                                fit: BoxFit.cover,
                              );
                            })
                          : Image.asset(
                              'images/book_default.jpg',
                              fit: BoxFit.cover,
                            )))
            ]),
            Positioned(
              right: 42,
              top: 218,
              child: GestureDetector(
                  onTap: () async {
                    final pickedFile = await picker.getImage(
                        source: ImageSource.gallery, imageQuality: 65);

                    if (pickedFile != null) {
                      updateFinanceBookBg(book, pickedFile);
                    }
                  },
                  child: Icon(Icons.image_outlined, color: Colors.grey[500])),
            ),
            Positioned(
              right: 82,
              top: 218,
              child: GestureDetector(
                  onTap: () async {
                    showEditPanel(book);
                  },
                  child: Icon(Icons.edit_outlined, color: Colors.grey[500])),
            ),
            Positioned(
                top: 110,
                left: 0,
                right: 0,
                child: GestureDetector(
                    onTap: () {
                      onEnterBook(book.id!);
                    },
                    child: Align(
                        child: Text(book.name,
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                shadows: [
                                  Shadow(color: Colors.black, blurRadius: 10)
                                ])))))
          ]));
        },
        itemCount: books.length,
        itemWidth: 348.0,
        itemHeight: 470.0,
        viewportFraction: 0.6,
        scale: 1,
        // pagination: new SwiperPagination(),
        // control: new SwiperControl(),
      );
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Consumer<FinanceBookState>(
        builder: (context, financeBookState, child) {
      return Column(children: [
        Padding(
          padding: EdgeInsets.only(top: 22),
        ),
        Text('账本', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Padding(
          padding: EdgeInsets.only(bottom: 12),
        ),
        Container(height: 300, child: renderSwiper(financeBookState.books)),
        Text('归档', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Padding(
          padding: EdgeInsets.only(top: 12),
        ),
        Container(
            height: 300, child: renderSwiper(financeBookState.archiveBooks)),
      ]);
    });
  }
}
