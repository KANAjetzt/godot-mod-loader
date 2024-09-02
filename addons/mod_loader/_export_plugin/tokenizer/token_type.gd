# https://github.com/godotengine/godot/blob/568589c9d8c763bfb3a4348174d53b42d7c59f21/modules/gdscript/gdscript_tokenizer.h#L56
enum Type {
	EMPTY,
	# Basic
	ANNOTATION,
	IDENTIFIER,
	LITERAL,
	# Comparison
	LESS,
	LESS_EQUAL,
	GREATER,
	GREATER_EQUAL,
	EQUAL_EQUAL,
	BANG_EQUAL,
	# Logical
	AND,
	OR,
	NOT,
	AMPERSAND_AMPERSAND,
	PIPE_PIPE,
	BANG,
	# Bitwise
	AMPERSAND,
	PIPE,
	TILDE,
	CARET,
	LESS_LESS,
	GREATER_GREATER,
	# Math
	PLUS,
	MINUS,
	STAR,
	STAR_STAR,
	SLASH,
	PERCENT,
	# Assignment
	EQUAL,
	PLUS_EQUAL,
	MINUS_EQUAL,
	STAR_EQUAL,
	STAR_STAR_EQUAL,
	SLASH_EQUAL,
	PERCENT_EQUAL,
	LESS_LESS_EQUAL,
	GREATER_GREATER_EQUAL,
	AMPERSAND_EQUAL,
	PIPE_EQUAL,
	CARET_EQUAL,
	# Control flow
	IF,
	ELIF,
	ELSE,
	FOR,
	WHILE,
	BREAK,
	CONTINUE,
	PASS,
	RETURN,
	MATCH,
	WHEN,
	# Keywords
	AS,
	ASSERT,
	AWAIT,
	BREAKPOINT,
	CLASS,
	CLASS_NAME,
	CONST,
	ENUM,
	EXTENDS,
	FUNC,
	IN,
	IS,
	NAMESPACE,
	PRELOAD,
	SELF,
	SIGNAL,
	STATIC,
	SUPER,
	TRAIT,
	VAR,
	VOID,
	YIELD,
	# Punctuation
	BRACKET_OPEN,
	BRACKET_CLOSE,
	BRACE_OPEN,
	BRACE_CLOSE,
	PARENTHESIS_OPEN,
	PARENTHESIS_CLOSE,
	COMMA,
	SEMICOLON,
	PERIOD,
	PERIOD_PERIOD,
	COLON,
	DOLLAR,
	FORWARD_ARROW,
	UNDERSCORE,
	# Whitespace
	NEWLINE,
	INDENT,
	DEDENT,
	# Constants
	CONST_PI,
	CONST_TAU,
	CONST_INF,
	CONST_NAN,
	# Error message improvement
	VCS_CONFLICT_MARKER,
	BACKTICK,
	QUESTION_MARK,
	# Special
	ERROR,
	TK_EOF, # "EOF" is reserved
	# use `TYPE.size()`
	# TK_MAX
};

# https://github.com/godotengine/godot/blob/568589c9d8c763bfb3a4348174d53b42d7c59f21/modules/gdscript/gdscript_tokenizer.cpp#L44
const TOKEN_NAMES: Array[String] = [
	"Empty", # EMPTY,
	# Basic
	"Annotation", # ANNOTATION
	"Identifier", # IDENTIFIER,
	"Literal", # LITERAL,
	# Comparison
	"<", # LESS,
	"<=", # LESS_EQUAL,
	">", # GREATER,
	">=", # GREATER_EQUAL,
	"==", # EQUAL_EQUAL,
	"!=", # BANG_EQUAL,
	# Logical
	"and", # AND,
	"or", # OR,
	"not", # NOT,
	"&&", # AMPERSAND_AMPERSAND,
	"||", # PIPE_PIPE,
	"!", # BANG,
	# Bitwise
	"&", # AMPERSAND,
	"|", # PIPE,
	"~", # TILDE,
	"^", # CARET,
	"<<", # LESS_LESS,
	">>", # GREATER_GREATER,
	# Math
	"+", # PLUS,
	"-", # MINUS,
	"*", # STAR,
	"**", # STAR_STAR,
	"/", # SLASH,
	"%", # PERCENT,
	# Assignment
	"=", # EQUAL,
	"+=", # PLUS_EQUAL,
	"-=", # MINUS_EQUAL,
	"*=", # STAR_EQUAL,
	"**=", # STAR_STAR_EQUAL,
	"/=", # SLASH_EQUAL,
	"%=", # PERCENT_EQUAL,
	"<<=", # LESS_LESS_EQUAL,
	">>=", # GREATER_GREATER_EQUAL,
	"&=", # AMPERSAND_EQUAL,
	"|=", # PIPE_EQUAL,
	"^=", # CARET_EQUAL,
	# Control flow
	"if", # IF,
	"elif", # ELIF,
	"else", # ELSE,
	"for", # FOR,
	"while", # WHILE,
	"break", # BREAK,
	"continue", # CONTINUE,
	"pass", # PASS,
	"return", # RETURN,
	"match", # MATCH,
	"when", # WHEN,
	# Keywords
	"as", # AS,
	"assert", # ASSERT,
	"await", # AWAIT,
	"breakpoint", # BREAKPOINT,
	"class", # CLASS,
	"class_name", # CLASS_NAME,
	"const", # CONST,
	"enum", # ENUM,
	"extends", # EXTENDS,
	"func", # FUNC,
	"in", # IN,
	"is", # IS,
	"namespace", # NAMESPACE
	"preload", # PRELOAD,
	"self", # SELF,
	"signal", # SIGNAL,
	"static", # STATIC,
	"super", # SUPER,
	"trait", # TRAIT,
	"var", # VAR,
	"void", # VOID,
	"yield", # YIELD,
	# Punctuation
	"[", # BRACKET_OPEN,
	"]", # BRACKET_CLOSE,
	"{", # BRACE_OPEN,
	"}", # BRACE_CLOSE,
	"(", # PARENTHESIS_OPEN,
	")", # PARENTHESIS_CLOSE,
	",", # COMMA,
	";", # SEMICOLON,
	".", # PERIOD,
	"..", # PERIOD_PERIOD,
	":", # COLON,
	"$", # DOLLAR,
	"->", # FORWARD_ARROW,
	"_", # UNDERSCORE,
	# Whitespace
	"Newline", # NEWLINE,
	"Indent", # INDENT,
	"Dedent", # DEDENT,
	# Constants
	"PI", # CONST_PI,
	"TAU", # CONST_TAU,
	"INF", # CONST_INF,
	"NaN", # CONST_NAN,
	# Error message improvement
	"VCS conflict marker", # VCS_CONFLICT_MARKER,
	"`", # BACKTICK,
	"?", # QUESTION_MARK,
	# Special
	"Error", # ERROR,
	"End of file", # EOF,
];
