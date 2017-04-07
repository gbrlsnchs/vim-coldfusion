" Quit if a syntax file is already loaded.
if exists("b:current_syntax")
  finish
endif

syn sync fromstart
syn sync maxlines=1000
syn case ignore

" INCLUDES {{{
syn include @sqlSyntax syntax/sql.vim
" do not load html, it contains huge keywords regex, so it will have impact on performance
" let's use simple SGML tag coloring instead
" runtime! syntax/html.vim
unlet b:current_syntax
syn include @htmlSyntax syntax/html.vim
syn region htmlRegion start='<html>' end='</html>' contains=@htmlSyntax
" INCLUDES }}}

" NUMBER {{{
syn match cfmlNumber
    \ "\v<\d+>"
" / NUMBER }}}

" EQUAL SIGN {{{
syn match cfmlEqualSign
    \ "\v\="
" / EQUAL SIGN }}}

" BOOLEAN {{{
syn match cfmlBoolean
    \ "\v<(true|false)>"
" / BOOLEAN }}}

" HASH SURROUNDED {{{
syn region cfmlHashSurround
  \ keepend
  \ oneline
  \ start="#"
  \ end="#"
  \ skip="##"
    \ contains=
        \@cfmlOperator,
        \@cfmlPunctuation,
        \cfmlBoolean,
        \cfmlCoreKeyword,
        \cfmlCoreScope,
        \cfmlCustomKeyword,
        \cfmlCustomScope,
        \cfmlEqualSign,
        \cfmlFunctionName,
        \cfmlNumber
" / HASH SURROUNDED }}}

" OPERATOR {{{

" OPERATOR - ARITHMETIC {{{
" +7 -7
" ++i --i
" i++ i--
" + - * / %
" += -= *= /= %=
" ^ mod
syn match cfmlArithmeticOperator
    \ "\v
    \(\+|-)\ze\d
    \|(\+\+|--)\ze\w
    \|\w\zs(\+\+|--)
    \|(\s(
    \(\+|-|\*|\/|\%){1}\={,1}
    \|\^
    \|mod
    \)\s)
    \"
" / OPERATOR - ARITHMETIC }}}

" OPERATOR - BOOLEAN {{{
" not and or xor eqv imp
" ! && ||
syn match cfmlBooleanOperator
    \ "\v\s
    \(not|and|or|xor|eqv|imp
    \|\!|\&\&|\|\|
    \)(\s|\))
    \|\s\!\ze\w
    \"
" / OPERATOR - BOOLEAN }}}

" OPERATOR - DECISION {{{
"is|equal|eq
"is not|not equal|neq
"contains|does not contain
"greater than|gt
"less than|lt
"greater than or equal to|gte|ge
"less than or equal to|lte|le
"==|!=|>|<|>=|<=
syn match cfmlDecisionOperator
    \ "\v\s
    \(is|equal|eq
    \|is not|not equal|neq
    \|contains|does not contain
    \|greater than|gt
    \|less than|lt
    \|greater than or equal to|gte|ge
    \|less than or equal to|lte|le
    \|(!|\<|\>|\=){1}\=
    \|\<
  \|\>
    \)\s"
" / OPERATOR - DECISION }}}

" OPERATOR - STRING {{{
" &
" &=
syn match cfmlStringOperator
    \ "\v\s\&\={,1}\s"
" / OPERATOR - STRING }}}

" OPERATOR - TERNARY {{{
" ? :
syn match cfmlTernaryOperator
    \ "\v\s
    \\?|\:
    \\s"
" / OPERATOR - TERNARY }}}

syn cluster cfmlOperator
    \ contains=
        \cfmlArithmeticOperator,
        \cfmlBooleanOperator,
        \cfmlDecisionOperator,
        \cfmlStringOperator,
        \cfmlTernaryOperator
" OPERATOR }}}

" PARENTHESIS {{{
syn cluster cfmlParenthesisRegionContains
    \ contains=
        \@cfmlAttribute,
        \@cfmlComment,
        \@cfmlFlowStatement,
        \@cfmlOperator,
        \@cfmlPunctuation,
        \cfmlBoolean,
        \cfmlBrace,
        \cfmlCoreKeyword,
        \cfmlCoreScope,
        \cfmlCustomKeyword,
        \cfmlCustomScope,
        \cfmlEqualSign,
        \cfmlFunctionName,
        \cfmlFunctionReturnType,
        \cfmlNumber,
        \cfmlStorageKeyword,
        \cfmlStorageType

syn region cfmlParenthesisRegion
    \ extend
    \ matchgroup=cfmlParenthesis1
    \ transparent
    \ start=/(/
    \ end=/)/
    \ contains=
        \@cfmlParenthesisRegionContains
" PARENTHESIS }}}

" BRACE {{{
syn match cfmlBrace
    \ "{\|}"

syn region cfmlBraceRegion
    \ extend
    \ fold
    \ keepend
    \ transparent
    \ start="{"
    \ end="}"
" BRACE }}}

" PUNCTUATION {{{

" PUNCTUATION - BRACKET {{{
syn match cfmlBracket
    \ "\(\[\|\]\)"
    \ contained
" / PUNCTUATION - BRACKET }}}

" PUNCTUATION - CHAR {{{
syn match cfmlComma ","
syn match cfmlDot "\."
syn match cfmlSemiColon ";"

" / PUNCTUATION - CHAR }}}

" PUNCTUATION - QUOTE {{{
syn region cfmlSingleQuotedValue
    \ matchgroup=cfmlSingleQuote
    \ start=/'/
    \ skip=/''/
    \ end=/'/
    \ contains=
        \cfmlHashSurround

syn region cfmlDoubleQuotedValue
    \ matchgroup=cfmlDoubleQuote
    \ start=/"/
    \ skip=/""/
    \ end=/"/
    \ contains=
        \cfmlHashSurround

syn cluster cfmlQuotedValue
    \ contains=
        \cfmlDoubleQuotedValue,
        \cfmlSingleQuotedValue

syn cluster cfmlQuote
    \ contains=
        \cfmlDoubleQuote,
        \cfmlSingleQuote
" / PUNCTUATION - QUOTE }}}

syn cluster cfmlPunctuation
    \ contains=
        \@cfmlQuote,
        \@cfmlQuotedValue,
        \cfmlBracket,
        \cfmlComma,
        \cfmlDot,
        \cfmlSemiColon

" PUNCTUATION }}}

" TAG START AND END {{{
" tag start
" <cf...>
" s^^   e
syn region cfmlTagStart
    \ keepend
    \ transparent
    \ start="\c<cf_*"
    \ end=">"
    \ contains=
        \@cfmlAttribute,
        \@cfmlComment,
        \@cfmlOperator,
        \@cfmlParenthesisRegion,
        \@cfmlPunctuation,
        \@cfmlQuote,
        \@cfmlQuotedValue,
        \cfmlAttrEqualSign,
        \cfmlBoolean,
        \cfmlBrace,
        \cfmlCoreKeyword,
        \cfmlCoreScope,
        \cfmlCustomKeyword,
        \cfmlCustomScope,
        \cfmlEqualSign,
        \cfmlFunctionName,
        \cfmlNumber,
        \cfmlStorageKeyword,
        \cfmlStorageType,
        \cfmlTagBracket,
        \cfmlTagName

" tag end
" </cf...>
" s^^^   e
syn match cfmlTagEnd
    \ transparent
    \ "\c</cf_*[^>]*>"
    \ contains=
        \cfmlTagBracket,
        \cfmlTagName

" tag bracket
" </...>
" ^^   ^
syn match cfmlTagBracket
    \ contained
    \ "\(<\|>\|\/\)"

" tag name
" <cf...>
"  s^^^e
syn match cfmlTagName
    \ contained
    \ "\v<\/*\zs\ccf\w*"
" TAG START AND END }}}

" ATTRIBUTE NAME AND VALUE {{{
syn match cfmlAttrName
    \ contained
  \ "\v(var\s)@<!\w+\ze\s*\=([^\=])+"

syn match cfmlAttrValue
    \ contained
    \ "\v(\=\"*)\zs\s*\w*"

syn match cfmlAttrEqualSign
    \ contained
    \ "\v\="

syn cluster cfmlAttribute
    \ contains=
        \@cfmlQuotedValue,
        \cfmlAttrEqualSign,
        \cfmlAttrName,
        \cfmlAttrValue,
        \cfmlCoreKeyword,
        \cfmlCoreScope
" ATTRIBUTE NAME AND VALUE }}}

" TAG REGION AND FOLDING {{{

" CFCOMPONENT REGION AND FOLD {{{
" <cfcomponent
" s^^^^^^^^^^^
" </cfcomponent>
" ^^^^^^^^^^^^^e
syn region cfmlComponentTagRegion
    \ fold
    \ keepend
    \ transparent
    \ start="\c<cfcomponent"
    \ end="\c</cfcomponent>"

" / CFCOMPONENT REGION AND FOLD }}}

" CFFUNCTION REGION AND FOLD {{{
" <cffunction
" s^^^^^^^^^^
" </cffunction>
" ^^^^^^^^^^^^e
syn region cfmlFunctionTagRegion
    \ fold
    \ keepend
    \ transparent
    \ start="\c<cffunction"
    \ end="\c</cffunction>"
    \ containedin=htmlRegion
" / CFFUNCTION REGION AND FOLD }}}

" CFIF REGION AND FOLD {{{
" <cfif
" s^^^^^^^
" </cfif>
" ^^^^^^^^^e
syn region cfmlIfTagRegion
    \ fold
    \ keepend
    \ transparent
    \ start="\c<\(cfif|cfelse|cfifelse\)"
    \ end="\c</cfif>"
    \ containedin=htmlRegion
" / CFIF REGION AND FOLD }}}

" CFLOOP REGION AND FOLD {{{
" <cfloop
" s^^^^^^
" </cfloop>
" ^^^^^^^^e
syn region cfmlLoopTagRegion
    \ fold
    \ keepend
    \ transparent
    \ start="\c<cfloop"
    \ end="\c</cfloop>"
    \ containedin=htmlRegion
" / CFLOOP REGION AND FOLD }}}

" CFOUTPUT REGION AND FOLD {{{
" <cfoutput
" s^^^^^^^^
" </cfoutput>
" ^^^^^^^^^^e
syn region cfmlOutputTagRegion
    \ fold
    \ keepend
    \ transparent
    \ start="\c<cfoutput"
    \ end="\c</cfoutput>"
    \ containedin=htmlRegion
" / CFOUTPUT REGION AND FOLD }}}

" CFQUERY REGION AND FOLD {{{
" <cfquery
" s^^^^^^^
" </cfquery>
" ^^^^^^^^^e
        "\@cfmlSqlStatement,
syn region cfmlQueryTagRegion
    \ fold
    \ keepend
    \ transparent
    \ start="\c<cfquery"
    \ end="\c</cfquery>"
    \ containedin=htmlRegion
    \ contains=
        \@cfmlSqlStatement,
        \cfmlTagStart,
        \cfmlTagEnd,
        \cfmlTagComment
" / CFQUERY REGION AND FOLD }}}

" SAVECONTENT REGION AND FOLD {{{
" <savecontent
" s^^^^^^^^^^
" </savecontent>
" ^^^^^^^^^^^^^e
syn region cfmlSavecontentTagRegion
    \ fold
    \ keepend
    \ transparent
    \ start="\c<cfsavecontent"
    \ end="\c</cfsavecontent>"
" / SAVECONTENT REGION AND FOLD }}}

" CFSCRIPT REGION AND FOLD {{{
" <cfscript>
" s^^^^^^^^^
" </cfscript>
" ^^^^^^^^^^e
"\cfmlCustomScope,
syn region cfmlScriptTagRegion
    \ fold
    \ keepend
    \ transparent
    \ start="\c<cfscript>"
    \ end="\c</cfscript>"
    \ contains=
        \@cfmlComment,
        \@cfmlFlowStatement,
        \cfmlHashSurround,
        \@cfmlOperator,
        \@cfmlParenthesisRegion,
        \@cfmlPunctuation,
        \cfmlBoolean,
        \cfmlBrace,
        \cfmlCoreKeyword,
        \cfmlCoreScope,
        \cfmlCustomKeyword,
        \cfmlCustomScope,
        \cfmlEqualSign,
        \cfmlFunctionDefinition,
        \cfmlFunctionName,
        \cfmlNumber,
        \cfmlOddFunction,
        \cfmlStorageKeyword,
        \cfmlTagEnd,
        \cfmlTagStart
" / CFSCRIPT REGION AND FOLD }}}

" CFSWITCH REGION AND FOLD {{{
" <cfswitch
" s^^^^^^^^
" </cfswitch>
" ^^^^^^^^^^e
syn region cfmlSwitchTagRegion
    \ fold
    \ keepend
    \ transparent
    \ start="\c<cfswitch"
    \ end="\c</cfswitch>"
" / CFSWITCH REGION AND FOLD }}}

" CFTRANSACTION REGION AND FOLD {{{
" <cftransaction
" s^^^^^^^^^^^^^
" </cftransaction>
" ^^^^^^^^^^^^^^^e
syn region cfmlTransactionTagRegion
    \ fold
    \ keepend
    \ transparent
    \ start="\c<cftransaction"
    \ end="\c</cftransaction>"
" / CFTRANSACTION REGION AND FOLD }}}

" CUSTOM TAG REGION AND FOLD {{{
" <cf_...>
" s^^^   ^
" </cf_...>
" ^^^^^   e
syn region cfmlCustomTagRegion
    \ fold
    \ keepend
    \ transparent
    \ start="\c<cf_[^>]*>"
    \ end="\c</cf_[^>]*>"
" / CUSTOM TAG REGION AND FOLD }}}

" / TAG REGION AND FOLDING }}}

" COMMENT {{{

" COMMENT BLOCK {{{
" /*...*/
" s^   ^e
syn region cfmlCommentBlock
        \ keepend
        \ start="/\*"
        \ end="\*/"
        \ contains=
            \cfmlMetaData
" / COMMENT BLOCK }}}

" COMMENT LINE {{{
" //...
" s^
syn match cfmlCommentLine
        \ "\/\/.*"
" / COMMENT LINE }}}

syn cluster cfmlComment
    \ contains=
        \cfmlCommentBlock,
        \cfmlCommentLine
" / COMMENT }}}

" TAG COMMENT {{{
" <!---...--->
" s^^^^   ^^^e
syn region cfmlTagComment
  \ keepend
    \ start="<!---"
    \ end="--->"
    \ contains=cfmlTagComment
" / TAG COMMENT }}}

" FLOW STATEMENT {{{
" BRANCH FLOW KEYWORD {{{
syn keyword cfmlBranchFlowKeyword
    \ break
    \ continue
    \ return

" / BRANCH KEYWORD }}}

" DECISION FLOW KEYWORD {{{
syn keyword cfmlDecisionFlowKeyword
    \ case
    \ defaultcase
    \ else
    \ if
    \ switch

" / DECISION FLOW KEYWORD }}}

" LOOP FLOW KEYWORD {{{
syn keyword cfmlLoopFlowKeyword
    \ do
    \ for
    \ in
    \ while

" / LOOP FLOW KEYWORD }}}

" TRY FLOW KEYWORD {{{
syn keyword cfmlTryFlowKeyword
    \ catch
    \ finally
    \ rethrow
    \ throw
    \ try

" / TRY FLOW KEYWORD }}}

syn cluster cfmlFlowStatement
    \ contains=
        \cfmlBranchFlowKeyword,
        \cfmlDecisionFlowKeyword,
        \cfmlLoopFlowKeyword,
        \cfmlTryFlowKeyword

" FLOW STATEMENT }}}

" STORAGE KEYWORD {{{
syn keyword cfmlStorageKeyword
    \ var
" / STORAGE KEYWORD }}}

" STORAGE TYPE {{{
syn match cfmlStorageType
  \ contained
  \ "\v<
    \(any
    \|array
    \|binary
    \|boolean
    \|date
    \|numeric
    \|query
    \|string
    \|struct
    \|uuid
    \|void
    \|xml
  \){1}\ze(\s*\=)@!"
" / STORAGE TYPE }}}

" CORE KEYWORD {{{
syn match cfmlCoreKeyword
        \ "\v<
        \(new
        \|required
        \)\ze\s"
" / CORE KEYWORD }}}

" CORE SCOPE {{{
syn match cfmlCoreScope
    \ "\v<
    \(application
    \|arguments
    \|attributes
    \|caller
    \|cfcatch
    \|cffile
    \|cfhttp
    \|cgi
    \|client
    \|cookie
    \|form
    \|local
    \|request
    \|server
    \|session
    \|super
    \|this
    \|thisTag
    \|thread
    \|variables
    \|url
    \){1}\ze(,|\.|\[|\)|\s)"
" / CORE SCOPE }}}

" SQL STATEMENT {{{
syn cluster cfmlSqlStatement
    \ contains=
        \@cfmlParenthesisRegion,
        \@cfmlQuote,
        \@cfmlQuotedValue,
        \@sqlSyntax,
        \cfmlBoolean,
        \cfmlDot,
        \cfmlEqualSign,
        \cfmlFunctionName,
        \cfmlHashSurround,
        \cfmlNumber
" SQL STATEMENT }}}

" TAG IN SCRIPT {{{
syn match cfmlTagNameInScript
    \ "\vcf_*\w+\s*\ze\("
" / TAG IN SCRIPT }}}

" METADATA {{{
syn region cfmlMetaData
    \ contained
    \ keepend
    \ start="@\w\+"
    \ end="$"
    \ contains=
        \cfmlMetaDataName

syn match cfmlMetaDataName
    \ contained
    \ "@\w\+"
" / METADATA }}}

" COMPONENT DEFINITION {{{
syn region cfmlComponentDefinition
    \ start="component"
    \ end="{"me=e-1
    \ contains=
        \@cfmlAttribute,
        \cfmlComponentKeyword

syn match cfmlComponentKeyword
    \ contained
    \ "\v<component>"
" / COMPONENT DEFINITION }}}

" INTERFACE DEFINITION {{{
syn match cfmlInterfaceDefinition
    \ "interface\s.*{"me=e-1
    \ contains=
        \cfmlInterfaceKeyword

syn match cfmlInterfaceKeyword
    \ contained
    \ "\v<interface>"
" / INTERFACE DEFINITION }}}

" PROPERTY {{{
syn region cfmlProperty
    \ transparent
    \ start="\v<property>"
    \ end=";"me=e-1
    \ contains=
        \@cfmlQuotedValue,
        \cfmlAttrEqualSign,
        \cfmlAttrName,
        \cfmlAttrValue,
        \cfmlPropertyKeyword

syn match cfmlPropertyKeyword
        \ contained
        \ "\v<property>"
" PROPERTY }}}

" FUNCTION DEFINITION {{{
syn match cfmlFunctionDefinition
    \ "\v
        \(<(public|private|package)\s){,1}
        \(<
            \(any
            \|array
            \|binary
            \|boolean
            \|date
            \|numeric
            \|query
            \|string
            \|struct
            \|uuid
            \|void
            \|xml
        \)\s){,1}
    \<function\s\w+\s*\("me=e-1
    \ contains=
        \cfmlFunctionKeyword,
        \cfmlFunctionModifier,
        \cfmlFunctionName,
        \cfmlFunctionReturnType

" FUNCTION KEYWORD {{{
syn match cfmlFunctionKeyword
    \ contained
    \ "\v<function>"
" / FUNCTION KEYWORD }}}

" FUNCTION MODIFIER {{{
syn match cfmlFunctionModifier
    \ contained
    \ "\v<
    \(public
    \|private
    \|package
    \)>"
" / FUNCTION MODIFIER }}}

" FUNCTION RETURN TYPE {{{
syn match cfmlFunctionReturnType
    \ contained
    \ "\v
    \(any
    \|array
    \|binary
    \|boolean
    \|date
    \|numeric
    \|query
    \|string
    \|struct
    \|uuid
    \|void
    \|xml
    \)"
" / FUNCTION RETURN TYPE }}}

" FUNCTION NAME {{{
" specific regex for core functions decreases performance
" so use the same highlighting for both function types
syn match cfmlFunctionName
    \ "\v<(cf|if|elseif|throw)@!\w+\s*\ze\("
" / FUNCTION NAME }}}

" / FUNCTION DEFINITION }}}

" ODD FUNCTION {{{
syn region cfmlOddFunction
    \ transparent
    \ start="\v<
        \(abort
        \|exit
        \|import
        \|include
        \|lock
        \|pageencoding
        \|param
        \|savecontent
        \|thread
        \|transaction
        \){1}"
    \ end="\v(\{|;)"me=e-1
    \ contains=
        \@cfmlQuotedValue,
        \cfmlAttrEqualSign,
        \cfmlAttrName,
        \cfmlAttrValue,
        \cfmlCoreKeyword,
        \cfmlOddFunctionKeyword,
        \cfmlCoreScope

" ODD FUNCTION KEYWORD {{{
syn match cfmlOddFunctionKeyword
        \ contained
        \ "\v<
        \(abort
        \|exit
        \|import
        \|include
        \|lock
        \|pageencoding
        \|param
        \|savecontent
        \|thread
        \|transaction
        \)\ze(\s|$|;)"
" / ODD FUNCTION KEYWORD }}}

" / ODD FUNCTION }}}

" CUSTOM {{{

" CUSTOM KEYWORD {{{
syn match cfmlCustomKeyword
    \ contained
    \ "\v<
    \(customKeyword1
    \|customKeyword2
    \|customKeyword3
    \)>"
" / CUSTOM KEYWORD }}}

" CUSTOM SCOPE {{{
syn match cfmlCustomScope
    \ contained
    \ "\v<
    \(prc
    \|rc
    \|event
    \|(\w+Service)
    \){1}\ze(\.|\[)"
" / CUSTOM SCOPE }}}

" / CUSTOM }}}

" SGML TAG START AND END {{{
" SGML tag start
" <...>
" s^^^e
" syn region cfmlSGMLTagStart
"     \ keepend
"     \ transparent
"   \ start="\v(\<cf)@!\zs\<\w+"
"     \ end=">"
"     \ contains=
"         \@cfmlAttribute,
"         \@cfmlComment,
"         \@cfmlOperator,
"         \@cfmlParenthesisRegion,
"         \@cfmlPunctuation,
"         \@cfmlQuote,
"         \@cfmlQuotedValue,
"         \cfmlAttrEqualSign,
"         \cfmlBoolean,
"         \cfmlBrace,
"         \cfmlCoreKeyword,
"         \cfmlCoreScope,
"         \cfmlCustomKeyword,
"         \cfmlCustomScope,
"         \cfmlEqualSign,
"         \cfmlFunctionName,
"         \cfmlNumber,
"         \cfmlStorageKeyword,
"         \cfmlStorageType,
"         \cfmlTagBracket,
"         \cfmlSGMLTagName

" SGML tag end
" </...>
" s^^^^e
" syn match cfmlSGMLTagEnd
    " \ transparent
    " \ "\v(\<\/cf)@!\zs\<\/\w+\>"
    " \ contains=
    "     \cfmlTagBracket,
    "     \cfmlSGMLTagName

" SGML tag name
" <...>
" s^^^e
" syn match cfmlSGMLTagName
"   \ contained
"   \ "\v(\<\/*)\zs\w+"

" SGML TAG START AND END }}}

" HIGHLIGHTING {{{

hi link cfmlNumber Number
hi link cfmlBoolean Boolean
hi link cfmlEqualSign Ignore
" HASH SURROUND
hi link cfmlHash PreProc
hi link cfmlHashSurround PreProc
" OPERATOR
hi link cfmlArithmeticOperator Function
hi link cfmlBooleanOperator Function
hi link cfmlDecisionOperator Ignore
hi link cfmlStringOperator Function
hi link cfmlTernaryOperator Function
" PARENTHESIS
hi link cfmlParenthesis1 Statement
" BRACE
hi link cfmlBrace PreProc
" PUNCTUATION - BRACKET
hi link cfmlBracket Statement
" PUNCTUATION - CHAR
hi link cfmlComma Comment
hi link cfmlDot Comment
hi link cfmlSemiColon Comment
" PUNCTUATION - QUOTE
hi link cfmlDoubleQuote String
hi link cfmlDoubleQuotedValue String
hi link cfmlSingleQuote String
hi link cfmlSingleQuotedValue String
" TAG START AND END
hi link cfmlTagName Function
hi link cfmlTagBracket Comment
" ATTRIBUTE NAME AND VALUE
hi link cfmlAttrName Type
hi link cfmlAttrValue Special
" COMMENT
hi link cfmlCommentBlock Comment
hi link cfmlCommentLine Comment
hi link cfmlTagComment Comment
" FLOW STATEMENT
hi link cfmlDecisionFlowKeyword Conditional
hi link cfmlLoopFlowKeyword Repeat
hi link cfmlTryFlowKeyword Exception
hi link cfmlBranchFlowKeyword Keyword
" STORAGE KEYWORD
hi link cfmlStorageKeyword Keyword
" STORAGE TYPE
hi link cfmlStorageType Keyword
" CORE KEYWORD
hi link cfmlCoreKeyword PreProc
" CORE SCOPE
hi link cfmlCoreScope Keyword
" TAG IN SCRIPT
hi link cfmlTagNameInScript Function
" METADATA
" meta data value = cfmlMetaData
hi link cfmlMetaData String
hi link cfmlMetaDataName Type
" COMPONENT DEFINITION
hi link cfmlComponentKeyword Keyword
" INTERFACE DEFINITION
hi link cfmlInterfaceKeyword Keyword
" PROPERTY
hi link cfmlPropertyKeyword Keyword
" FUNCTION DEFINITION
hi link cfmlFunctionKeyword Keyword
hi link cfmlFunctionModifier Keyword
hi link cfmlFunctionReturnType Keyword
hi link cfmlFunctionName Function
" ODD FUNCTION
hi link cfmlOddFunctionKeyword Function
" CUSTOM
hi link cfmlCustomKeyword Keyword
hi link cfmlCustomScope Structure
" SGML TAG
" hi link cfmlSGMLTagName Ignore

" / HIGHLIGHTING }}}

" Set the syntax
if !exists('b:current_syntax')
    let b:current_syntax = 'coldfusion'
endif
