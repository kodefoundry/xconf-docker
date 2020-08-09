#!/bin/sh
eval "echo \"$(cat $XCONF_PROPS)\"" >> $XCONF_PROPS
sh /docker-entrypoint.sh
#/bin/sh
