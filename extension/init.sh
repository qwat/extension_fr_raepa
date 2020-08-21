#!/usr/bin/env bash

echo "--- Running RAEPA extension init ---"

GNUGETOPT="getopt"
if [[ "$OSTYPE" =~ FreeBSD* ]] || [[ "$OSTYPE" =~ darwin* ]]; then
  GNUGETOPT="/usr/local/bin/getopt"
elif [[ "$OSTYPE" =~ openbsd* ]]; then
  GNUGETOPT="gnugetopt"
fi

# Exit on error
set -e

usage() {
cat << EOF
Usage: $0 [options]

-p|--pgservice       PG service to connect to the database.
-s|--srid            PostGIS SRID. Default to 2154 (Lambert93)
-d|--drop-schema     Drop schema (cascaded) if it exists
EOF
}

ARGS=$(${GNUGETOPT} -o p:s:d -l "pgservice:,srid:,drop-schema" -- "$@");
if [[ $? -ne 0 ]]
then
  usage
  exit 1
fi

eval set -- "$ARGS";



RAEPA_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


echo "--- current directory is ${RAEPA_DIR} ---" 

# Default values
SRID=2154
DROPSCHEMA=0

while true; do
  case "$1" in
    -p|--pgservice)
      shift
      if [[ -n "$1" ]]
      then
        PGSERVICE=$1
        shift
      fi
      ;;
    -s|--srid)
      shift;
      if [[ -n "$1" ]]; then
        SRID=$1
        shift;
      fi
      ;;
    -d|--drop-schema)
      DROPSCHEMA=1
      shift;
      ;;
    --)
      shift
      break
      ;;
  esac
done

if [[ -z $PGSERVICE ]]
then
  echo "Error: no PG service provided; either use -p or set the PGSERVICE environment variable."
  exit 1
fi

if [[ "$DROPSCHEMA" -eq 1 ]]; then
  echo "--- dropping schema qwat_raepa --- "
	psql service=${PGSERVICE} -v ON_ERROR_STOP=1 \
         -c "DROP SCHEMA IF EXISTS qwat_raepa CASCADE"
fi

echo ----- deactivate audit triggers ------------------------------

psql service=${PGSERVICE} -f ${RAEPA_DIR}/delta/pre-all.sql


# create the qwat_raepa schema
echo "--- creating schema qwat_raepa --- "
psql service=$PGSERVICE -v ON_ERROR_STOP=1 -c "CREATE SCHEMA IF NOT EXISTS qwat_raepa"

# execute global pre-all logic (drop views & co)

# add the qwat_raepa columns
echo "--- adding qwat_raepa columns --- "

psql service=$PGSERVICE -v ON_ERROR_STOP=1 -v SRID=$SRID -f ${RAEPA_DIR}/raepa_columns.sql

# execute global post-all logic (recreate views, functions, enable audit triggers )

# re-create the QWAT views, for the new qwat_raepa columns to be taken into account
echo "--- recreating qwat_raepa views (core views untouched)---- "
PGSERVICE=${PGSERVICE} SRID=${SRID} ${RAEPA_DIR}/rewrite_views.sh 

# create the qwat_raepa views
PGSERVICE=${PGSERVICE} SRID=${SRID} ${RAEPA_DIR}/insert_views.sh

# grants 

PGSERVICE=${PGSERVICE} SRID=${SRID} ${RAEPA_DIR}/roles.sh


echo "---- reactivate audit triggers ------- "

psql service=${PGSERVICE} -f ${RAEPA_DIR}/delta/post-all.sql

exit 0
