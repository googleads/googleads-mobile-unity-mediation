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

using GoogleMobileAds.Mediation.Bigo.Common;

namespace GoogleMobileAds.Mediation.Bigo.Api
{
    public class Bigo
    {
        internal static readonly IBigoClient client =
                BigoClientFactory.CreateBigoClient();

        public static void SetUserConsent(bool userConsent)
        {
            client.SetUserConsent(userConsent);
        }

        public static bool GetUserConsent()
        {
            return client.GetUserConsent();
        }

        public static void SetUserAgeRestricted(bool userAgeRestricted)
        {
            client.SetUserAgeRestricted(userAgeRestricted);
        }

        public static bool IsUserAgeRestricted()
        {
            return client.IsUserAgeRestricted();
        }

        public static void SetCCPAUserConsent(bool ccpaUserConsent)
        {
            client.SetCCPAUserConsent(ccpaUserConsent);
        }

        public static bool GetCCPAUserConsent()
        {
            return client.GetCCPAUserConsent();
        }
    }
}

namespace GoogleMobileAds.Api.Mediation.Bigo
{
    [System.Obsolete("Use `GoogleMobileAds.Mediation.Bigo.Api.Bigo` instead.")]
    public class Bigo
    {
        public static void SetUserConsent(bool userConsent)
        {
            GoogleMobileAds.Mediation.Bigo.Api.Bigo.SetUserConsent(userConsent);
        }

        public static bool GetUserConsent()
        {
            return GoogleMobileAds.Mediation.Bigo.Api.Bigo.GetUserConsent();
        }

        public static void SetUserAgeRestricted(bool userAgeRestricted)
        {
            GoogleMobileAds.Mediation.Bigo.Api.Bigo
                    .SetUserAgeRestricted(userAgeRestricted);
        }

        public static bool IsUserAgeRestricted()
        {
            return GoogleMobileAds.Mediation.Bigo.Api.Bigo.IsUserAgeRestricted();
        }

        public static void SetCCPAUserConsent(bool ccpaUserConsent)
        {
            GoogleMobileAds.Mediation.Bigo.Api.Bigo.SetCCPAUserConsent(ccpaUserConsent);
        }

        public static bool GetCCPAUserConsent()
        {
            return GoogleMobileAds.Mediation.Bigo.Api.Bigo.GetCCPAUserConsent();
        }
    }
}
