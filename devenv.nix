{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  # https://devenv.sh/basics/
  env.GREET = "devenv";

  # https://devenv.sh/packages/
  packages = with pkgs; [
    coreutils
    git
    just
    libyaml
    # openssl_1_1
    vips
    msgpack
    # bunler
  ];
  languages = {
    ruby = {
      enable = true;
      versionFile = ./.ruby-version;
      bundler.enable = false;
    };
  };

  # https://devenv.sh/processes/
  # processes.dev.exec = "${lib.getExe pkgs.watchexec} -n -- ls -la";

  # https://devenv.sh/services/
  services = {
    postgres = {
      enable = true;
      package = pkgs.postgresql_17;
      createDatabase = true;
      listen_addresses = "127.0.0.1";
      extensions = extensions: [
        extensions.postgis
        extensions.timescaledb
      ];
      initialDatabases = [
        {
          name = "auth_service_development";
        }
        {
          name = "auth_service_test";
        }
      ];
      initialScript = ''
        CREATE USER auth_service_development WITH PASSWORD 'auth_service_development';
        ALTER ROLE auth_service_development WITH LOGIN SUPERUSER INHERIT CREATEDB CREATEROLE REPLICATION;
        GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO auth_service_development;

        CREATE USER auth_service_test WITH PASSWORD 'auth_service_test';
        ALTER ROLE auth_service_development WITH LOGIN SUPERUSER INHERIT CREATEDB CREATEROLE REPLICATION;
        GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO auth_service_test;
      '';
    };
  };
  # https://devenv.sh/scripts/
  scripts.hello.exec = ''
    echo hello from $GREET
  '';

  # https://devenv.sh/basics/
  enterShell = ''
    hello         # Run scripts directly
    git --version # Use packages
  '';

  # https://devenv.sh/tasks/
  # tasks = {
  #   "myproj:setup".exec = "mytool build";
  #   "devenv:enterShell".after = [ "myproj:setup" ];
  # };

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    git --version | grep --color=auto "${pkgs.git.version}"
  '';

  # https://devenv.sh/git-hooks/
  # git-hooks.hooks.shellcheck.enable = true;

  # See full reference at https://devenv.sh/reference/options/
}
