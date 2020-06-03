# Load ENV file

if [ -f ENV ]; then
  set -o allexport
  # shellcheck disable=SC1091
  # shellcheck source=ENV
  source "$(pwd)/ENV"
  set +o allexport
fi

PATH="${BATS_TEST_DIRNAME}/stubs:$PATH"
TERMINUSDB_CONTAINER=${TERMINUSDB_CONTAINER:-terminusdb-server}
TERMINUSDB_STORAGE=${TERMINUSDB_STORAGE:-terminusdb_storage}

container() {
  yes | ./terminusdb-container "$1"
}

inspect() {
  sudo docker inspect -f '{{.State.Running}}' "$TERMINUSDB_CONTAINER"
}

inspect_volume() {
  sudo docker volume inspect -f '{{.Name}}' "$TERMINUSDB_STORAGE"
}

@test "container run" {
  run container run
  [ "$status" -eq 0 ]
  run inspect
  [ "$status" -eq 0 ]
}

@test "volume exists" {
  run inspect_volume
  [ "$status" -eq 0 ]
}

@test "container help" {
  run container help
  [ "$status" -eq 0 ]
}

@test "container console" {
  run container console
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "python" ]
}

@test "container attach" {
  run expect "${BATS_TEST_DIRNAME}"/expect/attach.exp
  [ "$status" -eq 0 ]
}

@test "container stats" {
  run expect "${BATS_TEST_DIRNAME}"/expect/stats.exp
  [ "$status" -eq 0 ]
}

@test "container stop" {
  run container stop
  [ "$status" -eq 0 ]
  run inspect
  [ "$status" -ne 0 ]
}

@test "container rm" {
  run container rm
  [ "$status" -eq 0 ]
  run inspect_volume
  [ "$status" -ne 0 ]
}

