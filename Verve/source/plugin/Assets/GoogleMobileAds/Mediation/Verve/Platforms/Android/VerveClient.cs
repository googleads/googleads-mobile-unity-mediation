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

        private const string VERVE_PRIVACY_CLASS_NAME = "com.my.target.common.VervePrivacy";

        public static VerveClient Instance
        {
            get
            {
                return instance;
            }
        }

        public void SetUserConsent(bool userConsent)
        {
            AndroidJavaClass vervePrivacy = new AndroidJavaClass(VERVE_PRIVACY_CLASS_NAME);
            vervePrivacy.CallStatic("setUserConsent", userConsent);
        }

        public bool GetUserConsent()
        {
            AndroidJavaClass vervePrivacy = new AndroidJavaClass(VERVE_PRIVACY_CLASS_NAME);
            AndroidJavaObject verveCurrentPrivacy =
                    vervePrivacy.CallStatic<AndroidJavaObject>("currentPrivacy");
            AndroidJavaObject userConsent =
                    verveCurrentPrivacy.Get<AndroidJavaObject>("userConsent");
            return userConsent.Call<bool>("booleanValue");
        }

        public void SetUserAgeRestricted(bool userAgeRestricted)
        {
            AndroidJavaClass vervePrivacy = new AndroidJavaClass(VERVE_PRIVACY_CLASS_NAME);
            vervePrivacy.CallStatic("setUserAgeRestricted", userAgeRestricted);
        }

        public bool IsUserAgeRestricted()
        {
            AndroidJavaClass vervePrivacy = new AndroidJavaClass(VERVE_PRIVACY_CLASS_NAME);
            AndroidJavaObject verveCurrentPrivacy =
                    vervePrivacy.CallStatic<AndroidJavaObject>("currentPrivacy");
            return verveCurrentPrivacy.Get<bool>("userAgeRestricted");
        }

        public void SetCCPAUserConsent(bool ccpaUserConsent)
        {
            AndroidJavaClass vervePrivacy = new AndroidJavaClass(VERVE_PRIVACY_CLASS_NAME);
            vervePrivacy.CallStatic("setCcpaUserConsent", ccpaUserConsent);
        }

        public bool GetCCPAUserConsent()
        {
            AndroidJavaClass vervePrivacy = new AndroidJavaClass(VERVE_PRIVACY_CLASS_NAME);
            AndroidJavaObject verveCurrentPrivacy =
                    vervePrivacy.CallStatic<AndroidJavaObject>("currentPrivacy");
            AndroidJavaObject ccpaUserConsent =
                    verveCurrentPrivacy.Get<AndroidJavaObject>("ccpaUserConsent");
            return ccpaUserConsent.Call<bool>("booleanValue");
        }
    }
}

#endif
