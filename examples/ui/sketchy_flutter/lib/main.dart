// Copyright 2017 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lib.app.dart/app.dart';
import 'package:zircon/zircon.dart';

import 'scenic.dart' as scenic;
import 'scenic_widget.dart';

// ignore_for_file: public_member_api_docs

void main() {
  runApp(new SketchyExampleApp());
}

class SketchyExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Sketchy Example',
      home: new SketchyExample(
          title: 'Sketchy Example (hit the button to add more rectangles)',
          applicationContext: new ApplicationContext.fromStartupInfo()),
    );
  }
}

class SketchyExample extends StatefulWidget {
  const SketchyExample({Key key, this.title, this.applicationContext})
      : super(key: key);

  final String title;
  final ApplicationContext applicationContext;

  @override
  _SketchyExampleState createState() =>
      new _SketchyExampleState(applicationContext);
}

class _SketchyExampleState extends State<SketchyExample> {
  factory _SketchyExampleState(ApplicationContext applicationContext) {
    final HandlePairResult tokenPair = System.eventpairCreate();
    assert(tokenPair.status == ZX.OK);

    return new _SketchyExampleState._internal(
        applicationContext,
        new scenic.Session.fromServiceProvider(
            applicationContext.environmentServices),
        tokenPair);
  }

  _SketchyExampleState._internal(
      this.applicationContext, this.session, HandlePairResult tokenPair)
      : sceneHost = new SceneHost(tokenPair.first),
        rect = new scenic.RoundedRectangle(
            session, 100.0, 100.0, 10.0, 10.0, 10.0, 10.0),
        material = new scenic.Material(session),
        rootNode = new scenic.ImportNode(session, tokenPair.second) {
    material.setColor(1.0, 0.3, 0.3, 1.0);
    _addShapeNode();
    _addShapeNode();
  }

  final ApplicationContext applicationContext;
  final SceneHost sceneHost;
  final scenic.Session session;
  final scenic.RoundedRectangle rect;
  final scenic.Material material;
  final scenic.ImportNode rootNode;
  final List<scenic.ShapeNode> shapeNodes = <scenic.ShapeNode>[];

  void _addShapeNode() {
    final scenic.ShapeNode shapeNode = new scenic.ShapeNode(session)
      ..setShape(rect)
      ..setMaterial(material)
      ..setTranslation(100.0 + shapeNodes.length * 30,
          100.0 + shapeNodes.length * 30, 10.0 + shapeNodes.length * 10);
    shapeNodes.add(shapeNode);
    rootNode.addChild(shapeNode);

    // TODO: don't present immediately; trigger an invalidation.
    session.present(0, (scenic.PresentationInfo info) {});
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Column(children: <Widget>[
        new Expanded(
          child: new ScenicWidget(sceneHost),
        ),
      ]),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          setState(_addShapeNode);
        },
        tooltip: 'Add RoundedRectangle',
        child: new Icon(Icons.add),
      ),
    );
  }
}
