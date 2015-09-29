@echo off
if "%1"=="" goto error
REM iverilog -s TEST -o %~n1 %~nx1
iverilog -s %~n1_test -o %~n1 %~nx1
REM vvp %~n1 > %~n1.output
vvp %~n1
goto end

:error
echo ƒGƒ‰[
goto end

:end
pause
