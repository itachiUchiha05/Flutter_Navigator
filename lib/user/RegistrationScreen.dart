import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_navigator/components/custom_text_field.dart';
import 'package:flutter_navigator/components/radioButton.dart';
import 'package:flutter_navigator/components/splash_button.dart';
import 'package:flutter_navigator/pojo/StudentData.dart';
import 'package:flutter_navigator/pojo/StudentDetailResponse.dart';
import 'package:flutter_navigator/pojo/listItem.dart';
import 'package:flutter_navigator/services/rest_api.dart';
import 'package:flutter_navigator/user/LoginScreen.dart';
import 'package:flutter_navigator/user/RegistrationScreen.dart';
import 'package:flutter_navigator/user/profileScreen.dart';
import 'package:flutter_navigator/utils/config.dart';
import 'package:flutter_navigator/utils/constant.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../pojo/CommonResponse.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = "RegistrationScreen";

  final Map arguments;

  const RegistrationScreen({Key? key,required this.arguments}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreen();
}

class _RegistrationScreen extends State<RegistrationScreen> with SingleTickerProviderStateMixin{
  TextEditingController rollNumberController =  TextEditingController();
  TextEditingController userNameController =  TextEditingController();
  TextEditingController passwordController =  TextEditingController();
  TextEditingController contactNumberController =  TextEditingController();
 // TextEditingController genderController =  TextEditingController();
  TextEditingController dobController =  TextEditingController();
  //TextEditingController languageController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  //TextEditingController dobController = TextEditingController();
 // dob = studentData.studentDOB;
 // gender = studentData.gender;

  DateTime startDate = DateTime.now();
  StudentData studentData = StudentData();

  String? userName,rollNumber,password,contact,email,address,dob,pageTitle,type,id;
  String gender= "";
  String language = "";

  final List<ListItem> _languages = [
    ListItem("eng", "eng"),
    ListItem("guj", "guj"),
    ListItem("hindi", "hindi"),
  ];

  List<DropdownMenuItem<ListItem>>? _languageItems;
  ListItem? _selectedItem;

  List<String> languages = ['guj','eng','hindi'];
  List<String> languageselected =[];


  bool showspinner = false;
  Config config = Config();
  RestApi restApi = RestApi();
  Permission? permission;


  @override
  void initState() {
    super.initState();

    pageTitle = widget.arguments['pageTitle'];
    type = widget.arguments['type'];
    //id = widget.arguments['id'];

    _languageItems = buildDropDownMenuItems(_languages);

    if(type=="edit"){
     profile();
    }
  }

  List<DropdownMenuItem<ListItem>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<ListItem>> items = [];
    for(ListItem listItem in listItems) {
      items.add(
        DropdownMenuItem(value: listItem,child: Text(listItem.name))
      );
    }
    return items;


  }

  Widget buildMultiSelect() {
    final items = languages
        .map((animal) => MultiSelectItem<String>(animal, animal))
        .toList();
    if(type=="edit") {
      for(var element in languages) {
        if(language.contains(",")){
          language.split(",").forEach((rank) {
            if(rank == element && rank != "") {
              languageselected.add(element);
            }
          });
        } else {
          if(language== element && language != ""){
            languageselected.add(element);
          }
        }
      }
    }

    return MultiSelectBottomSheetField(initialChildSize: 0.4,
    buttonIcon: const Icon(
      Icons.filter_alt_outlined,
      size: 15,
      color: KDarkAppBarColor,
    ),

      listType: MultiSelectListType.LIST,
      searchable: true,
      buttonText: const Text(""
          "select lanaguages", style: TextStyle(color: KDarkAppBarColor),)  ,
      title: const Text("languages"),
      items: items,
      initialValue: languageselected,
      onConfirm: (values) {
      for(var element in values) {
        languageselected.add(element.toString());
      }
      },
      selectedColor: kAppBarColor,
      itemsTextStyle: const TextStyle(color: KDarkAppBarColor),
      chipDisplay: MultiSelectChipDisplay(
        onTap: (value) {
          setState(() {
            languageselected.remove(value);
          });
        },
      ),
    );
  }

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: kAppBarColor,
      appBar: AppBar(
        title: Text(pageTitle!),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: KDarkAppBarColor,
      ),
      body: showspinner ? config.loadingView()
          : Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[


              EditTextIcon(

                hintText: "Roll no",
                keyBoardType: TextInputType.text,
                password: false,
                textController: rollNumberController,
                fillColor: Colors.white,
                borderWidth: 1.0,
                leadingIcon: const Icon(
                  Icons.numbers,
                  color: KDarkAppBarColor,
                ),
                onTap: () {},
                hintColor: KDarkAppBarColor,
                readOnly: false,
                borderRadius: 5.0,
                maxLines: 1,
                focusedBorderColor: Colors.grey,
                inputAction: TextInputAction.next,
              ),
              //Username
              EditTextIcon(

                hintText: "User Name",
                keyBoardType: TextInputType.text,
                password: false,
                textController: userNameController,
                fillColor: Colors.white,
                borderWidth: 1.0,
                leadingIcon: const Icon(
                  Icons.person,
                  color: KDarkAppBarColor,
                ),
                onTap: () {},
                hintColor: KDarkAppBarColor,
                readOnly: false,
                borderRadius: 5.0,
                maxLines: 1,
                focusedBorderColor: Colors.grey,
                inputAction: TextInputAction.next,
              ),
              EditTextIcon(
                hintText: "Password",
                hintColor: KDarkAppBarColor,
                keyBoardType: TextInputType.visiblePassword,
                password: true,
                leadingIcon: const Icon(
                  Icons.lock_outline,
                  color: KDarkAppBarColor,
                ),
                textController: passwordController,
                fillColor: Colors.white,
                borderWidth: 1.0,
                onTap: () {},
                readOnly: false,
                borderRadius: 5.0,
                maxLines: 1,
                focusedBorderColor: Colors.grey,
                inputAction: TextInputAction.next,
              ),


              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 const Padding(padding: EdgeInsets.all(10.0),
                 child: Text("Gender",
                 style: TextStyle(
                   color: KDarkAppBarColor,
                   fontSize: 18,
                   fontWeight: FontWeight.bold
                 ),),


                 ),
                  Padding(padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 1.0,color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    width: width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        RadioButton(title: "Male" ,value: "male", groupvalue: gender, onchanged: (value) {
                          setState(() {
                            gender = value as String;
                          });
                        }),
                        RadioButton(title: "female", value: "female", groupvalue: gender, onchanged: (value) {
                          setState(() {
                            gender = value as String;
                          });
                        }),

                      ],
                    ),
                  ),)


                ],
              ),

              // EditTextIcon(
              //
              //   hintText: "Gender",
              //   keyBoardType: TextInputType.text,
              //   password: false,
              //   textController: genderController,
              //   fillColor: Colors.white,
              //   borderWidth: 1.0,
              //   leadingIcon: const Icon(
              //     Icons.male,
              //     color: KDarkAppBarColor,
              //   ),
              //   onTap: () {},
              //   hintColor: KDarkAppBarColor,
              //   readOnly: false,
              //   borderRadius: 5.0,
              //   maxLines: 1,
              //   focusedBorderColor: Colors.grey,
              //   inputAction: TextInputAction.next,
              // ),

              EditTextIcon(

                hintText: "Contact",
                keyBoardType: TextInputType.text,
                password: false,
                textController: contactNumberController,
                fillColor: Colors.white,
                borderWidth: 1.0,
                leadingIcon: const Icon(
                  Icons.phone,
                  color: KDarkAppBarColor,
                ),
                onTap: () {},
                hintColor: KDarkAppBarColor,
                readOnly: false,
                borderRadius: 5.0,
                maxLines: 1,
                focusedBorderColor: Colors.grey,
                inputAction: TextInputAction.next,
              ),

              EditTextIcon(

                hintText: "Email",
                keyBoardType: TextInputType.text,
                password: false,
                textController: emailController,
                fillColor: Colors.white,
                borderWidth: 1.0,
                leadingIcon: const Icon(
                  Icons.email,
                  color: KDarkAppBarColor,
                ),
                onTap: () {},
                hintColor: KDarkAppBarColor,
                readOnly: false,
                borderRadius: 5.0,
                maxLines: 1,
                focusedBorderColor: Colors.grey,
                inputAction: TextInputAction.next,


              ),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    isExpanded: true,
                    hint: Text('select language',
                    style: TextStyle(color: kAppBarColor),),
                    value: _selectedItem,
                    items: _languageItems,
                    style: TextStyle(color: kAppBarColor,fontSize: 16),
                    onChanged: (value) {
                      setState(() {
                        _selectedItem = value as ListItem?;
                        language= _selectedItem!.value;
                      });
                    },
                  ),
                ),
              ),


              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                ),
                child: DropdownButtonHideUnderline(
                  child: buildMultiSelect(),
                ),
              ),



              // EditTextIcon(
              //
              //   hintText: "language",
              //   keyBoardType: TextInputType.text,
              //   password: false,
              //   textController: languageController,
              //   fillColor: Colors.white,
              //   borderWidth: 1.0,
              //   leadingIcon: const Icon(
              //     Icons.language,
              //     color: KDarkAppBarColor,
              //   ),
              //   onTap: () {},
              //   hintColor: KDarkAppBarColor,
              //   readOnly: false,
              //   borderRadius: 5.0,
              //   maxLines: 1,
              //   focusedBorderColor: Colors.grey,
              //   inputAction: TextInputAction.next,
              // ),


              EditTextIcon(

                hintText: "Date of Birth",
                keyBoardType: TextInputType.text,
                password: false,
                textController: dobController,
                fillColor: Colors.white,
                borderWidth: 1.0,
                leadingIcon: const Icon(
                  Icons.timer_3_rounded,
                  color: KDarkAppBarColor,
                ),
                onTap: () async {
                  DateTime? startDateTime =
                      await config.pickDate(context, startDate);
                  if(startDateTime != null){
                    startDate = startDateTime;
                    setState(() {
                      dobController.text =
                          DateFormat.yMMMd().format(startDate);
                      dob = DateFormat('dd-mm-yy').format(startDate);
                    });
                  }
                },
                hintColor: KDarkAppBarColor,
                readOnly: true,
                borderRadius: 5.0,
                maxLines: 1,
                focusedBorderColor: Colors.grey,
                inputAction: TextInputAction.done,
              ),



              Padding(padding: const EdgeInsets.only(left: 20.0,right: 20,top: 8,bottom: 8),
                child: MaterialSplashButton(
                  onTap: () {

                    userName = userNameController.text;
                    contact = contactNumberController.text;
                    rollNumber = rollNumberController.text;
                    password = passwordController.text;
                  //  gender = genderController.text;
                  //  language = languageController.text;
                    email= emailController.text;

                    for(var element in languageselected) {
                      language += element + ",";
                    }
                    //email

                    if(validate(userName,contact,rollNumber,password,gender,language,email,dob)) {
                      if (type == "add") {
                        register();
                      } else {
                            updatestudent();
                      }
                    }

                    //Navigator.pushReplacementNamed(context, LoginScreen.id);
                  },
                  borderRadius: 10.0,
                  color: KButtonColor,
                  height: 55,
                  width: width,
                  text: type == "add" ? "Register" : "update",
                ),)


            ],
          ),
        ),
      ),
    );
  }

  bool validate(String? userName, String? contact, String? rollNumber, String? password, String? gender,String? language,String? email, String? dob)  {

    if(userName!.isEmpty){
      config.showToastFailure("please enter name");
      return false;
    }
    if(gender!.isEmpty){
      config.showToastFailure("please select gender");
      return false;
    }

    if(password!.isEmpty){
      config.showToastFailure("please enter password");
      return false;
    }
    if(rollNumber!.isEmpty){
      config.showToastFailure("please enter rollnumber");
      return false;
    }

    if(contact!.isEmpty){
      config.showToastFailure("please enter contact");
      return false;
    }

    if(dob!.isEmpty){
      config.showToastFailure("please enter dob");
      return false;
    }

    if(language!.isEmpty){
      config.showToastFailure("please enter language");
      return false;
    }

    return true;
  }

  void register() async {
    try{
      if(mounted) {
        setState(() {
          showspinner =true;
        });
      }

      CommonResponse? response = await restApi.addStudent(rollNumber! ,userName!,dob! ,gender,contact!, password!,email!,language);

      if(response!= null) {
        if(response.result == "success") {
          config.showToastSuccess(response.msg);

        //  Navigator.pushReplacementNamed(context, LoginScreen.id);
        }
      else
        {
          config.showToastFailure(response.msg);
        }

    } else
      {
        config.showToastFailure(SERVICE_FAILURE);
      }

      if(mounted) {
        setState(() {
          showspinner = false;
        });
      }

  } catch (e) {
      if(kDebugMode) {
        print(e);
      }

      if(mounted) {
        setState(() {
          showspinner = false;
        });
      }
    }

  }

  void profile() async {
    try {
      if (mounted) {
        setState(() {
          showspinner = true;
        });
      }
      String id = await config.getStringSharedPreferences("userID");
      StudentDetailResponse? response = await restApi.getStudent(id);
      if (response != null) {
        if (response.result == "success") {
          config.showToastSuccess(response.msg);
          studentData = response.data!;
          config.showToastSuccess(response.msg);
          studentData = response.data!;
          userNameController.text = studentData.username!;
          rollNumberController.text = studentData.rollno!;
          contactNumberController.text = studentData.contactno!;
          gender = studentData.gender!;
          emailController.text = studentData.email!;
          passwordController.text = studentData.password!;
          //languageController.text = studentData.language!;
          dob = studentData.dob!;
          language = studentData.language!;

          for (var elements in _languages) {
            if (language == elements.value) {
              _selectedItem = elements;
            }
          }
          _languageItems = buildDropDownMenuItems(_languages);
        }
         else {
          config.showToastFailure(response.msg);
        }
      } else {
        config.showToastFailure(SERVICE_FAILURE);
      }
      if (mounted) {
        setState(() {
          showspinner = false;
        });
      }
    } catch (ex) {
      if (kDebugMode) {
        print(ex);
      }

      if (mounted) {
        setState(() {
          showspinner = false;
        });
      }
    }
  }

  void updatestudent() async {
    try{
      if(mounted) {
        setState(() {
          showspinner =true;
        });
      }

      String id = await config.getStringSharedPreferences("userID");
      CommonResponse? response = await restApi.updateStudent(id, rollNumber!, userName!, dob!, gender, contact!, password!, email!, language);

      if(response!= null) {
        if(response.result == "success") {
          config.showToastSuccess(response.msg);

           Navigator.pushNamedAndRemoveUntil(context, ProfileScreen.id,ModalRoute.withName(ProfileScreen.id));
        }
        else
        {
          config.showToastFailure(response.msg);
        }

      } else
      {
        config.showToastFailure(SERVICE_FAILURE);
      }

      if(mounted) {
        setState(() {
          showspinner = false;
        });
      }

    } catch (e) {
      if(kDebugMode) {
        print(e);
      }

      if(mounted) {
        setState(() {
          showspinner = false;
        });
      }
    }

  }

}

