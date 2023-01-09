import 'package:hive/hive.dart';
import 'package:passman/records/models/password_model.dart';

class PasswordModelAdapter extends TypeAdapter<PasswordModel> {
  @override
  int get typeId => 0;

  @override
  PasswordModel read(BinaryReader reader) {
    var title = reader.readString();
    var login = reader.readString();
    var password = reader.readString();
    var website = reader.readString();
    var notes = reader.readString();
    return PasswordModel(
      title: title,
      login: login,
      password: password,
      website: website,
      notes: notes,
    );
  }

  @override
  void write(BinaryWriter writer, PasswordModel obj) {
    writer.writeString(obj.title ?? "");
    writer.writeString(obj.login ?? "");
    writer.writeString(obj.password ?? "");
    writer.writeString(obj.website ?? "");
    writer.writeString(obj.notes ?? "");
  }
}
