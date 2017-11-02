#!/bin/bash

# Copyright 2017 The Fuchsia Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# Exit this script if one command fails.
set -e

readonly TREE_ROOT=`git rev-parse --show-toplevel`
readonly FUCHSIA_ROOT="$TREE_ROOT/../.."

# Source the $FUCHSIA_DIR/scripts/env.sh file.
source "${FUCHSIA_ROOT}/scripts/env.sh"

netruncmd : "@ bootstrap device_runner --user-shell=dev_user_shell --user-shell-args=--root-module=xi_app"