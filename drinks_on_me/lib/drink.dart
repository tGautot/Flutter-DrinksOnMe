class Drink{
  String name, iconPath;
  int count;

  Drink(this.name, this.iconPath, this.count);

  String toJson(){
    return '{"name":"$name","iconPath":"$iconPath","count":$count}';
  }
}