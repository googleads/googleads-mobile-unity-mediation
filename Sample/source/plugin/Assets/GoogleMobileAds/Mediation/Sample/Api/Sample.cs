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

using GoogleMobileAds.Mediation.Sample.Common;

namespace GoogleMobileAds.Mediation.Sample.Api
{
    public class Sample
    {
        internal static readonly ISampleClient client =
                SampleClientFactory.CreateSampleClient();

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

namespace GoogleMobileAds.Api.Mediation.Sample
{
    [System.Obsolete("Use `GoogleMobileAds.Mediation.Sample.Api.Sample` instead.")]
    public class Sample
    {
        public static void SetUserConsent(bool userConsent)
        {
            GoogleMobileAds.Mediation.Sample.Api.Sample.SetUserConsent(userConsent);
        }

        public static bool GetUserConsent()
        {
            return GoogleMobileAds.Mediation.Sample.Api.Sample.GetUserConsent();
        }

        public static void SetUserAgeRestricted(bool userAgeRestricted)
        {
            GoogleMobileAds.Mediation.Sample.Api.Sample
                    .SetUserAgeRestricted(userAgeRestricted);
        }

        public static bool IsUserAgeRestricted()
        {
            return GoogleMobileAds.Mediation.Sample.Api.Sample.IsUserAgeRestricted();
        }

        public static void SetCCPAUserConsent(bool ccpaUserConsent)
        {
            GoogleMobileAds.Mediation.Sample.Api.Sample.SetCCPAUserConsent(ccpaUserConsent);
        }

        public static bool GetCCPAUserConsent()
        {
            return GoogleMobileAds.Mediation.Sample.Api.Sample.GetCCPAUserConsent();
        }
    }
}
