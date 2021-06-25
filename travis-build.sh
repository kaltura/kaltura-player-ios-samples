#!/bin/bash

# Travis aborts the build if it doesn't get output for 10 minutes.
keepAlive() {
  while [ -f $1 ]
  do 
    sleep 10
    echo .
  done
}

FLAG=$(mktemp)
CODE=0

if [ -n "$TRAVIS_TAG" ] || [ "$TRAVIS_EVENT_TYPE" == "cron" ]; then
  keepAlive $FLAG &
else
  rm -rf build

  for dir in */ ; do
    cd $dir
    
    TARGET_NAME=$(echo "$dir" | rev | cut -c2- | rev)
    WORKSPACE="$TARGET_NAME.xcworkspace"

    DESTINATION="platform=iOS Simulator,name=iPhone 11,OS=latest"
    
    if [[ "$dir" == *"_tvOS"* ]]; then
      DESTINATION="platform=tvOS Simulator,name=Apple TV,OS=latest"
    fi
    
    echo "Will start xcodebuild for workspace: $WORKSPACE, scheme: $TARGET_NAME, destination $DESTINATION"

    xcodebuild clean build -workspace $WORKSPACE -scheme $TARGET_NAME -destination "$DESTINATION" | tee xcodebuild.log | xcpretty -r html; CODE=${PIPESTATUS[0]}
    
    echo "$TARGET_NAME xcodebuild was finished with status: $CODE"

    if [ $CODE -ne 0 ]; then cd ..; exit $CODE; fi
    cd ../
  done

fi

rm $FLAG # stop keepAlive
