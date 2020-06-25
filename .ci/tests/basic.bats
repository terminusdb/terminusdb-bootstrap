# SET TEST ENV
TERMINUSDB_AUTOLOGIN=false
TERMINUSDB_CONSOLE_BASE_URL=//127.0.0.1:3005
TERMINUSDB_BATS_CONSOLE_REPO="${BATS_TEST_DIRNAME}/../build/terminusdb-console"

# LOAD QUICKSTART ENV
set -o allexport
# shellcheck disable=SC1091
# shellcheck source=$(pwd)/terminusdb-container 
source "$(pwd)/terminusdb-container" nop 
set +o allexport

_log() {
  echo "$1" >> _bats_log 
}

PATH="${BATS_TEST_DIRNAME}/stubs:$PATH"


_log date +%s

container() {
  yes | "${BATS_TEST_DIRNAME}/../../terminusdb-container" "$1"
}

inspect() {
  _log "inspect ${TERMINUSDB_QUICKSTART_CONTAINER}"
  sudo docker inspect -f '{{.State.Running}}' "${TERMINUSDB_QUICKSTART_CONTAINER}"
}

inspect_volume() {
  _log "inspect volume ${TERMINUSDB_QUICKSTART_STORAGE}"
  sudo docker volume inspect -f '{{.Name}}' "${TERMINUSDB_QUICKSTART_STORAGE}"
}

@test "quickstart run" {
  run container run
  [ "${status}" -eq 0 ]
  run inspect
  [ "${status}" -eq 0 ]
}

@test "docker volume exists" {
  _log "hello?"
  run inspect_volume
  [ "${status}" -eq 0 ]
}

@test "quickstart help" {
  run container help
  [ "${status}" -eq 0 ]
}

@test "quickstart console" {
  run container console
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "python" ]
}

@test "quickstart attach" {
  run expect "${BATS_TEST_DIRNAME}/expect/attach.exp"
  [ "${status}" -eq 0 ]
}

@test "quickstart stats" {
  run expect "${BATS_TEST_DIRNAME}/expect/stats.exp"
  [ "${status}" -eq 0 ]
}

@test "terminusdb console build" {
  mkdir -p "${TERMINUSDB_BATS_CONSOLE_REPO}"
  if [[ ! -d "${TERMINUSDB_BATS_CONSOLE_REPO}" ]]; then
    git clone https://github.com/terminusdb/terminusdb-console.git "${TERMINUSDB_BATS_CONSOLE_REPO}"
  fi
  cd "${BATS_TEST_DIRNAME}/../.."
  TERMINUSDB_QUICKSTART_BRANCH=$(git rev-parse --abbrev-ref HEAD)
  case "${TERMINUSDB_QUICKSTART_BRANCH}" in
    dev)
      TERMINUSDB_CONSOLE_BRANCH=dev
    ;;
    canary)
      TERMINUSDB_CONSOLE_BRANCH=canary
    ;;
    *)
      TERMINUSDB_CONSOLE_BRANCH=master
  esac
  cd "${TERMINUSDB_BATS_CONSOLE_REPO}"
  git checkout "${TERMINUSDB_CONSOLE_BRANCH}"
  git pull
  npm install
  run npm run build
  [ "${status}" -eq 0 ]
}

@test "terminusdb console cypress tests" {
  cd "${TERMINUSDB_BATS_CONSOLE_REPO}"
  cd console/dist
  npx http-server -p 3005 &
  TERMINUSDB_BATS_HTTP_SERVER_PID=$!
  cd "${TERMINUSDB_BATS_CONSOLE_REPO}"
  export CYPRESS_BASE_URL="${TERMINUSDB_QUICKSTART_CONSOLE}/"
  npx cypress run --reporter tap --spec 'cypress/integration/tests/login.spec.js' >&3
  kill "${TERMINUSDB_BATS_HTTP_SERVER_PID}"
}

@test "quickstart stop" {
  run container stop
  [ "${status}" -eq 0 ]
  run inspect
  [ "${status}" -ne 0 ]
}

@test "quickstart rm" {
  run container rm
  [ "${status}" -eq 0 ]
  run inspect_volume
  [ "${status}" -ne 0 ]
}

