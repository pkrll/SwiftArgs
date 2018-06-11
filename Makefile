.PHONY: test codecov xcodeproj clean
SC=swift

test:
	$(SC) test --configuration debug -Xswiftc "-D" -Xswiftc "DEBUG"

codecov:
	xcodebuild clean build test -scheme SwiftArgs-Package -enableCodeCoverage YES -configuration "Debug"

xcodeproj:
	swift package generate-xcodeproj

sonarscanner:
	sonar-scanner

clean:
	rm -rf .build
	rm -rf xcov_report/
	rm -rf .scannerwork
