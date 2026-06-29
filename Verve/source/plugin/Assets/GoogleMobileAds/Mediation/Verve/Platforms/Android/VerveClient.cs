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

#if UNITY_ANDROID

using UnityEngine;

using GoogleMobileAds.Mediation.Verve.Common;

namespace GoogleMobileAds.Mediation.Verve.Android
{
    public class VerveClient : IVerveClient
    {
        private static VerveClient instance = new VerveClient();
        private VerveClient() {}

        public static VerveClient Instance
        {
            get
            {
                return instance;
            }
        }

        public void SetIABUSPrivacyString(string iabUSPrivacyString)
        {
            AndroidJavaClass hybid = new AndroidJavaClass("net.pubnative.lite.sdk.HyBid");
            AndroidJavaObject userDataManager = hybid.CallStatic<AndroidJavaObject>("getUserDataManager");
            userDataManager.Call("setIABUSPrivacyString", iabUSPrivacyString);
        }
    }
}

#endif
