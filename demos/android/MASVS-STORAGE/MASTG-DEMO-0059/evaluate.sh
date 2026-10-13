#!/bin/bash

jq -r -s '
  flatten
  | .[]
  | def format_val:
      if type == "object" and .value then
        if (.value | type == "array") then
          [.value[] | format_val] | join(", ")
        elif (.value | type == "object") then
          .value | tostring
        else
          .value | tostring
        end
      elif type == "array" then
        if (length > 0 and (.[0] | type == "number")) then
          ([.[] | tostring] | join(","))
        else
          [.[] | format_val] | join(", ")
        end
      else
        tostring
      end;
  "Class: \(.javaClassName), Method: \(.method), Params: \([.argsIn[]?.value | format_val] | join(", "))"
' output.json > evaluation.txt