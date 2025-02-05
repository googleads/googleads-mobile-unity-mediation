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

using GoogleMobileAds.Mediation.Moloco.Common;

namespace GoogleMobileAds.Mediation.Moloco.Api
{
    public class Moloco
    {
        internal static readonly IMolocoClient client = MolocoClientFactory.CreateMolocoClient();

        /// <summary>
        /// Sets whether the user has opted out of interest-based advertising.
        /// </summary>
        /// <param name="doNotSell">
        /// A bool indicating whether the user has opted out of interest-based advertising.
        /// </param>
        public static void SetDoNotSell(bool doNotSell)
        {
            client.SetDoNotSell(doNotSell);
        }

        /// <summary>
        /// Sets whether the user is known to be in an age-restricted category.
        /// </summary>
        /// <param name="userAgeRestricted">
        /// A bool indicating whether the user is age restricted.
        /// </param>
        public static void SetUserAgeRestricted(bool userAgeRestricted)
        {
            client.SetUserAgeRestricted(userAgeRestricted);
        }
    }
}
