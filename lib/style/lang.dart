import 'package:flutter/material.dart';

var languages = ['HE','EN'];

String lang;

var dirLang = {
  /// explicit directions in names refer to EN direction
  'genDir': {
    'EN': TextDirection.ltr,
    'HE': TextDirection.rtl,
  },
  'tile_left': {
    'EN': TextAlign.left,
    'HE': TextAlign.right,
  },
  'tile_right': {
    'EN': TextAlign.right,
    'HE': TextAlign.left,
  },
};

var genLang = {
  'yes':{
    'EN':'Yes',
    'HE':'כן'
  },
  'no':{
    'EN':'No',
    'HE':'לא'
  },
  'confirm':{
    'EN':'Confirm',
    'HE':'אישור'
  },
  'cancel':{
    'EN':'Cancel',
    'HE':'בטל'
  },
  'save':{
    'EN':'Save',
    'HE':'שמור'
  },
  'delete':{
    'EN':'Delete',
    'HE':'מחק'
  },
  'edit':{
    'EN':'Edit',
    'HE':'ערוך את'
  },
  'submit':{
    'EN':'Submit',
    'HE':'שלח'
  },
  'updated':{
    'EN':'Updated',
    'HE':'עודכן'
  },
};

var mainLang = {
  'index':{
    'EN':'Inventory',
    'HE':'מחסן'
  },
  'shop':{
    'EN':'Shopping Cart',
    'HE':'עגלת קניות'
  },
};

var drawerLang = {
  'options':{
    'EN':'Options',
    'HE':'אפשרויות'
  },
};

var formLang = {
  'delete':{
    'EN':'Delete',
    'HE':'מחק את'
  },
  'confirm1':{
    'EN':'Are you sure you want to delete the item',
    'HE':'האם אתה בטוח שברצונך למחוק את המוצר'
  },
  'confirm2':{
    'EN':'from your inventory?',
    'HE':'מהמחסן שלך?'
  },
  'name':{
    'EN':'Item name',
    'HE':'שם המוצר'
  },
  'name_val':{
    'EN':'Name is required',
    'HE':'נא להזין את שם המוצר'
  },
  'ppu':{
    'EN':'Price Per Unit',
    'HE':'מחיר ליחידה'
  },
  'ppu_val1':{
    'EN':'Price is required',
    'HE':'נא להזין מחיר'
  },
  'ppu_val2':{
    'EN':'Please enter a valid number',
    'HE':'נא להזין מספר תקין'
  },
  'ppu_val3':{
    'EN':'Wishful thinking is nice but price must be larger than zero',
    'HE':'אולי יום אחד אבל בינתיים המחיר חייב להיות גדול מאפס'
  },
  'stock':{
    'EN':'How many do you have right now?',
    'HE':'כמה יש לך כרגע?'
  },
  'stock_val1':{
    'EN':'This field cannot be empty, for zero insert 0',
    'HE':'נא להזין מספר תקין, ניתן להזין 0'
  },
  'stock_val2':{
    'EN':'Please enter a positive whole number',
    'HE':'נא להזין מספר שלם'
  },
  'base':{
    'EN':'How many do you usually need?',
    'HE':'לכמה אתה זקוק בדרך כלל?'
  },
  'base_val1':{
    'EN':'Base amount is required',
    'HE':'נא להזין כמות בסיס'
  },
  'base_val2':{
    'EN':'Please enter a positive whole number',
    'HE':'נא להזין מספר חיובי שלם'
  },
  'base_val3':{
    'EN':'Base amount cannot be zero',
    'HE':'כמות הבסיס חייבת להיות גדולה מאפס'
  },

};

var expLang = {
  'base':{
    'EN':'Base Amount:',
    'HE':'כמות בסיס:'
  },
  'price1':{
    'EN':'Need to buy',
    'HE':'נותר לקנות'
  },
  'price2':{
    'EN':'for',
    'HE':'בעלות של'
  },
  'update':{
    'EN':'Update List',
    'HE':'עדכן רשימה'
  },
  'update_shop_question':{
    'EN':'How many did you get?',
    'HE':'כמה קנית?'
  },
  'fill':{
    'EN':'Fill',
    'HE':'מלא'
  },
  'need':{
    'EN':'Need:',
    'HE':'חסרים:'
  },
  'price_of':{
    'EN':'For the price of',
    'HE':'בעלות של'
  },
  'update_stock_question':{
    'EN':'How many did you use?',
    'HE':'בכמה השתמשת?'
  },
  'update_stock_helper':{
    'EN':'entering more than you have will empty stock',
    'HE':'הזנה של יותר ממה שיש לך תרוקן את המחסן'
  },
  'stock':{
    'EN':'In Stock:',
    'HE':'במחסן:'
  },
  'bought':{
    'EN':'Update List',
    'HE':'עדכן רשימה'
  },
  'bought_question':{
    'EN':'How many did buy?',
    'HE':'כמה קנית?'
  },
  'used':{
    'EN':'Update List',
    'HE':'עדכן רשימה'
  },
  'used_question':{
    'EN':'How many did you use?',
    'HE':'בכמה השתמשת?'
  },
};

var fltLang = {
  'add':{
    'EN':'Add Item',
    'HE':'הוסף מוצר'
  },
  'add_tltp':{
    'EN':'Add a new item',
    'HE':'הוסף מוצר חדש'
  }
};

var indLang = {
  'name':{
    'EN':'Name',
    'HE':'שם'
  },
  'stock':{
    'EN':'Stock',
    'HE':'כמות במחסן'
  },
};

var shopLang = {
  'price':{
    'EN':'Total Price:',
    'HE':'סכום כולל:'
  }
};

var setLang = {
  'settings':{
    'EN':'Settings',
    'HE':'הגדרות'
  },
  'nothing':{
    'EN':'Nothing to see here yet',
    'HE':'אין כאן מה לראות עדיין'
  },
  'language':{
    'EN':'Change Language',
    'HE':'שנה שפה'
  },
  'theme':{
    'EN':'Change Theme',
    'HE':'החלף סגנון'
  },
  'default':{
    'EN':'Default Theme',
    'HE':'סגנון ברירת מחדל'
  },
  'alt':{
    'EN':'Alternative Theme',
    'HE':'סגנון אלטרנטיבי'
  },
  'HE':{
    'EN':'Hebrew',
    'HE':'עברית'
  },
  'EN':{
    'EN':'English',
    'HE':'אנגלית'
  },
  'currency':{
    'EN':'Select your currency',
    'HE':'בחר מטבע'
  },
  'ILS':{
    'EN':'Israeli Shekel',
    'HE':'שקל'
  },
  'USD':{
    'EN':'US Dollar',
    'HE':'דולר'
  },
  'GBP':{
    'EN':'English Pound',
    'HE':'פאונד'
  },
  'JPY':{
    'EN':'Japanese Yen',
    'HE':'ין'
  },

};

var restLang = {
  'empty':{
    'EN':'Empty',
    'HE':'רוקן'
  }
};