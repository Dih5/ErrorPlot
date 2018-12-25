(* Paclet Info File *)

(* created 2015/11/19*)

Paclet[
    Name -> "ErrorPlot",
    Version -> "1.0.0",
    MathematicaVersion -> "6+",
    Description -> "An alternative to the ErrorBar Plotting Package included in Mathematica.\r\nIt allows for log-scale plotting and a freer syntax.",
    Creator -> "Guillermo Hernandez <dihedralfive@gmail.com>",
    URL->"https://github.com/Dih5/ErrorPlot",
    Extensions ->
        {
            {"Kernel",
              "Context"->{"ErrorPlot`"},
              "Root"->"."
            },
            {"Documentation", Resources ->
                {"Guides/Plotting data with error bars"}
            , Language -> "English"},
            {"PacletServer",
              "License"->"MIT",
           		"Tags" -> {"plots"},
           		"Categories" -> {"Plotting"}
            }
        }
]
