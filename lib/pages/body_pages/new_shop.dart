import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer/assets/general_assets/expansionTiles.dart';
import 'package:organizer/assets/objectClasses/item.dart';
import 'package:organizer/bloc/item_bloc/item_bloc.dart';
import 'package:organizer/bloc/settings_bloc/settings_bloc.dart';
import 'package:organizer/db/preferencesDB.dart';
import 'package:organizer/events/item_event.dart';
import 'package:organizer/events/settings_event.dart';
import 'package:organizer/style/designStyle.dart';

import '../../events/category_event.dart';
import '../../assets/objectClasses/category_class.dart';
import '../../bloc/category_bloc/category_bloc.dart';
import '../../db/database.dart';
import '../../style/lang.dart';

//TODO: translate
//TODO: fix imports

class Shop extends StatefulWidget {
  @override
  _ShopState createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Future<void> _gatherBlocs() async {
    DatabaseProvider.db.getCategories().then(
      (categoryList) {
        BlocProvider.of<CategoryBloc>(context)
            .add(CategoryEvent.setItems(categoryList));
      },
    );
    DatabaseProvider.db.getItems().then(
      (itemList) {
        itemList.forEach((item) {
          if (item.categoryID != null) {
            DatabaseProvider.db.getCategoryByID(item.categoryID).then((string) {
              setState(() {
                item.categoryName = string;
              });
            });
          } else {
            item.categoryName = 'No Category';
          }
        });
        BlocProvider.of<ItemBloc>(context).add(ItemEvent.setItems(itemList));
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _gatherBlocs();
    getPreferences().then((settings) {
      BlocProvider.of<SettingsBloc>(context)
          .add(SettingsEvent.update(settings));
    });
  }

  newCategory(BuildContext context) {
    TextEditingController customController = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          customController.clear();
          return AlertDialog(
            title: Text(catLang['new_category'][lang]),
            content: TextField(
              decoration: InputDecoration(
                labelText: catLang['new_category_question'][lang],
              ),
              controller: customController,
            ),
            actions: <Widget>[
              MaterialButton(
                child: Text(genLang['submit'][lang]),
                onPressed: () {
                  Navigator.of(context).pop(customController.text);
                },
              ),
              MaterialButton(
                child: Text(genLang['cancel'][lang]),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    //var itemList = BlocProvider.of<ItemBloc>(context).state;

    return RefreshIndicator(
      onRefresh: _gatherBlocs,
      key: _refreshIndicatorKey,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: BlocConsumer<CategoryBloc, List<Category>>(
          buildWhen: (List<Category> previous, List<Category> current) {
            return true;
          },
          listenWhen: (List<Category> previous, List<Category> current) {
            if ((current != previous) && (previous.length != 0)) {
              return true;
            }
            return false;
          },
          builder: (context, categoryList) {
            return BlocConsumer<ItemBloc, List<Item>>(
              builder: (context, itemList) {
                double cartPrice = 0;
                itemList.forEach((item) {
                  var offset = item.amountBase - item.amountInStock;
                  if (item.categoryID == null) {
                    if (showControl) {
                      cartPrice += offset * item.pricePerUnit;
                    }
                  } else if (offset > 0) {
                    cartPrice += offset * item.pricePerUnit;
                  }
                });
                var nullList = itemList
                    .where((element) => element.categoryID == null)
                    .toList();
                var offsetNulls = nullList.where(
                    (element) => element.amountBase > element.amountInStock);
                Widget showUnCategorizedItems() {
                  if (showControl && offsetNulls.length > 0) {
                    return Card(
                      color: Colors.grey,
                      child: ExpansionTile(
                        childrenPadding: EdgeInsets.symmetric(horizontal: 5),
                        title: Row(
                          children: [
                            Text('No Category'),
                            Spacer(),
                            Text('${offsetNulls.length}/${nullList.length}')
                          ],
                        ),
                        children: List.generate(nullList.length, (i) {
                          var offset = nullList[i].amountBase -
                              nullList[i].amountInStock;
                          if (offset > 0) {
                            return Card(
                              color: Colors.white,
                              key: Key('$i'),
                              child: ShopExpansionTile(nullList[i]),
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        }),
                      ),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                }

                return ListView(
                  physics: ScrollPhysics(),
                  padding: EdgeInsets.only(left: 16, right: 16, bottom: 55),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: [
                    Text(
                      '${shopLang['price'][lang]} ${currency(cartPrice)}',
                      style: text['cart'],
                      textAlign: TextAlign.center,
                    ),
                    ...List.generate(categoryList.length, (i) {
                      final category = categoryList[i];
                      var categoryItems = itemList
                          .where((element) => element.categoryID == category.id)
                          .toList();
                      var offsetItems = categoryItems.where((element) =>
                          element.amountBase > element.amountInStock);
                      if (offsetItems.length == 0) {
                        return SizedBox.shrink();
                      } else {
                        return Card(
                          child: ExpansionTile(
                            childrenPadding:
                                EdgeInsets.symmetric(horizontal: 5),
                            title: Row(
                              children: [
                                Text('${category.name}'),
                                Spacer(),
                                Text(
                                    '${offsetItems.length}/${categoryItems.length}')
                              ],
                            ),
                            children: List.generate(categoryItems.length, (i) {
                              var offset = categoryItems[i].amountBase -
                                  categoryItems[i].amountInStock;
                              if (offset > 0) {
                                return Card(
                                  key: Key('$i'),
                                  child: ShopExpansionTile(categoryItems[i]),
                                );
                              } else {
                                return SizedBox.shrink();
                              }
                            }),
                          ),
                        );
                      }
                    }),
                    showUnCategorizedItems(),
                  ],
                );
              },
              listener: (BuildContext context, itemList) {},
            );
          },
          listener: (BuildContext context, itemList) {},
        ),
      ),
    );
  }
}
