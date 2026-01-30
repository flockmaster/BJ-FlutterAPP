abstract class BaseModel {
  Map<String, dynamic> toJson();
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return runtimeType == other.runtimeType;
  }

  @override
  int get hashCode => runtimeType.hashCode;
}