#!/bin/sh

error() {
	echo "E: ${@}"
	exit 1
}

# systemd is dumb and doesn't support Restart=on-failure on oneshot scripts...
for try in $(seq 5); do

	sampling_frequency_file=$(find /sys/bus/iio/devices -type f -name in_accel_sampling_frequency -follow -maxdepth 2 2> /dev/null | head -n1)

	if [ "${sampling_frequency_file}" ]; then
	        echo 100 > ${sampling_frequency_file}
		break
	fi

	sleep 5
done

[ -z "${sampling_frequency_file}" ] && error "Unable to find in_accel_sampling_frequency"

exit 0

