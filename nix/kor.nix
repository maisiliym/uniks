let
  inherit (builtins)
    catAttrs attrNames hasAttr getAttr mapAttrs listToAttrs concatStringsSep
    foldl' elem length elemAt head tail filter concatMap sort lessThan fromJSON
    toJSON readFile toFile intersectAttrs functionArgs typeOf isAttrs deepSeq
    trace getFlake isList isFunction;

in
rec {

  nameValuePair = name: value: { inherit name value; };

  getAttrs = names: attrs: genAttrs names (name: attrs.${name});

  genAttrs = names: f:
    listToAttrs (map (n: nameValuePair n (f n)) names);

  zipAttrsWithNames = names: f: sets:
    listToAttrs (map
      (name: {
        inherit name;
        value = f name (catAttrs name sets);
      })
      names);

  zipAttrsWith = f: sets: zipAttrsWithNames (concatMap attrNames sets) f sets;

  zipAttrs = zipAttrsWith (name: values: values);

  optional = cond: elem: if cond then [ elem ] else [ ];
  optionals = cond: elems: if cond then elems else [ ];

  foldl = foldl';

  optionalString = cond: string: if cond then string else "";

  concatMapStringsSep = sep: f: list:
    concatStringsSep sep (map f list);

  optionalAttrs = cond: set: if cond then set else { };

  hasAttrByPath = attrPath: e:
    let attr = head attrPath;
    in
    if attrPath == [ ] then true
    else if e ? ${attr}
    then hasAttrByPath (tail attrPath) e.${attr}
    else false;

  attrByPath = attrPath: default: e:
    let attr = head attrPath;
    in
    if attrPath == [ ] then e
    else if e ? ${attr}
    then attrByPath (tail attrPath) default e.${attr}
    else default;

  mapAttrs' = f: set:
    listToAttrs (map (attr: f attr set.${attr}) (attrNames set));

  invertValueName = set: mapAttrs' (n: v: nameValuePair "${v}" n) set;

  filterAttrs = pred: set: listToAttrs (concatMap
    (name:
      let v = set.${name};
      in if pred name v then [ (nameValuePair name v) ] else [ ])
    (attrNames set));

  remove = e: filter (x: x != e);

  intersectLists = e: filter (x: elem x e);

  subtractLists = e: filter (x: !(elem x e));

  unique = list:
    if list == [ ] then [ ] else
    let x = head list;
    in [ x ] ++ unique (remove x list);

  flatten = x:
    if isList x
    then concatMap (y: flatten y) x
    else [ x ];

  flattenNV = list: map (x: x.value) list;

  mapAttrsToList = f: attrs:
    map (name: f name attrs.${name}) (attrNames attrs);

  attrsToList = attrs: map (a: attrs.${a}) (attrNames attrs);

  attrToNamedList = attrs:
    mapAttrsToList (name: value: value // { inherit name; }) attrs;

  makeSearchPath = subDir: paths: concatStringsSep ":"
    (map (path: path + "/" + subDir) (filter (x: x != null) paths));

  getSpici = datom:
    assert mesydj (isAttrs datom)
      "Spici-Datom is not Attrs";
    let neimz = attrNames datom; in
    assert mesydj ((length neimz) == 1)
      "Spici-Datom has more than one Attr";
    let
      name = head neimz;
    in
    { inherit name; value = datom.${name}; };

  matc = matcSet: datom:
    let
      spici = getSpici datom;
      inherit (spici) name value;
      matcValiu = matcSet.${name};
    in
    if isFunction matcValiu then
      matcValiu value
    else value;

  indeksSpiciz = spiciz:
    let
      aylSpiciz = map getSpici spiciz;
      neimz = unique (map (s: s.name) aylSpiciz);
      meikNeimdYrei = neim:
        map (s: s.value) (filter (s: s.name == neim) aylSpiciz);
    in
    genAttrs neimz meikNeimdYrei;

  matchEnum = enum: match:
    genAttrs enum (name: name == match);

  louestOf = yrei: head (sort lessThan yrei);

  haiystOf = yrei: tail (sort lessThan yrei);

  importJSON = path: fromJSON (readFile path);

  eksportJSON = neim: datom: toFile neim (toJSON datom);

  getFleik = fleik:
    let
      url = concatStringsSep "" [
        (optionalString (fleik.type == "git") "git+")
        fleik.url
        "?"
        (optionalString (fleik ? ref) "ref=${fleik.ref}")
        (optionalString (fleik ? rev) "${optionalString (fleik ? ref) "&"}rev=${fleik.rev}")
      ];
      noFlakeNix = fleik ? flake && (!fleik.flake);
      kol = if noFlakeNix then fetchTree else getFlake;
    in
    kol url;

  kopiNiks = path: toFile (baseNameOf path)
    (readFile path);

  mkIf = condition: content:
    {
      _type = "if";
      inherit condition content;
    };

  mesydj = pred: msj:
    if pred then true
    else trace msj false;

  traceSeq = x: y:
    trace (builtins.deepSeq x x) y;

  mkStoreHashPrefix = object: builtins.substring 11 7 object.narHash;

  mkShortHash = object: builtins.substring 7 7 object.narHash;

  mkImplicitVersion = src:
    assert mesydj
      ((hasAttr "shortRev" src) || (hasAttr "narHash" src));
    let
      shortHash = mkShortHash src;
    in
      src.shortRev or shortHash;

  hazSingylAttr = attrs: (length (attrNames attrs)) == 1;

  cortHacPath = path: builtins.hashFile "sha256" path;

  cortHacString = string:
    builtins.substring 0 7
      (builtins.hashString "sha256" string);

  cortHacIuniks = iuniks:
    builtins.substring 0 7
      (builtins.hashFile "sha256" iuniks);

  arkSistymMap = {
    x86-64 = "x86_64-linux";
    amd64 = "x86_64-linux";
    i686 = "i686-linux";
    x86 = "i686-linux";
    aarch64 = "aarch64-linux";
    arm64 = "aarch64-linux";
    armv8 = "aarch64-linux";
    armv7l = "armv7l-linux";
    armv = "armv7l-linux";
    avr = "avr-none";
  };

  mkSaizAtList = saiz: {
    min = if (saiz == 0) then false else true;
    med = if (saiz == 2 || saiz == 3) then true else false;
    max = if (saiz == 3) then true else false;
  };

  matcSaiz = saiz: ifNon: ifMin: ifMed: ifMax:
    let saizAtList = mkSaizAtList saiz;
    in
    if saizAtList.max then ifMax
    else if saizAtList.med then ifMed
    else if saizAtList.min then ifMin
    else ifNon;

  mkLamdy = { klozyr, lamdy }:
    let
      rykuestydDatomz = functionArgs lamdy;
      rytyrndDatomz = intersectAttrs rykuestydDatomz klozyr;
    in
    lamdy rytyrndDatomz;

  mkLamdyz = { lamdyz, klozyr }:
    mapAttrs
      (n: v:
        mkLamdy { inherit klozyr; lamdy = v; }
      )
      lamdyz;

  # TODO(desc: "remove", tags: [ "mkHyraizyn" ])
  spiciDatum = { datum, spek }:
    let
      inherit (datum) spici;
      allSpeksNeimz = concatMap (n: getAttr n spek) (attrNames spek);
      wantedAttrsNeimz = spek.${spici};
      izyntWanted = n: !(elem n wantedAttrsNeimz);
      unwantedAttrs = filter izyntWanted allSpeksNeimz;
    in
    removeAttrs datum unwantedAttrs;

}
