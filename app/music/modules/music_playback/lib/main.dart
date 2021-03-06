// Copyright 2017 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:lib.app.dart/app.dart';
import 'package:lib.logging/logging.dart';
import 'package:lib.widgets/modular.dart';
import 'package:music_widgets/music_widgets.dart';

import 'modular/playback_module_model.dart';

void main() {
  setupLogger();

  ApplicationContext applicationContext =
      new ApplicationContext.fromStartupInfo();

  PlaybackModuleModel playbackModuleModel = new PlaybackModuleModel();

  ModuleWidget<PlaybackModuleModel> moduleWidget =
      new ModuleWidget<PlaybackModuleModel>(
    applicationContext: applicationContext,
    moduleModel: playbackModuleModel,
    child: new Scaffold(
      backgroundColor: Colors.grey[300],
      body: new ScopedModelDescendant<PlaybackModuleModel>(
        builder: (
          _,
          __,
          PlaybackModuleModel model,
        ) {
          if (model.deviceMode == 'null') {
            return new Container(color: Colors.black);
          } else if (model.deviceMode == 'edgeToEdge') {
            return new EdgeToEdgePlayer(
              currentTrack: playbackModuleModel.currentTrack,
              playbackPosition: playbackModuleModel.playbackPosition,
              isPlaying: playbackModuleModel.isPlaying,
              onTogglePlay: playbackModuleModel.togglePlayPause,
              onSkipNext: playbackModuleModel.next,
              onSkipPrevious: playbackModuleModel.previous,
            );
          } else if (model.deviceMode == 'normal') {
            return new Player(
              currentTrack: playbackModuleModel.currentTrack,
              playbackPosition: playbackModuleModel.playbackPosition,
              isPlaying: playbackModuleModel.isPlaying,
              onTogglePlay: playbackModuleModel.togglePlayPause,
              onSkipNext: playbackModuleModel.next,
              onSkipPrevious: playbackModuleModel.previous,
              onToggleRepeat: playbackModuleModel.toggleRepeat,
              isRepeated: playbackModuleModel.isRepeated,
            );
          }
        },
      ),
    ),
  );

  runApp(moduleWidget);
  moduleWidget.advertise();
}
