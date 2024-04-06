/* JFlex example: partial Java language lexer specification */
package py01compiladores;
import java_cup.runtime.*;

/**
 * This class is a simple example lexer.
 */
%%

%class Lexer
%unicode
%cup
%line
%column

%{
  StringBuffer string = new StringBuffer();

  private Symbol symbol(int type) {
    return new Symbol(type, yyline, yycolumn);
  }
  private Symbol symbol(int type, Object value) {
    return new Symbol(type, yyline, yycolumn, value);
  }
%}

LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
WhiteSpace     = {LineTerminator} | [ \t\f]

/* comments */
Comment = {TraditionalComment} | {EndOfLineComment} | {DocumentationComment}

TraditionalComment   = "/*" [^*] ~"*/" | "/*" "*"+ "/"
// Comment can be the last line of the file, without line terminator.
EndOfLineComment     = "//" {InputCharacter}* {LineTerminator}?
DocumentationComment = "/**" {CommentContent} "*"+ "/"
CommentContent       = ( [^*] | \*+ [^/*] )*

Identifier = [:jletter:] [:jletterdigit:]*

DecIntegerLiteral = 0 | [1-9][0-9]*
/*================================Lexemas propios================================*/
flotante = ([0-9]*[.])?[0-9]+
charc = [a-zA-Z]

/*=========================================================Lexemas propios=============================================================================*/
%state STRING

%%

/* keywords */
<YYINITIAL> {WhiteSpace}         { /* ignore */ }
<YYINITIAL> "+"                  { return symbol(sym.PLUS); }
<YYINITIAL> "abstract"           { return symbol(sym.ABSTRACT); }
<YYINITIAL> "boolean"            { return symbol(sym.BOOLEAN); }
<YYINITIAL> "break"              { return symbol(sym.BREAK); }
<YYINITIAL> "*"                  { return symbol(sym.TIMES); }

/*================================reglas de lexematizacion propias================================*/
<YYINITIAL> "\."                 { return symbol(sym.DOT); }
<YYINITIAL> {DecIntegerLiteral}  { return symbol(sym.INTEGER_LITERAL); }
<YYINITIAL> {flotante}           { return symbol(sym.FLOTANTE); }
<YYINITIAL> "true"               { return symbol(sym.TRUE); }
<YYINITIAL> "false"              { return symbol(sym.FALSE); }
<YYINITIAL> "if"                 { return symbol(sym.IF); }
<YYINITIAL> "else"               { return symbol(sym.ELSE); }
<YYINITIAL> "("                  { return symbol(sym.PARENTA); }
<YYINITIAL> ")"                  { return symbol(sym.PARENTC); }
<YYINITIAL> "["                  { return symbol(sym.PARENTCA); }
<YYINITIAL> "]"                  { return symbol(sym.PARENTCC); }
<YYINITIAL> "int"                { return symbol(sym.INT); }
<YYINITIAL> ";"                  { return symbol(sym.ENDLINE); }
<YYINITIAL> "float"              { return symbol(sym.FLOAT); }
<YYINITIAL> "char"               { return symbol(sym.CHAR); }
<YYINITIAL> "string"             { return symbol(sym.STRING); }
<YYINITIAL> "array"              { return symbol(sym.ARRAY); }
<YYINITIAL> "while"              { return symbol(sym.WHILE); }
<YYINITIAL> "swich"              { return symbol(sym.SWICH); }
<YYINITIAL> "case"               { return symbol(sym.CASE); }
<YYINITIAL> "for"                { return symbol(sym.FOR); }
<YYINITIAL> "in"                 { return symbol(sym.IN); }
<YYINITIAL> "range"              { return symbol(sym.RANGE); }
<YYINITIAL> ">"                  { return symbol(sym.GREATERT); }
<YYINITIAL> "<"                  { return symbol(sym.LOWERT); }
<YYINITIAL> ">="                 { return symbol(sym.GREATERE); }
<YYINITIAL> "<="                 { return symbol(sym.LOWERE); }
<YYINITIAL> "!"                  { return symbol(sym.NOT); }
<YYINITIAL> "!="                 { return symbol(sym.NOTEQUALS); }
<YYINITIAL> "&"                  { return symbol(sym.CONJUNTION); }
<YYINITIAL> "|"                  { return symbol(sym.DISJUNTION); }
<YYINITIAL> ":"                  { return symbol(sym.SEP); }
<YYINITIAL> charc                { return symbol(sym.CHARC); }
<YYINITIAL> "glob"               { return symbol(sym.GLOB); }
<YYINITIAL> "loc"                { return symbol(sym.LOC); }
<YYINITIAL> "return"             { return symbol(sym.RETURN); }
<YYINITIAL> "printf"             { return symbol(sym.PRINTF); }
<YYINITIAL> "func"               { return symbol(sym.FUNC); }
<YYINITIAL> "main"               { return symbol(sym.MAIN); }
<YYINITIAL> "param"              { return symbol(sym.PARAM); }
<YYINITIAL> "read"               { return symbol(sym.READ); }
<YYINITIAL> "default"            { return symbol(sym.DEFAULT); }
<YYINITIAL> "_"                  { return symbol(sym.UNDERS); }

/*================================reglas de lexematizacion propias================================*/

<YYINITIAL> {
  /* identifiers */
  {Identifier}                   { return symbol(sym.IDENTIFIER); }

  /* literals */
  
  \"                             { string.setLength(0); yybegin(STRING); }

  /* operators */
  "="                            { return symbol(sym.EQ); }
  "=="                           { return symbol(sym.EQEQ); }
  
  "++"                           { return symbol(sym.PLUSP); }
  "-"                            { return symbol(sym.MINUS); }
  "--"                           { return symbol(sym.MINUSM); }
  "/"                            { return symbol(sym.DIV); }
  "^"                            { return symbol(sym.POT); }
  "%"                            { return symbol(sym.MOD); }
  

  /* comments */
  {Comment}                      { /* ignore */ }

  /* whitespace */
  
}

<STRING> {
  \"                             { yybegin(YYINITIAL); 
                                   return symbol(sym.STRING_LITERAL, 
                                   string.toString()); }
  [^\n\r\"\\]+                   { string.append( yytext() ); }
  \\t                            { string.append('\t'); }
  \\n                            { string.append('\n'); }

  \\r                            { string.append('\r'); }
  \\\"                           { string.append('\"'); }
  \\                             { string.append('\\'); }
}
