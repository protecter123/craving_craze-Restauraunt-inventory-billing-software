class MediaItem {
  String description;
  double charge;
  bool isSelected, openDrawer, isEditable;

  MediaItem(
      {required this.description,
      this.charge = 0.0,
      this.isSelected = false,
      this.openDrawer = false,
      this.isEditable = false});
}
