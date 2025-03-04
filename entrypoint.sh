#!/bin/bash
set -e

# Default command if none provided
if [ $# -eq 0 ]; then
  exec rasa run --enable-api --cors "*" --port 5005
else
  # Execute whatever command was passed
  exec "$@"
fi