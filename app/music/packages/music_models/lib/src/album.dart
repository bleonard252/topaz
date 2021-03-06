// Copyright 2017 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:intl/intl.dart';

import 'artist.dart';
import 'music_image.dart';
import 'track.dart';

/// Model representing a Spotify album
///
/// https://developer.spotify.com/web-api/get-album/
class Album {
  /// The name of the album
  final String name;

  /// Artists of the album
  final List<Artist> artists;

  /// Cover art for the album
  final List<MusicImage> images;

  /// Tracks in album
  final List<Track> tracks;

  /// Date when album was released
  final DateTime releaseDate;

  /// The type of album.
  ///
  /// eg. "album", "single", "compilation"
  final String albumType;

  /// List of genres the album is associated with
  final List<String> genres;

  /// ID of album
  final String id;

  static final DateFormat _yearFormat = new DateFormat.y();

  /// Constructor
  Album({
    this.name,
    this.artists,
    this.images,
    this.tracks,
    this.releaseDate,
    this.albumType,
    this.genres,
    this.id,
  });

  /// Create album model from json data
  factory Album.fromJson(Object json) {
    if (json is Map) {
      DateTime releaseDate;
      if (json['release_date'] != null) {
        try {
          releaseDate = DateTime.parse(json['release_date']);
        } on Exception {
          // Sometimes release dates are given only as a year
          try {
            releaseDate = _yearFormat.parse(json['release_date']);
          } on Exception {
            // ignore.
          }
        }
      }

      return new Album(
        name: json['name'],
        artists: json['artists'] is List
            ? json['artists']
                .map((Object artistJson) => new Artist.fromJson(artistJson))
                .toList()
            : <Artist>[],
        images: MusicImage.listFromJson(json['images']),
        tracks: json['tracks'] != null && json['tracks']['items'] is List
            ? json['tracks']['items']
                .map((Object trackJson) => new Track.fromJson(trackJson))
                .toList()
            : <Track>[],
        releaseDate: releaseDate,
        albumType: json['album_type'],
        genres: json['genres'] is List<String> ? json['genres'] : null,
        id: json['id'],
      );
    } else {
      throw new Exception('The provided json object must be a Map.');
    }
  }

  /// Gets the default artwork for this album.
  /// Spotify uses the first image as the largest image.
  /// Returns NULL is there is no image in this album.
  String get defaultArtworkUrl {
    if (images != null && images.isNotEmpty) {
      return images.first.url;
    } else {
      return null;
    }
  }
}
