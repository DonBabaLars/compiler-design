
(* The type of tokens. *)

type token = 
  | WHILE
  | VAR
  | TVOID
  | TTRUE
  | TSTRING
  | TINT
  | TILDE
  | TFALSE
  | TBOOL
  | STRING of (string)
  | STAR
  | SHRL
  | SHRA
  | SHL
  | SEMI
  | RPAREN
  | RETURN
  | RBRACKET
  | RBRACE
  | PLUS
  | NULL
  | NEW
  | NEQ
  | LT
  | LPAREN
  | LOR
  | LEQ
  | LBRACKET
  | LBRACE
  | LAND
  | INT of (int64)
  | IF
  | IDENT of (string)
  | GT
  | GLOBAL
  | GEQ
  | FOR
  | EQEQ
  | EQ
  | EOF
  | EMPTYBRACKETS
  | ELSE
  | DASH
  | COMMA
  | BOR
  | BANG
  | BAND

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val stmt_top: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Ast.stmt Ast.node)

val prog: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Ast.prog)

val exp_top: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Ast.exp Ast.node)
