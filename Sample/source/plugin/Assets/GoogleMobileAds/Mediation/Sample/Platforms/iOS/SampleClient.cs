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

#if UNITY_IOS

using GoogleMobileAds.Mediation.Sample.Common;

namespace GoogleMobileAds.Mediation.Sample.iOS
{
    public class SampleClient : ISampleClient
    {
        private static SampleClient instance = new SampleClient();
        private SampleClient() { }

        public static SampleClient Instance
        {
            get
            {
                return instance;
            }
        }

        public void SetUserConsent(bool userConsent)
        {
            Externs.GADUMSampleSetUserConsent(userConsent);
        }

        public bool GetUserConsent()
        {
            return Externs.GADUMSampleGetUserConsent();
        }

        public void SetUserAgeRestricted(bool userAgeRestricted)
        {
            Externs.GADUMSampleSetUserAgeRestricted(userAgeRestricted);
        }

        public bool IsUserAgeRestricted()
        {
            return Externs.GADUMSampleIsUserAgeRestricted();
        }

        public void SetCCPAUserConsent(bool ccpaUserConsent)
        {
            Externs.GADUMSampleSetCCPAUserConsent(ccpaUserConsent);
        }

        public bool GetCCPAUserConsent()
        {
            return Externs.GADUMSampleGetCCPAUserConsent();
        }
    }
}

#endif
