{ lib }:

with lib;
{
  selectorFunction = mkOptionType {
    name = "selectorFunction";
    description =
      "Function that takes an attribute set and returns a list "
      + "containing a selection of the values of the input set";
    check = isFunction;
    merge = _loc: defs:
      as: concatMap (select: select as) (getValues defs);
  };
}
