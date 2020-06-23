
set -o allexport
# shellcheck disable=SC1091
# shellcheck source=$(pwd)/terminusdb-container 
source "$(pwd)/terminusdb-container" nop 
set +o allexport


echo "start" >&3
_log() {
  echo "$1" >> _bats_log 
}

PATH="${BATS_TEST_DIRNAME}/stubs:$PATH"


_log date +%s

container() {
  yes | "${BATS_TEST_DIRNAME}"/../../terminusdb-container "$1"
}

inspect() {
  _log "inspect $TERMINUSDB_QUICKSTART_CONTAINER"
  sudo docker inspect -f '{{.State.Running}}' "$TERMINUSDB_QUICKSTART_CONTAINER"
}

inspect_volume() {
  _log "inspect volume $TERMINUSDB_QUICKSTART_STORAGE"
  sudo docker volume inspect -f '{{.Name}}' "$TERMINUSDB_QUICKSTART_STORAGE"
}


@test "container run" {
  run container run
  [ "$status" -eq 0 ]
  run inspect
  [ "$status" -eq 0 ]
}

@test "volume exists" {
  _log "hello?"
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

@test "terminusdb console" {
  mkdir -p "${BATS_TEST_DIRNAME}/../build"
  TERMINUSDB_BATS_CONSOLE_REPO="${BATS_TEST_DIRNAME}/../build/terminusdb-console"
  if [[ -d "$TERMINUSDB_BATS_CONSOLE_REPO" ]]; then
    cd "$TERMINUSDB_BATS_CONSOLE_REPO"
    git pull
  else
    git clone https://github.com/terminusdb/terminusdb-console.git "$TERMINUSDB_BATS_CONSOLE_REPO"
  fi
  cd "$TERMINUSDB_BATS_CONSOLE_REPO"
  npm install
  npm run build
  cd console/dist
  npx http-server -p 3005 &
  sleep 5
  cd "$TERMINUSDB_BATS_CONSOLE_REPO"
  npx cypress run >&3
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

