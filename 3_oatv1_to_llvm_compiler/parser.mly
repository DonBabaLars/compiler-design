%{
open Ast

let loc (startpos:Lexing.position) (endpos:Lexing.position) (elt:'a) : 'a node =
  { elt ; loc=Range.mk_lex_range startpos endpos }

%}

/* Declare your tokens here. */
%token EOF
%token <int64>  INT
%token NULL
%token <string> STRING
%token <string> IDENT

%token TINT     /* int */
%token TVOID    /* void */
%token TSTRING  /* string */
%token IF       /* if */
%token ELSE     /* else */

%token FOR      /* for */

%token WHILE    /* while */
%token RETURN   /* return */
%token VAR      /* var */
%token SEMI     /* ; */
%token COMMA    /* , */
%token LBRACE   /* { */
%token RBRACE   /* } */
%token PLUS     /* + */
%token DASH     /* - */
%token STAR     /* * */
%token EQEQ     /* == */
%token EQ       /* = */
%token LPAREN   /* ( */
%token RPAREN   /* ) */
%token LBRACKET /* [ */
%token RBRACKET /* ] */

%token EMPTYBRACKETS /* [] */

%token TILDE    /* ~ */
%token BANG     /* ! */
%token GLOBAL   /* global */


/* new */
%token NEW      /* new */

%token SHL     /* << */
%token SHRL    /* >> */
%token SHRA    /* >>> */
%token LT      /* < */
%token LEQ     /* <= */
%token GT      /* > */
%token GEQ     /* >= */
%token NEQ     /* != */
%token LAND    /* & */
%token LOR     /* | */
%token BAND    /* [&] */
%token BOR     /* [|] */

/* booleans */
%token TBOOL   /* bool */
%token TTRUE   /* true */
%token TFALSE  /* false */



%left BOR
%left BAND
%left LOR
%left LAND
%left EQEQ NEQ
%left LT LEQ GT GEQ
%left SHL SHRL SHRA
%left PLUS DASH
%left STAR
%nonassoc BANG
%nonassoc TILDE
%nonassoc LBRACKET
%nonassoc LPAREN

/* ---------------------------------------------------------------------- */

%start prog
%start exp_top
%start stmt_top
%type <Ast.exp Ast.node> exp_top
%type <Ast.stmt Ast.node> stmt_top

%type <Ast.prog> prog
%type <Ast.exp Ast.node> exp
%type <Ast.stmt Ast.node> stmt
%type <Ast.block> block
%type <Ast.ty> ty
%%

exp_top:
  | e=exp EOF { e }

stmt_top:
  | s=stmt EOF { s }

prog:
  | p=list(decl) EOF  { p }

decl:
  | GLOBAL name=IDENT EQ init=gexp SEMI
    { Gvdecl (loc $startpos $endpos { name; init }) }
  | frtyp=ret_ty fname=IDENT LPAREN args=arglist RPAREN body=block
    { Gfdecl (loc $startpos $endpos { frtyp; fname; args; body }) }

arglist:
  | l=separated_list(COMMA, pair(ty,IDENT)) { l }

fdecl:
  | ret_ty f_name=exp LPAREN args=arglist RPAREN body=block
    { loc $startpos $endpos { ret_ty; f_name; args; body } }

    
ty:
  | TINT   { TInt }
  | TBOOL  { TBool }
  | r=rtyp { TRef r } 

%inline rtyp:
  | TSTRING { RString }
  | t=ty EMPTYBRACKETS { RArray t }
  
%inline ret_ty:
  | TVOID  { RetVoid }
  | t=ty   { RetVal t }


%inline bop:
  | PLUS     { Add }
  | DASH     { Sub }
  | STAR     { Mul }
  | EQEQ     { Eq }
  | SHL      { Shl }
  | SHRL     { Shr }
  | SHRA     { Sar }
  | LT       { Lt }
  | LEQ      { Lte }
  | GT       { Gt }
  | GEQ      { Gte }
  | NEQ      { Neq }
  | LAND     { And }
  | LOR      { Or }
  | BAND     { IAnd }
  | BOR      { IOr }

%inline uop:
  | DASH  { Neg }
  | BANG  { Lognot }
  | TILDE { Bitnot }

gexp:
  | i=INT               { loc $startpos $endpos @@ CInt i }
  | s=STRING            { loc $startpos $endpos @@ CStr s }
  (* | t=rtyp NULL  { loc $startpos $endpos @@ CNull t } *)
  | TTRUE                { loc $startpos $endpos @@ CBool true }
  | TFALSE               { loc $startpos $endpos @@ CBool false }
  | NEW t=ty EMPTYBRACKETS LBRACE es=separated_list(COMMA, gexp) RBRACE
                        { loc $startpos $endpos @@ CArr (t, es) }
  | t=ty EMPTYBRACKETS LBRACE es=separated_list(COMMA, gexp) RBRACE
                        { loc $startpos $endpos @@ CArr (t, es) }
  | t=ty EMPTYBRACKETS NULL
                        { loc $startpos $endpos @@ CArr (t, []) }

lhs:  
  | id=IDENT            { loc $startpos $endpos @@ Id id }
  | e=exp LBRACKET i=exp RBRACKET
                        { loc $startpos $endpos @@ Index (e, i) }

exp:
  | id=IDENT            { loc $startpos $endpos @@ Id id }
  | i=INT               { loc $startpos $endpos @@ CInt i } 
  | s=STRING            { loc $startpos $endpos @@ CStr s } (* new *)
  | t=rtyp NULL           { loc $startpos $endpos @@ CNull t }
  | TTRUE                { loc $startpos $endpos @@ CBool true } (* new *)
  | TFALSE               { loc $startpos $endpos @@ CBool false } (* new *)
  | e=exp LBRACKET i=exp RBRACKET
                        { loc $startpos $endpos @@ Index (e, i) }
  | e=exp LPAREN es=separated_list(COMMA, exp) RPAREN
                        { loc $startpos $endpos @@ Call (e,es) }

  | NEW t=ty EMPTYBRACKETS LBRACE es=separated_list(COMMA, exp) RBRACE
                        { loc $startpos $endpos @@ CArr (t, es) }


  | NEW TINT LBRACKET e=exp RBRACKET
                        { loc $startpos $endpos @@ NewArr (TInt, e) }
  | NEW TBOOL LBRACKET e=exp RBRACKET
                        { loc $startpos $endpos @@ NewArr (TBool, e) }

  | e1=exp b=bop e2=exp { loc $startpos $endpos @@ Bop (b, e1, e2) }
  | u=uop e=exp         { loc $startpos $endpos @@ Uop (u, e) }
  | LPAREN e=exp RPAREN { e }


vdecl:
  | VAR id=IDENT EQ init=exp { (id, init) }


stmt: 
  | p=lhs EQ e=exp SEMI { loc $startpos $endpos @@ Assn(p,e) }
  | d=vdecl SEMI        { loc $startpos $endpos @@ Decl(d) }
  | RETURN e=exp SEMI   { loc $startpos $endpos @@ Ret(Some e) }
  | RETURN SEMI         { loc $startpos $endpos @@ Ret(None) }
  | e=exp LPAREN es=separated_list(COMMA, exp) RPAREN SEMI
                        { loc $startpos $endpos @@ SCall (e, es) }
  | ifs=if_stmt         { ifs }
  | FOR LPAREN vdecls=separated_list(COMMA, vdecl) SEMI exp_opt=exp SEMI stmt_opt=stmt RPAREN b=block
                        { loc $startpos $endpos @@ For(vdecls, (Some exp_opt), (Some stmt_opt), b) }
  | FOR LPAREN vdecls=separated_list(COMMA, vdecl) SEMI SEMI stmt_opt=stmt RPAREN b=block
                        { loc $startpos $endpos @@ For(vdecls, (None), (Some stmt_opt), b) }
  | FOR LPAREN vdecls=separated_list(COMMA, vdecl) SEMI exp_opt=exp SEMI RPAREN b=block
                        { loc $startpos $endpos @@ For(vdecls, (Some exp_opt), (None), b) }
  | FOR LPAREN vdecls=separated_list(COMMA, vdecl) SEMI SEMI RPAREN b=block
                        { loc $startpos $endpos @@ For(vdecls, (None), (None), b) }
  | WHILE LPAREN e=exp RPAREN b=block  
                        { loc $startpos $endpos @@ While(e, b) } 

block:
  | LBRACE stmts=list(stmt) RBRACE { stmts }

if_stmt:
  | IF LPAREN e=exp RPAREN b1=block b2=else_stmt
    { loc $startpos $endpos @@ If(e,b1,b2) }

else_stmt:
  | (* empty *)       { [] }
  | ELSE b=block      { b }
  | ELSE ifs=if_stmt  { [ ifs ] }