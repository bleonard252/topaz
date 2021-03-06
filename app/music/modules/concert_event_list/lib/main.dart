// Copyright 2017 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:concert_widgets/concert_widgets.dart';
import 'package:config/config.dart';
import 'package:flutter/material.dart';
import 'package:lib.app.dart/app.dart';
import 'package:lib.logging/logging.dart';
import 'package:lib.widgets/modular.dart';

import 'modular/event_list_module_model.dart';

/// Retrieves the Songkick API Key
Future<String> _readAPIKey() async {
  Config config = await Config.read('/system/data/modules/config.json')
    ..validate(<String>['songkick_api_key']);
  return config.get('songkick_api_key');
}

Future<Null> main() async {
  setupLogger(name: 'Concert Event List Module');

  String apiKey = await _readAPIKey();

  ApplicationContext applicationContext =
      new ApplicationContext.fromStartupInfo();

  EventListModuleModel eventListModel =
      new EventListModuleModel(apiKey: apiKey);

  ModuleWidget<EventListModuleModel> moduleWidget =
      new ModuleWidget<EventListModuleModel>(
    applicationContext: applicationContext,
    moduleModel: eventListModel,
    child: new Scaffold(
      backgroundColor: Colors.white,
      body: new ScopedModelDescendant<EventListModuleModel>(builder: (
        BuildContext context,
        Widget child,
        EventListModuleModel model,
      ) {
        return new Material(
          child: model.deviceMode == 'edgeToEdge'
              ? new PageableEventList(
                  events: model.events,
                  onSelect: model.selectEvent,
                  selectedEvent: model.selectedEvent,
                  onPageChanged: model.onPageChanged,
                  loadingStatus: model.loadingStatus,
                )
              : new EventList(
                  events: model.events,
                  onSelect: model.selectEvent,
                  selectedEvent: model.selectedEvent,
                  loadingStatus: model.loadingStatus,
                ),
        );
      }),
    ),
  );

  runApp(moduleWidget);
  moduleWidget.advertise();
}
