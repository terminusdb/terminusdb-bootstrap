set -o allexport

# SET TEST ENV
TERMINUSDB_IGNORE_ENV=true
TERMINUSDB_HTTPS_ENABLED=true
TERMINUSDB_AUTOLOGIN_ENABLED=false
TERMINUSDB_BATS_CONSOLE_REPO="${BATS_TEST_DIRNAME}/../build/terminusdb-console"
TERMINUSDB_PORT=56363
TERMINUSDB_CONTAINER="terminusdb-server-bats-test"
TERMINUSDB_STORAGE=terminusdb-server-bats-test
TERMINUSDB_LOCAL="${TERMINUSDB_BATS_CONSOLE_REPO}/csvs"

mkdir -p "$TERMINUSDB_LOCAL" || true

# LOAD QUICKSTART ENV
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
  command -v expect || skip
  run expect "${BATS_TEST_DIRNAME}/expect/attach.exp"
  [[ "${status}" == 0 ]]
}

@test "terminusdb console build" {
  if [[ -z "$TRAVIS_BRANCH" ]]; then
    TERMINUSDB_QUICKSTART_BRANCH=$(git rev-parse --abbrev-ref HEAD)
  else
    TERMINUSDB_QUICKSTART_BRANCH="$TRAVIS_BRANCH"
  fi

  if [[ ! -d "${TERMINUSDB_BATS_CONSOLE_REPO}/cypress" ]]; then
    mkdir -p "${TERMINUSDB_BATS_CONSOLE_REPO}" || true
    cd "${TERMINUSDB_BATS_CONSOLE_REPO}"
    git init || true
    git remote add origin https://github.com/terminusdb/terminusdb-console.git || true
    git fetch
    echo branch $TERMINUSDB_QUICKSTART_BRANCH >&3
    git checkout -b "${TERMINUSDB_QUICKSTART_BRANCH}" --track origin/"${TERMINUSDB_QUICKSTART_BRANCH}"
  else
    cd "${TERMINUSDB_BATS_CONSOLE_REPO}"
    git checkout "${TERMINUSDB_QUICKSTART_BRANCH}" || true
    git pull || true
  fi
  cd "${TERMINUSDB_BATS_CONSOLE_REPO}"
  case "${TERMINUSDB_QUICKSTART_BRANCH}" in
    dev)
      TERMINUSDB_CONSOLE_BRANCH=dev
      echo "@terminusdb:registry=https://api.bintray.com/npm/terminusdb/npm-dev" > .npmrc
    ;;
    canary)
      TERMINUSDB_CONSOLE_BRANCH=canary
      echo "@terminusdb:registry=https://api.bintray.com/npm/terminusdb/npm-canary" > .npmrc
    ;;
    rc)
      TERMINUSDB_CONSOLE_BRANCH=rc
      echo "@terminusdb:registry=https://api.bintray.com/npm/terminusdb/npm-rc" > .npmrc
    ;;
    *)
      TERMINUSDB_CONSOLE_BRANCH=master
      rm .npmrc || true
  esac
  npm install
  run npm run build
  [[ "${status}" == 0 ]]
}

@test "terminusdb console login" {
  cd "${TERMINUSDB_BATS_CONSOLE_REPO}"
  export CYPRESS_BASE_URL="${TERMINUSDB_QUICKSTART_CONSOLE}/"
  npx cypress run --reporter=tap --config video=false >&3 \
    --spec cypress/integration/tests/login.spec.js
}

@test "terminusdb console hub login" {
  skip
  cd "${TERMINUSDB_BATS_CONSOLE_REPO}"
  npx cypress run --reporter=tap --config video=false >&3 --env \
    baseUrl="${TERMINUSDB_QUICKSTART_CONSOLE}/" \
    password=root \
	  userName=Sarah \
    userNamePassword= \
	  auth0Url=https://terminushub.eu.auth0.com/oauth/token \
	  role=https://hub-dev.dcm.ist/api/role \
    tests/loginAuth0.spec.js
}

@test "terminusdb console branching" {
  skip
  cd "${TERMINUSDB_BATS_CONSOLE_REPO}"
  export CYPRESS_BASE_URL="${TERMINUSDB_QUICKSTART_CONSOLE}/"
  npx cypress run --reporter=tap --config video=false >&3 \
    --spec cypress/integration/tests/test_branching.spec.js
}

@test "terminusdb console clone local" {
  skip
  cd "${TERMINUSDB_BATS_CONSOLE_REPO}"
  export CYPRESS_BASE_URL="${TERMINUSDB_QUICKSTART_CONSOLE}/"
  npx cypress run --reporter=tap --config video=false >&3 \
    --spec cypress/integration/tests/test_clone_a_local_db.spec.js
}

@test "terminusdb console db life cycle" {
  skip
  cd "${TERMINUSDB_BATS_CONSOLE_REPO}"
  export CYPRESS_BASE_URL="${TERMINUSDB_QUICKSTART_CONSOLE}/"
  npx cypress run --reporter=tap --config video=false >&3 \
    --spec cypress/integration/tests/test_db_life_cycle.spec.js
}

@test "terminusdb acceptance episode 1" {
  skip
  cd "${TERMINUSDB_BATS_CONSOLE_REPO}"
  export CYPRESS_BASE_URL="${TERMINUSDB_QUICKSTART_CONSOLE}/"
  npx cypress run --reporter=tap --config video=false >&3 \
    --spec cypress/integration/tests/test_episode_1.spec.js
}

@test "quickstart stop" {
  run container stop >&3
  [[ "${status}" == "0" ]]
  run inspect
  [[ "${status}" != "0" ]]
}

@test "terminusdb server tests" {
  $TERMINUSDB_QUICKSTART_DOCKER run --rm -e TERMINUSDB_HTTPS_ENABLED=false "$TERMINUSDB_QUICKSTART_REPOSITORY:$TERMINUSDB_QUICKSTART_TAG" bash -c "./terminusdb store init --key root && swipl -g run_tests -g halt ./start.pl"
}

@test "quickstart rm" {
  run yes_container rm >&3
  [[ "${status}" == 0 ]]
  run inspect_volume
  [[ "${status}" != 0 ]]
}
