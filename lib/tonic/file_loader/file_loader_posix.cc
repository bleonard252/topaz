// Copyright 2017 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#include "lib/tonic/file_loader/file_loader.h"

#include <iostream>
#include <memory>
#include <utility>

#include "lib/fxl/files/directory.h"
#include "lib/fxl/files/file.h"
#include "lib/fxl/files/path.h"
#include "lib/fxl/files/symlink.h"
#include "lib/fxl/logging.h"
#include "lib/tonic/converter/dart_converter.h"
#include "lib/tonic/parsers/packages_map.h"

namespace tonic {

const std::string FileLoader::kPathSeparator = "/";
const char FileLoader::kFileURLPrefix[] = "file://";
const size_t FileLoader::kFileURLPrefixLength = sizeof(FileLoader::kFileURLPrefix) - 1;

namespace {

const size_t kFileSchemeLength = FileLoader::kFileURLPrefixLength - 2;

}  // namespace

std::string FileLoader::SanitizePath(const std::string& url) {
  return url;
}

std::string FileLoader::CanonicalizeFileURL(const std::string& url) {
  return url.substr(kFileSchemeLength);
}

}  // namespace tonic