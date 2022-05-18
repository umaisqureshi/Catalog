/*

class UserServices {
  String ref = "users";
  createUser(Map value) async {
    String id=value["userId"];
    await  _database
        .reference()
        .child("$ref/$id")
        .set(value)
        .catchError((e) => {print(e.toString())});
  }
}
*/
