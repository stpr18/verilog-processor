@echo off
iverilog -s processor processor.v -o processor && vvp processor
pause
