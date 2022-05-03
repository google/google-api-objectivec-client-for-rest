#!/usr/bin/python3
#
# Copyright 2020 Google Inc. All rights reserved.
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

"""Looks at Source/GeneratedServices and updates the Package.swift file."""

import os
import re
import string
import sys


_PACKAGE_FILE = "Package.swift"


def _DirNamesInDirectory(path_to_dir):
  """Returns the list of directories in a given directory."""
  result = []
  for x in os.listdir(path_to_dir):
    if x in ('.', '..'):
      continue
    if os.path.isdir(os.path.join(path_to_dir, x)):
      result.append(x)
  return tuple(result)


class SwiftPMUpdater(object):
  """Wraps parsing Package.swift and then updating the content."""

  def __init__(self, file_content_str):
    self._original_content = file_content_str

  def UpdatedContent(self, services):
    """Generates the updated content."""
    sorted_services = sorted(services, key=lambda s: s.lower())

    def UpdateSection(content_str, section_start, section_end, new_section_content):
      """Helper to update a section."""
      regex_str = r'^(.+\n%s\n)(.+\n)?(%s\n.*)$' % (re.escape(section_start), re.escape(section_end))
      match = re.match(regex_str, content_str, flags=re.DOTALL)
      assert match, 'File content was not formatted as expected by the regex.'
      result = match.group(1)
      result += new_section_content
      result += match.group(3)
      return result

    # Products
    template = string.Template(r"""        .library(
            name: "GoogleAPIClientForREST_${Name}",
            targets: ["GoogleAPIClientForREST_${Name}"]
        ),
""")
    section = "".join([template.safe_substitute({'Name': x}) for x in sorted_services])
    result = UpdateSection(
        self._original_content,
        r"        // Products for all the Services.",
        r"        // End of products.",
        section)

    # Targets
    template = string.Template(r"""        .target(
            name: "GoogleAPIClientForREST_${Name}",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/${Name}",
            publicHeadersPath: "."
        ),
""")
    section = "".join([template.safe_substitute({'Name': x}) for x in sorted_services])
    result = UpdateSection(
        result,
        r"        // Targets for all the Services.",
        r"        // End of targets.",
        section)
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
  root_dir = os.path.dirname(script_dir)
  package_path = os.path.join(root_dir, _PACKAGE_FILE)
  assert os.path.isfile(package_path), (
      'Failed to find %r' % _PACKAGE_FILE)
  services_dir = os.path.join(root_dir, 'Source', 'GeneratedServices')
  assert os.path.isdir(services_dir), (
      'Failed to find Source/GeneratedServices directory')

  updater = SwiftPMUpdater(open(package_path).read())
  services = _DirNamesInDirectory(services_dir)
  if not _ValidateContent(package_path, updater.UpdatedContent(services)):
    return 1

  return 0

if __name__ == '__main__':
  sys.exit(Main(sys.argv[1:]))
