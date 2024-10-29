import 'package:craving_craze/Screens/Admin/Setting/Media/media_model.dart';
import 'package:flutter/material.dart';

class MediaProvider extends ChangeNotifier{
 final List<MediaItem> _mediaItems = [
   MediaItem(description: 'CASH',isEditable: false),
   MediaItem(description: 'CREDIT',isEditable: false),
   MediaItem(description: 'TOT3',isEditable: false),
   MediaItem(description: 'TOT4',isEditable: false),
   MediaItem(description: 'TOT5',isEditable: false),
   MediaItem(description: 'TOT6',isEditable: false),
   MediaItem(description: 'TOT7',isEditable: false),
   MediaItem(description: 'DEBIT',isEditable: false),
   MediaItem(description: 'VIPCard',isEditable: false),
 ];

 List<MediaItem> get mediaItems => _mediaItems;

 void toggleSelection(int index){
   _mediaItems[index].isSelected = !_mediaItems[index].isSelected;
   notifyListeners();
 }

 void toggleOpenDrawer(int index){
   _mediaItems[index].openDrawer = !_mediaItems[index].openDrawer;
   notifyListeners();
 }

 void updateCharge (int index, double newCharge){
   _mediaItems[index].charge = newCharge;
   notifyListeners();

 }
}