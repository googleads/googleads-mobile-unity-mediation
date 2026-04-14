#!/bin/bash
# Script must be run from a google3 workspace root.
# Generates a new Unity mediation adapter plugin.
#
# Usage:
#   # From google3/third_party/unity/gma_sdk_mediation/scripts/
#   ./generate_unity_adapter.sh -adapter_name <AdapterName> \
#     [-version <PluginVersion>] \
#     [-unity_version <GMASDKUnityVersion>] \
#     [-android_adapter_version <AndroidAdapterVersion>] \
#     [-ios_adapter_version <iOSAdapterVersion>] \
#     [-android_package_name <com.google.ads.mediation.yournetwork>] \
#     [-ios_pod_name <GoogleMobileAdsMediationYourNetwork>] \
#     [-with_extras]
#
# Example:
#   # From google3/third_party/unity/gma_sdk_mediation/scripts/
#   ./generate_unity_adapter.sh -adapter_name MyNewAd -version 1.0.0 \
#     -unity_version 11.0.0 -android_adapter_version 1.2.3.0 \
#     -ios_adapter_version 1.2.3.0 \
#     -android_package_name com.google.ads.mediation.mynewad \
#     -ios_pod_name GoogleMobileAdsMediationMyNewAd \
#     -with_extras

set -e
set -o pipefail

echo "-------------------------------------------------------------------------"

# 1) Set up bash variables and parse arguments.
adapter_name=""
version="1.0.0"
unity_version="11.0.0" # Default Google Mobile Ads Unity Plugin version
android_adapter_version="a.b.c.d"
ios_adapter_version="x.y.z.w"
android_package_name=""
ios_pod_name=""
with_extras=false
year=$(date +"%Y")

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    -adapter_name)
      adapter_name="$2"
      shift 2
      ;;
    -version)
      version="$2"
      shift 2
      ;;
    -unity_version)
      unity_version="$2"
      shift 2
      ;;
    -android_adapter_version)
      android_adapter_version="$2"
      shift 2
      ;;
    -ios_adapter_version)
      ios_adapter_version="$2"
      shift 2
      ;;
    -android_package_name)
      android_package_name="$2"
      shift 2
      ;;
    -ios_pod_name)
      ios_pod_name="$2"
      shift 2
      ;;
    -with_extras)
      with_extras=true
      shift 1
      ;;
    *)
      echo "Error: Invalid option '$1'"
      echo "Usage: $0 -adapter_name <AdapterName> [-version <PluginVersion>] [-unity_version <GMASDKUnityVersion>] [-android_adapter_version <AndroidAdapterVersion>] [-ios_adapter_version <iOSAdapterVersion>] [-android_package_name <com.google.ads.mediation.yournetwork>] [-ios_pod_name <GoogleMobileAdsMediationYourNetwork>] [-with_extras]"
      exit 1
      ;;
  esac
done

if [[ -z "$adapter_name" ]]; then
  echo "Error: -adapter_name is required."
  echo "Usage: $0 -adapter_name <AdapterName> [-version <PluginVersion>] [-unity_version <GMASDKUnityVersion>] [-android_adapter_version <AndroidAdapterVersion>] [-ios_adapter_version <iOSAdapterVersion>] [-android_package_name <com.google.ads.mediation.yournetwork>] [-ios_pod_name <GoogleMobileAdsMediationYourNetwork>] [-with_extras]"
  exit 1
fi

if [[ ! ${adapter_name:0:1} =~ [[:upper:]] ]]; then
  echo "Error: First character of the Adapter name must be in upper case."
  exit 1
fi

adapter_name_lower_cased=$(echo "$adapter_name" | tr '[:upper:]' '[:lower:]')
adapter_name_upper_cased=$(echo "$adapter_name" | tr '[:lower:]' '[:upper:]')
plugin_name="GoogleMobileAds${adapter_name}Mediation"

# Determine the root directory of the Unity mediation plugins.
# Assuming the script is in google3/third_party/unity/gma_sdk_mediation/scripts/
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
adapter_root_dir="$(dirname "${SCRIPT_DIR}")"
template_adapter_dir="${adapter_root_dir}/MyTarget" # Using MyTarget as a base template
extras_template_dir="${adapter_root_dir}/LiftoffMonetize" # Template for extras
new_adapter_dir="${adapter_root_dir}/${adapter_name}"

# Determine workspace type for making files writable
workspace_cmd=""
# Check if .hg exists two levels up (from scripts/ to google3/)
if [[ -d "${SCRIPT_DIR}/../../.hg" ]]; then
  workspace_cmd="hg"
  echo "Fig workspace detected."
# Check if .citc exists two levels up
elif [[ -d "${SCRIPT_DIR}/../../.citc" ]]; then
  workspace_cmd="g4"
  echo "Piper workspace detected."
else
  echo "No Piper or Fig workspace detected. Using chmod."
fi

# Function to make a file writable in the current workspace.
make_writable() {
  local file="$1"
  if [[ -n "$workspace_cmd" ]]; then
    echo "  Making writable: ${file} using ${workspace_cmd}"
    # Use g4 edit or hg edit. Redirect stdout/stderr to /dev/null to suppress messages.
    "${workspace_cmd}" edit "${file}" > /dev/null 2>&1 || true
  else
    echo "  Making writable: ${file} using chmod"
    chmod +w "${file}" || true
  fi
}
# Export the function so it's available in subshells spawned by find -exec
export -f make_writable

# Set default package/pod names if not provided
if [[ -z "$android_package_name" ]]; then
  android_package_name="com.google.ads.mediation.${adapter_name_lower_cased}"
fi
if [[ -z "$ios_pod_name" ]]; then
  ios_pod_name="GoogleMobileAdsMediation${adapter_name}"
fi

echo "Generating Unity adapter for: ${adapter_name}"
echo "Output directory: ${new_adapter_dir}"
echo "Plugin Version: ${version}"
echo "GMA Unity Plugin Version: ${unity_version}"
echo "Android Adapter Version: ${android_adapter_version}"
echo "iOS Adapter Version: ${ios_adapter_version}"
echo "Android Package Name: ${android_package_name}"
echo "iOS Pod Name: ${ios_pod_name}"
if [[ "$with_extras" == true ]]; then
  echo "Including Mediation Extras templates."
fi

# Check if adapter directory already exists
if [[ -d "${new_adapter_dir}" ]]; then
  echo "Error: Directory ${new_adapter_dir} already exists. Please remove it or choose a different adapter name."
  exit 1
fi

# 2) Create new adapter directory structure
echo "Creating directory structure..."
mkdir -p "${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Api"
mkdir -p "${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Common"
mkdir -p "${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Editor"
mkdir -p "${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Platforms/Android"
mkdir -p "${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Platforms/iOS"
mkdir -p "${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Platforms/Mediation"
mkdir -p "${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Plugins/Android"
mkdir -p "${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Plugins/iOS"

# 3) Copy template files and .meta files
echo "Copying template files from ${template_adapter_dir}..."
# Root files
cp "${adapter_root_dir}/LICENSE" "${new_adapter_dir}/LICENSE"
cp "${adapter_root_dir}/CONTRIBUTING.md" "${new_adapter_dir}/CONTRIBUTING.md"
cp "${template_adapter_dir}/README.md" "${new_adapter_dir}/README.md"
cp "${template_adapter_dir}/CHANGELOG.md" "${new_adapter_dir}/CHANGELOG.md"
cp "${template_adapter_dir}/build.gradle" "${new_adapter_dir}/build.gradle"
cp "${template_adapter_dir}/package.json" "${new_adapter_dir}/package.json"
cp "${template_adapter_dir}/METADATA" "${new_adapter_dir}/METADATA"
cp "${template_adapter_dir}/rapid.blueprint" "${new_adapter_dir}/rapid.blueprint"

# .meta files for root
cp "${adapter_root_dir}/MyTarget/LICENSE.meta" "${new_adapter_dir}/LICENSE.meta"
cp "${template_adapter_dir}/README.md.meta" "${new_adapter_dir}/README.md.meta"
cp "${template_adapter_dir}/CHANGELOG.md.meta" "${new_adapter_dir}/CHANGELOG.md.meta"
cp "${template_adapter_dir}/build.gradle.meta" "${new_adapter_dir}/build.gradle.meta"
cp "${template_adapter_dir}/package.json.meta" "${new_adapter_dir}/package.json.meta"
cp "${template_adapter_dir}/source.meta" "${new_adapter_dir}/source.meta"
cp "${template_adapter_dir}/source/plugin.meta" "${new_adapter_dir}/source/plugin.meta"
cp "${template_adapter_dir}/source/plugin/Assets.meta" "${new_adapter_dir}/source/plugin/Assets.meta"
cp "${template_adapter_dir}/source/plugin/Assets/GoogleMobileAds.meta" "${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds.meta"
cp "${template_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation.meta" "${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation.meta"
cp "${template_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/MyTarget.meta" "${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}.meta"

# C# API and Common
cp "${template_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/MyTarget/Api/MyTarget.cs" "${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Api/${adapter_name}.cs"
cp "${template_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/MyTarget/Api/MyTarget.cs.meta" "${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Api/${adapter_name}.cs.meta"
cp "${template_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/MyTarget/Common/IMyTargetClient.cs" "${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Common/I${adapter_name}Client.cs"
cp "${template_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/MyTarget/Common/IMyTargetClient.cs.meta" "${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Common/I${adapter_name}Client.cs.meta"
cp "${template_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/MyTarget/Common/PlaceholderClient.cs" "${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Common/PlaceholderClient.cs"
cp "${template_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/MyTarget/Common/PlaceholderClient.cs.meta" "${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Common/PlaceholderClient.cs.meta"

# C# Platform Factories
cp "${template_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/MyTarget/Platforms/Mediation/MyTargetClientFactory.cs" "${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Platforms/Mediation/${adapter_name}ClientFactory.cs"
cp "${template_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/MyTarget/Platforms/Mediation/MyTargetClientFactory.cs.meta" "${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Platforms/Mediation/${adapter_name}ClientFactory.cs.meta"

# C# Android Platform
cp "${template_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/MyTarget/Platforms/Android/MyTargetClient.cs" "${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Platforms/Android/${adapter_name}Client.cs"
cp "${template_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/MyTarget/Platforms/Android/MyTargetClient.cs.meta" "${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Platforms/Android/${adapter_name}Client.cs.meta"

# C# iOS Platform
cp "${template_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/MyTarget/Platforms/iOS/MyTargetClient.cs" "${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Platforms/iOS/${adapter_name}Client.cs"
cp "${template_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/MyTarget/Platforms/iOS/MyTargetClient.cs.meta" "${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Platforms/iOS/${adapter_name}Client.cs.meta"
cp "${template_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/MyTarget/Platforms/iOS/Externs.cs" "${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Platforms/iOS/Externs.cs"
cp "${template_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/MyTarget/Platforms/iOS/Externs.cs.meta" "${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Platforms/iOS/Externs.cs.meta"
cp "${template_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/MyTarget/Plugins/iOS/GADUMMyTargetInterface.m" "${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Plugins/iOS/GADUM${adapter_name}Interface.m"
cp "${template_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/MyTarget/Plugins/iOS/GADUMMyTargetInterface.m.meta" "${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Plugins/iOS/GADUM${adapter_name}Interface.m.meta"

# Mediation Dependencies XML
cp "${template_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/MyTarget/Editor/MyTargetMediationDependencies.xml" "${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Editor/${adapter_name}MediationDependencies.xml"
cp "${template_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/MyTarget/Editor/MyTargetMediationDependencies.xml.meta" "${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Editor/${adapter_name}MediationDependencies.xml.meta"

# ASMDEF files
cp "${template_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/MyTarget/Api/Api.asmdef" "${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Api/GoogleMobileAds.Mediation.${adapter_name}.Api.asmdef"
cp "${template_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/MyTarget/Api/Api.asmdef.meta" "${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Api/GoogleMobileAds.Mediation.${adapter_name}.Api.asmdef.meta"
cp "${template_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/MyTarget/Common/Common.asmdef" "${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Common/GoogleMobileAds.Mediation.${adapter_name}.Common.asmdef"
cp "${template_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/MyTarget/Common/Common.asmdef.meta" "${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Common/GoogleMobileAds.Mediation.${adapter_name}.Common.asmdef.meta"
cp "${template_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/MyTarget/Platforms/Android/Android.asmdef" "${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Platforms/Android/GoogleMobileAds.Mediation.${adapter_name}.Android.asmdef"
cp "${template_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/MyTarget/Platforms/Android/Android.asmdef.meta" "${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Platforms/Android/GoogleMobileAds.Mediation.${adapter_name}.Android.asmdef.meta"
cp "${template_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/MyTarget/Platforms/iOS/iOS.asmdef" "${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Platforms/iOS/GoogleMobileAds.Mediation.${adapter_name}.iOS.asmdef"
cp "${template_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/MyTarget/Platforms/iOS/iOS.asmdef.meta" "${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Platforms/iOS/GoogleMobileAds.Mediation.${adapter_name}.iOS.asmdef.meta"
cp "${template_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/MyTarget/Platforms/Mediation/Mediation.asmdef" "${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Platforms/Mediation/GoogleMobileAds.Mediation.${adapter_name}.Mediation.asmdef"
cp "${template_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/MyTarget/Platforms/Mediation/Mediation.asmdef.meta" "${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Platforms/Mediation/GoogleMobileAds.Mediation.${adapter_name}.Mediation.asmdef.meta"

# Optional: Copy Extras templates if -with_extras is used
if [[ "$with_extras" == true ]]; then
  echo "Copying Extras template files from ${extras_template_dir}..."
  mkdir -p "${new_adapter_dir}/source/android-library/${adapter_name_lower_cased}/src/main/java/com/google/unity/mediation/${adapter_name_lower_cased}"
  mkdir -p "${new_adapter_dir}/source/android-library/${adapter_name_lower_cased}/src/main/res/values"
  mkdir -p "${new_adapter_dir}/source/android-library/gradle/wrapper"

  cp "${extras_template_dir}/source/android-library/build.gradle" "${new_adapter_dir}/source/android-library/build.gradle"
  cp "${extras_template_dir}/source/android-library/gradle.properties" "${new_adapter_dir}/source/android-library/gradle.properties"
  cp "${extras_template_dir}/source/android-library/gradlew" "${new_adapter_dir}/source/android-library/gradlew"
  cp "${extras_template_dir}/source/android-library/gradlew.bat" "${new_adapter_dir}/source/android-library/gradlew.bat"
  cp "${extras_template_dir}/source/android-library/settings.gradle" "${new_adapter_dir}/source/android-library/settings.gradle"
  cp "${extras_template_dir}/source/android-library/liftoffmonetize/build.gradle" "${new_adapter_dir}/source/android-library/${adapter_name_lower_cased}/build.gradle"
  cp "${extras_template_dir}/source/android-library/liftoffmonetize/proguard-rules.pgcfg" "${new_adapter_dir}/source/android-library/${adapter_name_lower_cased}/proguard-rules.pgcfg"
  cp "${extras_template_dir}/source/android-library/liftoffmonetize/src/main/AndroidManifest.xml" "${new_adapter_dir}/source/android-library/${adapter_name_lower_cased}/src/main/AndroidManifest.xml"
  cp "${extras_template_dir}/source/android-library/liftoffmonetize/src/main/res/values/strings.xml" "${new_adapter_dir}/source/android-library/${adapter_name_lower_cased}/src/main/res/values/strings.xml"
  cp "${extras_template_dir}/source/android-library/liftoffmonetize/src/main/java/com/google/unity/mediation/liftoffmonetize/VungleUnityExtrasBuilder.java" "${new_adapter_dir}/source/android-library/${adapter_name_lower_cased}/src/main/java/com/google/unity/mediation/${adapter_name_lower_cased}/${adapter_name}UnityExtrasBuilder.java"
  cp "${extras_template_dir}/source/android-library/liftoffmonetize/src/main/java/com/google/unity/mediation/liftoffmonetize/VungleUnityInterstitialExtrasBuilder.java" "${new_adapter_dir}/source/android-library/${adapter_name_lower_cased}/src/main/java/com/google/unity/mediation/${adapter_name_lower_cased}/${adapter_name}UnityInterstitialExtrasBuilder.java"
  cp "${extras_template_dir}/source/android-library/liftoffmonetize/src/main/java/com/google/unity/mediation/liftoffmonetize/VungleUnityRewardedVideoExtrasBuilder.java" "${new_adapter_dir}/source/android-library/${adapter_name_lower_cased}/src/main/java/com/google/unity/mediation/${adapter_name_lower_cased}/${adapter_name}UnityRewardedVideoExtrasBuilder.java"
  cp "${extras_template_dir}/source/android-library/gradle/wrapper/gradle-wrapper.properties" "${new_adapter_dir}/source/android-library/gradle/wrapper/gradle-wrapper.properties"

  # Copy iOS Extras Builder
  cp "${extras_template_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/LiftoffMonetize/Api/LiftoffMonetizeMediationExtras.cs" "${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Api/${adapter_name}MediationExtras.cs"
  cp "${extras_template_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/LiftoffMonetize/Api/LiftoffMonetizeMediationExtras.cs.meta" "${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Api/${adapter_name}MediationExtras.cs.meta"
  cp "${extras_template_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/LiftoffMonetize/Api/LiftoffMonetizeInterstitialMediationExtras.cs" "${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Api/${adapter_name}InterstitialMediationExtras.cs"
  cp "${extras_template_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/LiftoffMonetize/Api/LiftoffMonetizeInterstitialMediationExtras.cs.meta" "${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Api/${adapter_name}InterstitialMediationExtras.cs.meta"
  cp "${extras_template_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/LiftoffMonetize/Api/LiftoffMonetizeRewardedVideoMediationExtras.cs" "${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Api/${adapter_name}RewardedVideoMediationExtras.cs"
  cp "${extras_template_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/LiftoffMonetize/Api/LiftoffMonetizeRewardedVideoMediationExtras.cs.meta" "${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Api/${adapter_name}RewardedVideoMediationExtras.cs.meta"

  cp "${extras_template_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/LiftoffMonetize/Plugins/iOS/LiftoffMonetizeExtrasBuilder.h" "${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Plugins/iOS/${adapter_name}ExtrasBuilder.h"
  cp "${extras_template_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/LiftoffMonetize/Plugins/iOS/LiftoffMonetizeExtrasBuilder.h.meta" "${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Plugins/iOS/${adapter_name}ExtrasBuilder.h.meta"
  cp "${extras_template_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/LiftoffMonetize/Plugins/iOS/LiftoffMonetizeExtrasBuilder.m" "${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Plugins/iOS/${adapter_name}ExtrasBuilder.m"
  cp "${extras_template_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/LiftoffMonetize/Plugins/iOS/LiftoffMonetizeExtrasBuilder.m.meta" "${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Plugins/iOS/${adapter_name}ExtrasBuilder.m.meta"
fi

# 4) Replace placeholders
echo "Replacing placeholder symbols..."

# First, make all files in the new adapter directory writable
echo "Preparing files for editing..."
find "${new_adapter_dir}" -type f -exec bash -c 'make_writable "$0"' {} \;

# Now perform the sed replacements
echo "Performing text replacements..."
find "${new_adapter_dir}" -type f \( -name "*.md" -o -name "*.cs" -o -name "*.xml" -o -name "*.gradle" -o -name "*.json" -o -name "*.blueprint" -o -name "*.m" -o -name "*.h" -o -name "*.java" -o -name "*.properties" -o -name "*.pgcfg" \) -exec sed -i '' \
  -e "s/MyTarget/${adapter_name}/g" \
  -e "s/myTarget/${adapter_name_lower_cased}/g" \
  -e "s/MYTARGET/${adapter_name_upper_cased}/g" \
  -e "s/LiftoffMonetize/${adapter_name}/g" \
  -e "s/liftoffmonetize/${adapter_name_lower_cased}/g" \
  -e "s/Vungle/${adapter_name}/g" \
  -e "s/vungle/${adapter_name_lower_cased}/g" \
  -e "s/GoogleMobileAdsMyTargetMediation/${plugin_name}/g" \
  -e "s/\"version\": \"3.35.0\"/\"version\": \"${version}\"/g" \
  -e "s/versionString = '3.35.0'/versionString = '${version}'/g" \
  -e "s/Copyright 2017 Google LLC/Copyright ${year} Google LLC/g" \
  -e "s/Copyright 2018 Google LLC/Copyright ${year} Google LLC/g" \
  -e "s/Copyright 2019 Google LLC/Copyright ${year} Google LLC/g" \
  -e "s/Copyright 2022 Google LLC/Copyright ${year} Google LLC/g" \
  -e "s/Copyright 2023 Google LLC/Copyright ${year} Google LLC/g" \
  -e "s/Copyright 2024 Google LLC/Copyright ${year} Google LLC/g" \
  -e "s/Copyright 2025 Google LLC/Copyright ${year} Google LLC/g" \
  -e "s/com.google.ads.mobile\": \"11.0.0\"/com.google.ads.mobile\": \"${unity_version}\"/g" \
  -e "s/GoogleMobileAdsMediationMyTarget\" version=\"5.40.0.0\"/${ios_pod_name}\" version=\"${ios_adapter_version}\"/g" \
  -e "s/com.google.ads.mediation:mytarget:5.45.3.0/${android_package_name}:${android_adapter_version}/g" \
  -e "s/value: 'MyTarget'/value: '${adapter_name}'/g" \
  -e "s/blueprint_file = ::Rapid::BlueprintFile(\"\/\/depot\/google3\/third_party\/unity\/gma_sdk_mediation\/MyTarget\/...\", \"MyTarget\")/blueprint_file = ::Rapid::BlueprintFile(\"\/\/depot\/google3\/third_party\/unity\/gma_sdk_mediation\/${adapter_name}\/...\", \"${adapter_name}\")/g" \
  -e "s/myTarget Adapter Integration Guide/${adapter_name} Adapter Integration Guide/g" \
  -e "s/mediation\/myTarget/mediation\/${adapter_name_lower_cased}/g" \
  -e "s/mytarget#mytarget-unity-mediation-plugin-changelog/${adapter_name_lower_cased}#${adapter_name_lower_cased}-unity-mediation-plugin-changelog/g" \
  -e "s/myTarget Unity Mediation Plugin Changelog/${adapter_name} Unity Mediation Plugin Changelog/g" \
  -e "s/MyTargetUnityAdapter-3.35.0.zip/${adapter_name}UnityAdapter-${version}.zip/g" \
  -e "s/Built and tested with the Google Mobile Ads Unity Plugin version 11.0.0./Built and tested with the Google Mobile Ads Unity Plugin version ${unity_version}./g" \
  -e "s/com.google.ads.mobile.mediation.mytarget/com.google.ads.mobile.mediation.${adapter_name_lower_cased}/g" \
  -e "s/Google Mobile Ads myTarget Mediation/Google Mobile Ads ${adapter_name} Mediation/g" \
  -e "s/vh-name:GoogleMobileAdsMediationMyTarget/vh-name:${ios_pod_name}/g" \
  -e "s/vh-name:Google Mobile Ads myTarget Mediation/vh-name:Google Mobile Ads ${adapter_name} Mediation/g" \
  -e "s/mediation plugin for myTarget package/mediation plugin for ${adapter_name} package/g" \
  -e "s/add myTarget mediation support/add ${adapter_name} mediation support/g" \
  -e "s/adapterName = 'MyTarget'/adapterName = '${adapter_name}'/g" \
  -e "s/BuildMyTargetUnity/Build${adapter_name}Unity/g" \
  -e "s/GADUMMyTarget/GADUM${adapter_name}/g" \
  -e "s/<MyTargetSDK\/MyTargetSDK.h>/<${adapter_name}SDK\/${adapter_name}SDK.h>/g" \
  -e "s/MTRGPrivacy/${adapter_name}Privacy/g" \
  -e "s/GoogleMobileAds.Mediation.MyTarget/GoogleMobileAds.Mediation.${adapter_name}/g" \
  -e "s/com.google.unity.mediation.mytarget/com.google.unity.mediation.${adapter_name_lower_cased}/g" \
  {} +

# Additional replacements for -with_extras
if [[ "$with_extras" == true ]]; then
  echo "Replacing placeholders in Extras files..."
  # Make files writable first
  find "${new_adapter_dir}/source/android-library/" -type f -exec bash -c 'make_writable "$0"' {} \;
  find "${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Api/" -type f \( -name "*.cs" \) -exec bash -c 'make_writable "$0"' {} \;
  find "${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Plugins/iOS/" -type f \( -name "*.h" -o -name "*.m" \) -exec bash -c 'make_writable "$0"' {} \;

  # Perform sed replacements for extras
  find "${new_adapter_dir}/source/android-library/" -type f -exec sed -i '' \
    -e "s/liftoffmonetize/${adapter_name_lower_cased}/g" \
    -e "s/LiftoffMonetize/${adapter_name}/g" \
    -e "s/Vungle/${adapter_name}/g" \
    -e "s/vungle/${adapter_name_lower_cased}/g" \
    -e "s/com.google.ads.mediation:vungle:7.7.2.0/${android_package_name}:${android_adapter_version}/g" \
    -e "s/GoogleMobileAdsMediationVungle\" version=\"7.7.1.0\"/${ios_pod_name}\" version=\"${ios_adapter_version}\"/g" \
    -e "s/VungleUnityExtrasBuilder/${adapter_name}UnityExtrasBuilder/g" \
    -e "s/VungleUnityInterstitialExtrasBuilder/${adapter_name}UnityInterstitialExtrasBuilder/g" \
    -e "s/VungleUnityRewardedVideoExtrasBuilder/${adapter_name}UnityRewardedVideoExtrasBuilder/g" \
    -e "s/VungleConstants/${adapter_name}Constants/g" \
    -e "s/VungleAdNetworkExtras/${adapter_name}AdNetworkExtras/g" \
    -e "s/VungleInterstitialAdapter/${adapter_name}InterstitialAdapter/g" \
    -e "s/VungleAdapter/${adapter_name}Adapter/g" \
    -e "s/com.google.unity.mediation.liftoffmonetize/com.google.unity.mediation.${adapter_name_lower_cased}/g" \
    -e "s/include 'liftoffmonetize'/include '${adapter_name_lower_cased}'/g" \
    -e "s/buildFile = 'source\/android-library\/liftoffmonetize\/build.gradle'/buildFile = 'source\/android-library\/${adapter_name_lower_cased}\/build.gradle'/g" \
    -e "s/from('source\/android-library\/liftoffmonetize\/build\/libs\/liftoffmonetize-unity-android-library.aar')/from('source\/android-library\/${adapter_name_lower_cased}\/build\/libs\/${adapter_name_lower_cased}-unity-android-library.aar')/g" \
    -e "s/into(\"\$\{pluginBuildDir\}\/Assets\/GoogleMobileAds\/Mediation\/LiftoffMonetize\/Plugins\/Android\/\")/into(\"\$\{pluginBuildDir\}\/Assets\/GoogleMobileAds\/Mediation\/${adapter_name}\/Plugins\/Android\/\")/g" \
    -e "s/#import <LiftoffMonetizeAdapter\/VungleAdNetworkExtras.h>/#import <${adapter_name}Adapter\/${adapter_name}AdNetworkExtras.h>/g" \
    -e "s/LiftoffMonetizeExtrasBuilder/${adapter_name}ExtrasBuilder/g" \
    -e "s/GADUMLiftoffMonetizeSetGDPRStatus/GADUM${adapter_name}SetGDPRStatus/g" \
    -e "s/GADUMLiftoffMonetizeSetGDPRMessageVersion/GADUM${adapter_name}SetGDPRMessageVersion/g" \
    -e "s/GADUMLiftoffMonetizeSetCCPAStatus/GADUM${adapter_name}SetCCPAStatus/g" \
    -e "s/com.vungle.ads.VunglePrivacySettings/com.${adapter_name_lower_cased}.ads.${adapter_name}PrivacySettings/g" \
    {} +

  # Sed for iOS extras C# and Objective-C
  find "${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Api/" -type f \( -name "*.cs" \) -exec sed -i '' \
    -e "s/LiftoffMonetize/${adapter_name}/g" \
    -e "s/liftoffmonetize/${adapter_name_lower_cased}/g" \
    -e "s/Vungle/${adapter_name}/g" \
    -e "s/vungle/${adapter_name_lower_cased}/g" \
    -e "s/com.google.unity.mediation.liftoffmonetize.VungleUnityInterstitialExtrasBuilder/com.google.unity.mediation.${adapter_name_lower_cased}.${adapter_name}UnityInterstitialExtrasBuilder/g" \
    -e "s/com.google.unity.mediation.liftoffmonetize.VungleUnityRewardedVideoExtrasBuilder/com.google.unity.mediation.${adapter_name_lower_cased}.${adapter_name}UnityRewardedVideoExtrasBuilder/g" \
    -e "s/LiftoffMonetizeExtrasBuilder/${adapter_name}ExtrasBuilder/g" \
    {} +

  find "${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Plugins/iOS/" -type f \( -name "*.h" -o -name "*.m" \) -exec sed -i '' \
    -e "s/LiftoffMonetize/${adapter_name}/g" \
    -e "s/liftoffmonetize/${adapter_name_lower_cased}/g" \
    -e "s/Vungle/${adapter_name}/g" \
    -e "s/vungle/${adapter_name_lower_cased}/g" \
    -e "s/#import <LiftoffMonetizeAdapter\/VungleAdNetworkExtras.h>/#import <${adapter_name}Adapter\/${adapter_name}AdNetworkExtras.h>/g" \
    -e "s/VungleAdNetworkExtras/${adapter_name}AdNetworkExtras/g" \
    -e "s/LiftoffMonetizeExtrasBuilder/${adapter_name}ExtrasBuilder/g" \
    {} +
fi

echo "Done! New adapter structure created at ${new_adapter_dir}"
echo ""
echo "--- Manual Steps Required ---"
echo "The script has automated most of the boilerplate. However, some manual adjustments are still needed:"
echo ""
echo "1.  **${new_adapter_dir}/CHANGELOG.md:**"
echo "    -   Update the descriptions for the initial release."
echo "    -   Verify the Android and iOS adapter versions are correct."
echo "    -   **CRITICAL:** Update the GitHub links to the *actual* Android and iOS adapter CHANGELOGs for ${adapter_name}."
echo ""
echo "2.  **${new_adapter_dir}/package.json:**"
echo "    -   Verify the 'displayName' and 'description'. The description is currently generic."
echo ""
echo "3.  **${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Editor/${adapter_name}MediationDependencies.xml:**"
echo "    -   **CRITICAL:** Update the \`androidPackage\` and \`iosPod\` \`spec\` and \`version\` attributes to match the actual dependencies for the ${adapter_name} SDK."
echo "    -   Add any necessary repositories for Android packages. The template includes common ones, but network-specific ones might be needed."
echo "    -   Add any additional \`iosPod\` entries if required (e.g., for the core SDK, like 'OpenWrapSDK' in PubMatic)."
echo ""
echo "4.  **C# Implementation Files:**"
echo "    -   **${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Common/I${adapter_name}Client.cs:** Define the interface methods that your Unity plugin will expose to interact with the native ${adapter_name} SDKs."
echo "    -   **${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Platforms/Android/${adapter_name}Client.cs:** Implement the \`I${adapter_name}Client\` interface for Android. **CRITICAL:** Update AndroidJavaClass names (e.g., \`com.my.target.common.MyTargetPrivacy\`) to the correct ${adapter_name} SDK classes and method calls."
echo "    -   **${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Platforms/iOS/${adapter_name}Client.cs:** Implement the \`I${adapter_name}Client\` interface for iOS, using \`Externs\`. Update method calls to match your native iOS implementation."
echo "    -   **${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Platforms/iOS/Externs.cs:** Declare the \`[DllImport(\"__Internal\")]\` methods. Update method names (e.g., \`GADUMMyTargetSetUserConsent\` to \`GADUM${adapter_name}SetUserConsent\`)."
echo "    -   **${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Api/${adapter_name}.cs:** Implement the public API, calling the \`client\` methods."
echo ""
echo "5.  **Native Platform Files:**"
echo "    -   **iOS:** Create Objective-C (\`.m\`) or Swift (\`.swift\`) files in \`${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Plugins/iOS/\` to implement the native calls declared in \`Externs.cs\`. **CRITICAL:** Update imports (e.g., \`<MyTargetSDK/MyTargetSDK.h>\` to \`<${adapter_name}SDK/${adapter_name}SDK.h>\`) and native SDK calls. See '${adapter_root_dir}/IronSource/source/plugin/Assets/GoogleMobileAds/Mediation/IronSource/Plugins/iOS/GADUMIronSourceInterface.m' for an example."
echo "    -   **Android:** Place any required Android AAR libraries in \`${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Plugins/Android/\`. If using \`-with_extras\`, review and update the Gradle project under \`${new_adapter_dir}/source/android-library/\`."
echo ""
if [[ "$with_extras" == true ]]; then
  echo "6.  **Mediation Extras Files:**"
  echo "    -   **${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Api/${adapter_name}MediationExtras.cs:** Define the C# extras class. Update keys and the \`IOSMediationExtraBuilderClassName\`."
  echo "    -   **${new_adapter_dir}/source/android-library/${adapter_name_lower_cased}/src/main/java/com/google/unity/mediation/${adapter_name_lower_cased}/${adapter_name}UnityExtrasBuilder.java:** Implement the Android extras builder. **CRITICAL:** Update keys and how the bundle is built, referencing the correct native Android adapter classes (e.g., \`com.google.ads.mediation.${adapter_name_lower_cased}.${adapter_name}Extras\`)."
  echo "    -   **${new_adapter_dir}/source/plugin/Assets/GoogleMobileAds/Mediation/${adapter_name}/Plugins/iOS/${adapter_name}ExtrasBuilder.h/m:** Implement the iOS extras builder. **CRITICAL:** Update keys and how \`GADAdNetworkExtras\` is created, referencing the correct native iOS adapter classes (e.g., \`<${adapter_name}Adapter/${adapter_name}AdNetworkExtras.h>\`)."
fi
echo ""
echo "7.  **.meta Files:** While copied, Unity might regenerate GUIDs. Check if any assets fail to link in Unity and update GUIDs in the \`.meta\` files if necessary."
echo ""
