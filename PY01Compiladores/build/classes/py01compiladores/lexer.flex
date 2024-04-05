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
entero = [0] | [1-9][0-9]*
float = [+-]?([0-9]*[.])?[0-9]+



/*=========================================================Lexemas propios=============================================================================*/
%state STRING

%%

/* keywords */
<YYINITIAL> "abstract"           { return symbol(sym.ABSTRACT); }
<YYINITIAL> "boolean"            { return symbol(sym.BOOLEAN); }
<YYINITIAL> "break"              { return symbol(sym.BREAK); }
<YYINITIAL> "*"                  { System.out.println("Mul"); return symbol(sym.TIMES); }

/*================================reglas de lexematizacion propias================================*/
<YYINITIAL> "\."                  { System.out.println("Dot"); return symbol(sym.DOT); }
<YYINITIAL> {entero}                  { System.out.println("entero"); return symbol(sym.ENTERO); }
<YYINITIAL> {float}                  { System.out.println("float"); return symbol(sym.FLOAT); }
<YYINITIAL> "true"                   { System.out.println("true"); return symbol(sym.TRUE); }
<YYINITIAL> "false"                   { System.out.println("false"); return symbol(sym.FALSE); }
<YYINITIAL> "if"                   { System.out.println("if"); return symbol(sym.IF); }
<YYINITIAL> "else"                   { System.out.println("else"); return symbol(sym.ELSE); }
<YYINITIAL> "("                   { System.out.println("PARENTA"); return symbol(sym.PARENTA); }
<YYINITIAL> ")"                   { System.out.println("PARENTC"); return symbol(sym.PARENTC); }
<YYINITIAL> "int"                   { System.out.println("int"); return symbol(sym.INT); }
<YYINITIAL> ";"                   { System.out.println(":"); return symbol(sym.ENDLINE); }





/*================================reglas de lexematizacion propias================================*/







<YYINITIAL> {
  /* identifiers */ 
  {Identifier}                   { return symbol(sym.IDENTIFIER); }

  /* literals */
  {DecIntegerLiteral}            { return symbol(sym.INTEGER_LITERAL); }
  \"                             { string.setLength(0); yybegin(STRING); }

  /* operators */
  "="                            { return symbol(sym.EQ); }
  "=="                           { return symbol(sym.EQEQ); }
  "+"                            { System.out.println("Suma"); return symbol(sym.PLUS);}

  /* comments */
  {Comment}                      { /* ignore */ }

  /* whitespace */
  {WhiteSpace}                   { /* ignore */ }
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
