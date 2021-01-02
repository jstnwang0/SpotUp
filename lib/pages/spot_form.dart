import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:smart_select/smart_select.dart';
import 'package:spot_up/constants/constants.dart';
import 'package:spot_up/models/post.dart';

class SpotForm extends StatefulWidget {
  Function closePanel;
  Function clearDragLocation;
  Function setLocation;
  LatLng dragLocation;

  SpotForm({
    this.clearDragLocation,
    this.dragLocation,
    this.closePanel,
    this.setLocation,
  });

  @override
  _SpotFormState createState() => _SpotFormState();
}

class _SpotFormState extends State<SpotForm> {
  final _formKey = GlobalKey<FormState>();

  String error = '';
  String name = '';
  List<String> newSubcategories = [];
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            SizedBox(height: 20.0),
            TextFormField(
              decoration: textInputDecoration.copyWith(hintText: 'Name'),
              validator: (val) => val.isEmpty ? 'Enter an spot name' : null,
              onChanged: (val) {
                setState(() => name = val);
              },
            ),
            widget.dragLocation == null
                ? RaisedButton(
                    color: Colors.deepPurple,
                    child: Text(
                      'Choose Location',
                      style: textStyle,
                    ),
                    onPressed: () {
                      widget.closePanel();

                      setState(() {
                        widget.setLocation();
                      });
                    })
                : RaisedButton(
                    color: Colors.deepPurple,
                    child: Text(
                      'Clear Location',
                      style: textStyle,
                    ),
                    onPressed: () {
                      widget.clearDragLocation();
                    }),
            RaisedButton(
                color: Colors.deepPurple,
                child: SmartSelect.multiple(
                  title: 'Categories',
                  choiceItems: S2Choice.listFrom<String, Post>(
                      source: subcategories,
                      value: (index, item) {
                        return item.subcategory[0];
                      },
                      title: (index, item) {
                        return item.title;
                      },
                      group: (index, item) {
                        return item.category[0]
                            .replaceAll(new RegExp('_'), ' ')
                            .split(' ')
                            .map((word) => word[0].toUpperCase() + word.substring(1))
                            .join(' ');
                      }),
                  value: null,
                  placeholder: '',
                  choiceGrouped: true,
                  modalType: S2ModalType.bottomSheet,
                  modalHeaderStyle: S2ModalHeaderStyle(
                    backgroundColor: Colors.deepPurple,
                    textStyle: textStyle,
                  ),
                  modalStyle: S2ModalStyle(
                    backgroundColor: Colors.white,
                  ),
                  choiceType: S2ChoiceType.chips,
                  choiceLayout: S2ChoiceLayout.grid,
                  choiceStyle: S2ChoiceStyle(
                    titleStyle: textStyle.copyWith(fontWeight: FontWeight.normal),
                    raised: true,
                    color: Colors.deepPurple,
                    accentColor: Colors.deepPurple,
                  ),
                  groupHeaderBuilder: (context, state, group) {
                    return Container(
                      color: Colors.deepPurple,
                      padding: const EdgeInsets.all(15),
                      alignment: Alignment.centerLeft,
                      child: S2Text(
                        text: group.name,
                        style: textStyle,
                      ),
                    );
                  },
                  tileBuilder: (context, state) {
                    return S2Tile.fromState(
                      state,
                      hideValue: true,
                      title: Text(state.title, style: textStyle),
                    );
                  },
                  onChange: (state) {
                    setState(() {
                      newSubcategories = state.value;
                    });
                  },
                ),
                onPressed: () {}),
            RaisedButton(
                color: Colors.deepPurple,
                child: Text(
                  'Add Spot',
                  style: textStyle,
                ),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    print('Submit Form');
                  }
                }),
            SizedBox(height: 12.0),
            Text(
              error,
              style: textStyle.copyWith(color: Colors.red, fontSize: 14.0),
            ),
          ],
        ),
      ),
    );
  }
}
