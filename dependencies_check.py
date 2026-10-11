# Copyright 2026 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""Check for problematic iOS adapter pod versions in Dependencies.xml.

This script runs as a presubmit build target and outputs a PresubmitResponse
proto in text format.
"""

import os
import sys
import xml.etree.ElementTree as ET

PROBLEMATIC_VERSIONS = {
    'GoogleMobileAdsMediationVungle': ['7.7.3.0'],
    'GoogleMobileAdsMediationInMobi': ['11.3.0.0'],
    'GoogleMobileAdsMediationChartboost': ['9.12.0.1'],
    'GoogleMobileAdsMediationAppLovin': ['13.6.2.1.0'],
    'GoogleMobileAdsMediationVerve': ['3.8.1.1'],
    'GoogleMobileAdsMediationIMobile': ['2.3.4.7'],
    'GoogleMobileAdsMediationFacebook': ['6.21.1.1'],
    'GoogleMobileAdsMediationMaio': ['2.2.1.2'],
    'GoogleMobileAdsMediationLine': ['3.0.1.1'],
    'GoogleMobileAdsMediationPangle': ['7.9.1.1.1'],
    'GoogleMobileAdsMediationPubMatic': ['5.1.1.0'],
    'GoogleMobileAdsMediationMyTarget': ['5.43.0.0'],
    'GoogleMobileAdsMediationMoloco': ['4.6.1.1'],
    'GoogleMobileAdsMediationFyber': ['8.4.7.1'],
    'GoogleMobileAdsMediationBidMachine': ['3.7.1.0'],
    'GoogleMobileAdsMediationMintegral': ['8.1.4.0'],
}


def check_file(file_path):
  errors = []
  try:
    tree = ET.parse(file_path)
    root = tree.getroot()

    ios_pods = root.find('iosPods')
    if ios_pods is not None:
      for ios_pod in ios_pods.findall('iosPod'):
        name = ios_pod.get('name')
        version = ios_pod.get('version')

        if name in PROBLEMATIC_VERSIONS:
          if version in PROBLEMATIC_VERSIONS[name]:
            errors.append(
                f'File: {file_path}\\n  Pod: {name}\\n  Version: {version}'
                ' (Problematic! See'
                ' go/ios-mediation-adapter-pods-remediation-06-04-26 for'
                f' why).\\n  Please use a fixed version (e.g. {version}.1 or'
                ' newer).'
            )
  except Exception as e:
    errors.append(f'Failed to parse XML in {file_path}: {e}')
  return errors


def main():
  current_dir = os.path.dirname(__file__)
  mediation_dir = current_dir

  found_any = False
  errors = []

  for root_dir, _, files in os.walk(mediation_dir):
    for file in files:
      if file.endswith('Dependencies.xml'):
        file_path = os.path.join(root_dir, file)
        found_any = True
        errors.extend(check_file(file_path))

  if not found_any:
    errors.append('Did not find any Dependencies.xml files to check')

  if errors:
    print('succeeded: false')
    # Escape newlines and quotes for the proto string
    error_msg = '\\n'.join(errors)
    # We need to escape double quotes inside the message
    error_msg = error_msg.replace('"', '\\"')
    print(f'failure_message: "{error_msg}"')
  else:
    print('succeeded: true')

  # Always exit with 0 to allow the presubmit service to parse the output
  sys.exit(0)


if __name__ == '__main__':
  main()
