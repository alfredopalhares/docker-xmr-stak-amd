#!/usr/bin/env bash

set -e

confd -backend env -onetime

exec "${PWD}/xmr-stak"