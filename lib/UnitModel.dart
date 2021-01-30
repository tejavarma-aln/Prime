
class Unit{

  final int id;
  final String name;
  final String symbol;
  final String uqc;

  Unit({this.id,this.name,this.symbol,this.uqc});

  Map<String,dynamic> serialize(){
    return {
      'id':id,
      'name':name,
      'symbol':symbol,
      'uqc':uqc
    };

  }

  @override
  String toString(){
    return "Unit{id:$id,name:$name,symbol:$symbol,uqc:$uqc}";
  }

}