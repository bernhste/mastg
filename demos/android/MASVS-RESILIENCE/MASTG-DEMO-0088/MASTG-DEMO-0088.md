---
platform: android
title: Runtime Detection of Root Detection Mechanisms
id: MASTG-DEMO-0088
code: [kotlin]
test: MASTG-TEST-0325
---

## Sample

This demo shows how to detect root detection mechanisms at runtime using Frooky. The sample app from @MASTG-DEMO-0087 implements multiple root detection checks.

{{ ../MASTG-DEMO-0087/MastgTest.kt }}

## Steps

1. Ensure the target app is installed on the device and frida-server is running.
2. Run @MASTG-TOOL-0145 with the hooks configuration to monitor root detection methods.

{{ run.sh }}

The hooks configuration monitors common root detection methods:

{{ hooks.yaml }}

## Observation

The output shows all root detection method invocations captured during app execution.

{{ output.json }}

## Evaluation

The test passes because the output confirms the app implements root detection checks that were monitored at runtime:

- **`java.io.File.<init>` calls for `su` path checks:**
    - From `MastgTest.checkForSuBinary()` at line 61.
    - The app checks for 10 `su` binary locations such as `/system/app/Superuser.apk`, `/sbin/su`, `/system/bin/su`, `/system/xbin/su`, etc.

- **`Runtime.exec` calls for `which su` command:**
    - From `MastgTest.checkForWhichSu()` at line 81.
    - The app executes the `which su` command to detect if the `su` binary is available in the system PATH.

- **`Runtime.exec` calls for system property checks:**
    - From `MastgTest.getSystemProperty` at line 181, called by `checkForDangerousProps`.
    - The app executes `getprop ro.debuggable` and `getprop ro.secure` commands to read system properties.
