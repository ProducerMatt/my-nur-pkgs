{ lib, buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "dalai";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "cocktailpeanut";
    repo = pname;
    rev = version;
    hash = "0000000000000000000000000000000000000000000000000000";
  };

  npmDepsHash = "0000000000000000000000000000000000000000000000000000";

  # The prepack script runs the build script, which we'd rather do in the build phase.
  #npmPackFlags = [ "--ignore-scripts" ];

  #NODE_OPTIONS = "--openssl-legacy-provider";

  meta = with lib; {
    description = "A dead simple way to run the LLaMA Large Language Model on your computer.";
    homepage = "https://cocktailpeanut.github.io/dalai/";
    license = licenses.mit; # NOTE: see NPM for license
    maintainers = with maintainers; [ ProducerMatt ];
  };
}
