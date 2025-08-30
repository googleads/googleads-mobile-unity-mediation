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

#if UNITY_IOS

using System;
using GoogleMobileAds.Mediation.BidMachine.Common;

namespace GoogleMobileAds.Mediation.BidMachine.iOS
{
    public class BidMachineClient : IBidMachineClient
    {
        private readonly static Lazy<BidMachineClient> _instance =
                new Lazy<BidMachineClient>(() => new BidMachineClient());

        private BidMachineClient() {}

        public static BidMachineClient Instance
        {
            get {
                return _instance.Value;
            }
        }

        public bool TestMode
        {
            get { return Externs.GADUMBidMachineGetTestMode(); }
            set { Externs.GADUMBidMachineSetTestMode(value); }
        }
    }
}

#endif
