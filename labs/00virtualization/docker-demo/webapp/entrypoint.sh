#!/bin/sh
# S617 Docker demo - entrypoint script
# ----------------------------------------------------------------------------
# An ENTRYPOINT script is where a container does its startup work BEFORE the
# main program runs: read configuration, wait for a database, write a config
# file, etc. Then it hands off to the real command.
#
# This one just shows the pattern. Read the last line carefully - it's the
# single most important idea in this file.

set -e   # stop immediately if any command fails

echo "[entrypoint] S617 demo container starting..."

# Runtime configuration comes from environment variables.
# ${GREETING:-hello} means "use $GREETING, or 'hello' if it isn't set".
echo "[entrypoint] GREETING = ${GREETING:-hello}"

# (Real entrypoints would do setup here: wait for another service,
#  generate a config file from env vars, run database migrations, and so on.)

echo "[entrypoint] handing off to: $*"

# exec "$@" replaces THIS script with the CMD (python http.server), so the app
# becomes PID 1 and receives stop/restart signals directly. Without 'exec', the
# shell stays PID 1, swallows the signals, and `docker stop` becomes slow and
# ungraceful. This one line is why well-behaved containers shut down cleanly.
exec "$@"
