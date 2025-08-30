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

namespace GoogleMobileAds.Mediation.BidMachine.Common
{
    public interface IBidMachineClient
    {
        /// <summary>
        /// Indicates whether BidMachine SDK needs to be initialized with the test mode configuration.
        /// When set to true, enable test mode along with all the logging modes to true.
        /// Default value is false.
        /// Important: This must be set before initializing `GoogleMobileAds`.
        /// </summary>
        bool TestMode { get; set; }
    }
}
