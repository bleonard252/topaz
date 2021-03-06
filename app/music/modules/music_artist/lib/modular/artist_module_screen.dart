// Copyright 2017 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:lib.ui.flutter/child_view.dart';
import 'package:lib.widgets/model.dart';
import 'package:lib.widgets/widgets.dart';
import 'package:music_models/music_models.dart';
import 'package:music_widgets/music_widgets.dart';

import 'artist_module_model.dart';

/// Top-level widget for the Artist Module
class ArtistModuleScreen extends StatelessWidget {
  /// Constructor
  const ArtistModuleScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey[300],
      body: new ScopedModelDescendant<ArtistModuleModel>(builder: (
        _,
        __,
        ArtistModuleModel model,
      ) {
        if (model.deviceMode == null) {
          return new Container(color: Colors.black);
        } else if (model.deviceMode == 'edgeToEdge') {
          switch (model.loadingStatus) {
            case LoadingStatus.completed:
              return new Container(
                child: new ChildView(connection: model.playbackViewConn),
              );
            case LoadingStatus.inProgress:
              return new Container(
                color: Colors.black,
                child: new Center(
                  child: new Container(
                    child: new FuchsiaSpinner(),
                    height: 32.0,
                    width: 32.0,
                  ),
                ),
              );
            case LoadingStatus.failed:
              return const Text('failed to load');
          }
        } else if (model.deviceMode == 'normal') {
          return new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Expanded(
                child: new ArtistScreen(
                  artist: model.artist,
                  albums: model.albums,
                  relatedArtists: model.relatedArtists,
                  loadingStatus: model.loadingStatus,
                  onTapArtist: (Artist artist) => model.goToArtist(artist.id),
                  onTapAblum: (Album album) => model.goToAlbum(album.id),
                  onTapTrack: (Track track, Album album) =>
                      model.playTrack(track, album),
                ),
              ),
              // Hack(dayang@): Embedding the Playback Module for now until this
              // can be done with Mondrian
              // https://fuchsia.atlassian.net/browse/SO-490
              new Container(
                height: 64.0,
                decoration: new BoxDecoration(
                  border: new Border(
                    top: new BorderSide(color: Colors.grey[400]),
                  ),
                ),
                child: model.playbackViewConn != null
                    ? new ChildView(connection: model.playbackViewConn)
                    : new Container(),
              ),
            ],
          );
        }
      }),
    );
  }
}
