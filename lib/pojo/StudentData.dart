class StudentData {
  String? sId;
  String? rollno;
  String? email;
  String? username;
  String? password;
  String? dob;
  String? gender;
  String? language;
  String? contactno;
  String? sImage;
  String? isActive;
  int? iV;

  StudentData(
      {this.sId,
        this.rollno,
        this.email,
        this.username,
        this.password,
        this.dob,
        this.gender,
        this.language,
        this.contactno,
        this.sImage,
        this.isActive,
        this.iV});

  StudentData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    rollno = json['rollno'];
    email = json['email'];
    username = json['username'];
    password = json['password'];
    dob = json['dob'];
    gender = json['gender'];
    language = json['language'];
    contactno = json['contactno'];
    sImage = json['sImage'];
    isActive = json['isActive'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['rollno'] = this.rollno;
    data['email'] = this.email;
    data['username'] = this.username;
    data['password'] = this.password;
    data['dob'] = this.dob;
    data['gender'] = this.gender;
    data['language'] = this.language;
    data['contactno'] = this.contactno;
    data['sImage'] = this.sImage;
    data['isActive'] = this.isActive;
    data['__v'] = this.iV;
    return data;
  }
}