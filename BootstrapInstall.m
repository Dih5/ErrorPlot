(* ::Package:: *)

Get["https://raw.githubusercontent.com/jkuczm/MathematicaBootstrapInstaller/v0.1.1/BootstrapInstaller.m"]


BootstrapInstall[
	"SyntaxAnnotations",
	"https://github.com/dih5/ErrorPlot/releases/download/v1.0.0/ErrorPlot.zip",
	"AdditionalFailureMessage" ->
		Sequence[
			"You can ",
			Hyperlink[
				"install the ErrorPlot package manually",
				"https://github.com/dih5/ErrorPlot#manual-installation"
			],
			"."
		]
]