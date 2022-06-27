set -o allexport

# SET TEST ENV
TERMINUSDB_IGNORE_ENV=true
TERMINUSDB_AUTOLOGIN_ENABLED=false
TERMINUSDB_PORT=56363
TERMINUSDB_CONTAINER="terminusdb-server-bats-test"
TERMINUSDB_STORAGE=terminusdb-server-bats-test

if [[ -n "$TERMINUSDB_LOCAL" ]]; then
  mkdir -p "$TERMINUSDB_LOCAL"
fi

# LOAD QUICKSTART ENV
# shellcheck disable=SC1091
# shellcheck source=$(pwd)/terminusdb-container
source "$(pwd)/terminusdb-container" nop

_check_if_docker_is_in_path

set +o allexport

PATH="${BATS_TEST_DIRNAME}/stubs:$PATH"

yes_container() {
  yes | container $@
}

container() {
  "${BATS_TEST_DIRNAME}/../../terminusdb-container" "${@}"
}

inspect() {
  [[ $($TERMINUSDB_QUICKSTART_DOCKER inspect -f '{{.State.Running}}' "${TERMINUSDB_QUICKSTART_CONTAINER}") == "true" ]]
}

inspect_volume() {
  $TERMINUSDB_QUICKSTART_DOCKER volume inspect -f '{{.Name}}' "${TERMINUSDB_QUICKSTART_STORAGE}"
}


@test "quickstart cli" {
  run container run
  run container cli
  [[ "${status}" == 0 ]]
  run container stop
}

@test "quickstart run" {
  run container run
  [[ "${status}" == 0 ]]
  run inspect
  [[ "${status}" == 0 ]]
}

@test "docker volume exists" {
  run inspect_volume
  [[ "${status}" == 0 ]]
}

@test "quickstart help" {
  run container help
  [[ "${status}" == 0 ]]
}

@test "quickstart attach" {
  command -v expect || skip
  run expect "${BATS_TEST_DIRNAME}/expect/attach.exp"
  [[ "${status}" == 0 ]]
}

@test "quickstart stop" {
  run container stop >&3
  [[ "${status}" == "0" ]]
  run inspect
  [[ "${status}" != "0" ]]
}

@test "terminusdb server tests" {
  $TERMINUSDB_QUICKSTART_DOCKER run --rm "$TERMINUSDB_QUICKSTART_REPOSITORY:$TERMINUSDB_QUICKSTART_TAG" bash -c "./terminusdb store init --key root && ./terminusdb test"
}

@test "quickstart rm" {
  run yes_container rm >&3
  [[ "${status}" == 0 ]]
  run inspect_volume
  [[ "${status}" != 0 ]]
}
