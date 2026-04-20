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

using GoogleMobileAds.Mediation.Bigo.Common;

namespace GoogleMobileAds.Mediation.Bigo.Android
{
    public class BigoClient : IBigoClient
    {
        private static BigoClient instance = new BigoClient();
        private BigoClient() {}

        private const string BIGO_PRIVACY_CLASS_NAME = "com.my.target.common.BigoPrivacy";

        public static BigoClient Instance
        {
            get
            {
                return instance;
            }
        }

        public void SetUserConsent(bool userConsent)
        {
            AndroidJavaClass bigoPrivacy = new AndroidJavaClass(BIGO_PRIVACY_CLASS_NAME);
            bigoPrivacy.CallStatic("setUserConsent", userConsent);
        }

        public bool GetUserConsent()
        {
            AndroidJavaClass bigoPrivacy = new AndroidJavaClass(BIGO_PRIVACY_CLASS_NAME);
            AndroidJavaObject bigoCurrentPrivacy =
                    bigoPrivacy.CallStatic<AndroidJavaObject>("currentPrivacy");
            AndroidJavaObject userConsent =
                    bigoCurrentPrivacy.Get<AndroidJavaObject>("userConsent");
            return userConsent.Call<bool>("booleanValue");
        }

        public void SetUserAgeRestricted(bool userAgeRestricted)
        {
            AndroidJavaClass bigoPrivacy = new AndroidJavaClass(BIGO_PRIVACY_CLASS_NAME);
            bigoPrivacy.CallStatic("setUserAgeRestricted", userAgeRestricted);
        }

        public bool IsUserAgeRestricted()
        {
            AndroidJavaClass bigoPrivacy = new AndroidJavaClass(BIGO_PRIVACY_CLASS_NAME);
            AndroidJavaObject bigoCurrentPrivacy =
                    bigoPrivacy.CallStatic<AndroidJavaObject>("currentPrivacy");
            return bigoCurrentPrivacy.Get<bool>("userAgeRestricted");
        }

        public void SetCCPAUserConsent(bool ccpaUserConsent)
        {
            AndroidJavaClass bigoPrivacy = new AndroidJavaClass(BIGO_PRIVACY_CLASS_NAME);
            bigoPrivacy.CallStatic("setCcpaUserConsent", ccpaUserConsent);
        }

        public bool GetCCPAUserConsent()
        {
            AndroidJavaClass bigoPrivacy = new AndroidJavaClass(BIGO_PRIVACY_CLASS_NAME);
            AndroidJavaObject bigoCurrentPrivacy =
                    bigoPrivacy.CallStatic<AndroidJavaObject>("currentPrivacy");
            AndroidJavaObject ccpaUserConsent =
                    bigoCurrentPrivacy.Get<AndroidJavaObject>("ccpaUserConsent");
            return ccpaUserConsent.Call<bool>("booleanValue");
        }
    }
}

#endif
