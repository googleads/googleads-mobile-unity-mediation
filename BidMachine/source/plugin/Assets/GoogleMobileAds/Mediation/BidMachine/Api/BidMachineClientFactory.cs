// Copyright 2025 Google LLC
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

using GoogleMobileAds.Mediation.BidMachine.Common;

namespace GoogleMobileAds.Mediation.BidMachine
{
    public class BidMachineClientFactory
    {
        public static IBidMachineClient BidMachineInstance()
        {
#if UNITY_IOS && !UNITY_EDITOR
            return GoogleMobileAds.Mediation.BidMachine.iOS.BidMachineClient.Instance;
#else
            return new GoogleMobileAds.Mediation.BidMachine.Common.PlaceholderClient();
#endif
        }
    }
}
