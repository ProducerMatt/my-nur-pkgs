{ lib, pkgs, ... }:

pkgs.python3Packages.buildPythonPackage rec {
  pname = "pyannote-audio";
  version = "unstable-2023-04-25";
  format = "setuptools";

  src = pkgs.fetchFromGitHub {
    owner = "pyannote";
    repo = "pyannote-audio";
    rev = "11b56a137a578db9335efc00298f6ec1932e6317";
    hash = "sha256-nSE+oUwDMAPjO/9WMmRRkmsUn6O1lauPkHbo63jtYck=";
    fetchSubmodules = true;
  };

  propagatedBuildInputs = with pkgs.python3Packages; [
    #asteroid-filterbanks
    einops
    huggingface-hub
    #lightning
    omegaconf
    #pyannote-core
    #pyannote-database
    #pyannote-metrics
    pytorch-metric-learning
    rich
    semver
    soundfile
    #speechbrain
    tensorboardx
    torch
    #torch-audiomentations
    torchaudio
    torchmetrics
  ];

  pythonImportsCheck = [ "pyannote_audio" ];

  meta = with lib; {
    description = "Neural building blocks for speaker diarization: speech activity detection, speaker change detection, overlapped speech detection, speaker embedding";
    homepage = "https://github.com/pyannote/pyannote-audio/tree/11b56a137a578db9335efc00298f6ec1932e6317";
    changelog = "https://github.com/pyannote/pyannote-audio/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ProducerMatt ];
  };
}
