{ src, nxpmicro-mfgtools }:

nxpmicro-mfgtools.overrideAttrs (attrs: {
  inherit src;
  version = src.shortRev;
})
