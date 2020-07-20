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
  var selectedItems = [];

  onSelectItem(item) {
    setState(() {
      if (selectedItems.contains(item)) {
        selectedItems.remove(item);
      } else {
        selectedItems.add(item);
      }
    });
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
    //var itemList = BlocProvider.of<ItemBloc>(context).state;

    return RefreshIndicator(
      onRefresh: _gatherBlocs,
      key: _refreshIndicatorKey,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: BlocBuilder<CategoryBloc, List<Category>>(
          builder: (context, categoryList) {
            return BlocBuilder<ItemBloc, List<Item>>(
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
                        SizedBox(width: 20),
                        Text('Selected: ${selectedItems.length}'),
                      ],
                    ),
                    ...List.generate(categoryList.length, (i) {
                      final category = categoryList[i];
                      var categoryItems = itemList
                          .where((element) => element.categoryID == category.id)
                          .toList();
                      return Card(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Slidable(
                            key: Key('$i'),
                            actionPane: SlidableScrollActionPane(),
                            actionExtentRatio: 0.15,
                            actions: <Widget>[
                              Switch(
                                onChanged: (value) {
                                  category.display = value;
                                  category.updateInDB(context);
                                },
                                value: category.display,
                              ),
                              IconSlideAction(
                                caption: 'edit',
                                icon: Icons.edit,
                                color: Colors.blue,
                                onTap: () {
                                  editCategory(context, category);
                                  //_gatherBlocs();
                                },
                              ),
                            ],
                            child: ExpansionTile(
                              childrenPadding:
                              EdgeInsets.symmetric(horizontal: 5),
                              title: Row(
                                children: [
                                  Text('${category.name}'),
                                  Spacer(),
                                  Text('Items: ${categoryItems.length}')
                                ],
                              ),
                              children:
                              List.generate(categoryItems.length, (i) {
                                return IndexExpansionTile(categoryItems[i]);
                              }),
                            ),
                          ),
                        ),
                      );
                    }),
                    Card(
                      color: Colors.grey,
                      child: ExpansionTile(
                        childrenPadding: EdgeInsets.symmetric(horizontal: 5),
                        title: Row(
                          children: [
                            Text('No Category'),
                            Spacer(),
                            Text('Items: ${nullList.length}')
                          ],
                        ),
                        children: List.generate(nullList.length, (i) {
                          return Card(
                            color: Colors.white,
                            child: IndexExpansionTile(nullList[i]),
                          );
                        }),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
