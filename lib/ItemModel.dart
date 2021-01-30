class StockItem {
  final int id;
  final String name;
  final String unit;
  final String hsn;
  final String description;
  final double gst;
  final double mrp;
  final double stdRate;
  final double opening;

  StockItem(
      {this.id,
      this.name,
      this.unit,
      this.hsn,
      this.description,
      this.gst,
      this.mrp,
      this.stdRate,
      this.opening});

  Map<String, dynamic> serialize() {
    return {
      'id': id,
      'name': name,
      'unit': unit,
      'hsn': hsn,
      'description': description,
      'gst': gst,
      'mrp': mrp,
      'stdRate': stdRate,
      'opening': opening
    };
  }

  @override
  String toString() {
    return "StockItem{id:$id,name:$name,unit:$unit,hsn:$hsn,description,$description,gst:$gst,mrp:$mrp,stdRate:$stdRate,opening:$opening}";
  }
}
