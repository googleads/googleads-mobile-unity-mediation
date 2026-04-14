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

using GoogleMobileAds.Mediation.Sample.Common;

namespace GoogleMobileAds.Mediation.Sample.Android
{
    public class SampleClient : ISampleClient
    {
        private static SampleClient instance = new SampleClient();
        private SampleClient() {}

        private const string SAMPLE_PRIVACY_CLASS_NAME = "com.my.target.common.SamplePrivacy";

        public static SampleClient Instance
        {
            get
            {
                return instance;
            }
        }

        public void SetUserConsent(bool userConsent)
        {
            AndroidJavaClass samplePrivacy = new AndroidJavaClass(SAMPLE_PRIVACY_CLASS_NAME);
            samplePrivacy.CallStatic("setUserConsent", userConsent);
        }

        public bool GetUserConsent()
        {
            AndroidJavaClass samplePrivacy = new AndroidJavaClass(SAMPLE_PRIVACY_CLASS_NAME);
            AndroidJavaObject sampleCurrentPrivacy =
                    samplePrivacy.CallStatic<AndroidJavaObject>("currentPrivacy");
            AndroidJavaObject userConsent =
                    sampleCurrentPrivacy.Get<AndroidJavaObject>("userConsent");
            return userConsent.Call<bool>("booleanValue");
        }

        public void SetUserAgeRestricted(bool userAgeRestricted)
        {
            AndroidJavaClass samplePrivacy = new AndroidJavaClass(SAMPLE_PRIVACY_CLASS_NAME);
            samplePrivacy.CallStatic("setUserAgeRestricted", userAgeRestricted);
        }

        public bool IsUserAgeRestricted()
        {
            AndroidJavaClass samplePrivacy = new AndroidJavaClass(SAMPLE_PRIVACY_CLASS_NAME);
            AndroidJavaObject sampleCurrentPrivacy =
                    samplePrivacy.CallStatic<AndroidJavaObject>("currentPrivacy");
            return sampleCurrentPrivacy.Get<bool>("userAgeRestricted");
        }

        public void SetCCPAUserConsent(bool ccpaUserConsent)
        {
            AndroidJavaClass samplePrivacy = new AndroidJavaClass(SAMPLE_PRIVACY_CLASS_NAME);
            samplePrivacy.CallStatic("setCcpaUserConsent", ccpaUserConsent);
        }

        public bool GetCCPAUserConsent()
        {
            AndroidJavaClass samplePrivacy = new AndroidJavaClass(SAMPLE_PRIVACY_CLASS_NAME);
            AndroidJavaObject sampleCurrentPrivacy =
                    samplePrivacy.CallStatic<AndroidJavaObject>("currentPrivacy");
            AndroidJavaObject ccpaUserConsent =
                    sampleCurrentPrivacy.Get<AndroidJavaObject>("ccpaUserConsent");
            return ccpaUserConsent.Call<bool>("booleanValue");
        }
    }
}

#endif
