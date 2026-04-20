// Copyright 2026 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import <BigoSDK/BigoSDK.h>

void GADUMBigoSetUserConsent(BOOL userConsent) { [BigoPrivacy setUserConsent:userConsent]; }

BOOL GADUMBigoGetUserConsent() { return [BigoPrivacy currentPrivacy].userConsent; }

void GADUMBigoSetUserAgeRestricted(BOOL userAgeRestricted) {
  [BigoPrivacy setUserAgeRestricted:userAgeRestricted];
}

BOOL GADUMBigoIsUserAgeRestricted() { return [BigoPrivacy currentPrivacy].userAgeRestricted; }

void GADUMBigoSetCCPAUserConsent(BOOL ccpaUserConsent) {
  [BigoPrivacy setCcpaUserConsent:ccpaUserConsent];
}

BOOL GADUMBigoGetCCPAUserConsent() { return [BigoPrivacy currentPrivacy].ccpaUserConsent; }
