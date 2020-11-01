#!/bin/bash
TMPHTPASS=$(mktemp)

htpasswd -b ${TMPHTPASS} admin 'admin'
htpasswd -b ${TMPHTPASS} developer 'developer'
htpasswd -b ${TMPHTPASS} user 'user'

oc -n openshift-config delete secret workshop-user-secret

oc -n openshift-config create secret generic workshop-user-secret --from-file=htpasswd=${TMPHTPASS}
