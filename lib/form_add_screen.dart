import 'package:flutter/material.dart';
import 'package:post_get/get_api_services.dart';
import 'package:post_get/get_class.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class FormAddScreen extends StatefulWidget {
  Profile profile;

  FormAddScreen({this.profile});
  @override
  _FormAddScreenState createState() => _FormAddScreenState();
}

class _FormAddScreenState extends State<FormAddScreen> {
  bool _isLoading = false;
  ApiService _apiService = ApiService();
  bool _isFieldNameValid;
  bool _isFieldJobValid;
  bool _isFieldAgeValid;
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerJob = TextEditingController();
  TextEditingController _controllerAge = TextEditingController();


  @override
  void initState() {
    if (widget.profile != null) {
      _isFieldNameValid = true;
      _controllerName.text = widget.profile.name;
      _isFieldJobValid = true;
      _controllerJob.text = widget.profile.job;
      _isFieldAgeValid = true;
      _controllerAge.text = widget.profile.age.toString();
    }
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Form Add",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildTextFieldName(),
                _buildTextFieldJob(),
                _buildTextFieldAge(),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: RaisedButton(
                    onPressed: () {
                      if (_isFieldNameValid == null ||
                          _isFieldJobValid == null ||
                          _isFieldAgeValid == null ||
                          !_isFieldNameValid ||
                          !_isFieldJobValid ||
                          !_isFieldAgeValid) {
                        _scaffoldState.currentState.showSnackBar(
                          SnackBar(
                            content: Text("Please fill all field"),
                          ),
                        );
                        return;
                      }
                      setState(() => _isLoading = true);
                      String name = _controllerName.text.toString();
                      String job = _controllerJob.text.toString();
                      int age = int.parse(_controllerAge.text.toString());
                      Profile profile =
                          Profile(name: name, job: job, age: age);
                          if (widget.profile == null) {
                      _apiService.createProfile(profile).then((isSuccess) {
                        setState(() => _isLoading = false);
                        if (isSuccess) {
                     Navigator.pop(_scaffoldState.currentState.context);
                     } else {
                     _scaffoldState.currentState.showSnackBar(SnackBar(
                       content: Text("Submit data success"),
                        ));
                        }
                        });
                        } else {
                        profile.id = widget.profile.id;
                     _apiService.updateProfile(profile).then((isSuccess) {
                       setState(() => _isLoading = false);
                       if (isSuccess) {
                      Navigator.pop(_scaffoldState.currentState.context);
                            } else {
                    _scaffoldState.currentState.showSnackBar(SnackBar(
                    content: Text("Update data success"),
                            ));
                     }
                     });
                      }
                   Text(
                      "Submit".toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    );
                   Colors.orange[600]; 
                    }
                    ),
                )
              ],
            ),
          ),
          _isLoading
              ? Stack(
                  children: <Widget>[
                    Opacity(
                      opacity: 0.3,
                      child: ModalBarrier(
                        dismissible: false,
                        color: Colors.grey,
                      ),
                    ),
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _buildTextFieldName() {
    return TextField(
      controller: _controllerName,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Full name",
        errorText: _isFieldNameValid == null || _isFieldNameValid
            ? null
            : "Full name is required",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldNameValid) {
          setState(() => _isFieldNameValid = isFieldValid);
        }
      },
    );
  }

  Widget _buildTextFieldJob() {
    return TextField(
      controller: _controllerJob,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: "Job",
        errorText: _isFieldJobValid == null || _isFieldJobValid
            ? null
            : "Job is required",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldJobValid) {
          setState(() => _isFieldJobValid = isFieldValid);
        }
      },
    );
  }

  Widget _buildTextFieldAge() {
    return TextField(
      controller: _controllerAge,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "Age",
        errorText: _isFieldAgeValid == null || _isFieldAgeValid
            ? null
            : "Age is required",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldAgeValid) {
          setState(() => _isFieldAgeValid = isFieldValid);
        }
      },
    );
  }

}