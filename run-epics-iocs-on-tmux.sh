#!/bin/bash
set -e -x

export EPICS_TMUX_SESSION=IOCs

source $CI_SCRIPTS/epics-config.sh

echo "Starting a new tmux session '${EPICS_TMUX_SESSION}'"
tmux new-session -d -s ${EPICS_TMUX_SESSION} /bin/bash

echo "Starting the IOCs..."
tmux new-window -n 'pyepics-test_ioc' -c "${CI_TOP}" "export EPICS_CA_SERVER_PORT=5066; . ci-scripts/run-pyepics-test-ioc.sh" && tmux set remain-on-exit on
tmux new-window -n 'motorsim_ioc' -c "${CI_TOP}"  "export EPICS_CA_SERVER_PORT=5067; . ci-scripts/run-motorsim-ioc.sh" && tmux set remain-on-exit on
tmux new-window -n 'adsim_ioc' -c "${CI_TOP}" "export EPICS_CA_SERVER_PORT=5068; . ci-scripts/run-sim-detector-ioc.sh" && tmux set remain-on-exit on

while [ /bin/true ]; do
    env |grep EPICS_
    ps aux |grep -i motor
    caget sim:mtr1 || /bin/true
    sleep 0.5
done

timeout 30s $CI_SCRIPTS/ensure-iocs-are-running.sh

echo "Running pyepics simulator program..."
tmux new-window -n 'pyepics-simulator' -c "${CI_TOP}" "ci-scripts/run-pyepics-simulator.sh" && tmux set remain-on-exit on

echo "Done - check tmux session ${EPICS_TMUX_SESSION}"
