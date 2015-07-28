#Rem monkeydoc on
#End

#Rem monkeydoc Module bit.arguments
To use this library, copy to your modules folder and rebuild the documentation.
Then locate the documentation under "modules" under "bit.arguments."

This module helps process and parse command line arguments and assists with help documentation.

Things that need doing:
* Feature complete

I release this software under license: http://creativecommons.org/licenses/by-sa/4.0/

	Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)

This is a human-readable summary of (and not a substitute for) the license.

Disclaimer~n
This license is acceptable for Free Cultural Works.

You are free to:

* Share & copy and redistribute the material in any medium or format
* Adapt & remix, transform, and build upon the material for any purpose, even commercially.
* The licensor cannot revoke these freedoms as long as you follow the license terms.

---

Other license terms for this code may be available upon a request to the author.

Last updated 2015.

---
Eric Canales~n
eric\@canales.me

#End

Strict

Const BIT_BOOL:= 1
Const BIT_STRING:= 2

#Rem monkeydoc
The main class that stores all options, arguments and help information.

Example:
<pre>
	Local opts:= New Options()
</pre>
#End
Class Options

	Public
	
	#Rem monkeydoc
	Sets the usage message when PrintHelp method is called. You should set it as per the example.
	Because if the user changes the exe name, the help will be updated to reflect that.
	You may need to import brl.filepath to use filepath.
	
	Example:
	<pre>	
		Local opts:= New Options()
		opts.SetUsageHelp(filepath.StripDir(os.AppArgs()[0]) + " [OPTION...]")
	</pre>
	#End
	Method SetUsageHelp:Void(usageHelp:String)
		Self.usageHelp = usageHelp
	End

	#Rem monkeydoc
	Prints the automatically generated help to the console.
	
	Example:
	<pre>
		Local opts:= New Options()
		opts.PrintHelp()
	</pre>
	#End
	Method PrintHelp:Void()
		Print "Usage:"
		Print "   " + Self.usageHelp
		Print ""
		Local maxLineLength:Int
		
		'determine max line length
		For Local group:= EachIn Self.optionGroups
			For Local option:= EachIn group.options
				Local helpLine:String = ""

				If option.name.Length = 1
					If helpLine.Length > 0
						helpLine += ", "
					EndIf
					helpLine += "-" + option.name
				EndIf
				For Local pAlias:= EachIn option.aliases
					If pAlias.name.Length = 1
						If helpLine.Length > 0
							helpLine += ", "
						EndIf
						helpLine += "-" + pAlias.name
					EndIf
				Next

				If option.name.Length > 1
					If helpLine.Length > 0
						helpLine += ", "
					EndIf
					helpLine += "--" + option.name
					If option.valueSample.Length > 0
						helpLine += "=" + option.valueSample
					EndIf
				EndIf
				For Local pAlias:= EachIn option.aliases
					If pAlias.name.Length > 1
						If helpLine.Length > 0
							helpLine += ", "
						EndIf
						helpLine += "--" + pAlias.name
						If pAlias.primaryOption.valueSample.Length > 0
							helpLine += "=" + pAlias.primaryOption.valueSample
						EndIf
					EndIf
				Next
				
				If maxLineLength < helpLine.Length
					maxLineLength = helpLine.Length
				EndIf
			Next
		Next
		
		'Now actually output everything this time
		For Local group:= EachIn Self.optionGroups
			Print group.name + " Options:"
			For Local option:= EachIn group.options
				Local helpLine:String = ""

				If option.name.Length = 1
					If helpLine.Length > 0
						helpLine += ", "
					EndIf
					helpLine += "-" + option.name
				EndIf
				For Local pAlias:= EachIn option.aliases
					If pAlias.name.Length = 1
						If helpLine.Length > 0
							helpLine += ", "
						EndIf
						helpLine += "-" + pAlias.name
					EndIf
				Next

				If option.name.Length > 1
					If helpLine.Length > 0
						helpLine += ", "
					EndIf
					helpLine += "--" + option.name
					If option.valueSample.Length > 0
						helpLine += "=" + option.valueSample
					EndIf
				EndIf
				For Local pAlias:= EachIn option.aliases
					If pAlias.name.Length > 1
						If helpLine.Length > 0
							helpLine += ", "
						EndIf
						helpLine += "--" + pAlias.name
						If pAlias.primaryOption.valueSample.Length > 0
							helpLine += "=" + pAlias.primaryOption.valueSample
						EndIf
					EndIf
				Next
				
				'add  spacing
				Local addSpace:= maxLineLength - helpLine.Length + 1
				For Local space:= 0 To addSpace
					helpLine += " "
				Next
				
				helpLine += option.description
				
				Print "   " + helpLine
			Next
			Print ""
		Next
	End
	
	#Rem monkeydoc
	Adds an option group. Options are stored by group. Usually you want just two groups, "Help" and "Application".
	But a larger or more complex tool may require more groups. The PrintHelp method prints these groups out in the
	order they were created.
	
	Example:
	<pre>
		Local opts:= New Options()
		opts.SetUsageHelp(filepath.StripDir(os.AppArgs()[0]) + " [OPTION...]")
		Local optsHelpGroup := opts.AddGroup("Help")
		Local optsAppGroup := opts.AddGroup("Application")
	</pre>
	#End
	Method AddGroup:OptionGroup(name:String)
		Self.optionGroups.AddLast(New OptionGroup(name))
		Return optionGroups.Last()
	End
	#Rem monkeydoc
	Find an option group by name and return it.
	
	Example:
	<pre>
		Local opts:= New Options()
		opts.SetUsageHelp(filepath.StripDir(os.AppArgs()[0]) + " [OPTION...]")
		opts.AddGroup("Help")
		opts.FindGroup("Help").AddOption("help", "Show Help Options", "", BIT_BOOL)
	</pre>
	#End
	Method FindGroup:OptionGroup(name:String)
		For Local pg:= EachIn Self.optionGroups
			If pg.name = name
				Return pg
			EndIf
		Next
		Return Null
	End
	
	#Rem monkeydoc
	Find an option by name or alias and return it.
	
	Example:
	<pre>
		Local opts:= New Options()
		opts.SetUsageHelp(filepath.StripDir(os.AppArgs()[0]) + " [OPTION...]")
		opts.AddGroup("Help").AddOption("help", "Show Help Options", "", BIT_BOOL)
		opts.FindOption("help").AddAlias("?")
	</pre>
	#End
	Method FindOption:Option(name:String)
		For Local group:= EachIn Self.optionGroups
			For Local option:= EachIn group.options
				If option.name = name
					Return option
				EndIf
				For Local pAlias:= EachIn option.aliases
					If pAlias.name = name
						Return option
					EndIf
				Next
			Next
		Next
		
		Return Null
	End
	
	#Rem monkeydoc
	Parse and process an argument list. This will set all the option values for later checking.
	
	Example:
	<pre>
		Local opts:= New Options()
		opts.SetUsageHelp(filepath.StripDir(os.AppArgs()[0]) + " [OPTION...]")
		opts.AddGroup("Help").AddOption("help", "Show Help Options", "", BIT_BOOL).AddAlias("?")
		
		Try
			opts.ParseArguments(os.AppArgs()[1 ..]) 'this will pass in the arguments supplied to the app from the command line
		Catch t:OptionsError
			'if any parsing errors, print them here
			Print t.message
			'also show the user how to request help.
			Print "Run '" + filepath.StripDir(os.AppArgs()[0]) + " --help' to see a full list of available command line options."
			'exit the app
			Return
		End
	</pre>
	#End
	Method ParseArguments:Bool(AppArgs:String[])
		If AppArgs.Length = 0
			Return True
		EndIf
		
		Local onArg:= 0
		Local arg:String
		
		For onArg = 0 To AppArgs.Length - 1
			arg = AppArgs[onArg]

			If arg = "-"
				'argument specified
				Self.Arguments.AddLast arg
			ElseIf arg.Length = 2
				If arg.StartsWith("-") = True And arg <> "--"
					Local option:= Self.FindOption(arg[1 ..])
					
					If option = Null
						'option does not exist
						Throw New OptionsError("Unknown option " + arg)
						Return False
					EndIf
					If option.type = BIT_BOOL
						option.SetValue(True)
						'go on to next argument
					Else
						'option is not a flag
						If onArg < AppArgs.Length - 1
							option.SetValue(AppArgs[onArg + 1])
							onArg += 1
						Else
							'failed, option wasn't a flag and no value was specified
							Throw New OptionsError("Missing argument for " + arg)
							Return False
						EndIf
					EndIf
				Else
					'an argument specified, but not a option
					Self.Arguments.AddLast arg
				EndIf
			ElseIf arg.Length > 2
				If arg.StartsWith("--") = False
					If arg.StartsWith("-")
						For Local flag:= 1 To arg.Length - 1
							Local option:= Self.FindOption(arg[flag .. flag + 1])
							If option = Null
								'option does not exist
								Throw New OptionsError("Unknown option -" + arg[flag .. flag + 1])
								Return False
							EndIf
							If option.type = BIT_STRING
								Throw New OptionsError("Missing argument for -" + arg[flag .. flag + 1])
								Return False
							EndIf
							option.SetValue(True)
						Next
					Else
						'an argument specified, but not a option
						Self.Arguments.AddLast arg
					EndIf
				Else
					Local eqLoc:= arg.Find("=")
					If (eqLoc <= 2 And eqLoc > - 1)
						Throw New OptionsError("Missing argument for " + arg)
						Return False
					EndIf
					If eqLoc = arg.Length - 1
						Throw New OptionsError("Missing argument for " + arg[ .. arg.Length - 1])
						Return False
					EndIf
					If eqLoc = -1
						Local option:= Self.FindOption(arg[2 ..])
						If option = Null
							'option does not exist
							Throw New OptionsError("Unknown option " + arg)
							Return False
						EndIf
						If option.type = BIT_BOOL
							option.SetValue(True)
							'go on to next argument
						Else
							'option is not a flag
							If onArg < AppArgs.Length - 1
								option.SetValue(AppArgs[onArg + 1])
								onArg += 1
							Else
								'failed, option wasn't a flag and no value was specified
								Throw New OptionsError("Missing argument for " + arg)
								Return False
							EndIf
						EndIf

					Else
						Local option:= Self.FindOption(arg[2 .. eqLoc])
						If option = Null
							'option does not exist
							Throw New OptionsError("Unknown option " + arg)
							Return False
						EndIf
						If option.type = BIT_STRING
							option.SetValue(arg[eqLoc + 1 ..])
						Else
							Throw New OptionsError("Argument not allowed for option " + arg[ .. eqLoc])
							Return False
						EndIf
					EndIf
				EndIf
			EndIf
		Next
		
		Return True
	End
	

	#Rem monkeydoc
	Process any arguments passed to the application that WERE NOT options.
	For example, calling "appName argument" would return "argument", since
	"argument" was not preceded with "-" or "--" and it was not the value
	for an option.
	
	Example:
	<pre>
		Local opts:= New Options()
		opts.SetUsageHelp(filepath.StripDir(os.AppArgs()[0]) + " [OPTION...]")
		opts.AddGroup("Help").AddOption("help", "Show Help Options", "", BIT_BOOL)
		
		Print "Arguments specified:"
		For Local arg:= EachIn opts.Arguments
			Print "   " + arg
		Next
	</pre>
	#End
	Method Arguments:StringList() Property
		Return arguments
	End
	
	Private

	Method Arguments:Void(arguments:StringList) Property
		Self.arguments = arguments
	End
		
	Field usageHelp:String
	Field optionGroups:List<OptionGroup> = New List<OptionGroup>
	Field arguments:StringList = New StringList

	
End

#Rem monkeydoc
This class stores an unlimited number of options in a single group.
#End
Class OptionGroup
	
	#Rem monkeydoc
	Adds an option to itself.

	Example:
	<pre>
		Local opts:= New Options()
	
		Local appGroup:= opts.AddGroup("Application")
		appGroup.AddOption("connect", "Connect to server", "SERVER", BIT_STRING)
		
		'You can also create an option group and a single option at the same time:
		opts.AddGroup("Help").AddOption("help", "Show help options", "", BIT_BOOL)
	</pre>
		
	#End
	Method AddOption:Option(name:String, description:String, valueSample:String = "", type:Int = BIT_STRING)
		Self.options.AddLast(New Option(name, Self, description, valueSample, type))
		Return Self.options.Last()
	End
	
	Private

	Method New(name:String)
		Self.name = name
	End

			
	Field name:String
	Field options:List<Option> = New List<Option>
	

End

#Rem monkeydoc
This class stores a single option and any of its aliases.
#End
Class Option
	#Rem monkeydoc
	Add an alias to an option.

	Example:
		<pre>
	Local opts:= New Options()
	
	helpOpt := opts.AddGroup("Help").AddOption("help", "Show help options", "", BIT_BOOL)
	helpOpt.AddAlias("?")
	
	'You can also create an option and an one or more alias at the same time:
	opts.AddGroup("Help").AddOption("help", "Show help options", "", BIT_BOOL).AddAlias("?").AddAlias("h")
	</pre>
		
	#End
	Method AddAlias:Option(name:String)
		Self.aliases.AddLast(New OptionAlias(name, Self))
		Return Self
	End
	
	#Rem monkeydoc
	Return true or false whether an option has been specified and/or assigned a value.

	Example:
	<pre>
		Local opts:= New Options()
		
		opts.AddGroup("Help").AddOption("help", "Show help options", "", BIT_BOOL).AddAlias("?")
		
		If opts.FindOption("?").ValueSet = True
			opts.PrintHelp
			Return
		EndIf
	</pre>
		
	#End
	Method ValueSet:Bool() Property
		Return Self.valueSet
	End
	
	#Rem monkeydoc
	Return the string value of a specified option.

	Example:
	<pre>
		Local opts:= New Options()
			
		opts.AddGroup("Application").AddOption("connect", "Connect to server", "SERVER", BIT_STRING).AddAlias("c")
			
		If opts.FindOption("c").ValueSet = True
			Print "Connecting to " + opts.FindOption("c").Value + "..."
		EndIf
	</pre>
		
	#End
	Method Value:String() Property
		Return Self.valueString
	End
	
	Private
	
	Method New(name:String, group:OptionGroup, description:String, valueSample:String = "", type:Int = BIT_STRING)
		Self.name = name
		Self.group = group
		Self.description = description
		Self.type = type
		Self.valueSample = valueSample
	End
	Method SetValue:Void(value:String)
		Self.valueString = value
		Self.valueSet = True
	End
	Method SetValue:Void(value:Bool = True)
		Self.valueBool = value
		Self.valueSet = True
	End
	
	Field description:String
	Field name:String
	Field type:Int
	Field valueString:String
	Field valueBool:Bool
	Field valueSet:Bool
	Field valueSample:String
	Field aliases:List<OptionAlias> = New List<OptionAlias>
	Field group:OptionGroup
End

Class OptionAlias
	Private
	
	Field primaryOption:Option
	Field name:String
	
	Method New(name:String, primaryOption:Option)
		Self.name = name
		Self.primaryOption = primaryOption
	End
End

#Rem monkeydoc
Error handling class for this library.
#End
Class OptionsError Extends Throwable
   
	#Rem monkeydoc
	Allows you to get the error message of any error that occurs during parsing.

	Example:
	<pre>
		Local opts:= New Options()
		opts.SetUsageHelp(filepath.StripDir(os.AppArgs()[0]) + " [OPTION...]")
		opts.AddGroup("Help").AddOption("help", "Show help options", "", BIT_BOOL).AddAlias("?")
			
		Local appGroup:= opts.AddGroup("Application")
		appGroup.AddOption("port", "Connect to port", "PORT", BIT_STRING).AddAlias("p")
			
		Try
			opts.ParseArguments(os.AppArgs()[1 ..])
		Catch t:OptionsError
			'print the error message
			Print t.message
			'print something that can help the user figure out what to do.
			Print "Run '" + filepath.StripDir(os.AppArgs()[0]) + " --help' to see a full list of available command line options."
			'exit program
			Return
		End
	</pre>
		
	#End
	Field message:String

	#Rem monkeydoc
	If you want to add your own custom error checking you can call this method here. Replace the Try Catch block documented above.
	
	Example:
	<pre>
		Try
			opts.ParseArguments(os.AppArgs()[1 ..])
			If opts.FindOption("p").ValueSet = True
				Local port := Int(opts.FindOption("p").Value)
				If port < 1 Or port > 65535
					Throw New OptionsError("Invalid port number " + port)
					Return
				EndIf
			EndIf
		Catch t:OptionsError
			'print the error message
			Print t.message
			'print something that can help the user figure out what to do.
			Print "Run '" + filepath.StripDir(os.AppArgs()[0]) + " --help' to see a full list of available command line options."
			'exit program
			Return
		End

	</pre>
		
	#End
	Method New(message:String)
		Self.message = message
	End
End