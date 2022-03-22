#!/usr/bin/python3
#
# Copyright 2016 Google Inc. All rights reserved.
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

"""Looks at Source/GeneratedServices and updates the podspec file."""

import os
import re
import string
import sys


_PODSPEC_NAME = 'GoogleAPIClientForREST.podspec'


def _DirNamesInDirectory(path_to_dir):
  """Returns the list of directories in a given directory."""
  result = []
  for x in os.listdir(path_to_dir):
    if x in ('.', '..'):
      continue
    if os.path.isdir(os.path.join(path_to_dir, x)):
      result.append(x)
  return tuple(result)


class PodspecUpdater(object):
  """Wraps parsing the podspec file and then updating the content."""

  def __init__(self, file_content_str):
    match = re.match(
        r'^(.+\n  # subspecs for all the services.\n)(.+\n)?(end\n)$',
        file_content_str, flags=re.DOTALL)
    assert match, 'File content was not formatted as expected by the regex.'
    self._file_start = match.group(1)
    self._file_end = match.group(3)

  def UpdatedContent(self, services):
    """Generates the updated content an iterable of services dir names."""
    template = string.Template(r"""  s.subspec '${Name}' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/${Name}/*.{h,m}'
  end
""")
    result = self._file_start
    for x in sorted(services, key=lambda s: s.lower()):
      result += template.safe_substitute({'Name': x})
    result += self._file_end
    return result


def _ValidateContent(path, expected_content):
  """Helper to validate the given file's content."""
  assert os.path.isfile(path), 'File didn\'t exist: %r' % path
  name = os.path.basename(path)
  current_content = open(path).read()
  if current_content == expected_content:
    print('%s is good.' % name)
  else:
    try:
      open(path, 'w').write(expected_content)
      print('Updated %s.' % name)
    except IOError as e:
      print('Failed to update %r, error %s.' % (path, e))
      return False
  return True


def Main(args):
  """Main method."""
  assert not args, 'No args supported on this script!'
  script_dir = os.path.dirname(os.path.realpath(__file__))
  root_dir = os.path.dirname(os.path.dirname(script_dir))
  podspec_path = os.path.join(root_dir, _PODSPEC_NAME)
  assert os.path.isfile(podspec_path), (
      'Failed to find %r' % _PODSPEC_NAME)
  services_dir = os.path.join(root_dir, 'Source', 'GeneratedServices')
  assert os.path.isdir(services_dir), (
      'Failed to find Source/GeneratedServices directory')

  updater = PodspecUpdater(open(podspec_path).read())
  services = _DirNamesInDirectory(services_dir)
  if not _ValidateContent(podspec_path, updater.UpdatedContent(services)):
    return 1

  return 0

if __name__ == '__main__':
  sys.exit(Main(sys.argv[1:]))
