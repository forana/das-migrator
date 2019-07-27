#!/usr/bin/env bash
set -eo pipefail

usage() {
    echo -e "\nUsage: $(basename $0) [--migration-path=<directory>] [--database-url=<url>]

    Options:
        --migration-path    Directory to scan for migrations. Defaults to the value of
                            \$MIGRATION_PATH, or ./migrations if not set.

        --database-url      Connection string to connect to the database with. Defaults to
                            the value of \$DATABASE_URL, or postgresql://localhost if not set.
"
}

echo-bold() {
    echo -e "\033[1m$1\033[0m"
}

MIGRATION_PATH=${MIGRATION_PATH:-./migrations}
DATABASE_URL=${DATABASE_URL:-postgresql://localhost}

while [ "$1" != "" ]; do
    case $1 in
        --migration-path )
            shift
            MIGRATION_PATH=$1
            ;;
        --database-url )
            shift
            DATABASE_URL=$1
            ;;
        -h | --help )
            usage
            exit 0
            ;;
        * )
            echo "Invalid argument \"$1\"."
            usage
            exit 1
            ;;
    esac
    shift
done

# sanity checks
which psql > /dev/null || (echo "psql not found on \$PATH. That is required for das migrator." && usage && exit 1)

if [ ! -d $MIGRATION_PATH ]; then
    echo "Migration path \"${MIGRATION_PATH}\" does not exist."
    usage
    exit 1
fi

psql -q ${DATABASE_URL} -c "select 1" > /dev/null || exit 1

# do the actual migrating
echo-bold "-----> Starting migrations"
for file in `ls -v1 ${MIGRATION_PATH} | grep .sql`; do
    echo-bold "---> ${file}"
    psql ${DATABASE_URL} -f ${MIGRATION_PATH}/${file}
done
echo-bold "-----> Migrations complete"
