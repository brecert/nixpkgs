{ lib, mkDerivation, python3, fetchFromGitHub, makeWrapper, wrapQtAppsHook, makeDesktopItem }:

mkDerivation rec {
  pname = "leo-editor";
  version = "6.2.1";

  src = fetchFromGitHub {
    owner = "leo-editor";
    repo = "leo-editor";
    rev = version;
    sha256 = "1s9jvxwzsl32clp78g92nq9p2byf08libr5widl1jnkv1cpkbvh9";
  };

  dontBuild = true;

  nativeBuildInputs = [ wrapQtAppsHook makeWrapper python3 ];
  propagatedBuildInputs = with python3.pkgs; [ pyqt5 docutils ];

  desktopItem = makeDesktopItem {
    name = "leo-editor";
    exec = "leo %U";
    icon = "leoapp32";
    type = "Application";
    comment = meta.description;
    desktopName = "Leo";
    genericName = "Text Editor";
    categories = lib.concatStringsSep ";" [
      "Application" "Development" "IDE"
    ];
    startupNotify = "false";
    mimeType = lib.concatStringsSep ";" [
      "text/plain" "text/asp" "text/x-c" "text/x-script.elisp" "text/x-fortran"
      "text/html" "application/inf" "text/x-java-source" "application/x-javascript"
      "application/javascript" "text/ecmascript" "application/x-ksh" "text/x-script.ksh"
      "application/x-tex" "text/x-script.rexx" "text/x-pascal" "text/x-script.perl"
      "application/postscript" "text/x-script.scheme" "text/x-script.guile" "text/sgml"
      "text/x-sgml" "application/x-bsh" "application/x-sh" "application/x-shar"
      "text/x-script.sh" "application/x-tcl" "text/x-script.tcl" "application/x-texinfo"
      "application/xml" "text/xml" "text/x-asm"
    ];
  };

  installPhase = ''
    mkdir -p "$out/share/icons/hicolor/32x32/apps"
    cp leo/Icons/leoapp32.png "$out/share/icons/hicolor/32x32/apps"

    mkdir -p "$out/share/applications"
    cp $desktopItem/share/applications/* $out/share/applications

    mkdir -p $out/share/leo-editor
    mv * $out/share/leo-editor

    makeWrapper ${python3.interpreter} $out/bin/leo \
      --set PYTHONPATH "$PYTHONPATH:$out/share/leo-editor" \
      --add-flags "-O $out/share/leo-editor/launchLeo.py"

    wrapQtApp $out/bin/leo
  '';

  meta = with lib; {
    homepage = "http://leoeditor.com";
    description = "A powerful folding editor";
    longDescription = "Leo is a PIM, IDE and outliner that accelerates the work flow of programmers, authors and web designers.";
    license = licenses.mit;
    maintainers = with maintainers; [ leonardoce ];
    mainProgram = "leo";
  };
}
