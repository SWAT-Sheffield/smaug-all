function [tree] = sci_get_head(tree)
// Generated by M2SCI
// Conversion function for Matlab get_head
// Input: tree = Matlab funcall tree
// Ouput: tree = Scilab equivalent for tree

tree=Funcall("exec",1,Rhs_tlist(tree.name),tree.lhs)
endfunction