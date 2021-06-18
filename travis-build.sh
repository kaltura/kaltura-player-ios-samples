#!/bin/bash

# Travis aborts the build if it doesn't get output for 10 minutes.
keepAlive() {
  while [ -f $1 ]
  do 
    sleep 10
    echo .
  done
}

buildBasicSampleiOS() {
  echo Building the KalturaPlayer iOS BasicSample test App
  cd BasicSample
  xcodebuild clean build -workspace BasicSample.xcworkspace -scheme BasicSample ONLY_ACTIVE_ARCH=NO -destination 'platform=iOS Simulator,name=iPhone 11' | tee xcodebuild.log | xcpretty -r html && exit ${PIPESTATUS[0]}
  cd ../
}

buildBasicSampletvOS() {
  echo Building the KalturaPlayer tvOS BasicSample test App
  cd BasicSample_tvOS
  xcodebuild clean build -workspace BasicSample_tvOS.xcworkspace -scheme BasicSample_tvOS ONLY_ACTIVE_ARCH=NO -destination 'platform=tvOS Simulator,name=Apple TV' | tee xcodebuild.log | xcpretty -r html && exit ${PIPESTATUS[0]}
  cd ../
}

buildOTTSampleiOS() {
  echo Building the KalturaPlayer iOS OTTSample test App
  cd OTTSample
  xcodebuild clean build -workspace OTTSample.xcworkspace -scheme OTTSample ONLY_ACTIVE_ARCH=NO -destination 'platform=iOS Simulator,name=iPhone 11' | tee xcodebuild.log | xcpretty -r html && exit ${PIPESTATUS[0]}
  cd ../
}

buildOTTSampletvOS() {
  echo Building the KalturaPlayer tvOS OTTSample test App
  cd OTTSample_tvOS
  xcodebuild clean build -workspace OTTSample_tvOS.xcworkspace -scheme OTTSample_tvOS ONLY_ACTIVE_ARCH=NO -destination 'platform=tvOS Simulator,name=Apple TV' | tee xcodebuild.log | xcpretty -r html && exit ${PIPESTATUS[0]}
  cd ../
}

buildOVPSampleiOS() {
  echo Building the KalturaPlayer iOS OVPSample test App
  cd OVPSample
  xcodebuild clean build -workspace OVPSample.xcworkspace -scheme OVPSample ONLY_ACTIVE_ARCH=NO -destination 'platform=iOS Simulator,name=iPhone 11' | tee xcodebuild.log | xcpretty -r html && exit ${PIPESTATUS[0]}
  cd ../
}

buildOVPSampletvOS() {
  echo Building the KalturaPlayer tvOS OVPSample test App
  cd OVPSample_tvOS
  xcodebuild clean build -workspace OVPSample_tvOS.xcworkspace -scheme OVPSample_tvOS ONLY_ACTIVE_ARCH=NO -destination 'platform=tvOS Simulator,name=Apple TV' | tee xcodebuild.log | xcpretty -r html && exit ${PIPESTATUS[0]}
  cd ../
}

FLAG=$(mktemp)

if [ -n "$TRAVIS_TAG" ] || [ "$TRAVIS_EVENT_TYPE" == "cron" ]; then
  keepAlive $FLAG &
else
  buildBasicSampleiOS
  buildBasicSampletvOS
  buildOTTSampleiOS
  buildOTTSampletvOS
  buildOVPSampleiOS
  buildOVPSampletvOS
fi

rm $FLAG  # stop keepAlive
