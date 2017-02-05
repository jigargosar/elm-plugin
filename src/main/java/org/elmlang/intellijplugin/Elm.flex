package org.elmlang.intellijplugin;

import com.intellij.lexer.FlexLexer;
import com.intellij.psi.tree.IElementType;
import com.intellij.psi.TokenType;
import static org.elmlang.intellijplugin.psi.ElmTypes.*;

%%

%class ElmLexer
%implements FlexLexer
%unicode
%function advance
%type IElementType
%eof{  return;
%eof}

%{
    private int commentLevel = 0;
%}

%state IN_COMMENT

CRLF= (\n|\r|\r\n)
WHITE_SPACE=[\ \t\f]
LINE_COMMENT=("--")[^\r\n]*
IDENTIFIER_CHAR=[[:letter:][:digit:]_]
HEX_CHAR=[[:digit:]A-Fa-f]
LOWER_CASE_IDENTIFIER=[:lowercase:]{IDENTIFIER_CHAR}*
UPPER_CASE_IDENTIFIER=[:uppercase:]{IDENTIFIER_CHAR}*
STRING_LITERAL=\"(\\.|[^\\\"])*\"
STRING_WITH_QUOTES_LITERAL=\"\"\"(\\.|[^\\\"]|\"{1,2}([^\"\\]|\\\"))*\"\"\"
NUMBER_LITERAL=("-")?[:digit:]+(\.[:digit:]+)?
HEXADECIMAL_LITERAL=0x{HEX_CHAR}+
CHAR_LITERAL='(\\.|\\x{HEX_CHAR}+|[^\\'])'
OPERATOR=("!"|"$"|"^"|"|"|"*"|"/"|"?"|"+"|"~"|-|=|@|#|%|&|<|>|:|€|¥|¢|£|¤|\.)+
RESERVED=("hiding" | "export" | "foreign" | "deriving")

%%

<IN_COMMENT> {
    "{-" {
        commentLevel++;
        return COMMENT_CONTENT;
    }
    "-}" {
        commentLevel--;
        if (commentLevel == 0) {
            yybegin(YYINITIAL);
            return END_COMMENT;
        }
        return COMMENT_CONTENT;
    }
    [^-{}]+ {
        return COMMENT_CONTENT;
    }
    [^] {
        return COMMENT_CONTENT;
    }
}


<YYINITIAL> {
    "module" {
        return MODULE;
    }
    "where" {
        return WHERE;
    }
    "effect" {
        return EFFECT;
    }
    "import" {
        return IMPORT;
    }
    "as" {
        return AS;
    }
    "exposing" {
        return EXPOSING;
    }
    "if" {
        return IF;
    }
    "then" {
        return THEN;
    }
    "else" {
        return ELSE;
    }
    "case" {
        return CASE;
    }
    "of" {
        return OF;
    }
    "let" {
        return LET;
    }
    "in" {
        return IN;
    }
    "type" {
        return TYPE;
    }
    "alias" {
        return ALIAS;
    }
    "port" {
        return PORT;
    }
    "infixl" {
        return INFIXL;
    }
    "infix" {
        return INFIX;
    }
    "infixr" {
        return INFIXR;
    }
    {RESERVED} {
        return RESERVED;
    }
    "(" {
        return LEFT_PARENTHESIS;
    }
    ")" {
        return RIGHT_PARENTHESIS;
    }
    "[" {
        return LEFT_SQUARE_BRACKET;
    }
    "]" {
        return RIGHT_SQUARE_BRACKET;
    }
    "{" {
        return LEFT_BRACE;
    }
    "}" {
        return RIGHT_BRACE;
    }
    ".." {
        return DOUBLE_DOT;
    }
    "," {
        return COMMA;
    }
    "=" {
        return EQ;
    }
    "->" {
        return ARROW;
    }
    "::" {
        return LIST_CONSTRUCTOR;
    }
    ":" {
        return COLON;
    }
    "|" {
        return PIPE;
    }
    "\\" {
        return BACKSLASH;
    }
    "_" {
        return UNDERSCORE;
    }
    "." {
        return DOT;
    }
    "-" {
        return MINUS;
    }
    {CRLF}*"{-" {
        commentLevel = 1;
        yybegin(IN_COMMENT);
        return START_COMMENT;
    }
    {LOWER_CASE_IDENTIFIER} {
        return LOWER_CASE_IDENTIFIER;
    }
    {UPPER_CASE_IDENTIFIER} {
        return UPPER_CASE_IDENTIFIER;
    }
    {STRING_WITH_QUOTES_LITERAL} {
        return STRING_LITERAL;
    }
    {STRING_LITERAL} {
        return STRING_LITERAL;
    }
    {CHAR_LITERAL} {
        return CHAR_LITERAL;
    }
    {NUMBER_LITERAL} {
        return NUMBER_LITERAL;
    }
    {HEXADECIMAL_LITERAL} {
        return NUMBER_LITERAL;
    }
    ({CRLF}+{WHITE_SPACE}+)+ {
        return TokenType.WHITE_SPACE;
    }
    {CRLF}*{LINE_COMMENT} {
        return LINE_COMMENT;
    }
    {OPERATOR} {
        return OPERATOR;
    }
    {WHITE_SPACE}+ {
        return TokenType.WHITE_SPACE;
    }
    {CRLF}+ {
        return FRESH_LINE;
    }
}

. {
    return TokenType.BAD_CHARACTER;
}
