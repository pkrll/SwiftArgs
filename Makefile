.PHONY: test codecov
SC=swift

test:
	$(SC) test --configuration debug -Xswiftc "-D" -Xswiftc "DEBUG"

codecov:
	xcodebuild test -scheme SwiftArgs-Package -enableCodeCoverage YES -configuration debug

xcodeproj:
	swift package generate-xcodeproj
