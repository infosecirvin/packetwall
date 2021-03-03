#!/bin/bash

# Common path for all GPIO access
BASE_GPIO_PATH=/sys/class/gpio

# Assign names to GPIO pin numbers for each light
GREEN=12

# Assign names to states
ON="1"
OFF="0"

# Utility function to export a pin if not already exported
exportPin()
{
  if [ ! -e $BASE_GPIO_PATH/gpio$1 ]; then
    echo "$1" > $BASE_GPIO_PATH/export
  fi
}

# Utility function to set a pin as an output
setOutput()
{
  echo "out" > $BASE_GPIO_PATH/gpio$1/direction
}

# Utility function to change state of a light
setLightState()
{
  echo $2 > $BASE_GPIO_PATH/gpio$1/value
}

# Utility function to turn all lights off
allLightsOff()
{
  setLightState $GREEN $OFF
}

# Ctrl-C handler for clean shutdown
shutdown()
{
  allLightsOff
  exit 0
}

trap shutdown SIGINT

# Export pins so that we can use them
exportPin $GREEN
# Set pins as outputs
setOutput $GREEN

# Turn lights off to begin
allLightsOff

while [ 1 ]
do
rule1=$(<r1)

if [ $rule1 == $ON ]; then
	setLightState $GREEN $ON
	sleep 9
	setLightState $GREEN $OFF
	sleep 1
else
	setLightState $GREEN $OFF
	sleep 9
fi
done
