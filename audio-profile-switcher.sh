
#!/bin/bash

# Commands to get needed envs
# pactl list

# Colors
BACKGROUND_RED="`tput setaf 1` "
BACKGROUND_WHITE="`tput setaf 6` "
FORGROUND_BLACK="`tput setaf 0` "
DIM="`tput dim` "
INVERT="`tput smso`"
BOLD="`tput bold` "
RESET="`tput sgr0` "
CLEAR="`tput clear` "

switch() {
  # pactl list cards short
  # My example:
  DEVICE="bluez_card.78_2B_64_16_8F_C6"
  # pactl list sinks short (remove the profile after last dot)
  # My example:
  DEVICE_SINK="bluez_output.78_2B_64_16_8F_C6"
  # pactl list cards 
  # find under Profiles of your device.
  # Don't use specific codecs, just base profile, it will pick last used codec.
  PROFILE_QUALITY="a2dp-sink"
  PROFILE_CALL="headset-head-unit"
    
  echo -en "$INVERT$BACKGROUND_WHITE Current profile : $RESET    " >&2
  currentProfile=$(pactl list short sinks | grep ${DEVICE_SINK} | awk '{print $2}' | head -1)
  
  if [[ $currentProfile == *"${PROFILE_QUALITY}" ]]; then
    echo "Quality profile"
    echo "-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_"
    echo -en "$INVERT$BACKGROUND_RED New profile : $RESET     "
    echo "Call profile"
  
    pactl set-card-profile ${DEVICE} ${PROFILE_CALL}
  elif [[ $currentProfile == *"${PROFILE_CALL}" ]]; then
    echo "Call profile"
    echo "-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_"
    echo -en "$INVERT$BACKGROUND_RED New profile : $RESET     "
    echo "Quality profile"
  
    pactl set-card-profile ${DEVICE} ${PROFILE_QUALITY}
  fi
}

install() {
  echo "$INVERT$BACKGROUND_WHITE > The script will be symlinked to your /usr/local/bin directory using the name you specify below$RESET"
  echo "$INVERT$BACKGROUND_RED > It will require sudo privileges to do the symlink$RESET"
  read -r -p "Do you want to continue? [Y/n] " RESPONSE
  
  case "${RESPONSE}" in
    [yY][eE][sS]|[yY]|"" )
      read -r -p "Enter the name oh the command you would like to you to call the script: " APP
      echo "Installing..."
      SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
      sudo cp "${SCRIPTPATH}"/audio-profile-switcher.sh /usr/local/bin/"${APP}"
      echo "Installed!"
    ;;
    [nN][oO]|[nN])
      echo "Aborting.."
    ;;
    *)
      echo "Invalid input..."
      exit 1
    ;;
  esac

  exit
}

main() {
  if [ "$1" = "install" ]; then
    install
  else
    switch
  fi
}

main "$@"