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

#if UNITY_ANDROID

using UnityEngine;

using GoogleMobileAds.Mediation.Moloco.Common;

namespace GoogleMobileAds.Mediation.Moloco.Android
{
    public class MolocoClient : IMolocoClient
    {
        private static MolocoClient instance = new MolocoClient();
        private const string privacyClassName =
            "com.moloco.sdk.publisher.privacy.MolocoPrivacy";
        private const string privacySettingsClassName =
            "com.moloco.sdk.publisher.privacy.MolocoPrivacy$PrivacySettings";

        private MolocoClient() {}

        public static MolocoClient Instance
        {
            get
            {
                return instance;
            }
        }

        public void SetDoNotSell(bool doNotSell)
        {
            AndroidJavaClass molocoPrivacy = new AndroidJavaClass(privacyClassName);
            AndroidJavaObject privacySettings =
                molocoPrivacy.GetStatic<AndroidJavaObject>("privacySettings");

            AndroidJavaObject isAgeRestrictedUser =
                privacySettings.Get<AndroidJavaObject>("isAgeRestrictedUser");
            AndroidJavaObject isUserConsent =
                privacySettings.Get<AndroidJavaObject>("isUserConsent");

            AndroidJavaObject newPrivacySettings =
                new AndroidJavaObject(privacySettingsClassName, isUserConsent, isAgeRestrictedUser,
                                        new AndroidJavaObject("java.lang.Boolean", doNotSell));
            molocoPrivacy.CallStatic("setPrivacy", newPrivacySettings);
        }
    }
}

#endif
