function [tree] = sci_trim(tree)
// Copyright INRIA (Generated by M2SCI)
// Conversion function for Matlab trim()
// Input: tree = Matlab funcall tree
// Ouput: tree = Scilab equivalent for tree
tree.lhs(1).dims=list(-1,-1)
tree.lhs(1).type=Type(Unknown,Unknown)
endfunction