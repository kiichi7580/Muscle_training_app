# .PHONY: setup
# setup:
# 		flutter clean
# 		flutter pub get

# .PHONY: ft
# ft:
# 		flutter test

.PHONY: build
build:
	flutter pub run build_runner watch --delete-conflicting-outputs