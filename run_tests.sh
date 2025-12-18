#!/bin/bash

# SpireCrash - Test Runner Script
# Runs GUT tests from command line

echo "Running SpireCrash tests..."
echo ""

/Applications/Godot.app/Contents/MacOS/Godot --headless -s addons/gut/gut_cmdln.gd \
  -gdir=res://tests/unit,res://tests/integration \
  -gexit

echo ""
echo "Tests complete!"
