
import 'dart:convert';

class Profile {
  String id;
  String name;
  String job;
  int age;

  Profile({this.id , this.name, this.job, this.age});

  factory Profile.fromJson(Map<String, dynamic> map) {
    return Profile(
        id: map["_id"], name: map["name"], job: map["job"], age: map["age"]);
  }

  Map<String, dynamic> toJson() {
    return {"_id": id, "name": name, "job": job, "age": age};
  }

  @override
  String toString() {
    return 'Profile{_id: $id, name: $name, job: $job, age: $age}';
  }

}

List<Profile> profileFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Profile>.from(data.map((item) => Profile.fromJson(item)));
}

String profileToJson(Profile data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
