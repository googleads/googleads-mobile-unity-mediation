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

using GoogleMobileAds.Mediation.Bigo.Common;

namespace GoogleMobileAds.Mediation.Bigo.iOS
{
    public class BigoClient : IBigoClient
    {
        private static BigoClient instance = new BigoClient();
        private BigoClient() { }

        public static BigoClient Instance
        {
            get
            {
                return instance;
            }
        }

        public void SetUserConsent(bool userConsent)
        {
            Externs.GADUMBigoSetUserConsent(userConsent);
        }

        public bool GetUserConsent()
        {
            return Externs.GADUMBigoGetUserConsent();
        }

        public void SetUserAgeRestricted(bool userAgeRestricted)
        {
            Externs.GADUMBigoSetUserAgeRestricted(userAgeRestricted);
        }

        public bool IsUserAgeRestricted()
        {
            return Externs.GADUMBigoIsUserAgeRestricted();
        }

        public void SetCCPAUserConsent(bool ccpaUserConsent)
        {
            Externs.GADUMBigoSetCCPAUserConsent(ccpaUserConsent);
        }

        public bool GetCCPAUserConsent()
        {
            return Externs.GADUMBigoGetCCPAUserConsent();
        }
    }
}

#endif
