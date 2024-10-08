// Copyright 2018 Google LLC
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

using System.Reflection;

using UnityEngine;

namespace GoogleMobileAds.Mediation.MyTarget.Common
{
    public class PlaceholderClient : IMyTargetClient
    {
        public PlaceholderClient()
        {
            Debug.Log ("Placeholder " + MethodBase.GetCurrentMethod().Name);
        }

        public void SetUserConsent(bool userConsent)
        {
            Debug.Log ("Placeholder " + MethodBase.GetCurrentMethod().Name);
        }

        public bool GetUserConsent()
        {
            Debug.Log ("Placeholder " + MethodBase.GetCurrentMethod().Name);
            return false;
        }

        public void SetUserAgeRestricted(bool userAgeRestricted)
        {
            Debug.Log ("Placeholder " + MethodBase.GetCurrentMethod().Name);
        }

        public bool IsUserAgeRestricted()
        {
            Debug.Log ("Placeholder " + MethodBase.GetCurrentMethod().Name);
            return false;
        }

        public void SetCCPAUserConsent(bool ccpaUserConsent)
        {
            Debug.Log ("Placeholder " + MethodBase.GetCurrentMethod().Name);
        }

        public bool GetCCPAUserConsent()
        {
            Debug.Log ("Placeholder " + MethodBase.GetCurrentMethod().Name);
            return false;
        }
    }
}
