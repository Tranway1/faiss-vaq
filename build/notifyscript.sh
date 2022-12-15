#!/bin/bash

MSG=$1
curl -X POST -H "Content-Type: application/json" -d '{"value1":'\""${MSG}\""'}' https://maker.ifttt.com/trigger/experiment_notification/with/key/bRjV_pzsiEwsDhi88uwOo2
