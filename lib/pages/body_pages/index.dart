import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:organizer/assets/general_assets/categoryForm.dart';
import 'package:organizer/assets/general_assets/editCategoryForm.dart';
import 'package:organizer/assets/general_assets/expansionTiles.dart';
import 'package:organizer/assets/objectClasses/item.dart';
import 'package:organizer/bloc/item_bloc/item_bloc.dart';
import 'package:organizer/bloc/settings_bloc/settings_bloc.dart';
import 'package:organizer/db/preferencesDB.dart';
import 'package:organizer/events/item_event.dart';
import 'package:organizer/events/settings_event.dart';

import '../../events/category_event.dart';
import '../../assets/objectClasses/category_class.dart';
import '../../bloc/category_bloc/category_bloc.dart';
import '../../db/database.dart';
import '../../style/lang.dart';

//TODO: translate
//TODO: fix imports

class CategoriesView extends StatefulWidget {
  @override
  _CategoriesViewState createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  bool selectMode = false;
  var selectedItems = [];

  selectItem(bool b, Item item) {
    setState(() {
      if (b) {
        selectedItems.add(item);
      } else {
        selectedItems.remove(item);
      }
    });
    if (selectedItems.length == 0) {
      setState(() {
        selectMode = false;
      });
    }
  }

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
            content: Wrap(
              children: [CategoryForm()],
            ),
          );
        });
  }

  editCategory(BuildContext context, Category category) {
    TextEditingController customController = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          customController.clear();
          return AlertDialog(
            title: Text(catLang['new_category'][lang]),
            content: Wrap(
              children: [EditCategoryForm(category)],
            ),
          );
        }).then((val) {
      return _gatherBlocs();
    });
  }

  @override
  Widget build(BuildContext context) {
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
            return true;
          },
          builder: (context, categoryList) {
            var sortColumn = 0;
            var sortAscending = true;
            return BlocConsumer<ItemBloc, List<Item>>(
              builder: (context, itemList) {
                var nullList = itemList
                    .where((element) => element.categoryID == null)
                    .toList();
                return ListView(
                  physics: ScrollPhysics(),
                  padding: EdgeInsets.only(left: 16, right: 16, bottom: 55),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: [
                    FittedBox(
                      child: DataTable(
                        showCheckboxColumn: selectMode,
                        columns: [
                          DataColumn(
                            label: Text('Category'),
                          ),
                          DataColumn(
                            label: Text('Name'),
                          ),
                          DataColumn(
                            label: Text('Stock\\Base'),
                          ),
                          DataColumn(
                            label: Text('Price'),
                          ),
                        ],
                        rows: [
                          ...List.generate(itemList.length, (i) {
                            var item = itemList[i];
                            return DataRow(
                              onSelectChanged: (bool) {
                                if (!selectMode) {
                                  setState(() {
                                    selectMode = true;
                                  });
                                }
                                selectItem(bool, item);
                              },
                              selected: selectedItems.contains(item),
                              cells: [
                                DataCell(RaisedButton(
                                  onPressed: () {},
                                  child: Text('${item.categoryName}'),
                                  onLongPress: () {
                                    if (!selectMode) {
                                      setState(() {
                                        selectMode = true;
                                        selectedItems.add(item);
                                      });
                                    }
                                  },
                                )),
                                DataCell(Text('${item.name}')),
                                DataCell(Text(
                                    '${item.amountInStock}\\${item
                                        .amountBase}')),
                                DataCell(Text('${item.getPrice()}')),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RaisedButton(
                          child: Text('Empty Stock'),
                          onPressed: () {
                            DatabaseProvider.db.clearStock();
                            DatabaseProvider.db.getItems().then((itemList) {
                              BlocProvider.of<ItemBloc>(context)
                                  .add(ItemEvent.setItems(itemList));
                            });
                          },
                        ),
                      ],
                    ),
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
