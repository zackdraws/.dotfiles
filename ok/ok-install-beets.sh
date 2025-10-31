#!/usr/bin/env bash

# Beets Virtual Environment Setup Script for MSYS2 UCRT64

# Fail on error
set -e

# Set your project directory (can be changed)
PROJECT_DIRJECT_DI="$HOME/programs/beets"
VENV_DIR="$PROR/beets-env"

# Create project directory if it doesn't exist
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR"

echo "Creating virtual environment at $VENV_DIR"
python -m venv "$VENV_DIR"

echo "Activating virtual environment..."
source "$VENV_DIR/bin/activate"

echo "Installing beets and plugins..."
pip install --upgrade pip
pip install 'beets[fetchart,lyrics,lastgenre,ftintitle,chromaprint]'

echo "Done! You can now use beets."
echo "To activate the environment again later, run:"
echo "    source \"$VENV_DIR/bin/activate\""
