# SET TEST ENV
TERMINUSDB_AUTOLOGIN=false
#TERMINUSDB_CONSOLE_BASE_URL=//127.0.0.1:3005
TERMINUSDB_BATS_CONSOLE_REPO="${BATS_TEST_DIRNAME}/../build/terminusdb-console"

# LOAD QUICKSTART ENV
set -o allexport
# shellcheck disable=SC1091
# shellcheck source=$(pwd)/terminusdb-container 
source "$(pwd)/terminusdb-container" nop 
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

@test "quickstart console" {
  run container console
  [[ "${status}" == 0 ]]
  [[ "${lines[0]}" == "python" ]]
}

@test "quickstart attach" {
  run expect "${BATS_TEST_DIRNAME}/expect/attach.exp"
  [[ "${status}" == 0 ]]
}

@test "terminusdb console build" {
  TERMINUSDB_QUICKSTART_BRANCH=$(git rev-parse --abbrev-ref HEAD)
  if [[ ! -d "${TERMINUSDB_BATS_CONSOLE_REPO}" ]]; then
    git clone https://github.com/terminusdb/terminusdb-console.git "${TERMINUSDB_BATS_CONSOLE_REPO}"
  else
    mkdir -p "${TERMINUSDB_BATS_CONSOLE_REPO}"
  fi
  cd "${TERMINUSDB_BATS_CONSOLE_REPO}"
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
  git checkout "${TERMINUSDB_CONSOLE_BRANCH}"
  git pull
  npm install
  run npm run build
  [[ "${status}" == 0 ]]
}

@test "terminusdb console tests" {
  cd "${TERMINUSDB_BATS_CONSOLE_REPO}"
  cd console/dist
  fuser -k 3005/tcp || true
  npx http-server -p 3005 &
  sleep 10
  cd "${TERMINUSDB_BATS_CONSOLE_REPO}"
  export CYPRESS_BASE_URL="${TERMINUSDB_QUICKSTART_CONSOLE}/"
  npx cypress run --reporter tap --spec 'cypress/integration/tests/login.spec.js' >&3
  fuser -k 3005/tcp || true
}

@test "quickstart stop" {
  run container stop >&3
  [[ "${status}" == "0" ]]
  run inspect
  [[ "${status}" != "0" ]]
}

@test "terminusdb server tests" {
  $TERMINUSDB_QUICKSTART_DOCKER run -it --rm -e TERMINUSDB_HTTPS_ENABLED=false "$TERMINUSDB_QUICKSTART_REPOSITORY:$TERMINUSDB_QUICKSTART_TAG" bash -c "./utils/db_init -s localhost -k root && swipl -g run_tests -g halt ./start.pl"
}

@test "quickstart rm" {
  run yes_container rm >&3
  [[ "${status}" == 0 ]]
  run inspect_volume
  [[ "${status}" != 0 ]]
}
