{ lib
, pkgs
, ...
}:

pkgs.python3Packages.buildPythonPackage rec {
  pname = "whisper-x";
  version = "3.1.1";
  format = "setuptools";

  src = pkgs.fetchFromGitHub {
    owner = "m-bain";
    repo = "whisperX";
    rev = "v${version}";
    hash = "sha256-fwK3hYtFgvPoWAjSxm/nn1FsxOZ32FCanyfWinwoh8Q=";
  };

  nativeBuildInputs = with pkgs; [
    git
  ];
  propagatedBuildInputs = with pkgs.python3Packages; [
    pkgs.git
    faster-whisper
    ffmpeg-python
    nltk
    pandas
    setuptools
    torch
    torchaudio
    transformers
  ];

  pythonImportsCheck = [ "whisper_x" ];

  meta = with lib; {
    description = "WhisperX:  Automatic Speech Recognition with Word-level Timestamps (& Diarization";
    homepage = "https://github.com/m-bain/whisperX/tree/v3.1.1";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ ProducerMatt ];
  };
}
