#!/usr/bin/python3
#
# Copyright 2024 Google Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

"""Helper to act on a directory of cached discovery data."""

import argparse
import json
import os
import sys

def Main(args):
  """Main method."""
  parser = argparse.ArgumentParser()
  parser.add_argument('--index-name', default="index.json")
  # Not sure why prod_tt_sasportal is in discovery, always skip it off.
  parser.add_argument('--skip', default=["prod_tt_sasportal"], action='append')
  parser.add_argument('cache_dir')
  opts = parser.parse_args(args)
  
  index_path = os.path.join(opts.cache_dir, opts.index_name)
  with open(index_path, 'r') as fp:
    services = json.load(fp).get('items')

  cached_paths = []
  for x in services:
    if not x.get("preferred"):
      continue
    name = x.get('name')
    if name in opts.skip:
      continue
    version = x.get('version')
    file_name = f'{name}.{version}.json'
    cached_path = os.path.join(opts.cache_dir, file_name)
    if os.path.isfile(cached_path):
      cached_paths.append(cached_path)
    else:
      print(f'WARNING: {file_name} not found, skipping', file=sys.stderr)

  print(" ".join(cached_paths))

if __name__ == '__main__':
  sys.exit(Main(sys.argv[1:]))
