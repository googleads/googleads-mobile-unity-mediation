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


        public static BigoClient Instance
        {
            get
            {
                return instance;
            }
        }

        public void SetCoppaConsent(bool consent)
        {
            AndroidJavaClass bigoAdSdk = new AndroidJavaClass("sg.bigo.ads.BigoAdSdk");
            AndroidJavaClass consentOptions = new AndroidJavaClass("sg.bigo.ads.ConsentOptions");
            AndroidJavaObject coppaOption = consentOptions.GetStatic<AndroidJavaObject>("COPPA");
            
            AndroidJavaClass unityPlayer = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
            AndroidJavaObject currentActivity = unityPlayer.GetStatic<AndroidJavaObject>("currentActivity");

            bigoAdSdk.CallStatic("setUserConsent", currentActivity, coppaOption, consent);
        }

    }
}

#endif
