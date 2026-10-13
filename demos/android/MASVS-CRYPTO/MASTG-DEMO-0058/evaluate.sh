#!/bin/bash

jq -r -s '
  flatten
  | .[]
  | select(
      .method=="setBlockModes"
      and any(.argsIn[]?.value[]?; . == "ECB")
    )
  | "Class: \(.javaClassName), Method: \(.method), Block modes: \([.argsIn[]?.value[]?] | join(", "))"
' output.json > evaluation.txt