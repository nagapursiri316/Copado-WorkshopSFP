@echo off
setlocal EnableExtensions EnableDelayedExpansion
REM Local Agentia quality gates (Windows).
REM Edit this script to match your project. Agentia runs it from the repo root during
REM `agentia cicd work test` (local by default) and `agentia cicd work submit` (unless --skip-local-tests).
REM The script must exit non-zero if any check fails.

echo ## Running apex tests (if --apex-test-classes was specified)
call agentia cicd work test apex -t "!AGENTIA_APEX_TEST_CLASSES!" !AGENTIA_APEX_RERUN_FAILED!
if errorlevel 1 exit /b %errorlevel%

if exist node_modules (
  echo ## Running LWC tests
  call npx sfdx-lwc-jest -- --passWithNoTests
  if errorlevel 1 exit /b %errorlevel%
)
