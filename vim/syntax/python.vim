" " Python autocompletion:
" syn match pythonError "^\\s*def\\s\\+\\w\\+(.*)\\s*$" display
" syn match pythonError "^\\s*class\\s\\+\\w\\+(.*)\\s*$" display
" syn match pythonError "^\\s*for\\s.*[^:]$" display
" syn match pythonError "^\\s*except\\s*$" display
" syn match pythonError "^\\s*finally\\s*$" display
" syn match pythonError "^\\s*try\\s*$" display
" syn match pythonError "^\\s*else\\s*$" display
" syn match pythonError "^\\s*else\\s*[^:].*" display
" syn match pythonError "^\\s*if\\s.*[^\\:]$" display
" syn match pythonError "^\\s*except\\s.*[^\\:]$" display
" syn match pythonError "[;]$" display
" syn keyword pythonError        do

" From https://github.com/Coacher/python-syntax/blob/master/syntax/python.vim
" Python syntax file for Vim
" Author: Ilya Tumaykin <itumaykin (plus) github (at) gmail (dot) com>
" License: Vim license
" Originated from the Python syntax file shipped with Vim


" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if v:version < 600
	syntax clear
elseif exists('b:current_syntax')
	finish
endif


let s:save_cpo = &cpoptions
set cpoptions&vim

" Some Python 2 features are not available in Python 3 and vice versa
" This variable controls whether highlighting should be done in Python 2 style
let g:python_syntax_prefer_python2 =
	\ get(g:, 'python_syntax_prefer_python2', 0)


" Comments
" https://docs.python.org/2/reference/lexical_analysis.html#comments
" https://docs.python.org/3/reference/lexical_analysis.html#comments
syn region pythonComment oneline keepend start='#' end='\n'
	\ contains=pythonTodo,@Spell
syn keyword pythonTodo contained	BUG FIXME NOTE TODO XXX


" Explicit line joining
" https://docs.python.org/2/reference/lexical_analysis.html#explicit-line-joining
" https://docs.python.org/3/reference/lexical_analysis.html#explicit-line-joining
syn match pythonLineJoin display	'\\$'


" Keywords
" https://docs.python.org/2/reference/lexical_analysis.html#keywords
" https://docs.python.org/3/reference/lexical_analysis.html#keywords
syn keyword pythonKeyword	as assert break continue del global
syn keyword pythonKeyword	lambda pass return with yield

syn keyword pythonKeyword nextgroup=pythonFunctionName skipwhite	def
syn keyword pythonKeyword nextgroup=pythonClassName skipwhite		class

syn keyword pythonConditional		elif else if
syn keyword pythonExceptionHandler	except finally raise try
syn keyword pythonInclude			from import
syn keyword pythonOperator			and in is not or
syn keyword pythonRepeat			for while

if g:python_syntax_prefer_python2
	syn keyword pythonKeyword	exec print
else
	syn keyword pythonKeyword	False None True nonlocal
	" 'async' and 'await' are available since Python 3.5
	" https://docs.python.org/3/reference/compound_stmts.html#coroutines
	" https://docs.python.org/3.6/whatsnew/3.6.html#new-keywords
	syn keyword pythonKeyword	async await
endif


" Operators
" https://docs.python.org/2/reference/lexical_analysis.html#operators
" https://docs.python.org/3/reference/lexical_analysis.html#operators
syn match pythonOperator display	'[*+\-%/<>|&~^]'
syn match pythonOperator display	'\*\*\|//\|<<\|>>'
syn match pythonOperator display	'[=!><]='

" '=' surrounded by spaces is treated as the assignment operator
" https://www.python.org/dev/peps/pep-0008/#other-recommendations
syn match pythonOperator display	'\s\zs=\ze\s'

if g:python_syntax_prefer_python2
	syn match pythonOperator display	'<>'
else
	syn match pythonOperator display	'@'
endif


" Delimiters
" https://docs.python.org/2/reference/lexical_analysis.html#delimiters
" https://docs.python.org/3/reference/lexical_analysis.html#delimiters
syn match pythonDelimiter display	'[().,:[\]{};]'

if g:python_syntax_prefer_python2
	syn match pythonDelimiter display	'[@`]'
else
	syn match pythonDelimiter display	'->'
endif


" Augmented assignments
" https://docs.python.org/2/reference/lexical_analysis.html#delimiters
" https://docs.python.org/3/reference/lexical_analysis.html#delimiters
"
" https://docs.python.org/2/reference/simple_stmts.html#augmented-assignment-statements
" https://docs.python.org/3/reference/simple_stmts.html#augmented-assignment-statements
syn match pythonAugmentedAssignment display	'[+\-*/|&^%]='
syn match pythonAugmentedAssignment display	'\%(//\|\*\*\|<<\|>>\)='

if !g:python_syntax_prefer_python2
	syn match pythonAugmentedAssignment display	'@='
endif


" String literals
" https://docs.python.org/2/reference/lexical_analysis.html#string-literals
" https://docs.python.org/3/reference/lexical_analysis.html#string-and-bytes-literals
syn match pythonEscape contained	'\\$'

syn match pythonEscape contained display	+\\[\\'"abfnrtv]+
syn match pythonEscape contained display	'\\\o\{1,3}'
syn match pythonEscape contained display	'\\x\x\{2}'

syn match pythonUnicodeEscape contained display	'\\u\x\{4}'
syn match pythonUnicodeEscape contained display	'\\U\x\{8}'

syn match pythonUnicodeName contained display	'\\N{\u\+\%( \u\+\)*}'

if g:python_syntax_prefer_python2
	syn region pythonShortString matchgroup=pythonQuotes
		\ start=+[bB]\=\z(['"]\)+ skip='\\[\\\_$\z1]' end='\z1'
		\ contains=pythonEscape,@Spell
	syn region pythonLongString matchgroup=pythonTripleQuotes keepend
		\ start=+[bB]\=\z('''\|"""\)+ end='\z1'
		\ contains=pythonEscape,@Spell

	syn region pythonShortString matchgroup=pythonQuotes
		\ start=+[uU]\z(['"]\)+ skip='\\[\\\_$\z1]' end='\z1'
		\ contains=pythonEscape,pythonUnicodeEscape,pythonUnicodeName,@Spell
	syn region pythonLongString matchgroup=pythonTripleQuotes keepend
		\ start=+[uU]\z('''\|"""\)+ end='\z1'
		\ contains=pythonEscape,pythonUnicodeEscape,pythonUnicodeName,@Spell

	syn region pythonRawShortString matchgroup=pythonQuotes
		\ start=+[uU][rR]\z(['"]\)+ skip='\\[\\\_$\z1]' end='\z1'
		\ contains=pythonUnicodeEscape,@Spell
	syn region pythonRawLongString matchgroup=pythonTripleQuotes keepend
		\ start=+[uU][rR]\z('''\|"""\)+ end='\z1'
		\ contains=pythonUnicodeEscape,@Spell
else
	syn region pythonShortString matchgroup=pythonQuotes
		\ start=+[uUbB]\=\z(['"]\)+ skip='\\[\\\_$\z1]' end='\z1'
		\ contains=pythonEscape,pythonUnicodeEscape,pythonUnicodeName,@Spell
	syn region pythonLongString matchgroup=pythonTripleQuotes keepend
		\ start=+[uUbB]\=\z('''\|"""\)+ end='\z1'
		\ contains=pythonEscape,pythonUnicodeEscape,pythonUnicodeName,@Spell

	syn region pythonRawShortString matchgroup=pythonQuotes
		\ start=+[rR][bB]\z(['"]\)+ skip='\\[\\\_$\z1]' end='\z1'
		\ contains=@Spell
	syn region pythonRawLongString matchgroup=pythonTripleQuotes keepend
		\ start=+[rR][bB]\z('''\|"""\)+ end='\z1'
		\ contains=@Spell
endif

syn region pythonRawShortString matchgroup=pythonQuotes
	\ start=+[bB]\=[rR]\z(['"]\)+ skip='\\[\\\_$\z1]' end='\z1'
	\ contains=@Spell
syn region pythonRawLongString matchgroup=pythonTripleQuotes keepend
	\ start=+[bB]\=[rR]\z('''\|"""\)+ end='\z1'
	\ contains=@Spell


" Numeric literals
" https://docs.python.org/2/reference/lexical_analysis.html#numeric-literals
" https://docs.python.org/3/reference/lexical_analysis.html#numeric-literals
if g:python_syntax_prefer_python2
	syn match pythonDecInteger display	'\<\%([1-9]\d*\|0\+\)[lL]\=\>'
	syn match pythonOctInteger display	'\<0[oO]\o\+[lL]\=\>'
	syn match pythonHexInteger display	'\<0[xX]\x\+[lL]\=\>'
	syn match pythonBinInteger display	'\<0[bB][01]\+[lL]\=\>'
else
	syn match pythonDecInteger display	'\<\%([1-9]\d*\|0\+\)\>'
	syn match pythonOctInteger display	'\<0[oO]\o\+\>'
	syn match pythonHexInteger display	'\<0[xX]\x\+\>'
	syn match pythonBinInteger display	'\<0[bB][01]\+\>'
endif

syn match pythonImgInteger display	'\<\d\+[jJ]\>'

syn match pythonFloat display	'\<\d\+\.\d*\%([eE][+-]\=\d\+\)\=[jJ]\=\>'
syn match pythonFloat display	'\k\@4<!\.\d\+\%([eE][+-]\=\d\+\)\=[jJ]\=\>'
syn match pythonFloat display	'\<\d\+[eE][+-]\=\d\+[jJ]\=\>'


" Function and class definitions
" https://docs.python.org/2/reference/compound_stmts.html#function-definitions
" https://docs.python.org/3/reference/compound_stmts.html#function-definitions
"
" https://docs.python.org/2/reference/compound_stmts.html#class-definitions
" https://docs.python.org/3/reference/compound_stmts.html#class-definitions
"
" Note: 'def' keyword and a function name on separate lines are not highlighted
" Note: the above note also applies to 'class' keyword and a class name
syn match pythonFunctionName contained display	'\%(def\s\+\)\@<=\h\w*'
syn match pythonClassName contained display		'\%(class\s\+\)\@<=\h\w*'

" 'self'/'cls' should be used as the first argument to instance/class methods
" https://www.python.org/dev/peps/pep-0008/#function-and-method-arguments
syn keyword pythonSpecialArgument	self cls


" Decorators
" https://docs.python.org/2/reference/compound_stmts.html#grammar-token-decorator
" https://docs.python.org/3/reference/compound_stmts.html#grammar-token-decorator
"
" Note: '@' sign and a decorator name on separate lines are not highlighted
syn match pythonDecoratorSign display nextgroup=pythonDecorator skipwhite
	\ '\%(\\\n\)\@8<!\_^\s*\zs@'
syn match pythonDecorator contained display	'\%(@\s*\)\@<=\h\w*\%(\.\h\w*\)*'


" Built-in functions
" https://docs.python.org/2/library/functions.html
" https://docs.python.org/3/library/functions.html
syn keyword pythonBuiltinFunction	abs all any bin callable chr classmethod
syn keyword pythonBuiltinFunction	compile delattr dir divmod enumerate eval
syn keyword pythonBuiltinFunction	filter format getattr globals hasattr hash
syn keyword pythonBuiltinFunction	help hex id input isinstance issubclass
syn keyword pythonBuiltinFunction	iter len locals map max min next oct open
syn keyword pythonBuiltinFunction	ord pow property repr reversed round
syn keyword pythonBuiltinFunction	setattr slice sorted staticmethod sum
syn keyword pythonBuiltinFunction	super vars zip __import__

if g:python_syntax_prefer_python2
	syn keyword pythonBuiltinFunction	basestring cmp execfile range
	syn keyword pythonBuiltinFunction	raw_input reduce reload unichr
	" Python 2 non-essential built-in functions
	" https://docs.python.org/2/library/functions.html#non-essential-built-in-functions
	syn keyword pythonBuiltinFunction	apply coerce intern
else
	syn keyword pythonBuiltinFunction	ascii exec print
endif


" Built-in constants
" https://docs.python.org/2/library/constants.html
" https://docs.python.org/3/library/constants.html
syn keyword pythonBuiltinConstant	NotImplemented Ellipsis __debug__

if g:python_syntax_prefer_python2
	syn keyword pythonBuiltinConstant	False True None
endif


" Built-in types
" https://docs.python.org/2/library/stdtypes.html#built-in-types
" https://docs.python.org/3/library/stdtypes.html#built-in-types
syn keyword pythonBuiltinType	object type
syn keyword pythonBuiltinType	bool int float complex
syn keyword pythonBuiltinType	str list tuple bytearray memoryview
syn keyword pythonBuiltinType	set frozenset dict

if g:python_syntax_prefer_python2
	syn keyword pythonBuiltinType	file long unicode buffer xrange
else
	syn keyword pythonBuiltinType	bytes range
endif


" Built-in exceptions
" https://docs.python.org/2/library/exceptions.html
" https://docs.python.org/3/library/exceptions.html
syn keyword pythonBuiltinException	BaseException Exception
syn keyword pythonBuiltinException	ArithmeticError BufferError LookupError

syn keyword pythonBuiltinException	AssertionError AttributeError EOFError
syn keyword pythonBuiltinException	FloatingPointError GeneratorExit
syn keyword pythonBuiltinException	ImportError IndentationError IndexError
syn keyword pythonBuiltinException	KeyError KeyboardInterrupt MemoryError
syn keyword pythonBuiltinException	NameError NotImplementedError OSError
syn keyword pythonBuiltinException	OverflowError ReferenceError
syn keyword pythonBuiltinException	RuntimeError StopIteration SyntaxError
syn keyword pythonBuiltinException	SystemError SystemExit TabError
syn keyword pythonBuiltinException	TypeError UnboundLocalError
syn keyword pythonBuiltinException	UnicodeDecodeError UnicodeEncodeError
syn keyword pythonBuiltinException	UnicodeError UnicodeTranslateError
syn keyword pythonBuiltinException	ValueError ZeroDivisionError

syn keyword pythonBuiltinException	Warning
syn keyword pythonBuiltinException	BytesWarning DeprecationWarning
syn keyword pythonBuiltinException	FutureWarning ImportWarning
syn keyword pythonBuiltinException	PendingDeprecationWarning RuntimeWarning
syn keyword pythonBuiltinException	SyntaxWarning UnicodeWarning UserWarning

if g:python_syntax_prefer_python2
	syn keyword pythonBuiltinException	EnvironmentError IOError StandardError
else
	syn keyword pythonBuiltinException	BlockingIOError BrokenPipeError
	syn keyword pythonBuiltinException	ChildProcessError
	syn keyword pythonBuiltinException	ConnectionAbortedError
	syn keyword pythonBuiltinException	ConnectionError
	syn keyword pythonBuiltinException	ConnectionRefusedError
	syn keyword pythonBuiltinException	ConnectionResetError
	syn keyword pythonBuiltinException	FileExistsError FileNotFoundError
	syn keyword pythonBuiltinException	InterruptedError IsADirectoryError
	syn keyword pythonBuiltinException	NotADirectoryError PermissionError
	syn keyword pythonBuiltinException	ProcessLookupError RecursionError
	syn keyword pythonBuiltinException	StopAsyncIteration TimeoutError

	syn keyword pythonBuiltinException	ResourceWarning
endif


" Sync at the beginning of a class, function, or method definition
syn sync maxlines=300
syn sync match pythonSync grouphere NONE	'\_^\s*\%(def\|class\)\s\+\h\w*'


if v:version >= 508 || !exists('s:did_python_syn_inits')
	if v:version <= 508
		let s:did_python_syn_inits = 1
		command -nargs=+ HiLink hi link <args>
	else
		command -nargs=+ HiLink hi def link <args>
	endif

	HiLink pythonComment				Comment
	HiLink pythonTodo					Todo

	HiLink pythonLineJoin				Delimiter

	HiLink pythonKeyword				Statement

	HiLink pythonConditional			Conditional
	HiLink pythonExceptionHandler		Exception
	HiLink pythonInclude				Include
	HiLink pythonOperator				Operator
	HiLink pythonRepeat					Repeat

	HiLink pythonDelimiter				Delimiter

	HiLink pythonAugmentedAssignment	pythonOperator

	HiLink pythonEscape					SpecialChar
	HiLink pythonUnicodeEscape			SpecialChar
	HiLink pythonUnicodeName			pythonUnicodeEscape

	HiLink pythonQuotes					Special
	HiLink pythonTripleQuotes			pythonQuotes

	HiLink pythonShortString			String
	HiLink pythonLongString				String
	HiLink pythonRawShortString			String
	HiLink pythonRawLongString			String

	HiLink pythonDecInteger				Number
	HiLink pythonOctInteger				Number
	HiLink pythonHexInteger				Number
	HiLink pythonBinInteger				Number
	HiLink pythonImgInteger				Number

	HiLink pythonFloat					Float

	HiLink pythonFunctionName			Function
	HiLink pythonClassName				Structure
	HiLink pythonSpecialArgument		Identifier

	HiLink pythonDecoratorSign			PreProc
	HiLink pythonDecorator				Macro

	HiLink pythonBuiltinFunction		Function
	HiLink pythonBuiltinConstant		Constant
	HiLink pythonBuiltinType			Type
	HiLink pythonBuiltinException		pythonBuiltinType

	delcommand HiLink
	unlet! s:did_python_syn_inits
endif

let b:current_syntax = 'python'

let &cpoptions = s:save_cpo
unlet! s:save_cpo

" vim:set ts=4 sts=0 noet sw=4 ff=unix:
