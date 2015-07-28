Strict

Import os
Import bit.arguments
Import brl.filepath

Function Main:Int()
	New CommandLineTool()
	Return 0
End

Class CommandLineTool

	Method New()
	
		Local params:= New Options()
		params.SetUsageHelp(filepath.StripDir(os.AppArgs()[0]) + " [OPTION...]") 'this returns the name of the compiled exe :: filepath.StripDir(os.AppArgs()[0])
		params.AddGroup("Help").AddOption("help", "Show help options", "", BIT_BOOL).AddAlias("?")
		
		Local appGroup:= params.AddGroup("Application")
		appGroup.AddOption("connect", "Connect to server", "SERVER", BIT_STRING).AddAlias("c")
		appGroup.AddOption("port", "Connection port", "PORT", BIT_STRING).AddAlias("p")
		appGroup.AddOption("version", "Display version",, BIT_BOOL).AddAlias("v")
		
		Try
			params.ParseArguments(os.AppArgs()[1 ..])
			If params.FindOption("p").ValueSet = True
				Local port:= Int(params.FindOption("p").Value)
				If port < 1 Or port > 65535
					Throw New OptionsError("Invalid port number " + port)
					Return
				EndIf
			EndIf
		Catch t:OptionsError
			Print t.message
			Print "Run '" + filepath.StripDir(os.AppArgs()[0]) + " --help' to see a full list of available command line options."
			Return
		End
		
		'take action on arguments
		If params.FindOption("?").ValueSet = True
			params.PrintHelp
			Return
		EndIf
		If params.FindOption("v").ValueSet = True
			Print filepath.StripDir(os.AppArgs()[0]) + " 1.0.0"
			Return
		EndIf
		
		If params.FindOption("c").ValueSet = True
			Print "Connecting to " + params.FindOption("c").Value + "..."
		EndIf

		If params.FindOption("p").ValueSet = True
			Print "Connecting on port " + params.FindOption("p").Value + "..."
		EndIf

		Print ""
		Print "Other Arguments specified:"
		For Local arg:= EachIn params.Arguments
			Print "   " + arg
		Next
				
	End

End