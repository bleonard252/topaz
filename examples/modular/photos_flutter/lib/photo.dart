// Copyright 2017 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/painting.dart';

import 'photo_storage.dart';

// ignore_for_file: public_member_api_docs

/// The representation of a photo.
class Photo {
  final PhotoStorage _storage;

  final String url;
  final String description;
  final int timestamp;

  Photo(this._storage, this.url, this.description, this.timestamp);

  ImageProvider get imageProvider => _storage.getImageProvider(this);
}
